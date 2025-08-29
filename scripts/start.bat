@echo off
REM Windows startup script for OpenPress
REM This is a Windows equivalent of the Linux start.sh script

echo Starting OpenPress WebServer...

REM Create necessary directories
if not exist logs mkdir logs
if not exist ssl mkdir ssl
if not exist letsencrypt mkdir letsencrypt

REM Note: For Windows deployment, use Docker Desktop
echo Please use Docker Desktop to run this setup on Windows
echo Run: docker-compose up -d

pause
