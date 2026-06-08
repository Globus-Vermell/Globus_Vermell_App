# Globus Vermell

> **IMPORTANTE:** La inteligencia artificial integrada en esta aplicación se encuentra actualmente en fase **Beta**. Se recomienda encarecidamente someter a revisión y verificación manual (al 100%) todas las respuestas, datos y análisis generados por la IA antes de hacer uso de ellos en entornos reales, de producción o de carácter profesional.

## Descripción del Proyecto
Globus Vermell es una aplicación móvil avanzada orientada al sector de la arquitectura. Desarrollada bajo un enfoque multiplataforma fluido, la aplicación se complementa con un robusto servidor backend de inteligencia artificial, ofreciendo asistencia analítica y descriptiva de alto nivel para información arquitectónica.

## Arquitectura del Sistema y Tecnologías
El ecosistema de la aplicación está diseñado para ser escalable y eficiente, dividiéndose en las siguientes capas tecnológicas:

* **Frontend (Interfaz de Usuario):** Construido con **Flutter** y **Dart**, garantizando un rendimiento nativo, una experiencia de usuario óptima y compatibilidad en múltiples dispositivos móviles.
* **Backend y Servicios IA:** Implementado mediante **Python** y **FastAPI**, integrando de manera directa la API de **Cohere** para el procesamiento de lenguaje natural y la generación de contenido.
* **BaaS y Gestión de Datos:** La persistencia de datos, gestión de usuarios y autenticación se resuelven de forma integral utilizando **Supabase**.

## Características Principales
- Asistencia inteligente y generación de contenido mediante modelos de lenguaje integrados.
- Interfaz de usuario interactiva, moderna y de alto rendimiento.
- Sincronización en la nube y gestión de base de datos en tiempo real.
- Estructura de código mantenible basada en buenas prácticas de desarrollo móvil.

## Información del Repositorio
Por motivos de integridad académica, el repositorio principal de desarrollo de **Globus Vermell** es de carácter **privado** y está alojado y gestionado a través de **GitHub Classroom**. Los repositorios públicos secundarios asociados a este proyecto se utilizan de manera exclusiva para alojar los despliegues (deployments) de la aplicación.

## Instrucciones de Despliegue Local
Para compilar y ejecutar el entorno de desarrollo en una máquina local, siga estos pasos:

1. **Clonar el proyecto:** (Requiere acceso autorizado al repositorio en GitHub Classroom).
   Ejecute: `git clone <URL_DEL_REPOSITORIO>`

2. **Descargar dependencias:**
   Verifique que el SDK de Flutter esté correctamente instalado en su sistema.
   Ejecute: `flutter pub get`

3. **Configuración de Variables de Entorno:**
   Es necesario configurar las credenciales para los servicios externos. Cree un archivo de entorno o configure las variables correspondientes con las claves de acceso para **Cohere API** en caso de necesitar la IA.

4. **Ejecución:**
   Inicie la aplicación en un emulador configurado o en un dispositivo físico conectado.
   Ejecute: `flutter run`