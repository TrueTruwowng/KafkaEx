@echo off
echo ========================================
echo RUNNING SPRING BOOT APPLICATION
echo ========================================
echo.
echo Starting the application (tests skipped)...
echo.
echo The application will start on http://localhost:8080
echo.
echo Press Ctrl+C to stop the application
echo.
echo ========================================
echo.

mvn spring-boot:run -DskipTests

