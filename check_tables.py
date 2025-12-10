import sqlite3

db = sqlite3.connect('dml.db')
cursor = db.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
tables = [row[0] for row in cursor.fetchall()]
print("Tablas creadas:")
for table in tables:
    print(f"  - {table}")
print(f"\nTotal: {len(tables)} tablas")

# Verificar tablas críticas
critical_tables = ['tickets', 'ticket_historial', 'stock_alertas', 'estadisticas_repuestos']
print("\nTablas requeridas:")
for table in critical_tables:
    exists = table in tables
    status = "✓" if exists else "✗"
    print(f"  {status} {table}")

db.close()
