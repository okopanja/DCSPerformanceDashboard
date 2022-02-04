# DCSPerformanceDashboard
Performance Monitoring Dashboard for DCS
# Installation instructions
## Docker
Requires:
- installed docker
- installed docker-compose
1. customize your dashboard configuration in [prometheus/config.yml](prometheus/config.yml)
2. edit targets and their labels.
3. create grafana & prometheus
```
cd DCSPerformanceDashboard
docker-compose up -d
```
## DCS Host
### windows_exporter
1. download https://github.com/prometheus-community/windows_exporter/releases
2. download/edit [windows_exporter.bat](dcs/windows_exporter.bat) and place it together with exporter. Adjust it to your needs.
3. create text_inputs folder relative to the windows_exporter.exe
4. place [windows_exporter.lua](dcs/windows_exporter.lua) inside DCS Scripts folder (Saved Games!!!!)
5. edit line 3 of windows_exporter.lua to fit the location of the of file in text_inputs folder
6. add following line to Export.lua
```
local WindowsExporter=require('lfs');dofile(WindowsExporter.writedir()..'Scripts/windows_exporter.lua')
```
### nvidia_gpu_exporter
1. download https://github.com/utkuozdemir/nvidia_gpu_exporter/releases

# Usage instructions
1. start windows_exporter.bat
2. start nvidia_gpu_exporter
3. start DCS
4. inspect any errors in dcs.log


