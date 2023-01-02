
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS ull_music;
CREATE DATABASE ull_music WITH TEMPLATE = template0 ENCODING = 'UTF8';

ALTER DATABASE ull_music OWNER TO postgres;

\connect ull_music

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

/* -- CREATE TABLES -- */
CREATE TABLE servicio_tecnico (
  id_tecnico INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  dni VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_tecnico)
);

CREATE TABLE problema (
  id_problema SERIAL NOT NULL,
  nombre_problema VARCHAR(50) NOT NULL,
  descripcion VARCHAR(1000) NOT NULL,
  resolucion VARCHAR(1000) NOT NULL,
  PRIMARY KEY (id_problema)
);

CREATE TABLE usuarios (
  id_usuario SERIAL NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  dni VARCHAR(20) NOT NULL,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  fecha_registro DATE DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario)
);

CREATE TABLE canciones (
  id_cancion SERIAL NOT NULL,
  nombre_cancion VARCHAR(50) NOT NULL,
  año_salida INT NOT NULL,
  duracion FLOAT NOT NULL,
  PRIMARY KEY (id_cancion)
);

CREATE TABLE listas_de_canciones (
  id_lista INT NOT NULL,
  id_usuario INT NOT NULL,
  nombre_lista VARCHAR(50) NOT NULL,
  duracion FLOAT NOT NULL,
  PRIMARY KEY (id_lista, id_usuario),
  FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario)
);

CREATE TABLE autores (
  id_autor SERIAL NOT NULL,
  nombre_autor VARCHAR(50) NOT NULL,
  discografia VARCHAR(1000) NULL,
  PRIMARY KEY (id_autor)
);

CREATE TABLE albumes (
  id_album SERIAL NOT NULL,
  id_autor INT NOT NULL,
  nombre_album VARCHAR(50) NOT NULL,
  año_salida INT NOT NULL,
  duracion FLOAT NOT NULL,
  PRIMARY KEY (id_album),
  FOREIGN KEY (id_autor) REFERENCES autores (id_autor)
);

CREATE TABLE generos (
  id_genero SERIAL NOT NULL,
  nombre_genero VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_genero)
);

/* -- Tabla de relaciones -- */

CREATE TABLE resuelve (
  id_tecnico INT NOT NULL,
  id_problema INT NOT NULL,
  id_usuario INT NOT NULL,
  fecha_resolucion DATE DEFAULT CURRENT_TIMESTAMP,
  resuelto BOOLEAN NOT NULL,
  PRIMARY KEY (id_tecnico, id_problema, id_usuario, fecha_resolucion),
  FOREIGN KEY (id_tecnico) REFERENCES servicio_tecnico (id_tecnico),
  FOREIGN KEY (id_problema) REFERENCES problema (id_problema),
  FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario)
);

CREATE TABLE lista_canciones_canciones (
  id_lista INT NOT NULL,
  id_cancion INT NOT NULL,
  PRIMARY KEY (id_lista, id_cancion),
  FOREIGN KEY (id_lista) REFERENCES listas_de_canciones (id_lista),
  FOREIGN KEY (id_cancion) REFERENCES canciones (id_cancion),
);

CREATE TABLE usuario_canciones (
  id_usuario INT NOT NULL,
  id_cancion INT NOT NULL,
  PRIMARY KEY (id_usuario, id_cancion),
  FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario),
  FOREIGN KEY (id_cancion) REFERENCES canciones (id_cancion)
);

CREATE TABLE canciones_albumes (
  id_cancion INT NOT NULL,
  id_album INT NOT NULL,
  PRIMARY KEY (id_cancion, id_album),
  FOREIGN KEY (id_cancion) REFERENCES canciones (id_cancion),
  FOREIGN KEY (id_album) REFERENCES albumes (id_album)
);

CREATE TABLE canciones_autores (
  id_cancion INT NOT NULL,
  id_autor INT NOT NULL,
  PRIMARY KEY (id_cancion, id_autor),
  FOREIGN KEY (id_cancion) REFERENCES canciones (id_cancion),
  FOREIGN KEY (id_autor) REFERENCES autores (id_autor)
);

CREATE TABLE canciones_generos (
  id_cancion INT NOT NULL,
  id_genero INT NOT NULL,
  PRIMARY KEY (id_cancion, id_genero),
  FOREIGN KEY (id_cancion) REFERENCES canciones (id_cancion),
  FOREIGN KEY (id_genero) REFERENCES generos (id_genero)
);

CREATE TABLE autores_generos (
  id_autor INT NOT NULL,
  id_genero INT NOT NULL,
  PRIMARY KEY (id_autor, id_genero),
  FOREIGN KEY (id_autor) REFERENCES autores (id_autor),
  FOREIGN KEY (id_genero) REFERENCES generos (id_genero)
);

CREATE TABLE albumes_generos (
  id_album INT NOT NULL,
  id_genero INT NOT NULL,
  PRIMARY KEY (id_album, id_genero),
  FOREIGN KEY (id_album) REFERENCES albumes (id_album),
  FOREIGN KEY (id_genero) REFERENCES generos (id_genero)
);

CREATE TABLE grupo (
  id_autor INT NOT NULL,
  nombre_integrante VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_autor, nombre_integrante),
  FOREIGN KEY (id_autor) REFERENCES autores (id_autor)
);

CREATE TABLE artista (
  id_autor INT NOT NULL,
  nombre_artista VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_autor),
  FOREIGN KEY (id_autor) REFERENCES autores (id_autor)
);

/* -- INSERT DATA -- */
