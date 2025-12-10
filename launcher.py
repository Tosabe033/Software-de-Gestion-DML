#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
DML Launcher - Inicia el sistema
"""
import sys
import os
from pathlib import Path

# Agregar CODIGO_FUENTE al path
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir / "CODIGO_FUENTE"))

# Importar y ejecutar
from CODIGO_FUENTE.launcher import DMLLauncher

if __name__ == "__main__":
    launcher = DMLLauncher()
    launcher.run()
