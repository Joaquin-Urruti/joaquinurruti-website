---
title: Computing Large-Scale Distance Matrices with a Local OSRM Server
description: Scaling Logistics Cost Modeling with Local OSRM Distance Matrices
---

# Computing Large-Scale Distance Matrices with a Local OSRM Server

!!! abstract "Project Summary"
    **Project Type**: Open Source Tool / Internal Infrastructure  
    **Repository**: [osrm-local-server](https://github.com/Joaquin-Urruti/osrm-local-server)  
    **Industry**: Logistics / Supply Chain / Agricultural Distribution  
    
    **Key Outcomes**:
    
    - Unlimited distance calculations without API rate limits
    - Very fast matrix generation for large origin-destination pairs
    - 100% cost elimination vs. commercial routing API usage
    - Full control over data freshness and routing parameters
    - Repeatable, auditable distance metrics for compliance
    - Scalable to regional or country-level logistics networks

This project addresses a common bottleneck in logistics operations: calculating road distances between many locations efficiently. When public routing APIs become too slow, expensive, or rate-limited, running OSRM locally transforms routing into a predictable, high-throughput service that scales with your business needs.

## Do you need to calculate transport costs based on a very large distance matrix?

When you’re pricing logistics, kilometers are money. If your business needs to compute road distance between **many origins** (warehouses, farms, stores, supplier locations) and **many destinations** (customers, ports, plants, distribution centers), the usual “call a routing API per pair” approach falls apart quickly: it’s slow, rate-limited, and expensive.

This project provides a practical alternative: **run OSRM locally** and generate **large origin–destination (OD) distance matrices** quickly, using OSRM’s **Table Service** instead of individual route calls.

The result is a system designed for companies that need to calculate logistics costs at scale, without depending on the public OSRM API or its usage limits.

## Why this matters for cost modeling

In most logistics and supply-chain models, distance is a core input:

- Transport cost is usually proportional to kilometers traveled.
- Choosing the optimal destination (plant, port, DC) depends on relative distances.
- Costs must be recalculated frequently as volumes, routes, or commercial conditions change.

Public routing APIs are not designed for these workloads. Rate limits, request caps, and latency make them unsuitable for building large OD matrices repeatedly.

Running OSRM locally removes these constraints and turns routing into a predictable, high-throughput internal service.

## What the project delivers

This repository implements an end-to-end workflow to compute distance matrices using a local OSRM instance:

1. Start an OSRM server locally using Docker and OpenStreetMap data.
2. Load origin geometries (polygons) and destination points from GIS files.
3. Generate centroids for origin polygons.
4. Snap centroids to the nearest road segment to ensure routable points.
5. Use OSRM’s **Table Service** to compute all origin–destination distances and durations in one request.
6. Export the results to Excel for further analysis or cost modeling.

The example configuration is set up for Argentina, but the same approach works for any region with available OpenStreetMap extracts.

## Key architectural decisions

### OSRM running locally in Docker

OSRM is a high-performance routing engine built on OpenStreetMap data. Running it locally gives full control over:

- Data freshness
- Compute resources
- Request volume
- Reproducibility of results

Docker ensures the setup is repeatable and easy to deploy across environments.

### Using the Table Service for matrices

Instead of computing one route at a time, the project uses OSRM’s **Table Service**, which computes a full distance and duration matrix between multiple sources and destinations in a single call.

This approach drastically reduces overhead and makes large matrices feasible.

### Snapping origins to the road network

Origin data often comes as polygons (fields, zones, service areas). Their centroids may not lie exactly on a routable road.

The pipeline snaps each centroid to the nearest road node before routing, ensuring realistic and reliable distance calculations.

![Architecture Diagram](../../assets/portfolio-orsm.svg)
*Schema of the workflow*

## How to run the project

### Requirements

- Docker
- Python 3.11+
- Jupyter Notebook
- Dependencies installed via `uv` or `pip`

### Start the local OSRM server

```bash
git clone https://github.com/Joaquin-Urruti/osrm-local-server
cd osrm-local-server

uv sync
# or
pip install -r requirements.txt

./iniciar_server_osrm_docker.sh
```

The first run preprocesses the OpenStreetMap extract and takes longer. Subsequent runs reuse the processed data and start quickly.

### Input data

#### Place your GIS files under inputs:
- "origins.gpkg" or .shp: polygon geometries with identifiers (in this project polygons were used, but they could be points). 
- "destinations.gpkg" or .shp: point geometries for destinations.  

All data is converted internally to WGS84 (EPSG:4326) for compatibility with OSRM.

### Generate the distance matrix

#### Run the notebook distancias_table.ipynb. It will:
- Filter origins by campaign and optional zones
- Generate and snap centroids
- Query the local OSRM Table Service
- Export the OD matrix to: outputs/matrix.xlsx

Each row represents an origin–destination pair with distance (km) and duration (hours).

## Results and business impact

The main result is the ability to compute large distance matrices quickly and reliably, without depending on the public OSRM server.

### For companies, this enables:

- Faster logistics cost calculations
- Repeatable and auditable distance metrics
- Scenario analysis across many origins and destinations
- Full control over routing data and performance

This setup is particularly valuable for agricultural logistics, retail distribution, manufacturing supply chains, and any operation where kilometers directly affect margins.

### In summary

If your organization needs to calculate logistics costs at scale and public routing APIs are becoming a bottleneck, running OSRM locally with the Table Service is a solid, production-ready approach.

This project provides a concrete, reusable starting point for building those distance matrices efficiently and without external limits.



<div class="grid cards" style="margin-top: 3rem" markdown>

-   :material-coffee:{ .lg .middle } Let's have a virtual coffee together!

    ---
    
    Want to see if we're a match? Let's have a chat and find out. Schedule a free 30-minute strategy session to discuss your challenges and explore how we can work together.

    [Book Free Intro Call :material-arrow-top-right:](https://calendly.com){ .md-button .md-button--primary }

</div>