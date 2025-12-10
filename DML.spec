# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\launcher.py'],
    pathex=[],
    binaries=[],
    datas=[('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\dml.db', '.'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\app.py', '.'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\schema.sql', '.'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\requirements.txt', '.'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\templates', 'templates'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\static', 'static'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\DOCUMENTACION_SISTEMA', 'DOCUMENTACION_SISTEMA'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\DOCUMENTACION_CONTRATO', 'DOCUMENTACION_CONTRATO'), ('C:\\Users\\Andrea\\Downloads\\dml_sgtec_v3\\ARCHIVOS_REFERENCIA', 'ARCHIVOS_REFERENCIA')],
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
