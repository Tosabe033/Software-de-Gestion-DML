# -*- coding: utf-8 -*-
"""
Wrapper que ejecuta app desde CODIGO_FUENTE para compatibilidad
"""
import sys
import os
from pathlib import Path

# Agregar CODIGO_FUENTE al path
script_dir = Path(__file__).parent
sys.path.insert(0, str(script_dir / "CODIGO_FUENTE"))

# Importar y ejecutar app
from CODIGO_FUENTE.app import app

if __name__ == "__main__":
    app.run(debug=False)
