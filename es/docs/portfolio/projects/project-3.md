---
title: Despliegue de GeoNode - Plataforma Geoespacial Open Source
---

# Despliegue de Plataforma Geoespacial para Presentación Profesional de Trabajos GIS

!!! abstract "Resumen del Caso de Estudio"
    **Cliente**: Profesional GIS Independiente
    **Industria**: Tecnología Geoespacial / Open Source

    **Métricas de Impacto**:

    - Plataforma desplegada y funcionando en producción
    - 7 contenedores Docker orquestados exitosamente
    - 2 problemas técnicos críticos resueltos durante la implementación
    - Tiempo de implementación: ~2 semanas
    - 99% uptime mensual objetivo


## Resumen

GeoNode es una plataforma web geoespacial open source que puede ser desplegada para un profesional GIS independiente o cualquier organización que necesite publicar mapas, tableros o contenido web basado en capas geoespaciales. El proyecto consistió en desplegar GeoNode en un servidor dedicado utilizando Docker Compose, enfrentando y resolviendo desafíos técnicos relacionados con conflictos de puertos y configuración de health checks. La plataforma proporciona un punto centralizado para la publicación de proyectos profesionales con acceso para clientes y control total para el editor.

## El Desafío

Como profesional independiente, decidí montar una plataforma propia para publicar y compartir proyectos cartográficos con una experiencia simple para el cliente y con margen real de crecimiento. Los factores clave de la decisión fueron:

**Presupuesto limitado**: Servidor dedicado existente, sin recursos para soluciones gestionadas.

**Necesidad de control total**: Quería una plataforma propia, no servicios externos como ArcGIS Online. Plataforma propia con control total sobre datos, permisos, actualizaciones y backups.

**Accesibilidad para clientes**: Los clientes deben poder ver los proyectos sin capacitación técnica, con visualización en navegador, sin capacitación.

**Flexibilidad para crecer**: Catálogo, metadatos, roles, colaboración, estilos.

**Integración con stack GIS**: Estándares e interoperabilidad (OGC).

**Base reutilizable para futuros proyectos**: Plantillas y flujo repetible.

### Requisitos Técnicos

| Requisito | Descripción |
|-----------|-------------|
| Plataforma GIS web | GeoNode como base |
| Contenedores Docker | Facilitar despliegue y mantenimiento |
| GeoServer incluido | Servicios OGC (WMS, WFS) |
| HTTPS | Certificados válidos |
| Acceso público | Posibilidad de publicar mapas con/sin autenticación |

### Criterios de Éxito

- Plataforma operativa con uptime del 99%
- GeoServer accesible para administración
- Capas públicas visibles sin login
- Mantenimiento gestionable por el propietario

## Enfoque Técnico

### Stack Tecnológico & Arquitectura

!!! info "Arquitectura del Sistema"
    La solución implementa una arquitectura de microservicios con 7 contenedores Docker:

    **Componentes**:

    - **nginx**: Reverse Proxy (puertos 80, 443)
    - **Kong**: API Gateway (puerto 8001)
    - **Django**: Aplicación web GeoNode (puerto 8000)
    - **GeoServer**: Servidor de mapas OGC (puerto 8083)
    - **PostgreSQL/PostGIS**: Base de datos espacial (puerto 5432)
    - **Redis**: Caché y broker de mensajes (puerto 6379)
    - **Memcached**: Caché adicional (puerto 11211)
    - **Celery**: Procesamiento de tareas en background

    **Flujo de datos**: nginx/Kong → Django → GeoServer/PostgreSQL

![Diagrama de Arquitectura](../../assets/project-3/geonode_architecture.png)

*Arquitectura de contenedores*

## Aspectos Destacados de la Implementación 

### Fases del Proyecto

**Fase 1: Preparación**
- Configuración inicial del servidor
- Instalación de Docker y Docker Compose
- Clonación del repositorio GeoNode
- Configuración de archivo `.env`

**Fase 2: Despliegue Inicial**
- Levantamiento de contenedores base
- Ejecución de migraciones de base de datos
- Configuración de variables de entorno
- Creación de superusuario administrador

**Fase 3: Resolución de Problemas**
- Identificación y resolución de conflictos de puerto
- Ajuste de health checks
- Verificación de conectividad entre servicios

**Fase 4: Producción**
- Configuración de dominios y DNS
- Implementación de HTTPS
- Pruebas finales y validación


## Resultados e Impacto

### Métricas Técnicas

| Métrica | Objetivo | Estado |
|---------|----------|--------|
| Uptime mensual | 99% | En monitoreo |
| Contenedores activos | 7/7 | Logrado |
| Puerto GeoServer | 8083 | Configurado |
| Health check Django | Healthy | Corregido |
| Tiempo de carga | < 5 seg | Verificado |
| Usuarios concurrentes | 50+ | Por verificar |

### Componentes Desplegados

| Componente | Puerto | Estado |
|-----------|--------|--------|
| Django (GeoNode) | 8000 | Healthy |
| GeoServer Admin | 8083 | Corriendo |
| nginx | 80, 443 | Corriendo |
| PostgreSQL/PostGIS | 5432 | Healthy |
| Redis | 6379 | Corriendo |
| Memcached | 11211 | Corriendo |
| Kong Admin | 8001 | Corriendo |

### Valor Entregado

**Para el Editor (Propietario):**
- Control total sobre la plataforma
- No dependencia de servicios externos
- Costo reducido (solo servidor dedicado)
- Flexibilidad para personalizar

**Para los Clientes:**
- Acceso sin autenticación a capas públicas
- Interfaz intuitiva para visualización
- Descarga de datos disponible
- Compartir URLs directamente

## Mis Contribuciones

Como único desarrollador de esta solución, mis responsabilidades incluyeron:

- **Análisis de Requerimientos**: Evaluación de necesidades técnicas y selección de tecnología
- **Despliegue e Implementación**: Configuración y puesta en marcha de todos los componentes
- **Resolución de Problemas**: Identificación y solución de conflictos de puertos y health checks
- **Documentación**: Producción de guías de gestión y troubleshooting

<div class="grid cards" style="margin-top: 3rem" markdown>

-   :material-coffee:{ .lg .middle } ¡Tomemos un café virtual juntos!

    ---

    ¿Necesitás desplegar tu propia plataforma de datos GIS? Agendá una sesión gratuita de 30 minutos para discutir tus desafíos y explorar cómo podemos trabajar juntos.

    [Agendá una llamada gratuita :material-arrow-top-right:](https://calendly.com){ .md-button .md-button--primary }

</div>
