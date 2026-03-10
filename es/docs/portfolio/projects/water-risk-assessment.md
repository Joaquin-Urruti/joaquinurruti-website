---
title: "Evaluación de Riesgo Hídrico para Adquisición de Tierras Agrícolas"
description: "Análisis histórico de riesgo hídrico basado en imágenes satelitales para decisiones informadas de compra y arrendamiento de campos"
tags:
  - GIS
  - Google Earth Engine
  - Dynamic World
  - Teledetección
  - Agricultura
  - Riesgo Hídrico
  - Python
---

!!! abstract "Resumen del Caso de Estudio"
    **Cliente**: Empresa de Producción Agropecuaria — Argentina
    **Industria**: Tecnología Agrícola / Agricultura de Precisión  
    
    **Métricas de Impacto**:
    
    - 6+ años de imágenes históricas Sentinel-2 analizadas por cada evaluación de campo
    - 2 clases distintas de inundación identificadas (agua abierta y vegetación inundada) usando Google Dynamic World
    - Perfil de riesgo estacional de 12 meses generado por campo, habilitando la planificación operativa mes a mes
    - 40-60% de reducción estimada en el tiempo de due diligence para decisiones de adquisición de tierras
    - Riesgo de inundación cuantificado en 5 niveles de severidad (0-10%, 10-20%, 20-30%, 30-40%, >40% de probabilidad)

## Descripción General

Al adquirir o arrendar tierras agrícolas, comprender la dinámica hídrica es un factor crítico para la toma de decisiones. Este proyecto entregó un flujo de trabajo analítico basado en imágenes satelitales, construido sobre la API Python de Google Earth Engine, que caracteriza el comportamiento histórico del agua dentro de un campo, produciendo un perfil de riesgo probabilístico y estacional que respalda directamente las negociaciones de compra y arrendamiento de tierras.

## El Desafío

En la producción agropecuaria, el valor de un campo no está determinado únicamente por su potencial productivo. La probabilidad de anegamiento — y la consecuente pérdida de *transitabilidad* (la condición del suelo necesaria para que la maquinaria opere de forma segura) — puede comprometer las ventanas de siembra y cosecha, incrementar los costos operativos e impactar directamente en la rentabilidad.

Los enfoques tradicionales para evaluar el riesgo hídrico se basaban en imágenes satelitales de una sola fecha u observaciones de campo esporádicas. Estos métodos ofrecían una foto aislada en lugar de una visión integral de cómo se comporta el agua a lo largo de las estaciones y los años. Los tomadores de decisiones necesitaban una herramienta capaz de responder preguntas clave:

- ¿Qué porcentaje de la superficie de un campo se ve históricamente afectado por agua, y durante qué meses?
- ¿Cómo varía el riesgo de inundación entre diferentes lotes dentro de un mismo establecimiento?
- ¿Cuál es la probabilidad de que un campo sea intransitable durante los períodos críticos de campaña (siembra y cosecha)?

Sin esta información, compradores e inquilinos quedaban expuestos a riesgos hidrológicos ocultos que podían erosionar significativamente los retornos esperados.

## Enfoque Técnico

### Stack Tecnológico

- **Plataforma de Procesamiento**: Google Earth Engine — API Python (`earthengine-api`)
- **Fuente Satelital**: Sentinel-2 (vía colección Google Dynamic World)
- **Clasificación de Cobertura**: Google Dynamic World — dataset de uso/cobertura del suelo en tiempo casi real que provee probabilidades por píxel para cada clase, incluyendo clases diferenciadas de `water` y `flooded_vegetation`
- **Visualización e Informes**: Python, Matplotlib, gráficos personalizados
- **Formatos de Datos Geoespaciales**: GeoJSON para límites de lotes, compuestos ráster para mapas de probabilidad hídrica

!!! info "Nota Metodológica"
    Si bien este caso de estudio fue implementado usando imágenes **Sentinel-2** a través de Dynamic World, la metodología está diseñada para ser agnóstica al sensor. Puede extenderse a **Landsat 7/8** (usando umbrales de MNDWI) o a una **colección híbrida Sentinel + Landsat** para incrementar la profundidad temporal y la densidad de observaciones cuando se requieren registros históricos más extensos.


### Dynamic World: Detección de Inundación con Doble Clase

El análisis aprovecha **Google Dynamic World**, un dataset de uso/cobertura del suelo en tiempo casi real derivado de imágenes Sentinel-2. A diferencia de los índices de agua tradicionales que producen una clasificación binaria agua/no-agua, Dynamic World provee estimaciones de probabilidad por píxel para múltiples clases de cobertura — incluyendo de forma crítica dos clases relacionadas con inundación:

- **`water`**: Cuerpos de agua abierta, agua estancada sobre suelo desnudo y escorrentía superficial
- **`flooded_vegetation`**: Vegetación parcial o totalmente sumergida, indicando suelos saturados y condiciones de anegamiento sin agua abierta visible

Esta distinción de doble clase es esencial para la evaluación de riesgo agrícola. Un campo puede no presentar agua abierta pero aún así exhibir vegetación inundada extensa — una condición que compromete la transitabilidad del suelo con la misma severidad. Al rastrear ambas clases de forma independiente, el análisis captura el espectro completo del riesgo hidrológico.

### Extensibilidad a Otros Sensores

Si bien esta implementación utilizó el Dataset Dynamic World generado a partir de imágenes Sentinel-2, la metodología está diseñada para soportar fuentes de datos alternativas o combinadas. La imagen a continuación ilustra cómo diferentes sensores satelitales y métodos de clasificación detectan agua en un mismo campo:

![Comparación de clasificación de agua entre tres fuentes satelitales](../../assets/water-risk-assessment/different_water_classifications.jpg)
*Comparación de enfoques de detección de agua: banda SCL de Sentinel-2 (izquierda), MNDWI de Landsat 8 (centro) y MNDWI de Landsat 7 (derecha). Los contornos amarillos indican cuerpos de agua y áreas anegadas detectadas. Cada método ofrece diferentes compromisos en resolución espacial, profundidad temporal y precisión de clasificación — el flujo de trabajo puede incorporar cualquiera de ellos según los requerimientos del proyecto.*

## Aspectos Destacados de la Implementación

### Mapeo Histórico de Probabilidad Hídrica

El algoritmo central procesa cada imagen disponible de Dynamic World en la serie temporal, extrae las bandas de probabilidad de `water` y `flooded_vegetation` para cada píxel, y calcula la probabilidad histórica promedio de cada clase en cada ubicación. El resultado es un par de superficies de probabilidad continuas que revelan qué áreas dentro de un campo están crónicamente afectadas por agua abierta, vegetación inundada, o ambas.

![Mapa de probabilidad hídrica superpuesto sobre imagen satelital](../../assets/water-risk-assessment/water_probability.png)

*Mapa de probabilidad hídrica histórica para un establecimiento sobre el Río Uruguay. Las áreas verdes indican zonas dominadas por vegetación inundada; las áreas violetas indican agua abierta persistente. La superposición revela la distribución espacial del riesgo hidrológico en siete lotes (Lote 1–7).*

### Perfilado Estacional Mensual

Más allá del promedio histórico, el flujo de trabajo genera un desglose mes a mes de la probabilidad de agua y vegetación inundada. Este perfil estacional es crítico para la planificación agrícola, ya que revela si los picos de riesgo de inundación coinciden con las ventanas de siembra o cosecha.

![Serie temporal de probabilidad mensual — histórica](../../assets/water-risk-assessment/historic_dynamic.png)

*Probabilidad mensual histórica de agua (rojo) y vegetación inundada (azul) a lo largo de todo el archivo satelital. Los picos corresponden a eventos de inundación mayores, con patrones estacionales recurrentes visibles año tras año.*

![Perfil de probabilidad mensual — promediado](../../assets/water-risk-assessment/monthly_dynamic.png)

*Perfil de probabilidad mensual promediado que muestra el comportamiento estacional de agua y vegetación inundada. Esta vista permite la identificación rápida de meses de alto riesgo para las operaciones agrícolas.*

### Análisis de Riesgo por Lote

El sistema calcula curvas de probabilidad hídrica para cada lote individual dentro de un establecimiento, permitiendo un análisis comparativo. Esto es particularmente valioso al negociar términos de arrendamiento para lotes específicos o priorizar qué lotes adquirir.

![Curvas de probabilidad hídrica por lote](../../assets/water-risk-assessment/field_dynamic.png)
*Probabilidad hídrica por lote para un establecimiento sobre el Río Uruguay. Cada curva representa un lote diferente, mostrando su comportamiento hídrico estacional particular. Los lotes más grandes cerca del río (ej., "Costa Río Uruguay 4 — 102 ha") exhiben perfiles de riesgo distintos en comparación con lotes más pequeños o más elevados.*

### Clasificación Integral de Riesgo

El entregable final integra todos los productos en un único panel de evaluación de riesgo: mapas espaciales mensuales, un gráfico de áreas apiladas mostrando la superficie por nivel de riesgo por mes, y una tabla detallada cuantificando hectáreas dentro de cada categoría de riesgo.

![Panel completo de evaluación de riesgo hídrico](../../assets/water-risk-assessment/riesgo_hidrico.jpg)

*Evaluación completa de riesgo hídrico: (izquierda) distribución espacial mensual del riesgo de inundación, (arriba-derecha) gráfico de áreas apiladas de superficie por nivel de probabilidad de inundación por mes, (abajo-derecha) tabla detallada mostrando hectáreas dentro de cada categoría de riesgo (0-10%, 10-20%, 20-30%, 30-40%, >40%) para cada mes del año.*

### Flujo de Trabajo Analítico

<div align="center" style="margin: 0 auto; display: block; max-width: 1400px;">
```mermaid
flowchart LR
    A["🛰️ Ingestar Colección<br/>Dynamic World"] --> B["🔍 Filtrado Espacial<br/>y Temporal"]
    B --> C["💧 Extraer water y<br/>flooded_vegetation"]
    C --> D["📅 Agregación<br/>Mensual"]
    D --> E["📊 Cómputo de<br/>Probabilidad"]
    E --> F["🗺️ Mapas de Riesgo<br/>e Informes"]

    classDef proxy fill:#EED5CF,stroke:#B5C0C0,stroke-width:2px,color:#3A4040
    classDef core fill:#DDEAF6,stroke:#B5C0C0,stroke-width:2px,color:#3A4040
    classDef data fill:#D6CCFF,stroke:#B5C0C0,stroke-width:2px,color:#3A4040

    class A proxy
    class B,C,D,E core
    class F data
```
</div>

## Resultados e Impacto

- **6+ años de datos Sentinel-2** procesados por cada evaluación de campo vía Dynamic World, proporcionando una caracterización estadísticamente significativa del comportamiento hídrico
- **2 clases independientes de inundación** (agua abierta y vegetación inundada) rastreadas por separado, capturando el espectro completo del riesgo hidrológico que los métodos de índice único no detectan
- **Perfil de riesgo estacional de 12 meses** entregado por establecimiento, habilitando la alineación precisa de los planes operativos con las condiciones del campo
- **Sistema de clasificación de riesgo en 5 niveles** (0-10%, 10-20%, 20-30%, 30-40%, >40% de probabilidad de inundación) aplicado a cada hectárea, brindando a los tomadores de decisiones una visión clara y cuantificada de la exposición
- **40-60% de reducción en el tiempo de due diligence** (estimado) — reemplazando semanas de visitas a campo y evidencia anecdótica por una evaluación basada en datos entregada en días
- **Impacto directo en la negociación de arrendamientos** — los lotes con perfiles de alto riesgo proporcionaron argumentos para ajustar precios, mientras que los lotes de bajo riesgo confirmaron valuaciones premium

## Mis Contribuciones

- **Diseñé e implementé el flujo de trabajo completo usando la API Python de GEE** desde cero, incluyendo el filtrado de la colección Dynamic World, la extracción de bandas de probabilidad y la agregación temporal
- **Seleccioné Google Dynamic World como fuente de clasificación**, aprovechando sus probabilidades pre-computadas por píxel para distinguir entre agua abierta y vegetación inundada — una distinción crítica para la evaluación de transitabilidad agrícola
- **Diseñé el pipeline de agregación mensual e histórica**, transformando bandas de probabilidad crudas por imagen en superficies de probabilidad accionables y perfiles estacionales
- **Desarrollé el módulo de análisis por lote**, integrando geometrías de límites de lotes con salidas ráster de probabilidad para generar curvas de riesgo comparativas
- **Diseñé el marco de clasificación de riesgo** (escala de probabilidad de inundación en 5 niveles) y el panel de reporte final combinando mapas espaciales, gráficos de series temporales y resúmenes tabulares
- **Entregué el análisis como una herramienta reutilizable basada en scripts** aplicable a cualquier nuevo campo bajo evaluación, respaldando las decisiones de adquisición de tierras en curso de la empresa


<div class="grid cards" style="margin-top: 3rem" markdown>

-   :material-coffee:{ .lg .middle } ¡Tomemos un café virtual juntos!

    ---

    ¿Necesitás análisis de riesgo hídrico basado en imágenes satelitales para evaluación de tierras agrícolas? Reservá una sesión gratuita de 30 minutos para conversar sobre tus desafíos y explorar cómo podemos trabajar juntos.

    [Reservar una llamada gratuita :material-arrow-top-right:](https://calendly.com/joaquin-urruti/consultation-30min){ .md-button .md-button--primary }

</div>
