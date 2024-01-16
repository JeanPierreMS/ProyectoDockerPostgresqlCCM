-- Crear la tabla de Escuelas 

CREATE TABLE Escuela ( 

    IdEscuela SERIAL PRIMARY KEY, 

    Nombre VARCHAR(255) NOT NULL, 

    Direccion VARCHAR(255) NOT NULL 

); 

 -- Crear la tabla para controlar la unicidad de DNI 

CREATE TABLE DNIControl ( 

    DNI VARCHAR(10) PRIMARY KEY 

); 

 -- Crear la tabla de Estudiantes 

CREATE TABLE Estudiante ( 

    IdEstudiante SERIAL PRIMARY KEY, 

    Nombre VARCHAR(255) NOT NULL, 

    Apellido VARCHAR(255) NOT NULL, 

    Direccion VARCHAR(255), 

    IdEscuela INT, 

    DNI VARCHAR(10) NOT NULL, 

    CONSTRAINT CHK_Estudiante_DNI CHECK (SUBSTRING(DNI, 1, 2) BETWEEN '01' AND '24' AND LENGTH(DNI) = 10), 

    FOREIGN KEY (IdEscuela) REFERENCES Escuela(IdEscuela), 

    FOREIGN KEY (DNI) REFERENCES DNIControl(DNI) 

); 

 -- Crear la tabla de Conductores 

CREATE TABLE Conductor ( 

    IdConductor SERIAL PRIMARY KEY, 

    Nombre VARCHAR(255) NOT NULL, 

    Apellido VARCHAR(255) NOT NULL, 

    DNI VARCHAR(10) NOT NULL, 

    CONSTRAINT CHK_Conductor_DNI CHECK (SUBSTRING(DNI, 1, 2) BETWEEN '01' AND '24' AND LENGTH(DNI) = 10), 

    FOREIGN KEY (DNI) REFERENCES DNIControl(DNI) 

); 

 -- Crear la tabla de Vehículos 

CREATE TABLE Vehiculo ( 

    IdVehiculo SERIAL PRIMARY KEY, 

    Marca VARCHAR(255) NOT NULL, 

    Modelo VARCHAR(255) NOT NULL, 

    Placa VARCHAR(50) NOT NULL UNIQUE, 

    IdConductor INT, 

    FOREIGN KEY (IdConductor) REFERENCES Conductor(IdConductor) 

); 

 -- Crear la tabla de Rutas 

CREATE TABLE Ruta ( 

    IdRuta SERIAL PRIMARY KEY, 

    Nombre VARCHAR(255) NOT NULL, 

    IdVehiculo INT, 

    FOREIGN KEY (IdVehiculo) REFERENCES Vehiculo(IdVehiculo) 

); 

 -- Crear la tabla de Paradas 

CREATE TABLE Parada ( 

    IdParada SERIAL PRIMARY KEY, 

    Nombre VARCHAR(255) NOT NULL, 

    Ubicacion VARCHAR(255) NOT NULL, 

    IdRuta INT, 

    FOREIGN KEY (IdRuta) REFERENCES Ruta(IdRuta) 

); 

 -- Crear la tabla de Encargados 

CREATE TABLE Encargado ( 

    IdEncargado SERIAL PRIMARY KEY, 

    Nombre VARCHAR(255) NOT NULL, 

    Apellido VARCHAR(255) NOT NULL, 

    Telefono VARCHAR(50), 

    IdRuta INT, 

    DNI VARCHAR(10) NOT NULL, 

    CONSTRAINT CHK_Encargado_DNI CHECK (SUBSTRING(DNI, 1, 2) BETWEEN '01' AND '24' AND LENGTH(DNI) = 10), 

    FOREIGN KEY (IdRuta) REFERENCES Ruta(IdRuta), 

    FOREIGN KEY (DNI) REFERENCES DNIControl(DNI) 

); 