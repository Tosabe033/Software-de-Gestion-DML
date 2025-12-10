#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Script para compilar launcher.py a ejecutable .exe con PyInstaller
Uso: python compile_exe.py
"""

import os
import sys
import subprocess
from pathlib import Path

def main():
    script_dir = Path(__file__).parent
    
    print("\n" + "="*60)
    print("  COMPILADOR DML - Convertir a Ejecutable")
    print("="*60 + "\n")
    
    # Verificar PyInstaller
    print("[1/4] Verificando PyInstaller...")
    try:
        import PyInstaller
        print("✓ PyInstaller encontrado\n")
    except ImportError:
        print("✗ PyInstaller no está instalado")
        print("Instalando PyInstaller...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "PyInstaller", "-q"])
        print("✓ PyInstaller instalado\n")
    
    # Crear carpeta de distribución
    print("[2/4] Preparando directorios...")
    dist_dir = script_dir / "dist"
    build_dir = script_dir / "build"
    
    if dist_dir.exists():
        import shutil
        shutil.rmtree(dist_dir)
    if build_dir.exists():
        import shutil
        shutil.rmtree(build_dir)
    
    print("✓ Directorios listos\n")
    
    # Compilar con PyInstaller
    print("[3/4] Compilando launcher.py a DML.exe...")
    print("-" * 60)
    
    # Construcción del comando PyInstaller
    cmd = [
        sys.executable, "-m", "PyInstaller",
        "--name=DML",
        "--onefile",
        "--windowed",
        "--distpath=dist",
        "--workpath=build",
        "--add-data=dml.db:.",
        "--add-data=app.py:.",
        "--add-data=schema.sql:.",
        "--add-data=requirements.txt:.",
        "--add-data=templates:templates",
        "--add-data=static:static",
        "--add-data=DOCUMENTACION_SISTEMA:DOCUMENTACION_SISTEMA",
        "--add-data=DOCUMENTACION_CONTRATO:DOCUMENTACION_CONTRATO",
        "--add-data=ARCHIVOS_REFERENCIA:ARCHIVOS_REFERENCIA",
        "--hidden-import=flask",
        "--hidden-import=werkzeug",
        "--hidden-import=reportlab",
        "--hidden-import=scrypt",
        "launcher.py"
    ]
    
    # Eliminar strings vacíos del comando
    cmd = [arg for arg in cmd if arg]
    
    try:
        result = subprocess.run(cmd, cwd=str(script_dir), capture_output=False)
        if result.returncode != 0:
            print("\n✗ Error durante compilación")
            sys.exit(1)
    except Exception as e:
        print(f"\n✗ Error: {e}")
        sys.exit(1)
    
    print("-" * 60)
    print("✓ Compilación completada\n")
    
    # Verificar resultado
    print("[4/4] Verificando ejecutable...")
    exe_path = script_dir / "dist" / "DML.exe"
    
    if exe_path.exists():
        size_mb = exe_path.stat().st_size / (1024 * 1024)
        print(f"✓ Ejecutable creado: {exe_path}")
        print(f"✓ Tamaño: {size_mb:.1f} MB\n")
        
        print("="*60)
        print("  ✅ ÉXITO")
        print("="*60)
        print(f"\nEl ejecutable está listo en:\n{exe_path}\n")
        print("Para usar:")
        print("1. Copia DML.exe a la carpeta del proyecto")
        print("2. Dobla-clic en DML.exe para ejecutar")
        print("3. El sistema se abrirá automáticamente\n")
        
        # Copiar a raíz
        import shutil
        dest = script_dir / "DML.exe"
        shutil.copy(exe_path, dest)
        print(f"✓ Copiado a: {dest}\n")
        
    else:
        print(f"✗ El ejecutable no se creó correctamente")
        sys.exit(1)


if __name__ == "__main__":
    main()
