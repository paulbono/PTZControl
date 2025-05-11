# Camera Angle Management Guide

## Camera Angle Structure

### 1. Configuration Format
Camera angles are stored in `ptz_data.json` with the following structure:

```json
{
    "main": {
        "ip": "10.0.0.132",
        "preset_name": {
            "pan": "fba8",    // Pan position (hex)
            "tilt": "ffc7",   // Tilt position (hex)
            "zoom": "3669",   // Zoom level (hex)
            "focus": "0249"   // Focus setting (hex)
        }
    },
    "alt": {
        "ip": "10.0.0.154",
        "preset_name": {
            "pan": "0008",
            "tilt": "ffc0",
            "zoom": "361d",
            "focus": "0247"
        }
    }
}
```

### 2. Command Structure
Camera control commands use the VISCA protocol:

```python
# Pan/Tilt Command Format
PAN_TILT_COMMAND = "810106{PAN_TILT_TYPE}{PAN_SPEED}{TILT_SPEED}0{PAN[0]}0{PAN[1]}0{PAN[2]}0{PAN[3]}0{TILT[0]}0{TILT[1]}0{TILT[2]}0{TILT[3]}FF"

# Zoom Command Format
ZOOM_COMMAND = "810104470{ZOOM[0]}0{ZOOM[1]}0{ZOOM[2]}0{ZOOM[3]}FF"

# Focus Command Format
FOCUS_COMMAND = "810104480{FOCUS[0]}0{FOCUS[1]}0{FOCUS[2]}0{FOCUS[3]}FF"
```

## Adding New Camera Angles

### 1. Manual Method
1. Position the camera using manual controls
2. Query current position:
```bash
# Get current position values
python3 ptz_cameras.py --main --query_all
# or
python3 ptz_cameras.py --alt --query_all
```

3. Add to `ptz_data.json`:
```json
{
    "main": {
        "new_preset_name": {
            "pan": "value_from_query",
            "tilt": "value_from_query",
            "zoom": "value_from_query",
            "focus": "value_from_query"
        }
    }
}
```

### 2. Using Wrapper Scripts
Create a new wrapper script for the preset:

```bash
# Windows (WrapperScript/new_preset.bat)
cd C:\Users\User\Desktop\PTZControl
C:\Users\User\AppData\Local\Programs\Python\Python310\python.exe .\ptz_cameras.py --main --preset "new_preset_name"

# Mac (WrapperScriptPython/new_preset.sh)
#!/bin/bash
cd the_folder
python3 ./ptz_cameras.py --main --preset "new_preset_name"
```

## Common Camera Angles

### 1. Main Camera Presets
```json
{
    "worship_center": {
        "pan": "fba8",
        "tilt": "ffc7",
        "zoom": "3669",
        "focus": "0249"
    },
    "pulpit_center": {
        "pan": "fc68",
        "tilt": "ffe8",
        "zoom": "360b",
        "focus": "0230"
    },
    "sermon_center": {
        "pan": "fbc4",
        "tilt": "ffe8",
        "zoom": "360b",
        "focus": "022c"
    },
    "altar_center": {
        "pan": "fbed",
        "tilt": "ffe8",
        "zoom": "3608",
        "focus": "0231"
    }
}
```

### 2. Alt Camera Presets
```json
{
    "worship_center": {
        "pan": "0008",
        "tilt": "ffc0",
        "zoom": "361d",
        "focus": "0247"
    },
    "pulpit_center": {
        "pan": "008e",
        "tilt": "ffd5",
        "zoom": "3c3b",
        "focus": "0245"
    },
    "sermon_center": {
        "pan": "0030",
        "tilt": "ffd1",
        "zoom": "379f",
        "focus": "02a2"
    },
    "altar_center": {
        "pan": "008e",
        "tilt": "ffd5",
        "zoom": "3c3b",
        "focus": "0556"
    }
}
```

## Camera Control Commands

### 1. Basic Commands
```bash
# Move to preset
python3 ptz_cameras.py --main --preset "preset_name"
python3 ptz_cameras.py --alt --preset "preset_name"

# Power control
python3 ptz_cameras.py --main --on
python3 ptz_cameras.py --main --off

# Query position
python3 ptz_cameras.py --main --query_all
```

### 2. Manual Control
```bash
# Pan control
python3 ptz_cameras.py --main --pan "value"

# Tilt control
python3 ptz_cameras.py --main --tilt "value"

# Zoom control
python3 ptz_cameras.py --main --zoom "value"
```

## Best Practices

### 1. Naming Conventions
- Use descriptive names: `location_purpose`
- Examples:
  - `worship_center`
  - `pulpit_center`
  - `sermon_center`
  - `altar_center`
- Add `_pnp` suffix for "People and Pulpit" views

### 2. Position Calibration
1. Start with wide view
2. Set focus
3. Adjust zoom
4. Fine-tune pan/tilt
5. Save preset
6. Test movement
7. Verify focus

### 3. Maintenance
1. Regular position verification
2. Focus calibration
3. Preset testing
4. Configuration backup
5. Documentation updates

## Troubleshooting

### 1. Common Issues
1. Position Drift
   - Recalibrate preset
   - Check camera stability
   - Verify network connection

2. Focus Issues
   - Check lighting
   - Recalibrate focus
   - Verify zoom level

3. Movement Problems
   - Check network connection
   - Verify camera power
   - Check command format

### 2. Error Messages
1. Network Errors
   - Check IP configuration
   - Verify network connectivity
   - Check firewall settings

2. Protocol Errors
   - Verify command format
   - Check camera compatibility
   - Verify protocol version

3. System Errors
   - Check system logs
   - Verify configuration
   - Check resource usage 