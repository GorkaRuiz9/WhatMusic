import requests
import json
import os
import time

# --- TU LISTA DE ÉXITOS ---
mi_playlist = [
    "Los del Rio Macarena",
    "Spice Girls Wannabe",
    "Queen Bohemian Rhapsody",
    "David Bisbal Ave Maria",
    "Estopa La Raja de tu Falda",
    "Daddy Yankee Gasolina",
    "Michael Jackson Thriller",
    "Rosalia Despecha",
    "Shakira Waka Waka",
    "Melendi Caminando por la vida",
    "Celia Cruz La vida es un carnaval",
    "Bon Jovi Livin on a Prayer",
    "Abba Dancing Queen",
    "Ricky Martin Maria",
    "Las Ketchup Asereje",
    "Hombres G Devuelveme a mi chica",
    "Raphael Mi Gran Noche",
    "Mecano En tu fiesta me cole",
    "Alaska A quien le importa",
    "El Canto del Loco Zapatillas",
    "Chayanne Torero",
    "Don Omar Danza Kuduro"
]

print(f"🚀 Iniciando búsqueda HD...")
cartas_encontradas = []

for busqueda in mi_playlist:
    print(f"🔎 {busqueda}...", end=" ")
    
    try:
        url = f"https://itunes.apple.com/search?term={busqueda}&media=music&limit=1&country=ES"
        response = requests.get(url)
        
        if response.status_code == 200:
            data = response.json()
            if data["resultCount"] > 0:
                track = data["results"][0]
                fecha = track.get("releaseDate", "")[:4]
                
                # --- EL TRUCO DEL ALMENDRUCO PARA HD ---
                # iTunes da url tipo ".../100x100bb.jpg". La cambiamos a 1000x1000
                imagen_hd = track.get("artworkUrl100").replace("100x100", "1000x1000")
                
                item = {
                    "titulo": track.get("trackName"),
                    "artista": track.get("artistName"),
                    "ano": fecha,
                    "preview": track.get("previewUrl"),
                    "imagen": imagen_hd  # <--- Usamos la HD
                }
                cartas_encontradas.append(item)
                print(f"✅ OK")
            else:
                print("❌ No encontrada")
        time.sleep(0.2) 
    except Exception as e:
        print(f"Error: {e}")

# Guardar
ruta = "../app/assets/cartas.json"
with open(ruta, 'w', encoding='utf-8') as f:
    json.dump(cartas_encontradas, f, ensure_ascii=False, indent=2)

print(f"\n✨ ¡JSON generado con imágenes HD! Recuerda reconstruir la app.")