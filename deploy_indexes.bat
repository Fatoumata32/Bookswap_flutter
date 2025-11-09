@echo off
echo ========================================
echo   DEPLOIEMENT DES INDEX FIRESTORE
echo ========================================
echo.
echo Etape 1: Connexion a Firebase...
echo.

call firebase login

echo.
echo Etape 2: Deploiement des index...
echo.

cd /d "%~dp0"
call firebase deploy --only firestore:indexes --project bookswap-a3d69

echo.
echo ========================================
echo   INDEX DEPLOYES !
echo   Attendez 3-5 minutes qu'ils soient actifs
echo ========================================
echo.
pause
