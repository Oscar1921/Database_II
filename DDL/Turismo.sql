-- Base de datos para sector turismo
-- USA BASE MODELO 

USE master;
GO

-- Validar existencia de base de datos y forzar cierre de conexiones
IF DB_ID('Turismo_OERA') IS NOT NULL 
BEGIN 
    -- Cortar conexiones activas para evitar error de "Base de datos en uso"
    ALTER DATABASE Turismo_OERA SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Turismo_OERA; 
    PRINT 'Base de datos eliminada';
END 
GO 

-- Crear la base de datos
CREATE DATABASE Turismo_OERA;
PRINT 'Se ha creado la base de datos';
GO

-- IMPORTANTE: Entrar a la base de datos recién creada
USE Turismo_OERA;
GO

-- Creación de esquemas 
IF SCHEMA_ID(N'RRHH') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA RRHH AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de RRHH';
END 
ELSE 
BEGIN 
    PRINT 'Esquema RRHH creado';
END
GO

IF SCHEMA_ID(N'Compras') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Compras AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de COMPRAS';
END 
ELSE 
BEGIN 
    PRINT 'Esquema Compras creado';
END
GO

IF SCHEMA_ID(N'Ventas') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Ventas AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de Ventas';
END 
ELSE 
BEGIN 
    PRINT 'Esquema Ventas creado';
END
GO

IF SCHEMA_ID(N'UNC') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA UNC AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de UNC';
END 
ELSE 
BEGIN 
    PRINT 'Esquema UNC creado';
END
GO

IF SCHEMA_ID(N'OERA') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA OERA AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de OERA';
END 
ELSE 
BEGIN 
    PRINT 'Esquema OERA creado';
END
GO

-- =========================================
-- CREACIÓN DE TABLAS
-- =========================================

-- 1. Tabla Pais
IF OBJECT_ID('OERA.Pais', 'U') IS NOT NULL
BEGIN 
    DROP TABLE OERA.Pais;
    PRINT 'Tabla OERA.Pais eliminada';
END 
GO 

CREATE TABLE OERA.Pais (
    idpais int primary key identity (1,1),
    nombrepais varchar(40) not null,
    codigoiso varchar (3) not null, 
    constraint UQ_nombrepais UNIQUE(nombrepais),
    constraint UQ_codigoiso UNIQUE(codigoiso)
);
PRINT 'Tabla OERA.Pais creada exitosamente';
GO


-- 2. Tabla Nacionalidad
IF OBJECT_ID('OERA.Nacionalidad', 'U') IS NOT NULL
BEGIN 
    DROP TABLE OERA.Nacionalidad;
    PRINT 'Tabla OERA.Nacionalidad eliminada';
END 
GO 

CREATE TABLE OERA.Nacionalidad (
    idnacionalidad int identity (1,1),
    nom_nacionalidad varchar (80) not null, -- Falta la coma agregada
    idpais int not null,                    -- Falta esta columna agregada
    constraint PK_nacionalidad primary key (idnacionalidad),
    constraint UQ_nacionalidad UNIQUE (nom_nacionalidad),
    constraint FK_pais_nacionalidad foreign key (idpais) references OERA.Pais (idpais)
);
PRINT 'Tabla OERA.Nacionalidad creada exitosamente';
GO


-- 3. Tabla Region (DEPARTAMENTO)
IF OBJECT_ID('OERA.Region', 'U') IS NOT NULL
BEGIN 
    DROP TABLE OERA.Region;
    PRINT 'Tabla OERA.Region eliminada';
END 
GO 

CREATE TABLE OERA.Region (
    idregion int identity(1,1), 
    nomregion varchar (80) not null,
    codigoubigeo varchar (3) not null, -- Falta la coma agregada
    idpais int not null,               -- Coma final eliminada
    constraint PK_region primary key (idregion),
    constraint UQ_nomregion UNIQUE (nomregion),
    constraint FK_region_pais
    foreign key (idpais) references OERA.Pais (idpais)
);
PRINT 'Tabla OERA.Region creada exitosamente';
GO
-- 4. Tabla Subregion (PROVINCIA)
IF OBJECT_ID('OERA.subregion', 'U') IS NOT NULL
BEGIN 
    DROP TABLE OERA.subregion;
    PRINT 'Tabla OERA.Subregion eliminada';
END 
GO 

CREATE TABLE OERA.subregion (
idsubregion int identity(1,1),
nomsubregion nvarchar(100) not null,
codigo_ubigeo varchar(4) not null,
idregion int not null,
constraint PK_subregion primary key (idsubregion),
constraint FK_subregion_region
foreign key (idregion)
references OERA.region (idregion)
);
print 'Tabla OERA.Subregion creada';
go

--Crear tabla ciudad o distrito
if OBJECT_ID('OERA.ciudad', 'U') is not null
begin
    Drop Table OERA.Ciudad;
    print 'La tabla OERA.Ciudad Eliminada'
end
go

CREATE TABLE OERA.Ciudad (
    idciudad int identity (1,1),
    nomciudad varchar(80) not null,
    codigo_ubigeo varchar(6),
    idsubregion int not null,
    constraint PK_ciudad primary key (idciudad),
    constraint FK_ciudad_subregion
    foreign key (idsubregion)
    References OERA.Subregion (idsubregion)
    );
    print 'Tabla Ciudad creada';
    go

--Crear tabla Tipo_documento
if OBJECT_ID('RRHH.TipoDocumento', 'U') is not null
begin
    Drop Table RRHH.TipoDocumento;
    print 'La tabla RRHH.TipoDocumento Eliminada'
end
go

CREATE TABLE RRHH.TipoDocumento(
    idtipodocumento int identity(1,1),
    nombredoc varchar(50) not null,
    abreviatura char(10) not null,
    constraint PK_tipodocumento
    primary key (idtipodocumento),
    constraint UQ_NOMBREDOC unique (nombredoc),
    constraint UQ_abreviatura UNIQUE (abreviatura)
);
print 'Tabla TipoDocumento creada';
go

--Crear tabla Persona
if OBJECT_ID('RRHH.Persona', 'U') is not null
begin
    Drop Table RRHH.Persona;
    print 'La tabla RRHH.Persona Eliminada'
end
go

CREATE TABLE RRHH.Persona(
    idpersona int identity(1,1),
    tipo_persona char(1) not null, --N: Natural, J:Juridica
    constraint CHK_tipo_persona
    CHECK(tipo_persona in ('N', 'J')),    
    nombres varchar(100),
    apaterno varchar(100),
    amaterno varchar(100),

    razon_social varchar(200) not null,
    nombre_comercial varchar(200),

    idtipodocumento int not null,
    numero_documento varchar(20) not null,
    telefono varchar(20)
    constraint CHK_numero_telefono
    CHECK (LEN(Ltrim(RTRIM(telefono)))  between 12 and 20
    and telefono not like '%[^0-9+()]%'
    )
    ,
    email varchar (150),
    idnacionalidad int not null,
    estado varchar(20) default 'Activo'
    constraint CHK_estado
    CHECK (estado in ('Activo', 'Inacivo')),

    constraint PK_persona primary key (idpersona),
    constraint UQ_persona_documento 
    UNIQUE (idtipodocumento, numero_documento),

    constraint FK_Persona_tipodocumento
    foreign key (idtipodocumento)
    References RRHH.TipoDocumento (idtipodocumento),
    constraint FK_persona_nacionalidad
    foreign key (idnacionalidad)
    References OERA.Nacionalidad (idnacionalidad)
);
print 'Tabla Persona creada';
go

--Crear tabla Cargo
if OBJECT_ID('RRHH.Cargo', 'U') is not null
begin
    Drop Table RRHH.Cargo;
    print 'La tabla RRHH.Cargo Eliminada'
end
go

CREATE TABLE RRHH.Cargo(
    idcargo int identity(1,1),
    nomcargo varchar(50) not null,
    descripcion varchar(max),
    salario_base decimal(10,2) not null
    constraint PK_cargo Primary key (idcargo)
);
print 'Tabla Cargo creada';
go