import requests
import json
import time
import os

# --- CABECERA PARA ENGAÑAR A APPLE ---
# Esto hace que parezcamos un navegador Chrome real y no nos bloqueen
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

def generar_categoria(nombre_archivo_txt, nombre_salida_json):
    print(f"\n📚 PROCESANDO CATEGORÍA: {nombre_archivo_txt}...")
    
    try:
        with open(nombre_archivo_txt, 'r', encoding='utf-8') as f:
            lista_canciones = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print(f"⚠️ No encuentro el archivo '{nombre_archivo_txt}'.")
        return

    print(f"   --> Canciones: {len(lista_canciones)}")
    print(f"   --> Empezando... (Si va lento es para evitar bloqueos)\n")

    cartas = []
    total = len(lista_canciones)
    
    for i, busqueda in enumerate(lista_canciones):
        # Imprimimos inicio de línea
        print(f"[{i+1}/{total}] 🔎 {busqueda}...", end=" ", flush=True)
        
        exito = False
        intentos = 0
        
        while not exito and intentos < 2: 
            try:
                parametros = {
                    "term": busqueda,
                    "media": "music",
                    "limit": 1,
                    "country": "ES" 
                }
                
                # AÑADIMOS HEADERS AQUI
                response = requests.get("https://itunes.apple.com/search", params=parametros, headers=HEADERS, timeout=10)
                
                if response.status_code == 200:
                    data = response.json()
                    if data["resultCount"] > 0:
                        track = data["results"][0]
                        img_hd = track.get("artworkUrl100", "").replace("100x100", "600x600")
                        
                        item = {
                            "titulo": track.get("trackName"),
                            "artista": track.get("artistName"),
                            "ano": track.get("releaseDate", "")[:4],
                            "preview": track.get("previewUrl"),
                            "imagen": img_hd
                        }
                        cartas.append(item)
                        print("✅ OK") # Salto de línea
                        exito = True
                    else:
                        print("❌ NO ENCONTRADA") # Salto de línea
                        exito = True 
                elif response.status_code in [403, 429]:
                    print(f"⏳", end="", flush=True)
                    time.sleep(2) # Espera corta y reintenta
                    intentos += 1
                else:
                    print(f"❌ Error {response.status_code}") # Salto de línea
                    exito = True

            except Exception as e:
                print(f"⚠️ Red", end=" ", flush=True)
                intentos += 1
                time.sleep(1)
        
        # Si después de los intentos sigue sin éxito (fallo total), cerramos la línea
        if not exito:
             print("❌ BLOQUEADO")

        # Pausa de cortesía
        time.sleep(0.8)

    # Guardar
    ruta_salida = f"../app/assets/{nombre_salida_json}"
    carpeta = os.path.dirname(ruta_salida)
    if not os.path.exists(carpeta) and carpeta != "":
        os.makedirs(carpeta)

    with open(ruta_salida, 'w', encoding='utf-8') as f:
        json.dump(cartas, f, ensure_ascii=False, indent=2)
    
    print(f"\n✨ ¡TERMINADO! {len(cartas)} canciones guardadas en '{ruta_salida}'")

# --- EJECUCIÓN ---
#generar_categoria("lista_espanol.txt", "espanol.json")
#generar_categoria("lista_ingles.txt", "ingles.json")
generar_categoria("lista_disney.txt", "disney.json")