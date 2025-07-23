# multi-body-alignment
left 6DOF XYZUVW, Center 6DOF XYZUVW, Right 2DOF XY
# SWIR Fiber-Laser Alignment Station — Coordinate System Framework

## Overview

This document describes the coordinate system setup, component relationships, and Python-based motion command framework for the SWIR fiber-laser alignment station.  
The system enables intuitive, high-level movements (e.g., “rotate laser by 1° around DUT’s Y axis”) through global/local coordinate transformation and scripting.

---

## System Diagram

Left: Suruga DS102 COM3 (6 DOF: XYZUVW) — holds Laser Fiber
Center: PI Hexapod C-887 (6 DOF) — holds DUT (Device Under Test)
Right: Suruga DS102 COM5 (2 DOF: XY) — holds Camera Allied Vision G033
Top & Side: Monitoring Cameras (Pixelink)


Global Coordinate Origin: **User-defined at a key DUT position** (e.g., optical center or calibration point).

---

## Bill of Materials (BOM)

| Component             | Model/Type        | Description                               |
|-----------------------|-------------------|-------------------------------------------|
| Linear Stage (Laser)  | Suruga DS102      | 6 DOF XYZUVW Motorized Stage (COM3)       |
| Hexapod (DUT)         | PI C-887          | 6 DOF Hexapod Stage Controller            |
| Camera Stage          | Suruga DS102      | 2 DOF XY Stage (COM5)                     |
| Monitoring Camera #1  | Allied Vision     | Goldeye G-033 SWIR or similar             |
| Monitoring Camera #2  | Pixelink          | PL-D Series or similar                    |
| Laser Source          | PPS               | SWIR Laser Module                         |
| DUT                   | N/A               | Device Under Test (fiber, chip, etc)      |
| Cables, Adapters      | -                 | USB/Serial/Power as needed                |
| Workstation           | Windows 10/11 PC  | Python 3.8+, ROS2 recommended (optional)  |

---

## Coordinate System Architecture

### Global Coordinate System (GCS)
- **Origin:** Defined at key DUT position (optical center).
- **Axes:** X (left/right), Y (forward/back), Z (up/down).

### Local Coordinate Systems
- **Each device (laser stage, hexapod, camera stage) has its own local origin, typically at the tool center (fiber tip, DUT center, camera lens center).**

#### Visualization
- Use **ROS tf2** + **RViz** for real-time coordinate frame visualization.
- For geometry simulation, use **FreeCAD Python API**.

---

## Python Framework for Motion Command Conversion

### Principle
- Use 4x4 Homogeneous Transformation Matrices for local ↔ global conversions.
- For a move “relative to DUT by 1 degree in global Y”, compute the required local move for the target device.

#### Example Python Snippet

```python
import numpy as np
from transforms3d.euler import euler2mat

def rotation_matrix(axis, angle_deg):
    angle_rad = np.deg2rad(angle_deg)
    if axis == 'x':
        return euler2mat(angle_rad, 0, 0, 'sxyz')
    elif axis == 'y':
        return euler2mat(0, angle_rad, 0, 'sxyz')
    elif axis == 'z':
        return euler2mat(0, 0, angle_rad, 'sxyz')

# Example: Rotate laser fiber by 1° around global Y
T_G_laser = np.eye(4)  # Replace with calibration value
R = rotation_matrix('y', 1)
T_increment_global = np.eye(4)
T_increment_global[:3, :3] = R
T_increment_local = np.linalg.inv(T_G_laser) @ T_increment_global @ T_G_laser


alignment-station/
├── README.md
├── calibration/
│   └── calibration_data.json
├── scripts/
│   ├── move_device.py
│   └── transform_utils.py
├── visualization/
│   └── rviz_config.rviz
└── logs/
