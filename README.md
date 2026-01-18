# 🎵 What Music?

**Suena la música... ¿Pero sabrías decir qué canción es?**

**What Music** es el desafío musical definitivo. Al empezar, **no verás nada**: ni título, ni artista, ni portada. Solo tú, tu oído y 20 segundos de audio. ¿Serás capaz de reconocer el temazo y ubicarlo en el tiempo?

![Flutter](https://img.shields.io/badge/Made_with-Flutter-blue.svg)
![Python](https://img.shields.io/badge/Data-Python_Scripts-yellow.svg)
![Status](https://img.shields.io/badge/Status-Playable-brightgreen.svg)

---

## 📥 Descarga la App (Android)

¡Empieza a jugar ya mismo sin complicaciones!

### 👉 [IR A RELEASES PARA DESCARGAR (APK)](https://github.com/GorkaRuiz9/WhatMusic/releases)

1. Ve a la sección **Releases**.
2. Descarga el archivo `.apk` más reciente.
3. Instálalo en tu móvil Android y... ¡a jugar!

---

## 🎮 ¿Cómo se juega?

La mecánica es sencilla pero adictiva. Diseñada para jugar en grupo, en el coche o en familia:

1.  **Elige tu Temática:** Selecciona entre *Éxitos en Español* o *Hits en Inglés*.
2.  **Escucha a Ciegas:** Dale al Play. La carta está boca abajo ("What Music?"). No sabes quién canta ni cómo se llama la canción.
3.  **El Reto Triple:** Tienes que adivinar:
    * 🎤 **¿Quién es el intérprete?**
    * 🎵 **¿Cuál es el título de la canción?**
    * 📅 **¿En qué AÑO salió?**
4.  **Revela:** Pulsa "REVELAR" para girar la carta. Descubrirás la portada del álbum en HD y todos los datos para ver quién ha acertado.

---

## ✨ Características Principales

* **🕵️‍♂️ Modo Misterio:** La interfaz oculta toda la información hasta que tú decides revelarla.
* **🎧 Audio Real:** Fragmentos de alta calidad directos de iTunes.
* **🌍 Dos Mazos de Cartas:**
    * 🇪🇸 **Español:** Desde clásicos de verbena y pop de los 2000 hasta el reggaetón actual.
    * 🇬🇧 **Inglés:** Rock, Pop, Disco y los nº1 mundiales de todas las épocas.
* **🖼️ Experiencia Visual:** Portadas de discos en Alta Definición.
* **🌙 Modo Fiesta:** Diseño oscuro neón, perfecto para jugar de noche sin deslumbrar.

---

## 🛠️ Tecnología

Este proyecto es Open Source:
* **Frontend:** Desarrollado en **Flutter**, garantizando fluidez y animaciones nativas.
* **Backend / Data:** Scripts de **Python** automatizados que generan los mazos de cartas (`json`) consultando la API de iTunes para obtener metadatos precisos y carátulas HD.

### Generar más contenido
Si tienes el código y quieres añadir tus propias listas de canciones:
1. Edita los archivos `.txt` en la carpeta `scripts/`.
2. Ejecuta el generador masivo:
   ```bash
   python3 generador_masivo.py
