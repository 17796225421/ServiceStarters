@echo off
setlocal enabledelayedexpansion
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":10000 :11000"') do (
  set "pid=%%a"
  if not defined !pid! (
    taskkill /PID !pid! /F
    set "!pid!=1"
  )
)

cd C:\Users\zhouzihong\Desktop\aiarticle\aiarticle
start /b mvn spring-boot:run >nul 2>nul

cd C:\Users\zhouzihong\Desktop\aibrower\server
start /b node app.js >nul 2>nul