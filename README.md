# Álamo - Flutter App


Álamo es una aplicación móvil y web desarrollada en Flutter que conecta a personas en situación de vulnerabilidad con centros de ayuda cercanos en categorías como alimentación, vestimenta, salud y refugio. Esta solución innovadora combina tecnologías modernas como Firebase, Google Maps Platform y OpenAI para ofrecer una experiencia integral y accesible a los usuarios.

## Tabla de Contenidos
- [Características](#características)
- [Arquitectura](#arquitectura)
- [Requisitos Previos](#requisitos-previos)
- [Capturas ](#capturas)
---

## Características

- **Autenticación Segura**: Inicio de sesión con Firebase Authentication, compatible con Google y correo electrónico.
- **Mapa Interactivo**: Integración con Google Maps para localizar centros de ayuda en tiempo real.
- **Asistente Virtual**: Comunicación con un asistente OpenAI para guiar a los usuarios hacia servicios específicos.
- **Gestión de Recursos**: Biblioteca para almacenar y organizar archivos educativos y de asistencia.

---

## Arquitectura

La aplicación sigue un enfoque modular y multiplataforma, reutilizando componentes entre la versión móvil y web:

- **Frontend**: Flutter con Riverpod para gestión de estado.
- **Backend**: Firebase como plataforma Backend-as-a-Service.
  - Autenticación: Firebase Authentication.
  - Almacenamiento de datos: Cloud Firestore.
  - Almacenamiento de archivos: Firebase Storage.
- **Integración**:
  - Google Maps Platform para geolocalización.
  - APIs de OpenAI para el asistente virtual.

---

## Requisitos Previos

- **Flutter SDK**: Versión 3.x o superior.
- **Dart**: Compatible con Flutter 3.x.
- **Firebase CLI**: Para la configuración de servicios de Firebase.
- **Android Studio** o **Xcode**: Para pruebas locales en Android o iOS.
- **Codemagic**: Opcional, para integración continua (CI/CD).
- **Claves**: Para este proyecto se necesitan claves de OpenAI Platform, y de Google Maps Platform.

## Capturas
