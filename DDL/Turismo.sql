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
    fecha_registro datetime default getdate(),
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
    fecha_registro datetime default getdate(),
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
    fecha_registro datetime default getdate(),
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
fecha_registro datetime default getdate(),
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
    fecha_registro datetime default getdate(),
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
    fecha_registro datetime default getdate(),
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
    fecha_registro datetime default getdate(),
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
    salario_base decimal(10,2) not null,
    fecha_registro datetime default getdate(),
    constraint PK_cargo Primary key (idcargo)
);
print 'Tabla Cargo creada';
go
--Crear tabla Direccion
if OBJECT_ID('OERA.Direccion', 'U') is not null
begin
    Drop Table OERA.Direccion;
    print 'La tabla OERA.Direccion Eliminada'
end
go

CREATE TABLE OERA.Direccion (
iddireccion int identity(1,1),
idciudad int not null,
tipo_calle nvarchar(50) not null, --Av. Jr. Psje. Prolong. AA.HH.
calle nvarchar(200) not null, --Atahualpa
numero nvarchar(10) default 'S/N', --1050, s/n
referencia nvarchar(max),
codigo_postal nvarchar(10) not null,
fecha_registro datetime default getdate(),
constraint CHK_zip
CHECK (len(codigo_postal) between 5 and 10), --06001
latitud decimal (10,8) null,
longitud decimal (10,8) null,
altitud decimal (10,8) null,
constraint PK_direccion primary key (iddireccion),
constraint FK_direccion_ciudad
foreign key (idciudad) References OERA.ciudad(idciudad)
); 
print 'Tabla Direccion Creada';
go

--Crear tabla Cliente
if OBJECT_ID('Ventas.Cliente', 'U') is not null
begin
    Drop Table Ventas.Cliente;
    print 'La tabla Ventas.Cliente Eliminada'
end
go

CREATE TABLE Ventas.Cliente(
	idpersona int not null
	constraint PK_Cliente primary key (idpersona),
	fecha_nacimineto date not null,
	genero varchar(20), --Maculino, Femenino, Empresa, No Especifica, Prefiero no decirlo
	preferencia_viaje varchar(150) null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null, --Informacion adicional
	puntos_fidelidad int default 0,
	fecha_registro datetime default getdate(),
	nivel_cliente varchar(20) not null default 'Basico' --Basico, Bronze, Plata
	constraint FK_cliente_persona
	foreign key (idpersona) references RRHH.Persona(idpersona)
);
print 'Tabla Cliente creada';
go

--Crear tabla Empleado
if OBJECT_ID('RRHH.Empleado', 'U') is not null
begin
    Drop Table RRHH.Empleado;
    print 'La tabla RRHH.Empleado Eliminada'
end
go

CREATE TABLE RRHH.Empleado(
    idpersona int not null,
    fecha_registro datetime default getdate(),
    constraint PK_Empleado Primary key (idpersona),
    cod_empleado varchar(15) null,
    fecha_ingreso date not null,
    fecha_cese date not null,
    tipo_contrato varchar(30) null,
    estado_laboral varchar(20) not null,
    constraint CHK_Estado_laboral 
    CHECK (estado_laboral in ('Activo', 'Inactivo', 'Suspendido')),
    jornada_laboral varchar(30) null,
    regimen_laboral varchar(30) null,
    id_supervisor int null,
    contacto_emergencia varchar(150) null,
    telefono_emergencia varchar(20) null,
    observaciones varchar(max) null, --Informacion adicional
    CONSTRAINT FK_empleado_persona
    Foreign key (idpersona) References RRHH.Persona (idpersona),
    constraint FK_empleado_supervisor
    Foreign key (id_supervisor) References RRHH.Persona (idpersona)

);
print 'Tabla RRHH.Empleado creada';
go

--Crear tabla Direccion_cliente
if OBJECT_ID('Ventas.Direccion_Cliente', 'U') is not null
begin
    Drop Table Ventas.Direccion_Cliente;
    print 'La tabla Ventas.Direccion_Cliente Eliminada'
end
go

CREATE TABLE Ventas.Direccion_Cliente(
    idpersona int not null,
    iddireccion int not null,
    tipo_direccion varchar(20) null,
    constraint CHK_tipo_direccion
    CHECK (tipo_direccion in ('Casa', 'Trabajo', 'Facturacion','Entrega')),
    es_principal bit default 0,
    estado_direccion varchar(20) not null default 'Activo',
    fecha_registro datetime default getdate(),
    constraint CHK_Estado_Direccion_Cliente
    CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
    constraint PK_direccion_cliente
    primary key (idpersona, iddireccion),
    constraint FK_direccion_cliente_persona
    foreign key (idpersona) references RRHH.Persona (idpersona),
    constraint FK_direccion_cliente
    foreign key (iddireccion) references OERA.Direccion (iddireccion)

);
print 'Tabla Direccion Cliente creada';
go

--Crear tabla Direccion_Empleado
if OBJECT_ID('RRHH.Direccion_Empleado', 'U') is not null
begin
    Drop Table RRHH.Direccion_Empleado;
    print 'La tabla RRHH.Direccion_Empleado Eliminada'
end
go

CREATE TABLE RRHH.Direccion_Empleado(
    idpersona int not null,
    iddireccion int not null,
    tipo_direccion varchar(20) NOT null,
    constraint CHK_tipo_direccion_emp
    CHECK (tipo_direccion in ('Casa', 'Trabajo')),
    es_principal bit default 0,
    estado_direccion varchar(20) not null default 'Activo',
    fecha_registro datetime default getdate(),
    constraint CHK_Estado_Direccion_Empleado
    CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
    constraint PK_direccion_empleado
    primary key (idpersona, iddireccion),
    constraint FK_direccion_empleado_persona
    foreign key (idpersona) references RRHH.Persona (idpersona),
    constraint FK_direccion_empleado
    foreign key (iddireccion) references OERA.Direccion (iddireccion)

);
print 'Tabla Direccion Empleado creada';
go

--Crear tabla Categoria_Proveedor
if OBJECT_ID('Compras.Categorìa_Proveedor', 'U') is not null
begin
    Drop Table Compras.Categorìa_Proveedor;
    print 'La tabla Compras.Categorìa_Proveedor Eliminada'
end
go

CREATE TABLE Compras.Categorìa_Proveedor(
 idcat_proveedor int identity (1,1),
 nomcat_proveedor varchar(60) not null,
 despcripcion varchar(max),
 constraint PK_cat_proveedor primary key (idcat_proveedor),
 constraint UQ_nombre_cat_proveedor UNIQUE (nomcat_proveedor)

);
print 'Tabla Compras.Categorìa_Proveedor creada';
go

--Crear tabla Proveedor
if OBJECT_ID('Compras.Proveedor', 'U') is not null
begin
    Drop Table Compras.Proveedor;
    print 'La tabla Compras.Proveedor Eliminada'
end
go

CREATE TABLE Compras.Proveedor(
 idpersona int not null,
 cod_proveedor varchar(15) null,
 fecha_inicio_relacion date not null,
 fecha_fin_relacion date null,
 sitio_web nvarchar(250) null,
 requiere_contrato bit not null default 0,
 estado_proveedor varchar(20) not null default 'Activo',
 observaciones nvarchar(max) null,
 fecha_registro datetime default getdate(),
 constraint PK_proveedor primary key(idpersona),
 constraint CHK_Estado_Proveedor 
 CHECK (estado_proveedor in ('Activo', 'Inactivo', 'Suspendido')),
 constraint FK_proveedor_persona
 foreign key(idpersona) References RRHH.Persona(idpersona)
);
print 'Tabla Proveedor creada';
go

--Crear tabla Direccion_Proveedor
if OBJECT_ID('Compras.Direccion_Proveedor', 'U') is not null
begin
    Drop Table Compras.Direccion_Proveedor;
    print 'La tabla Compras.Direccion_Proveedor Eliminada'
end
go

CREATE TABLE Compras.Direccion_Proveedor(
    idpersona int not null,
    iddireccion int not null,
    tipo_direccion varchar(20) NOT null,
    constraint CHK_tipo_direccion_proveedor
    CHECK (tipo_direccion in ('Fiscal', 'Envio', 'Fisica', 'Correspondencia', 'Pago', 'Sucursal', 'Almacen', 'Operativa')),
    es_principal bit default 0,
    estado_direccion varchar(20) not null default 'Activo',
    fecha_registro datetime default getdate(),
    constraint CHK_Estado_Direccion_Proveedor
    CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
    constraint PK_direccion_proveedor
    primary key (idpersona, iddireccion),
    constraint FK_direccion_proveedor_persona
    foreign key (idpersona) references RRHH.Persona (idpersona),
    constraint FK_direccion_proveedor
    foreign key (iddireccion) references OERA.Direccion (iddireccion)

);
print 'Tabla Direccion Proveedor creada';
go
