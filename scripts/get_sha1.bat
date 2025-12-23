@echo off
echo Getting SHA-1 fingerprint for debug keystore...
echo.

if not exist "%USERPROFILE%\.android\debug.keystore" (
    echo Debug keystore not found at %USERPROFILE%\.android\debug.keystore
    echo Please run the app once on an emulator or device to generate it.
    pause
    exit /b
)

keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

echo.
echo Please copy the SHA1 fingerprint above and add it to your Firebase Console.
echo Project Settings > General > Your apps > Android apps > Add fingerprint
echo.
pause

