"""
Helper script para generar hashes de contraseña.
Ejecutar para obtener los hashes de las contraseñas por defecto.
"""

from werkzeug.security import generate_password_hash

password = "admin123"
hashed = generate_password_hash(password)
print(f"Hash para 'admin123': {hashed}")
