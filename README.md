# Quick Resources
## General MoSeq Information/References
[MoSeq4all](https://dattalab.github.io/moseq2-website/index.html)

[MoSeq Wiki](https://github-wiki-see.page/m/dattalab/moseq2-app/wiki)

The file paths and folder setup are modeled after how I created the workspace on the Plotkin Lab computer, but can be edited for optimization (note changes here). This repo and information folder should be helpful in collaborating to work on MoSeq and transferring data and programming.

## Rig Setup
The rig for video acquisition requires a depth camera collecting from a birdseye view above an open field

Camera: Orbbec Femto Bolt depth camera
Open field: White open field (avoid shiny/reflective surface and regulate lighting!)

#### Outstanding Tasks
- Find optimal distance from ground for depth camera
- Find optimal camera settings (zoom, FOV, etc.) to acquire good single-mouse depth videos

# Folders/Files
MoSeq Info - There should be a folder to hold all of the important MoSeq information
- Contains project files in a subfolder titled moseq_out, where outputs from the MoSeq program will be collected
- A moseq_start.bat should exist that will start MoSeq when double-clicked (shortcut on desktop should exist!)

OrbbecWrapper - A folder that acts as a home for the tools that we run day-to-day so that paths in scrupts never change; important for acquisition and camera functioning
- K4AWrapper subfolder containing K4A wrapper, which is a compatibility layer bundled with our OrbbecSDK that makes our camera behave like an Azure Kinect (K4A) device that works with software tools. It contains utilities like k4arecorder.exe so that we have the ability to record depth-only videos in Windows without having to install the Azure Kinect SDK (and k4aviewer.exe to view). Most of the important K4A information is in the bin folder.

# Applications & Programs
Docker Desktop
- Run this before starting MoSeq; MoSeq image is running within a Docker container
  * If log in is necessary, use email taryn.brechbill@stonybrook.edu | password: plotkinlab1234
- Provides the Linux container runtime via WSL2; environment only runs when the Docker engine is up
- Mounts files, bridging data so that MoSeq can "see" the videos you acquire
- Startup instructions:
  * Start Docker Desktop & wait until it says "Engine running"
  * Launch MoSeq (there should be a shortcut on desktop, or a batch like moseq_start.bat)

MoSeq
- Terminal for analyzing acquired data (lives within Docker Desktop)

Preview Video
- A shortcut to the k4aviewer.exe where you can check if your camera is set up properly and has the right settings for acquisition

#### Outstanding Tasks
- Find a way to view depth recordings in real time, maybe being able to see the ML working in real time

# Commands & File Paths (Plotkin Lab Computer)
File path to MoSeq data folder:
- C:\Users\Plotkin Lab\Desktop\Moseq Info\moseq_out
- Add your subfolder to the moseq_out folder first and then add it to the file path after \moseq_out

File path to the recording software:
- C:\Users\Plotkin Lab\Desktop\OrbbecWrapper\K4AWrapper\bin\k4arecorder.exe

To make a session folder for your experiment:
- Open PowerShell (windows key -> type PowerShell, hit enter)
- Paste the following, and replace SESSION with your experimental folder name (see naming guidelines): mkdir "C:\Users\Plotkin Lab\Desktop\MoSeq Info\moseq_out\SESSION"

To verify the existence of a file you created/moved (or just list whatever is in a session folder):
- Open PowerShell (windows key -> type PowerShell, hit enter)
- Paste the following, and replace PATH with your file path: Get-ChildItem "C:\Users\Plotkin Lab\Desktop\PATH" | Select Name,Length

To check if a path/file exists:
- Open PowerShell (windows key -> type PowerShell, hit enter)
- Paste the following, and replace PATH with your file path: Test-Path "C:\Users\Plotkin Lab\Desktop\PATH"

To record a video with k4arecorder.exe:
- .\k4arecorder.exe -d NFOV_UNBINNED -c OFF --imu OFF -r 15 -l 300 MKVFILENAME.mkv (Once you are cd'd into the folder where the recorder lives) (Your mkv file will live wherever the k4arecorder.exe lives when acquired)

To push a video (mkv) from computer through MoSeq:
1. List running containters so you can confirm the name being used (e.g. "intelligent_hoover")
- docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
2. Open a shell inside the container (e.g. "intelligent_hoover")
- docker exec -it intelligent_hoover
3. Create a working folder
- mkdir -p /proj
4. (PowerShell in NEW window) Copy your MKV's into the container
- docker cp "C:\Users\Plotkin Lab\Desktop\Test Videos\." intelligent_hoover:/proj/
5. (Inside container) List the MKV's to confirm they are there
- ls -1 /proj/*.mkv
6. (Inside container) Extract an MKV
- mkdir -p /proj/proc_1 && moseq2-extract extract /proj/TestMouseD2_20s.mkv --output-dir /proj/proc_1 --camera-type azure --fps 15
7. (Inside container) See what extraction produced ~ expect names like results_00.h5, results_00.mp4, results_00.yaml, plus tiffs
- ls -la /proj/proc_1
8. (Back in Windows PowerShell) Copy the preview MP4 back to Windows ~ give it a new name
- docker cp intelligent_hoover:/proj/proc/results_00.mp4 "C:\Users\Plotkin Lab\Desktop\Test Videos\NEWFILENAME.mp4"
9. (Inside container) Fit the MoSeq model on extraction
- moseq2-model model /proj/proc --output-dir /proj/model

If you have an issue with model
* docker run --rm -it --volume "C:\Users\Plotkin Lab\Desktop\Test Videos:/proj" dattalab/moseq2:v1.3.1 bash
