import random
from faker import Faker
import psycopg2

# Initialize Faker
fake = Faker()

def generate_valid_dni():
    prefix = random.randint(1, 24)  # DNI prefix between 01 and 24
    suffix = fake.random_number(digits=8, fix_len=True)  # 8-digit suffix
    return f"{prefix:02}{suffix}"

db_params = {
    'database': 'progresoCCM',
    'user': 'administrator',
    'password': 'tresleches',
    'host': '10.10.10.2',
    'port': 15432
}

def create_fake_data():

    conn = psycopg2.connect(**db_params)
    cursor = conn.cursor()

    for _ in range(500):  # Adjust the range for the number of records
        # Escuela
        school_name = fake.company()
        school_address = fake.address()
        cursor.execute("INSERT INTO Escuela (Nombre, Direccion) VALUES (%s, %s) RETURNING IdEscuela", (school_name, school_address))
        school_id = cursor.fetchone()[0]

        # DNIControl and Estudiante
        student_dni = generate_valid_dni()
        cursor.execute("INSERT INTO DNIControl (DNI) VALUES (%s)", (student_dni,))
        student_name = fake.first_name()
        student_surname = fake.last_name()
        student_address = fake.address()
        cursor.execute("INSERT INTO Estudiante (Nombre, Apellido, Direccion, IdEscuela, DNI) VALUES (%s, %s, %s, %s, %s)",
                       (student_name, student_surname, student_address, school_id, student_dni))

        # Conductor
        driver_dni = generate_valid_dni()
        cursor.execute("INSERT INTO DNIControl (DNI) VALUES (%s)", (driver_dni,))
        driver_name = fake.first_name()
        driver_surname = fake.last_name()
        cursor.execute("INSERT INTO Conductor (Nombre, Apellido, DNI) VALUES (%s, %s, %s) RETURNING IdConductor",
                       (driver_name, driver_surname, driver_dni))
        driver_id = cursor.fetchone()[0]

        # Vehiculo
        vehicle_brand = fake.company()
        vehicle_model = fake.word()
        vehicle_plate = fake.bothify(text='??-###-##', letters='ABCDEFGHIJKLMNOPQRSTUVWXYZ')
        cursor.execute("INSERT INTO Vehiculo (Marca, Modelo, Placa, IdConductor) VALUES (%s, %s, %s, %s) RETURNING IdVehiculo",
                       (vehicle_brand, vehicle_model, vehicle_plate, driver_id))
        vehicle_id = cursor.fetchone()[0]

        # Ruta
        route_name = fake.street_name()
        cursor.execute("INSERT INTO Ruta (Nombre, IdVehiculo) VALUES (%s, %s) RETURNING IdRuta",
                       (route_name, vehicle_id))
        route_id = cursor.fetchone()[0]

        # Parada
        stop_name = fake.street_address()
        stop_location = fake.address()
        cursor.execute("INSERT INTO Parada (Nombre, Ubicacion, IdRuta) VALUES (%s, %s, %s)",
                       (stop_name, stop_location, route_id))

        # Encargado
        manager_dni = generate_valid_dni()
        cursor.execute("INSERT INTO DNIControl (DNI) VALUES (%s)", (manager_dni,))
        manager_name = fake.first_name()
        manager_surname = fake.last_name()
        manager_phone = fake.phone_number()
        cursor.execute("INSERT INTO Encargado (Nombre, Apellido, Telefono, IdRuta, DNI) VALUES (%s, %s, %s, %s, %s)",
                       (manager_name, manager_surname, manager_phone, route_id, manager_dni))

    conn.commit()
    cursor.close()
    conn.close()

if __name__ == '__main__':
    create_fake_data()
