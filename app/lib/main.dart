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
      title: 'What Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MenuPrincipal(),
    );
  }
}

// ------------------------------------------
// PANTALLA 1: MENÚ PRINCIPAL
// ------------------------------------------
class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final Color colorNeon = const Color(0xFF00D2FF);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("WHAT\nMUSIC", 
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  fontSize: 50, 
                  fontWeight: FontWeight.w900, 
                  color: colorNeon,
                  letterSpacing: 4
                )
              ),
              const SizedBox(height: 10),
              Text("TRIVIAL MUSICAL", 
                style: GoogleFonts.montserrat(color: Colors.white70, letterSpacing: 3)
              ),
              const SizedBox(height: 80),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaCategorias()),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 40),
                label: const Text("JUGAR"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorNeon,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------
// PANTALLA 2: SELECCIÓN DE CATEGORÍA
// ------------------------------------------
class PantallaCategorias extends StatelessWidget {
  const PantallaCategorias({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ELIGE TEMÁTICA", style: GoogleFonts.orbitron(fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF141E30),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
          ),
        ),
        child: SingleChildScrollView( // Añadido Scroll por si hay muchos botones
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. ESPAÑOL
                _BotonCategoria(
                  titulo: "ÉXITOS ESPAÑOL", 
                  icono: Icons.music_note, 
                  color: Colors.amber,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const JuegoPage(
                        tituloTema: "ESPAÑOL", 
                        rutasJson: ["assets/espanol.json"]
                      )
                    ));
                  }
                ),
                const SizedBox(height: 20),
                
                // 2. INGLÉS
                _BotonCategoria(
                  titulo: "HITS INGLÉS", 
                  icono: Icons.language, 
                  color: Colors.pinkAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const JuegoPage(
                        tituloTema: "INGLÉS", 
                        rutasJson: ["assets/ingles.json"]
                      )
                    ));
                  }
                ),
                const SizedBox(height: 20),

                // 3. DISNEY (¡NUEVO!)
                _BotonCategoria(
                  titulo: "MUNDO DISNEY", 
                  icono: Icons.castle, // Icono de castillo
                  color: Colors.cyanAccent, // Azul mágico
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const JuegoPage(
                        tituloTema: "DISNEY", 
                        rutasJson: ["assets/disney.json"]
                      )
                    ));
                  }
                ),
                const SizedBox(height: 20),

                // 4. MIX TOTAL (ACTUALIZADO CON DISNEY)
                _BotonCategoria(
                  titulo: "MIX ALEATORIO", 
                  icono: Icons.shuffle, 
                  color: const Color(0xFFBD00FF),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const JuegoPage(
                        tituloTema: "MIX TOTAL", 
                        // AHORA INCLUYE LOS 3 ARCHIVOS
                        rutasJson: [
                          "assets/espanol.json", 
                          "assets/ingles.json",
                          "assets/disney.json"
                        ] 
                      )
                    ));
                  }
                ),
                const SizedBox(height: 40), // Espacio final
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BotonCategoria extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  const _BotonCategoria({
    required this.titulo, required this.icono, required this.color, required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.2), blurRadius: 15, offset: const Offset(0,5))
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: color, size: 35),
            const SizedBox(width: 20),
            Text(titulo, style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white
            )),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
// PANTALLA 3: EL JUEGO
// ------------------------------------------
class JuegoPage extends StatefulWidget {
  final String tituloTema;
  final List<String> rutasJson;

  const JuegoPage({
    super.key, 
    required this.tituloTema, 
    required this.rutasJson
  });

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
    _cargarMultiplesDatos();
  }

  @override
  void dispose() {
    _player.dispose();
    _timerAudio?.cancel();
    super.dispose();
  }

  Future<void> _cargarMultiplesDatos() async {
    List<dynamic> listaFusionada = [];
    
    try {
      for (String ruta in widget.rutasJson) {
        // Bloque try-catch interno por si falta algún archivo (ej: si no has generado disney.json aún)
        try {
          final String response = await rootBundle.loadString(ruta);
          final data = json.decode(response);
          listaFusionada.addAll(data);
        } catch (e) {
          print("Aviso: No se pudo cargar $ruta. ¿Quizás no existe?");
        }
      }

      if (listaFusionada.isEmpty) {
        throw Exception("No se han cargado canciones de ninguna lista.");
      }

      if (mounted) {
        setState(() {
          _cartasTodas = listaFusionada; 
          _reiniciarMazo();    
          _cargando = false;
        });
      }
    } catch (e) {
      print("Error cargando datos: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Genera los JSON con el script primero."), backgroundColor: Colors.red)
        );
        Navigator.pop(context); // Volver atrás si falla
      }
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
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
            Text("¡TEMÁTICA COMPLETADA!",
              style: baseStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text("Has jugado las ${_cartasTodas.length} canciones.",
              style: baseStyle.copyWith(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context), 
                icon: const Icon(Icons.arrow_back),
                label: const Text("VOLVER A CATEGORÍAS"),
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.tituloTema, 
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text("${_mazoDisponible.length} restantes", style: const TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
        ),

        Expanded(
          flex: 4,
          child: Center(
            child: Container(
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

        const SizedBox(height: 20),

        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (_respuestaRevelada || _cargandoAudio) ? null : _playAudio,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
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
                          color: _reproduciendoAhora ? Colors.white : Colors.black, size: 40),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _cargandoAudio ? "Cargando..." : (_reproduciendoAhora ? "Sonando (20s)" : "Escuchar Pista"),
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
              ),
              
              const Spacer(),
              const SizedBox(height: 30),

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
          Text(widget.tituloTema, style: baseStyle.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
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