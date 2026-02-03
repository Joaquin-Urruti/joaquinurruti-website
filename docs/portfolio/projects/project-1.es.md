---
title: Mapeo automático de cumplimiento de aplicaciones fitosanitarias en Argentina
description: Sistema GIS automatizado para calcular zonas de restricción de aplicaciones fitosanitarias en campos agrícolas argentinos, procesando regulaciones multi-jurisdiccionales para generar mapas de cumplimiento e informes para operaciones de pulverización aérea y terrestre.
---

!!! abstract "Resumen del Caso de Estudio"
    **Cliente**: Empresa Argentina de Producción Agrícola
    <!-- **Website**: [Espartina]   -->
    <!-- **Website**: [https://espartina.com.ar/]   -->
    **Industria**: Tecnología Agrícola / Cumplimiento Regulatorio

    **Métricas de Impacto**:

    - Reducción de 1000x en tiempo de procesamiento GIS manual por campaña
    - +2100 lotes agrícolas analizados en toda Argentina por ciclo de procesamiento
    - +70 departamentos/partidos con legislación rastreada en la base de datos de cumplimiento
    - 100% de cumplimiento con regulaciones fitosanitarias locales en todas las jurisdicciones
    - +100 horas de analista ahorradas por campaña agrícola


# Automatización de extremo a extremo del mapeo de cumplimiento de aplicaciones fitosanitarias en Argentina con un flujo de trabajo GIS automatizado

## Resumen

Desarrollo de un sistema de cumplimiento geoespacial automatizado que calcula zonas de exclusión y amortiguación para aplicaciones de productos fitosanitarios en campos agrícolas de Argentina. El sistema procesa múltiples marcos regulatorios de diferentes jurisdicciones para generar mapas de restricción precisos e informes de cumplimiento tanto para aplicaciones aéreas como terrestres.

## El Desafío

Las operaciones agrícolas en Argentina deben cumplir con regulaciones estrictas respecto a la aplicación de productos fitosanitarios cerca de áreas sensibles como escuelas, zonas urbanas, cuerpos de agua y cortinas de árboles. La complejidad surge de tres factores clave:

**Fragmentación Jurisdiccional**: Cada provincia y departamento (o partido) en Argentina tiene autoridad autónoma para definir sus propias distancias de restricción, resultando en un mosaico de regulaciones a lo largo de las regiones agrícolas del país.

**Múltiples Tipos de Restricción**: Las regulaciones distinguen entre dos métodos de aplicación (aéreo y terrestre) y dos niveles de restricción (zonas de exclusión total donde no se permite ninguna aplicación, y zonas de amortiguación donde solo se permiten productos de banda verde).

**Escala Operacional**: La empresa gestiona campos agrícolas distribuidos a lo largo de todo el cinturón agrícola argentino, requiriendo verificación de cumplimiento para docenas de jurisdicciones con diferentes requisitos regulatorios cada temporada de cultivo.

Anteriormente, este análisis requería **mucho trabajo GIS manual** para cada departamento—creando buffers individuales alrededor de objetos sensibles usando distancias específicas de la jurisdicción, luego intersectando estos con los límites del campo. Este proceso era lento, propenso a errores y difícil de delegar a especialistas no-GIS.

## Enfoque Técnico

### Stack Tecnológico

-   **Lenguaje de Programación**: Python 3.x
-   **Procesamiento Geoespacial**: GeoPandas, Shapely
-   **Entorno de Desarrollo**: Google Colab (Jupyter Notebook)
-   **Almacenamiento de Datos**: Google Drive
-   **Formatos de Datos**: GeoPackage (.gpkg), Excel (.xlsx)
-   **Sistema de Referencia de Coordenadas**: EPSG:32720 (UTM Zona 20S)

### Arquitectura

!!! info "Arquitectura del Sistema" La solución sigue una arquitectura de procesamiento por lotes con almacenamiento y ejecución basados en la nube.

    **Componentes**:

    - **Capa de Entrada**: Carpeta de Google Drive conteniendo archivos GeoPackage estandarizados
    - **Motor de Procesamiento**: Notebook Python ejecutando operaciones espaciales
    - **Base de Datos de Legislación**: GeoPackage con matriz regulatoria por jurisdicción
    - **Generador de Salida**: Exportación automatizada de capas procesadas e informes


### Modelo de Datos

La base de datos de legislación mantiene una matriz regulatoria con 15 parámetros de distancia por departamento:

| Tipo de Parámetro | Objetos Cubiertos | Tipos de Aplicación |
|----------------------|------------------------|--------------------------|
| Distancias de exclusión | Árboles, Áreas urbanas, Escuelas, Cursos de agua, Cuerpos de agua | Terrestre, Aéreo |
| Distancias de amortiguación | Árboles, Áreas urbanas, Escuelas, Cursos de agua, Cuerpos de agua | Terrestre, Aéreo |

## Aspectos Destacados de la Implementación

### Gestión de la Matriz Regulatoria

El sistema ingiere una capa de legislación donde cada departamento contiene valores de distancia codificados siguiendo una convención de nomenclatura estandarizada:

``` python
DISTANCE_CODES = {
    'EPT': 'Exclusion - Urban Areas - Terrestrial',
    'APT': 'Buffer - Urban Areas - Terrestrial',
    'EPA': 'Exclusion - Urban Areas - Aerial',
    'APA': 'Buffer - Urban Areas - Aerial',
    'EET': 'Exclusion - Schools - Terrestrial',
    'AET': 'Buffer - Schools - Terrestrial',
    # Códigos adicionales para cuerpos de agua y cursos de agua
}
```

### Generación Dinámica de Buffers

Un desafío técnico clave fue manejar la naturaleza acumulativa de las zonas de amortiguación. La distancia de amortiguación se mide desde el objeto sensible, no desde el límite de la zona de exclusión. La solución ajusta las distancias de buffer automáticamente.

### Pipeline de Procesamiento Espacial

El procesamiento central sigue un enfoque sistemático:

1.  **Reparación de Geometría**: Las capas de entrada se limpian para corregir errores de geometría y topología
2.  **Reproyección**: Todas las capas convertidas a UTM Zona 20S para cálculos métricos
3.  **Unión Espacial**: Los objetos sensibles heredan parámetros regulatorios de su departamento contenedor
4.  **Generación de Buffers**: 15 capas de buffer distintas creadas basadas en tipo de objeto y categoría de restricción
5.  **Intersección**: Buffers recortados a los límites del lote agrícola
6.  **Resolución de Superposición**: A las zonas de amortiguación se les resta las zonas de exclusión para prevenir doble conteo

![Procesamiento de áreas de exclusión y amortiguación](../../assets/project-1/proceso_areas_exclusion.png)

*Diagrama del flujo de trabajo de procesamiento geoespacial para zonas de exclusión y amortiguación: desde la ingestión de datos regulatorios y geográficos hasta la generación de buffers no superpuestos por tipo de restricción, recortados a los límites de parcelas agrícolas.*

![Zona de exclusión y amortiguación para aplicaciones terrestres en un campo dado](../../assets/project-1/exclusion-type.png)
*Zona de exclusión y amortiguación para aplicaciones terrestres en un campo dado.*

## Resultados e Impacto

El sistema automatizado entrega mejoras operacionales significativas:

| Métrica | Resultado |
|------------------------------------|------------------------------------|
| Reducción de tiempo de procesamiento | 99% comparado con flujo de trabajo manual - de 100 horas a menos de 10 minutos |
| Jurisdicciones cubiertas | +300 departamentos en toda Argentina |
| Precisión | 100% cumplimiento regulatorio con ordenanzas locales |
| Generación de informes | Salidas automatizadas en Excel y GeoPackage |
| Accesibilidad de usuarios | Especialistas no-GIS pueden ejecutar el flujo de trabajo |

**Beneficios de Negocio**:

-   **Negociación Pre-arrendamiento**: Datos de restricción disponibles antes de decisiones de alquiler de campos, habilitando negociaciones informadas
-   **Cumplimiento Regulatorio**: Documentación completa de áreas restringidas para propósitos de auditoría
-   **Análisis Estratégico**: Métricas agregadas por zona, departamento o tipo de restricción para reportes gerenciales
-   **Planificación Operacional**: Delineación clara de áreas que requieren tratamiento especial o restricciones de productos

## Mis Contribuciones

Como único desarrollador de esta solución, mis responsabilidades incluyeron:

-   **Análisis de Requerimientos**: Traduje requerimientos regulatorios complejos en un modelo de datos estructurado
-   **Diseño de Arquitectura**: Diseñé el flujo de trabajo basado en la nube optimizado para delegación a usuarios no técnicos
-   **Desarrollo Geoespacial**: Implementé todos los algoritmos de procesamiento espacial incluyendo generación de buffers, intersección y resolución de superposición
-   **Documentación**: Produje documentación técnica comprensiva para mantenimiento y transferencia de conocimiento

## Lecciones Aprendidas

**La Simplicidad Habilita la Adopción**: Al diseñar la solución como un notebook de Colab con integración de Google Drive, el flujo de trabajo pudo ser delegado a miembros del equipo sin experiencia en GIS. La decisión de priorizar la usabilidad sobre la sofisticación técnica demostró ser crítica para el éxito operacional.

**Mantenimiento de Datos Regulatorios**: El aspecto más desafiante es mantener la base de datos de legislación actualizada. Establecer un proceso claro para monitorear cambios regulatorios y actualizar la base de datos es tan importante como la implementación técnica.

**La Precisión Geométrica Importa**: El cumplimiento agrícola requiere cálculos de área precisos. Invertir tiempo en reparación de geometría y selección adecuada del sistema de coordenadas previno problemas posteriores con discrepancias de área.

<div class="grid cards" style="margin-top: 3rem" markdown>

-   :material-coffee:{ .lg .middle } ¡Tomemos un café virtual juntos!

    ---

    ¿Querés ver si somos un buen match? Charlemos y descubrámoslo. Agendá una sesión de estrategia gratuita de 30 minutos para discutir tus desafíos y explorar cómo podemos trabajar juntos.

    [Agendá una llamada gratuita :material-arrow-top-right:](https://calendly.com){ .md-button .md-button--primary }

</div>
