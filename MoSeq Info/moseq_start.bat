@echo off
echo Hello Plotkin Lab member!
echo Starting MoSeq container...
echo(
docker run -it --entrypoint /bin/bash --mount type=bind,source="C:\Users\Plotkin Lab\Desktop\MoSeq Info\moseq_out",target=/data dattalab/moseq2:v1.3.1
echo(
echo --------
echo Container stopped. Please press any key to close.
pause >nul