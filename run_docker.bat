@echo off

REM Checking if Docker is installed and running
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not installed or not running.
    exit /b 1
)

REM Checking if the Docker volume exists
docker volume ls -q --filter name=flask_data | findstr /R . >nul 2>&1
if %errorlevel% neq 0 (
    REM Creating the Docker volume if it doesn't exist
    echo Creating Docker volume flask_data...
    docker volume create flask_data
    if %errorlevel% neq 0 (
        echo Error: Unable to create Docker volume.
        exit /b 1
    )
)

REM Checking if the Docker container exists
docker ps -a --format "{{.Names}}" | findstr /C:"flask-container" >nul 2>&1
if %errorlevel% equ 0 (
    REM Stopping the previous Docker container if it exists
    echo Stopping the previous Docker container...
    docker stop flask-container >nul 2>&1
    docker rm flask-container >nul 2>&1
)

REM Starting the Docker container with volume
echo Starting the Docker container...
docker run -d -p 5000:5000 --name flask-container -v flask_data:/app flask-app

REM Displaying a message indicating successful launch
if %errorlevel% equ 0 (
    echo Docker container has been started successfully.
) else (
    echo Error: Unable to start Docker container.
)
