import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:google_fonts/google_fonts.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const WhatMusicApp());
}

class WhatMusicApp extends StatelessWidget {
  const WhatMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What Music', // Aquí irá el tema de las canciones
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const JuegoPage(),
    );
  }
}

class JuegoPage extends StatefulWidget {
  const JuegoPage({super.key});

  @override
  State<JuegoPage> createState() => _JuegoPageState();
}

class _JuegoPageState extends State<JuegoPage> {
  late AudioPlayer _player; 
  Timer? _timerAudio;
  
  List<dynamic> _cartasTodas = [];      
  List<dynamic> _mazoDisponible = [];   
  Map<String, dynamic>? _cartaActual;
  
  bool _cargando = true;        
  bool _juegoTerminado = false; 
  
  bool _respuestaRevelada = false;
  bool _musicHaSonado = false;
  bool _reproduciendoAhora = false;
  bool _cargandoAudio = false; 

  final Color _colorFondoArriba = const Color(0xFF141E30);
  final Color _colorFondoAbajo = const Color(0xFF243B55);
  final Color _colorNeon = const Color(0xFF00D2FF);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _reproduciendoAhora = state.playing;
          if (state.processingState == ProcessingState.completed) {
             _reproduciendoAhora = false;
             _player.stop();
             _player.seek(Duration.zero);
          }
        });
      }
    });
    _cargarDatos();
  }

  @override
  void dispose() {
    _player.dispose();
    _timerAudio?.cancel();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    try {
      final String response = await rootBundle.loadString('assets/cartas.json');
      final data = json.decode(response);
      if (mounted) {
        setState(() {
          _cartasTodas = data; 
          _reiniciarMazo();    
          _cargando = false;
        });
      }
    } catch (e) {
      print("Error fatal cargando JSON: $e");
    }
  }

  void _reiniciarMazo() {
    _player.stop();
    _timerAudio?.cancel();
    setState(() {
      _juegoTerminado = false;
      _mazoDisponible = List.from(_cartasTodas);
      _mazoDisponible.shuffle();
      _sacarCartaNueva();
    });
  }

  void _sacarCartaNueva() {
    _timerAudio?.cancel();
    _player.stop();
    setState(() {
      if (_mazoDisponible.isEmpty) {
        _juegoTerminado = true;
        _cartaActual = null;
        return; 
      }
      int index = Random().nextInt(_mazoDisponible.length);
      _cartaActual = _mazoDisponible[index];
      _mazoDisponible.removeAt(index);
      _respuestaRevelada = false;
      _musicHaSonado = false;
      _reproduciendoAhora = false;
      _cargandoAudio = false;
    });
  }

  Future<void> _playAudio() async {
    if (_cargandoAudio || _juegoTerminado) return;
    if (_reproduciendoAhora) {
      await _player.stop();
      _timerAudio?.cancel();
      return;
    }
    setState(() { _cargandoAudio = true; });

    try {
      await _player.stop();
      String urlLimpia = _cartaActual!['preview'];
      String urlAntiCache = "$urlLimpia${urlLimpia.contains('?') ? '&' : '?'}t=${DateTime.now().millisecondsSinceEpoch}";
      await _player.setUrl(urlAntiCache);
      _player.play();
      setState(() { _musicHaSonado = true; });
      _timerAudio?.cancel();
      _timerAudio = Timer(const Duration(seconds: 20), () {
        _player.stop();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("⚠️ Error de conexión"), backgroundColor: Colors.redAccent));
      }
    } finally {
      if (mounted) { setState(() { _cargandoAudio = false; }); }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyleBase = GoogleFonts.montserrat(); 
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_colorFondoArriba, _colorFondoAbajo],
          ),
        ),
        child: SafeArea(
          child: _cargando
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _juegoTerminado
                ? _buildPantallaFin(textStyleBase) 
                : _buildPantallaJuego(textStyleBase), 
        ),
      ),
    );
  }

  Widget _buildPantallaFin(TextStyle baseStyle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            Text("¡JUEGO COMPLETADO!",
              style: baseStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text("Has jugado las ${_cartasTodas.length} canciones.",
              style: baseStyle.copyWith(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton.icon(
                onPressed: _reiniciarMazo,
                icon: const Icon(Icons.refresh),
                label: const Text("VOLVER A EMPEZAR"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colorNeon, foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPantallaJuego(TextStyle baseStyle) {
    return Column(
      children: [
        // CABECERA
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("WHAT MUSIC", 
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text("${_mazoDisponible.length} restantes", style: const TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
        ),

        // CARTA (Ahora más pequeña gracias al margen 60)
        Expanded(
          flex: 4,
          child: Center(
            child: Container(
              // AUMENTADO MARGEN A 60 PARA HACERLA MAS PEQUEÑA
              margin: const EdgeInsets.symmetric(horizontal: 60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.white,
                  child: _respuestaRevelada 
                    ? _buildCartaRevelada(baseStyle) 
                    : _buildCartaMisteriosa(baseStyle),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20), // Reducido un poco

        // CONTROLES
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BOTÓN PLAY (Reducido a 70px)
              GestureDetector(
                onTap: (_respuestaRevelada || _cargandoAudio) ? null : _playAudio,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  // TAMAÑO REDUCIDO: 70
                  height: 70, width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _respuestaRevelada ? Colors.grey : (_reproduciendoAhora ? Colors.redAccent : _colorNeon),
                    boxShadow: [
                      if (!_respuestaRevelada)
                        BoxShadow(color: (_reproduciendoAhora ? Colors.red : _colorNeon).withOpacity(0.6), blurRadius: 20, spreadRadius: 1)
                    ]
                  ),
                  child: _cargandoAudio
                      ? const Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Icon(_reproduciendoAhora ? Icons.stop_rounded : Icons.play_arrow_rounded,
                          color: _reproduciendoAhora ? Colors.white : Colors.black, 
                          size: 40), // Icono reducido a 40
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _cargandoAudio ? "Cargando..." : (_reproduciendoAhora ? "Sonando (20s)" : "Escuchar Pista"),
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
              ),
              
              const Spacer(),

              const SizedBox(height: 30),

              // BOTONES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30), 
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: (_musicHaSonado && !_respuestaRevelada)
                            ? () { setState(() { _respuestaRevelada = true; _player.stop(); }); }
                            : null, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.15), foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                          ),
                          child: const Text("REVELAR"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _respuestaRevelada ? _sacarCartaNueva : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _colorNeon, foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                          ),
                          child: const Text("SIGUIENTE"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // MARGEN INFERIOR (Ladrillo invisible)
              const SizedBox(height: 90),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCartaMisteriosa(TextStyle baseStyle) {
    return Container(
      color: const Color(0xFF1F2833), width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note_rounded, size: 60, color: _colorNeon.withOpacity(0.5)),
          const SizedBox(height: 15),
          Text("¿WHAT MUSIC?", style: baseStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text("Dale al play", style: baseStyle.copyWith(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCartaRevelada(TextStyle baseStyle) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(_cartaActual!['imagen'], fit: BoxFit.cover),
        Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.95)], stops: const [0.4, 0.85]))),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("AÑO", style: baseStyle.copyWith(fontSize: 12, color: Colors.grey, letterSpacing: 2)),
              Text("${_cartaActual!['ano']}", style: baseStyle.copyWith(fontSize: 50, fontWeight: FontWeight.w900, color: _colorNeon, height: 1.0)),
              const SizedBox(height: 10),
              Text(_cartaActual!['titulo'], style: baseStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              Text(_cartaActual!['artista'], style: baseStyle.copyWith(fontSize: 16, color: Colors.grey[300]), textAlign: TextAlign.center),
              const SizedBox(height: 10),
            ],
          ),
        )
      ],
    );
  }
}