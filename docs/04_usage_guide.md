# PTZ Control System Usage Guide

## System Startup

### 1. Initialization
1. Navigate to the `_Scheduled` directory
2. Execute `00_Init.sh` to initialize the system
3. Wait for initialization to complete

### 2. Command Listener Setup
1. Execute either:
   - `01_CommandListen.sh` for direct command listening
   - `01_CommandWrapped.sh` for wrapped command listening
2. Verify the listener is running

### 3. Stream Initialization
1. Execute `02_StartStream.sh`
2. Wait for stream initialization
3. Verify stream status

## Camera Control

### 1. Basic Commands

#### Power Control
```bash
# Turn camera on
python3 ptz_cameras.py --main --on

# Turn camera off
python3 ptz_cameras.py --main --off
```

#### Preset Control
```bash
# Move to preset position
python3 ptz_cameras.py --main --preset "preset_name"
```

#### Manual Control
```bash
# Pan control
python3 ptz_cameras.py --main --pan "value"

# Tilt control
python3 ptz_cameras.py --main --tilt "value"

# Zoom control
python3 ptz_cameras.py --main --zoom "value"
```

### 2. Status Queries

#### Camera Status
```bash
# Query all parameters
python3 ptz_cameras.py --main --query_all

# Query specific parameters
python3 ptz_cameras.py --main --query_zoom
python3 ptz_cameras.py --main --query_pan_tilt
python3 ptz_cameras.py --main --query_focus
```

## System Shutdown

### 1. Normal Shutdown
1. Execute `03_Teardown.sh`
2. Wait for cleanup to complete
3. Verify system shutdown

### 2. Emergency Stop
1. Execute `04_eStop.sh`
2. Wait for emergency shutdown
3. Verify camera status

## Configuration

### 1. Camera Configuration
Edit `ptz_data.json` to modify:
- Camera IP addresses
- Preset positions
- Power states
- Custom configurations

### 2. System Configuration
- Modify script parameters in `_Scheduled` directory
- Adjust network settings
- Configure logging

## Troubleshooting

### 1. Common Issues

#### Camera Not Responding
1. Check network connectivity
2. Verify camera power
3. Check IP configuration
4. Verify VISCA protocol support

#### Command Listener Issues
1. Check listener status
2. Verify network ports
3. Check firewall settings
4. Verify command format

#### Stream Issues
1. Check stream initialization
2. Verify network bandwidth
3. Check resource usage
4. Verify stream configuration

### 2. Error Messages

#### Network Errors
- Check network connectivity
- Verify IP configuration
- Check firewall settings
- Verify port availability

#### Protocol Errors
- Verify VISCA protocol support
- Check command format
- Verify camera compatibility
- Check protocol version

#### System Errors
- Check system logs
- Verify resource usage
- Check system status
- Verify configuration

## Best Practices

### 1. Operation
- Always use proper shutdown procedures
- Monitor system status
- Regular maintenance
- Backup configurations

### 2. Security
- Use secure networks
- Regular password updates
- Monitor access logs
- Regular security updates

### 3. Maintenance
- Regular system updates
- Configuration backups
- Performance monitoring
- Regular testing

## Support

### 1. Documentation
- System documentation
- API documentation
- Configuration guide
- Troubleshooting guide

### 2. Contact
- System administrator
- Technical support
- Emergency contact
- Maintenance team 