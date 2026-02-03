---
title: Cálculo de Matrices de Distancia a Gran Escala con un Servidor OSRM Local
description: Escalando el Modelado de Costos Logísticos con Matrices de Distancia OSRM Locales
---

# Cálculo de Matrices de Distancia a Gran Escala con un Servidor OSRM Local

!!! abstract "Resumen del Proyecto"
    **Tipo de Proyecto**: Herramienta Open Source / Infraestructura Interna
    **Repositorio**: [osrm-local-server](https://github.com/Joaquin-Urruti/osrm-local-server)
    **Industria**: Logística / Cadena de Suministro / Distribución Agrícola

    **Resultados Clave**:

    - Cálculos de distancia ilimitados sin límites de tasa de API
    - Generación muy rápida de matrices para grandes pares origen-destino
    - 100% de eliminación de costos vs. uso de APIs de ruteo comerciales
    - Control total sobre la frescura de datos y parámetros de ruteo
    - Métricas de distancia repetibles y auditables para cumplimiento
    - Escalable a redes logísticas regionales o a nivel país

Este proyecto aborda un cuello de botella común en operaciones logísticas: calcular distancias por carretera entre muchas ubicaciones eficientemente. Cuando las APIs públicas de ruteo se vuelven muy lentas, costosas o limitadas en tasa, ejecutar OSRM localmente transforma el ruteo en un servicio predecible y de alto rendimiento que escala con las necesidades de tu negocio.

## ¿Necesitás calcular costos de transporte basados en una matriz de distancia muy grande?

Cuando estás calculando precios de logística, los kilómetros son dinero. Si tu negocio necesita computar distancias por carretera entre **muchos orígenes** (almacenes, campos, tiendas, ubicaciones de proveedores) y **muchos destinos** (clientes, puertos, plantas, centros de distribución), el enfoque usual de "llamar a una API de ruteo por par" colapsa rápidamente: es lento, tiene límites de tasa y es costoso.

Este proyecto proporciona una alternativa práctica: **ejecutar OSRM localmente** y generar **grandes matrices de distancia origen-destino (OD)** rápidamente, usando el **Table Service** de OSRM en lugar de llamadas de ruta individuales.

El resultado es un sistema diseñado para empresas que necesitan calcular costos logísticos a escala, sin depender de la API pública de OSRM o sus límites de uso.

## Por qué esto importa para el modelado de costos

En la mayoría de los modelos de logística y cadena de suministro, la distancia es un input central:

- El costo de transporte es usualmente proporcional a los kilómetros recorridos.
- Elegir el destino óptimo (planta, puerto, CD) depende de las distancias relativas.
- Los costos deben recalcularse frecuentemente a medida que cambian los volúmenes, rutas o condiciones comerciales.

Las APIs públicas de ruteo no están diseñadas para estas cargas de trabajo. Los límites de tasa, topes de solicitudes y latencia las hacen inadecuadas para construir grandes matrices OD repetidamente.

Ejecutar OSRM localmente elimina estas restricciones y convierte el ruteo en un servicio interno predecible y de alto rendimiento.

## Lo que entrega el proyecto

Este repositorio implementa un flujo de trabajo de extremo a extremo para computar matrices de distancia usando una instancia local de OSRM:

1. Iniciar un servidor OSRM localmente usando Docker y datos de OpenStreetMap.
2. Cargar geometrías de origen (polígonos) y puntos de destino desde archivos GIS.
3. Generar centroides para los polígonos de origen.
4. Ajustar los centroides al segmento de carretera más cercano para asegurar puntos ruteables.
5. Usar el **Table Service** de OSRM para computar todas las distancias y duraciones origen-destino en una sola solicitud.
6. Exportar los resultados a Excel para análisis adicional o modelado de costos.

La configuración de ejemplo está preparada para Argentina, pero el mismo enfoque funciona para cualquier región con extractos disponibles de OpenStreetMap.

## Decisiones arquitectónicas clave

### OSRM ejecutándose localmente en Docker

OSRM es un motor de ruteo de alto rendimiento construido sobre datos de OpenStreetMap. Ejecutarlo localmente da control total sobre:

- Frescura de datos
- Recursos de cómputo
- Volumen de solicitudes
- Reproducibilidad de resultados

Docker asegura que la configuración sea repetible y fácil de desplegar en diferentes entornos.

### Usando el Table Service para matrices

En lugar de computar una ruta a la vez, el proyecto usa el **Table Service** de OSRM, que computa una matriz completa de distancias y duraciones entre múltiples orígenes y destinos en una sola llamada.

Este enfoque reduce drásticamente la sobrecarga y hace factibles las matrices grandes.

### Ajustando orígenes a la red vial

Los datos de origen a menudo vienen como polígonos (campos, zonas, áreas de servicio). Sus centroides pueden no estar exactamente sobre una carretera ruteable.

El pipeline ajusta cada centroide al nodo de carretera más cercano antes del ruteo, asegurando cálculos de distancia realistas y confiables.

![Diagrama de Arquitectura](../../assets/portfolio-orsm.svg)
*Esquema del flujo de trabajo*

## Cómo ejecutar el proyecto

### Requisitos

- Docker
- Python 3.11+
- Jupyter Notebook
- Dependencias instaladas vía `uv` o `pip`

### Iniciar el servidor OSRM local

```bash
git clone https://github.com/Joaquin-Urruti/osrm-local-server
cd osrm-local-server

uv sync
# o
pip install -r requirements.txt

./iniciar_server_osrm_docker.sh
```

La primera ejecución preprocesa el extracto de OpenStreetMap y toma más tiempo. Las ejecuciones posteriores reutilizan los datos procesados e inician rápidamente.

### Datos de entrada

#### Colocá tus archivos GIS bajo inputs:
- "origins.gpkg" o .shp: geometrías de polígonos con identificadores (en este proyecto se usaron polígonos, pero podrían ser puntos).
- "destinations.gpkg" o .shp: geometrías de puntos para destinos.

Todos los datos se convierten internamente a WGS84 (EPSG:4326) para compatibilidad con OSRM.

### Generar la matriz de distancias

#### Ejecutá el notebook distancias_table.ipynb. Este:
- Filtra orígenes por campaña y zonas opcionales
- Genera y ajusta centroides
- Consulta el Table Service de OSRM local
- Exporta la matriz OD a: outputs/matrix.xlsx

Cada fila representa un par origen-destino con distancia (km) y duración (horas).

## Resultados e impacto de negocio

El resultado principal es la capacidad de computar grandes matrices de distancia rápida y confiablemente, sin depender del servidor público de OSRM.

### Para empresas, esto habilita:

- Cálculos de costos logísticos más rápidos
- Métricas de distancia repetibles y auditables
- Análisis de escenarios a través de muchos orígenes y destinos
- Control total sobre datos de ruteo y rendimiento

Esta configuración es particularmente valiosa para logística agrícola, distribución retail, cadenas de suministro de manufactura, y cualquier operación donde los kilómetros afectan directamente los márgenes.

### En resumen

Si tu organización necesita calcular costos logísticos a escala y las APIs públicas de ruteo se están convirtiendo en un cuello de botella, ejecutar OSRM localmente con el Table Service es un enfoque sólido y listo para producción.

Este proyecto proporciona un punto de partida concreto y reutilizable para construir esas matrices de distancia eficientemente y sin límites externos.



<div class="grid cards" style="margin-top: 3rem" markdown>

-   :material-coffee:{ .lg .middle } ¡Tomemos un café virtual juntos!

    ---

    ¿Querés ver si somos un buen match? Charlemos y descubrámoslo. Agendá una sesión de estrategia gratuita de 30 minutos para discutir tus desafíos y explorar cómo podemos trabajar juntos.

    [Agendá una llamada gratuita :material-arrow-top-right:](https://calendly.com){ .md-button .md-button--primary }

</div>
