#!/usr/bin/env python3
"""Genera hashes correctos para schema.sql"""

from werkzeug.security import generate_password_hash

usuarios = [
    ('admin@dml.local', 'admin', 'Administrador', 'ADMIN'),
    ('raypac@dml.local', 'raypac', 'RAYPAC', 'RAYPAC'),
    ('st@dml.local', 'tecnico', 'Servicio Técnico', 'DML_ST'),
    ('repuestos@dml.local', 'repuestos', 'Repuestos', 'DML_REPUESTOS'),
]

print("-- ======================== USUARIOS INICIALES ========================\n")
print("INSERT INTO users (email, password_hash, nombre, role, is_active) VALUES")

for i, (email, pwd, nombre, role) in enumerate(usuarios):
    hash_pwd = generate_password_hash(pwd)
    comma = "," if i < len(usuarios) - 1 else ";"
    print(f"('{email}', '{hash_pwd}', '{nombre}', '{role}', 1){comma}")
