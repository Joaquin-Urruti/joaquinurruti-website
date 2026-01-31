---
title: Automatic crop protection compliance mapping across Argentina
description: Automated GIS system for calculating phytosanitary application restriction zones across Argentine agricultural fields, processing multi-jurisdictional regulations to generate compliance maps and reports for aerial and terrestrial spraying operations.
---

!!! abstract "Case Study Summary"
    **Client**: Argentine Agricultural Production Company  
    <!-- **Website**: [Espartina]   -->
    <!-- **Website**: [https://espartina.com.ar/]   -->
    **Industry**: Agricultural Technology / Regulatory Compliance  
    
    **Impact Metrics**:
    
    - 1000x reduction in manual GIS processing time per campaign
    - +2100 agricultural lots analyzed across Argentina per processing cycle
    - +70 departments/partidos with legislation tracked in the compliance database
    - 100% compliance with local phytosanitary regulations across all jurisdictions
    - +100 of analyst time saved per agricultural campaign

# End-to-end automation of phytosanitary applications compliance mapping across Argentina with an automated GIS workflow

## Overview

Development of an automated geospatial compliance system that calculates exclusion and buffer zones for phytosanitary product applications across agricultural fields in Argentina. The system processes multiple regulatory frameworks from different jurisdictions to generate precise restriction maps and compliance reports for both aerial and terrestrial applications.

## The Challenge

Agricultural operations in Argentina must comply with strict regulations regarding the application of phytosanitary products near sensitive areas such as schools, urban zones, water bodies, and tree lines. The complexity arises from three key factors:

**Jurisdictional Fragmentation**: Each department (partido) in Argentina has autonomous authority to define its own restriction distances, resulting in a patchwork of regulations across the country's agricultural regions.

**Multiple Restriction Types**: Regulations distinguish between two application methods (aerial and terrestrial) and two restriction levels (total exclusion zones where no application is permitted, and buffer zones where only green-band products are allowed).

**Operational Scale**: The company manages agricultural fields distributed across the entire Argentine agricultural belt, requiring compliance verification for dozens of jurisdictions with different regulatory requirements each growing season.

Previously, this analysis required manual GIS work for each department—creating individual buffers around sensitive objects using jurisdiction-specific distances, then intersecting these with field boundaries. This process was time-consuming, error-prone, and difficult to delegate to non-GIS specialists.

## Technical Approach

### Technology Stack

- **Programming Language**: Python 3.x
- **Geospatial Processing**: GeoPandas, Shapely
- **Development Environment**: Google Colab (Jupyter Notebook)
- **Data Storage**: Google Drive
- **Data Formats**: GeoPackage (.gpkg), Excel (.xlsx)
- **Coordinate Reference System**: EPSG:32720 (UTM Zone 20S)

### Architecture

!!! info "System Architecture"
    The solution follows a batch processing architecture with cloud-based storage and execution.
    
    **Components**:
    
    - **Input Layer**: Google Drive folder containing standardized GeoPackage files
    - **Processing Engine**: Python notebook executing spatial operations
    - **Legislation Database**: GeoPackage with regulatory matrix by jurisdiction
    - **Output Generator**: Automated export of processed layers and reports

### Data Model

The legislation database maintains a regulatory matrix with 15 distance parameters per department:

| Parameter Type | Objects Covered | Application Types |
|----------------|-----------------|-------------------|
| Exclusion distances | Urban areas, Schools, Water courses, Water bodies | Terrestrial, Aerial |
| Buffer distances | Urban areas, Schools, Water courses, Water bodies | Terrestrial, Aerial |

## Implementation Highlights

### Regulatory Matrix Management

The system ingests a legislation layer where each department contains codified distance values following a standardized naming convention:

```python
DISTANCE_CODES = {
    'EPT': 'Exclusion - Urban Areas - Terrestrial',
    'APT': 'Buffer - Urban Areas - Terrestrial',
    'EPA': 'Exclusion - Urban Areas - Aerial',
    'APA': 'Buffer - Urban Areas - Aerial',
    'EET': 'Exclusion - Schools - Terrestrial',
    'AET': 'Buffer - Schools - Terrestrial',
    # Additional codes for water bodies and water courses
}
```

### Dynamic Buffer Generation

A key technical challenge was handling the cumulative nature of buffer zones. The buffer distance is measured from the sensitive object, not from the exclusion zone boundary. The solution adjusts buffer distances automatically:

```python
def adjust_buffer_distances(gdf: gpd.GeoDataFrame) -> gpd.GeoDataFrame:
    """Adjust buffer distances to account for exclusion zone overlap."""
    buffer_cols = [col for col in gdf.columns if col.startswith('A')]
    
    for buffer_col in buffer_cols:
        exclusion_col = 'E' + buffer_col[1:]
        if exclusion_col in gdf.columns:
            mask = gdf[buffer_col] != 0
            gdf.loc[mask, buffer_col] = gdf.loc[mask, buffer_col] + gdf.loc[mask, exclusion_col]
    
    return gdf
```

### Spatial Processing Pipeline

The core processing follows a systematic approach:

1. **Geometry Repair**: Input layers are cleaned using `buffer(0)` to fix topology errors
2. **Reprojection**: All layers converted to UTM Zone 20S for metric calculations
3. **Spatial Join**: Sensitive objects inherit regulatory parameters from their containing department
4. **Buffer Generation**: 15 distinct buffer layers created based on object type and restriction category
5. **Intersection**: Buffers clipped to agricultural lot boundaries
6. **Overlap Resolution**: Buffer zones have exclusion zones subtracted to prevent double-counting

![Processing of exclusion and buffer areas](../../assets/project-2/proceso_areas_exclusion.png)

*Diagram of the geospatial processing workflow for exclusion and buffer zones: from regulatory and geographic data ingestion to the generation of non-overlapping buffers by restriction type, clipped to agricultural plot boundaries.*




```python
def generate_restriction_zones(
    sensitive_objects: gpd.GeoDataFrame,
    distance_column: str,
    lots: gpd.GeoDataFrame
) -> gpd.GeoDataFrame:
    """Generate restriction zones intersected with agricultural lots."""
    filtered = sensitive_objects[sensitive_objects[distance_column] > 0].copy()
    
    filtered['geometry'] = filtered.apply(
        lambda row: row.geometry.buffer(row[distance_column]), 
        axis=1
    )
    
    intersected = gpd.overlay(filtered, lots, how='intersection')
    intersected['hectares'] = intersected.geometry.area / 10000
    
    return intersected
```

### Non-Overlapping Zone Extraction

To provide clean outputs for aerial and terrestrial applications, exclusion geometries are subtracted from buffer geometries:

```python
def separate_restriction_types(
    combined_zones: gpd.GeoDataFrame
) -> tuple[gpd.GeoDataFrame, gpd.GeoDataFrame]:
    """Separate exclusion and buffer zones without geometric overlap."""
    exclusion = combined_zones[combined_zones['restriction_type'] == 'Exclusion']
    buffer = combined_zones[combined_zones['restriction_type'] == 'Buffer']
    
    buffer_clean = gpd.overlay(buffer, exclusion, how='difference')
    
    return exclusion, buffer_clean
```

## Results & Impact

The automated system delivers significant operational improvements:

| Metric | Result |
|--------|--------|
| Processing time reduction | [COMPLETE: specify percentage] compared to manual workflow |
| Jurisdictions covered | [COMPLETE: specify number] departments across Argentina |
| Accuracy | 100% regulatory compliance with local ordinances |
| Report generation | Automated Excel and GeoPackage outputs |
| User accessibility | Non-GIS specialists can execute the workflow |

**Business Benefits**:

- **Pre-lease Negotiation**: Restriction data available before field rental decisions, enabling informed negotiations
- **Regulatory Compliance**: Complete documentation of restricted areas for audit purposes
- **Strategic Analysis**: Aggregated metrics by zone, department, or restriction type for management reporting
- **Operational Planning**: Clear delineation of areas requiring special treatment or product restrictions

## My Contributions

As the sole developer of this solution, my responsibilities included:

- **Requirements Analysis**: Translated complex regulatory requirements into a structured data model
- **Architecture Design**: Designed the cloud-based workflow optimized for delegation to non-technical users
- **Legislation Database**: Created and maintained the regulatory matrix with distance parameters for all relevant jurisdictions
- **Geospatial Development**: Implemented all spatial processing algorithms including buffer generation, intersection, and overlap resolution
- **User Experience**: Packaged the solution as a simple Google Colab notebook requiring only file uploads to execute
- **Documentation**: Produced comprehensive technical documentation for maintenance and knowledge transfer

## Lessons Learned

**Simplicity Enables Adoption**: By designing the solution as a Colab notebook with Google Drive integration, the workflow could be delegated to team members without GIS expertise. The decision to prioritize usability over technical sophistication proved critical for operational success.

**Regulatory Data Maintenance**: The most challenging aspect is keeping the legislation database current. Establishing a clear process for monitoring regulatory changes and updating the database is as important as the technical implementation.

**Geometric Precision Matters**: Agricultural compliance requires precise area calculations. Investing time in geometry repair and proper coordinate system selection prevented downstream issues with area discrepancies.

!!! tip "Portfolio Best Practices"
    This case study demonstrates:
    
    - End-to-end automation of complex geospatial workflows
    - Integration of regulatory compliance requirements into technical solutions
    - Design for non-technical user adoption through simplified interfaces
    - Multi-jurisdictional data management at national scale
    - Python/GeoPandas expertise for agricultural technology applications





<div class="grid cards" style="margin-top: 3rem" markdown>

-   :material-coffee:{ .lg .middle } Let's have a virtual coffee together!

    ---
    
    Want to see if we're a match? Let's have a chat and find out. Schedule a free 30-minute strategy session to discuss your challenges and explore how we can work together.

    [Book Free Intro Call :material-arrow-top-right:](https://calendly.com){ .md-button .md-button--primary }

</div>