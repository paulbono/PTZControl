# PTZ Camera Control System Overview

## Current System Architecture

The PTZ (Pan-Tilt-Zoom) Camera Control System is a distributed solution for managing multiple PTZ cameras in a production environment. The system currently consists of several key components:

### Core Components

1. **Main Control Script (`ptz_cameras.py`)**
   - Primary control interface for PTZ cameras
   - Handles camera commands (pan, tilt, zoom, focus)
   - Supports preset positions
   - Manages camera power states
   - Implements VISCA protocol for camera communication

2. **Scheduled Scripts Sequence**
   - `00_Init.sh`: System initialization
   - `01_CommandListen.sh`/`01_CommandWrapped.sh`: Command reception setup
   - `02_StartStream.sh`: Stream initialization
   - `03_Teardown.sh`: System cleanup
   - `04_eStop.sh`: Emergency stop functionality
   - `05_stopTerminal.sh`: Terminal session management

3. **Slide Listener**
   - Network-based command reception system
   - Receives commands from remote computers
   - Integrates with the main control system

### System Flow

1. System initialization via `00_Init.sh`
2. Command listener setup (wrapped or direct)
3. Stream initialization
4. Main application execution
5. Command processing and camera control
6. System teardown when needed

### Current Limitations

1. Manual operation requiring script execution
2. Basic error handling
3. Limited logging and monitoring
4. No centralized configuration management
5. Platform-specific implementations (PC/Mac)
6. Limited scalability
7. Basic security measures

## System Requirements

- Python 3.x
- Network connectivity between control system and cameras
- Compatible PTZ cameras supporting VISCA protocol
- Operating System: Currently supports both Windows and macOS

## Configuration

Camera configurations are stored in `ptz_data.json`, including:
- Camera IP addresses
- Preset positions
- Power states
- Custom configurations

## Communication Protocol

The system uses the VISCA protocol for camera control, implementing:
- Pan/Tilt commands
- Zoom control
- Focus management
- Power control
- Status queries 