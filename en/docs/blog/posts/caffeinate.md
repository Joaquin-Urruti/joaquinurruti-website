---
date: 2026-01-03
authors:
  - joaquinurruti
categories:
  - Tools
  - Quick Tips
  - Commands
description: A MacOS terminal command that will prevent your computer 
---


# Running Uninterrupted Long Processes with MacOS "caffeinate" command

## Why use the "caffeinate" command?

MacOS sleep mode interrupts long-running processes like GIS data analysis, satellite imagery processing, or database migrations. A 6-hour raster processing job can be killed when the system enters sleep mode, wasting hours of computation.


## Solution: Strategic Use of Caffeinate

The built-in `caffeinate` command prevents system sleep **only when necessary**, maintaining power efficiency while ensuring critical processes complete without interruption.


## How Caffeinate Works

`caffeinate` creates **assertions** that modify system sleep behavior. It operates in two modes:

**Wrapper Mode:** When a program is specified, `caffeinate` creates assertions for that utility. Assertions remain active during execution and are automatically released upon completion.

**Direct Mode:** Without a specified utility, `caffeinate` creates assertions directly and keeps them active until manually terminated (`Ctrl+C`) or the terminal closes.

---

## Available Options

### `-d` (display): Prevents the **display** from sleeping. 
**Use case:** Visual process monitoring, presentations, real-time dashboards.

### `-i` (idle)
Prevents the **system** from idle sleeping.

**Use case:** Batch processes, analysis scripts, background operations without user interaction.

### `-m` (media/disk)
Prevents the **disk** from idle sleeping.

**Use case:** Intensive I/O operations, database migrations, backups, continuous log writing.

### `-s` (system on AC)
Prevents the **entire system** from sleeping.

**Important:** Only valid when running on AC power. Ignored when on battery.

**Use case:** Local development servers, critical processes requiring guaranteed continuous execution.

### `-u` (user activity)
Declares that the **user is active**.

**Special behavior:**
- Automatically turns on the display if it's off
- Prevents display from idle sleeping
- Uses a default timeout of 5 seconds if `-t` is not specified

**Use case:** Scripts requiring simulated user activity, keeping SSH sessions active.

### `-t` `<seconds>` (timeout)
Specifies the **validity time** of the assertion in seconds.

**Important:** Not used in wrapper mode, as duration is controlled by the program's execution.

**Use case:** Keep system awake for a specific known period (e.g., 3600 seconds = 1 hour).

### `-w` `<pid>` (wait for process)
Waits for the process with the specified PID to exit. Assertion is automatically released when the process terminates.

**Important:** Ignored when used in wrapper mode.

**Use case:** Keep system active while a specific running process continues working.

---

## Common Flag Combinations Summary

| Flags | Description | Use Case |
|-------|-------------|----------|
| `-i` | Only prevents idle sleep | Python scripts, batch processes |
| `-di` | Display + idle sleep | Visual process monitoring |
| `-ims` | System + disk + idle (display OFF) | **Energy-efficient background processing** |
| `-dims` | Full protection (display ON) | Critical DB/disk operations with monitoring |
| `-i -t 3600` | Idle sleep for 1 hour | Process with known duration |
| `-u` | Simulates user activity | Keep sessions active |

### Why `-ims` is Recommended

The `-ims` combination is **ideal for long-running background processes** because:

- **Energy efficient:** Allows display to sleep, saving power
- **System protection:** Prevents system and disk idle sleep
- **AC power awareness:** The `-s` flag ensures protection only when plugged in
- **Perfect for overnight jobs:** GIS processing, database operations, data pipelines

---

## Implementation Examples

### Basic Process Wrapping

```bash
caffeinate -i python analyze_ndvi_timeseries.py
```

### Time-Based Execution

```bash
# Keep system awake for 8 hours
caffeinate -i -t 28800
```

### Energy-Efficient Background Processing

```bash
caffeinate -ims python batch_processing_overnight.py
```

### Critical Operations with Monitoring

```bash
caffeinate -dims python process_data.py
```

### Database Operations

```bash
caffeinate -dims psql -f migration_script.sql
```

### Monitor Existing Process

```bash
caffeinate -i -w 12345
```

### Automation Pipeline Integration

```bash
#!/bin/bash
# run_geo_pipeline.sh

caffeinate -ims python preprocess_sentinel2.py && \
python train_crop_classifier.py && \
python generate_yield_predictions.py
```

---

## Results

- **Zero interrupted processes**: Reliable completion of overnight jobs
- **Improved resource utilization**: Systems sleep when idle, saving energy
- **Better debugging**: Display stays active for monitoring when needed
- **Simplified deployment**: Single command handles sleep management
```


---

# **Working with similar geospatial data workflows?** 
If you're dealing with interrupted processing pipelines or need help optimizing your GIS automation infrastructure, let's connect. I specialize in building robust data processing systems for agricultural and environmental applications.

[Book Free Intro Call :material-arrow-top-right:](https://calendly.com/joaquin-urruti/consultation-30min){ .md-button .md-button--primary }