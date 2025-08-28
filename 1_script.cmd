@echo off
REM Ottieni il percorso corrente
set "CURRENT_DIR=%cd%"

REM Avvia Docker e monta la cartella come /sharedFolder
docker run -p 8888:8888 --rm  -v "%CURRENT_DIR%:/home/jovyan/work" -e JUPYTER_TOKEN=yourpassword repbioinfo/bioinfo-r-python
