
---

### 📦 Downloadable Windows Batch Script (`setup_alignment_station.bat`)

```batch
@echo off
REM Create alignment-station project scaffold
mkdir alignment-station
cd alignment-station
mkdir calibration scripts visualization logs
echo {} > calibration\calibration_data.json
echo # Python script to move device > scripts\move_device.py
echo # Utility functions for coordinate transforms > scripts\transform_utils.py
echo # RViz config placeholder > visualization\rviz_config.rviz
echo Project scaffold created. Please add code and calibration data as needed.
