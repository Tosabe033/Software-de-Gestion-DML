#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Compilar launcher.py a DML.exe con PyInstaller
"""

import os
import sys
import subprocess
from pathlib import Path
import shutil

def main():
    script_dir = Path(__file__).parent
    root_dir = script_dir.parent
    
    print("\n" + "="*60)
    print("  Compilando DML.exe")
    print("="*60 + "\n")
    
    # Verificar PyInstaller
    print("[1/3] Verificando PyInstaller...")
    try:
        import PyInstaller
        print("OK - PyInstaller instalado\n")
    except ImportError:
        print("Instalando PyInstaller...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "PyInstaller", "-q"])
        print("OK - PyInstaller instalado\n")
    
    # Limpiar directorios previos
    print("[2/3] Preparando directorios...")
    for d in ["dist", "build"]:
        p = script_dir / d
        if p.exists():
            shutil.rmtree(p)
    print("OK\n")
    
    # Compilar
    print("[3/3] Compilando launcher.py...")
    print("-" * 60)
    
    cmd = [
        sys.executable, "-m", "PyInstaller",
        "--name=DML",
        "--onefile",
        "--windowed",
        "--distpath", str(script_dir / "dist"),
        "--workpath", str(script_dir / "build"),
        "--add-data", f"{root_dir / 'dml.db'}{os.pathsep}.",
        "--add-data", f"{script_dir / 'app.py'}{os.pathsep}CODIGO_FUENTE",
        "--add-data", f"{script_dir / 'schema.sql'}{os.pathsep}CODIGO_FUENTE",
        "--add-data", f"{script_dir / 'requirements.txt'}{os.pathsep}CODIGO_FUENTE",
        "--add-data", f"{root_dir / 'INTERFAZ'}{os.pathsep}INTERFAZ",
        "--add-data", f"{root_dir / 'DOCUMENTACION_SISTEMA'}{os.pathsep}DOCUMENTACION_SISTEMA",
        "--add-data", f"{root_dir / 'DOCUMENTACION_CONTRATO'}{os.pathsep}DOCUMENTACION_CONTRATO",
        "--add-data", f"{root_dir / 'DATOS_INICIALES'}{os.pathsep}DATOS_INICIALES",
        "--hidden-import=flask",
        "--hidden-import=werkzeug",
        "--hidden-import=reportlab",
        "--hidden-import=scrypt",
        str(script_dir / "launcher.py")
    ]
    
    try:
        result = subprocess.run(cmd, cwd=str(script_dir))
        if result.returncode != 0:
            print("\nERROR durante compilacion")
            sys.exit(1)
    except Exception as e:
        print(f"\nERROR: {e}")
        sys.exit(1)
    
    print("-" * 60)
    print("OK\n")
    
    # Verificar
    print("Verificando ejecutable...")
    exe_path = script_dir / "dist" / "DML.exe"
    
    if exe_path.exists():
        size_mb = exe_path.stat().st_size / (1024 * 1024)
        print(f"OK - Creado: {exe_path.name}")
        print(f"OK - Tamanio: {size_mb:.1f} MB\n")
        
        # Copiar a raiz
        dest = root_dir / "DML.exe"
        shutil.copy(exe_path, dest)
        print(f"OK - Copiado a: {dest}\n")
        
        print("="*60)
        print("  EXITO - DML.exe listo")
        print("="*60)
        print("\nUso: DML.exe (doble-clic)\n")
        
    else:
        print("ERROR - Ejecutable no creado")
        sys.exit(1)


if __name__ == "__main__":
    main()
