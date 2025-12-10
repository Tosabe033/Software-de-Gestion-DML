# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\CODIGO_FUENTE\\launcher.py'],
    pathex=[],
    binaries=[],
    datas=[('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\dml.db', '.'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\CODIGO_FUENTE\\app.py', 'CODIGO_FUENTE'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\CODIGO_FUENTE\\schema.sql', 'CODIGO_FUENTE'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\CODIGO_FUENTE\\requirements.txt', 'CODIGO_FUENTE'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\INTERFAZ', 'INTERFAZ'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\DOCUMENTACION_SISTEMA', 'DOCUMENTACION_SISTEMA'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\DOCUMENTACION_CONTRATO', 'DOCUMENTACION_CONTRATO'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\DATOS_INICIALES', 'DATOS_INICIALES')],
    hiddenimports=['flask', 'werkzeug', 'reportlab', 'scrypt'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='DML',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
