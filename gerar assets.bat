@echo off
setlocal enabledelayedexpansion

set "OUTPUT=assets.json"

echo { > %OUTPUT%
echo   "version": 1, >> %OUTPUT%
echo   "gerado": "%date% %time%", >> %OUTPUT%
echo   "items": [ >> %OUTPUT%

set "first=1"

:: Procura todos os ficheiros .png nas subpastas
for /f "tokens=*" %%i in ('dir /s /b *.png') do (
    
    set "fullpath=%%i"
    
    :: Extrair nome do ficheiro (ex: fabio_boca-01.png)
    set "filename=%%~nxi"
    
    :: Extrair nome da pasta pai (ex: boca)
    for %%j in ("%%i\..") do set "folder=%%~nxj"
    
    :: Caminho relativo para o JSON
    set "relative=!folder!/!filename!"
    
    :: Separar Autor e Nome (baseado no _)
    :: Se o ficheiro for "fabio_boca-01.png", autor=fabio, nome_item=boca-01
    for /f "tokens=1,2 delims=_" %%a in ("!filename!") do (
        set "autor=%%a"
        set "nome_ext=%%b"
        :: Remove a extensão .png do nome do item
        set "nome_item=!nome_ext:.png=!"
    )

    :: Tratar a vírgula do JSON (não pode ter vírgula no último item)
    if defined first (
        set "first="
    ) else (
        echo         , >> %OUTPUT%
    )

    :: Escrever a entrada do item no JSON
    echo     { >> %OUTPUT%
    echo       "id": "!autor!_!nome_item!", >> %OUTPUT%
    echo       "nome": "!nome_item!", >> %OUTPUT%
    echo       "autor": "!autor!", >> %OUTPUT%
    echo       "categoria": "!folder!", >> %OUTPUT%
    echo       "arquivo": "!relative!" >> %OUTPUT%
    echo     } >> %OUTPUT%
)

echo   ] >> %OUTPUT%
echo } >> %OUTPUT%

echo Ficheiro %OUTPUT% gerado com sucesso!
pause