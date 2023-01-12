
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
  id_tecnico SERIAL NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  dni VARCHAR(20) NOT NULL UNIQUE,
  fecha_de_alta DATE DEFAULT CURRENT_TIMESTAMP,
  fecha_de_baja DATE NULL,
  PRIMARY KEY (id_tecnico)
);

CREATE TABLE problema (
  id_problema SERIAL NOT NULL,
  nombre_problema VARCHAR(50) NOT NULL UNIQUE,
  descripcion VARCHAR(1000) NOT NULL,
  resolucion VARCHAR(1000) NOT NULL,
  PRIMARY KEY (id_problema)
);

CREATE TABLE usuarios (
  id_usuario SERIAL NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  dni VARCHAR(20) NOT NULL UNIQUE,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(50) NOT NULL UNIQUE,
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
  id_lista SERIAL NOT NULL,
  nombre_lista VARCHAR(50) NOT NULL,
  descripcion VARCHAR(1000) NULL,
  duracion FLOAT NOT NULL,
  PRIMARY KEY (id_lista)
);

CREATE TABLE autores (
  id_autor SERIAL NOT NULL,
  nombre_autor VARCHAR(50) NOT NULL UNIQUE,
  discografia VARCHAR(1000) NULL,
  PRIMARY KEY (id_autor)
);

CREATE TABLE albumes (
  id_album SERIAL NOT NULL,
  id_autor INT NOT NULL,
  nombre_album VARCHAR(50) NOT NULL UNIQUE,
  año_salida INT NOT NULL,
  duracion FLOAT NOT NULL,
  PRIMARY KEY (id_album),
  CONSTRAINT fk_id_autor
    FOREIGN KEY (id_autor)
    REFERENCES autores (id_autor)
    ON DELETE CASCADE
);

CREATE TABLE generos (
  id_genero SERIAL NOT NULL,
  nombre_genero VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (id_genero)
);

CREATE TABLE comentarios (
  id_comentario SERIAL NOT NULL,
  id_usuario INT NOT NULL,
  id_cancion INT NOT NULL,
  texto_comentario VARCHAR(1000) NOT NULL,
  fecha_comentario DATE DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_comentario, id_usuario, id_cancion),
  CONSTRAINT fk_id_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_cancion
    FOREIGN KEY (id_cancion)
    REFERENCES canciones (id_cancion)
    ON DELETE CASCADE
);

/* -- Tabla de relaciones -- */

CREATE TABLE resuelve (
  id_tecnico INT NOT NULL,
  id_problema INT NOT NULL,
  id_usuario INT NOT NULL,
  fecha_incidencia DATE NOT NULL,
  fecha_resolucion DATE NOT NULL,
  resuelto BOOLEAN NOT NULL,
  PRIMARY KEY (id_tecnico, id_problema, id_usuario),
  CONSTRAINT fk_id_tecnico
    FOREIGN KEY (id_tecnico)
    REFERENCES servicio_tecnico (id_tecnico)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_problema
    FOREIGN KEY (id_problema)
    REFERENCES problema (id_problema)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario)
    ON DELETE CASCADE
);

CREATE TABLE lista_canciones_canciones (
  id_lista INT NOT NULL,
  id_cancion INT NOT NULL,
  PRIMARY KEY (id_lista, id_cancion),
  CONSTRAINT fk_id_lista
    FOREIGN KEY (id_lista)
    REFERENCES listas_de_canciones (id_lista)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_cancion
    FOREIGN KEY (id_cancion)
    REFERENCES canciones (id_cancion)
    ON DELETE CASCADE  
);

CREATE TABLE lista_canciones_usuarios (
  id_lista INT NOT NULL,
  id_usuario INT NOT NULL,
  PRIMARY KEY (id_lista, id_usuario),
  CONSTRAINT fk_id_lista
    FOREIGN KEY (id_lista)
    REFERENCES listas_de_canciones (id_lista)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario)
    ON DELETE CASCADE
);

CREATE TABLE usuarios_canciones (
  id_usuario INT NOT NULL,
  id_cancion INT NOT NULL,
  PRIMARY KEY (id_usuario, id_cancion),
  CONSTRAINT fk_id_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_cancion
    FOREIGN KEY (id_cancion)
    REFERENCES canciones (id_cancion)
    ON DELETE CASCADE
);

CREATE TABLE canciones_albumes (
  id_cancion INT NOT NULL,
  id_album INT NOT NULL,
  PRIMARY KEY (id_cancion, id_album),
  CONSTRAINT fk_id_cancion
    FOREIGN KEY (id_cancion)
    REFERENCES canciones (id_cancion)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_album
    FOREIGN KEY (id_album)
    REFERENCES albumes (id_album)
    ON DELETE CASCADE
);

CREATE TABLE canciones_autores (
  id_cancion INT NOT NULL,
  id_autor INT NOT NULL,
  PRIMARY KEY (id_cancion, id_autor),
  CONSTRAINT fk_id_cancion
    FOREIGN KEY (id_cancion)
    REFERENCES canciones (id_cancion)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_autor
    FOREIGN KEY (id_autor)
    REFERENCES autores (id_autor)
    ON DELETE CASCADE
);

CREATE TABLE canciones_generos (
  id_cancion INT NOT NULL,
  id_genero INT NOT NULL,
  PRIMARY KEY (id_cancion, id_genero),
  CONSTRAINT fk_id_cancion
    FOREIGN KEY (id_cancion)
    REFERENCES canciones (id_cancion)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_genero
    FOREIGN KEY (id_genero)
    REFERENCES generos (id_genero)
    ON DELETE CASCADE
);

CREATE TABLE autores_generos (
  id_autor INT NOT NULL,
  id_genero INT NOT NULL,
  PRIMARY KEY (id_autor, id_genero),
  CONSTRAINT fk_id_autor
    FOREIGN KEY (id_autor)
    REFERENCES autores (id_autor)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_genero
    FOREIGN KEY (id_genero)
    REFERENCES generos (id_genero)
    ON DELETE CASCADE
);

CREATE TABLE albumes_generos (
  id_album INT NOT NULL,
  id_genero INT NOT NULL,
  PRIMARY KEY (id_album, id_genero),
  CONSTRAINT fk_id_album
    FOREIGN KEY (id_album)
    REFERENCES albumes (id_album)
    ON DELETE CASCADE,
  CONSTRAINT fk_id_genero
    FOREIGN KEY (id_genero)
    REFERENCES generos (id_genero)
    ON DELETE CASCADE
);

CREATE TABLE grupo (
  id_autor INT NOT NULL,
  nombre_integrante VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_autor, nombre_integrante),
  CONSTRAINT fk_id_autor
    FOREIGN KEY (id_autor)
    REFERENCES autores (id_autor)
    ON DELETE CASCADE
);

CREATE TABLE artista (
  id_autor INT NOT NULL,
  nombre_artista VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_autor),
  CONSTRAINT fk_id_autor
    FOREIGN KEY (id_autor)
    REFERENCES autores (id_autor)
    ON DELETE CASCADE
);


/* -- CHECKS -- */

ALTER TABLE servicio_tecnico
ADD CONSTRAINT CK_date_tecnico
CHECK (fecha_de_baja > fecha_de_alta);

ALTER TABLE canciones
ADD CONSTRAINT CK_duration_canciones
CHECK (duracion > 0);

ALTER TABLE usuarios
ADD CONSTRAINT CK_email_usuarios
CHECK (email LIKE '%@%');

/* -- DISPARADORES -- */

--disparador para actualizar la duracion de cada lista de canciones
CREATE FUNCTION duration_list() returns trigger AS $$
BEGIN
  UPDATE listas_de_canciones
  SET duracion = (SELECT ROUND(SUM(duracion)::numeric, 2)
                  FROM canciones 
                  WHERE id_cancion IN (SELECT id_cancion 
                                       FROM lista_canciones_canciones 
                                       WHERE id_lista = NEW.id_lista))
  WHERE id_lista = NEW.id_lista;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER duration_list AFTER INSERT OR UPDATE OR DELETE ON lista_canciones_canciones
FOR EACH ROW EXECUTE PROCEDURE duration_list();


--disparador para actualizar la duracion de cada album
CREATE FUNCTION duration_album() returns trigger AS $$
BEGIN
  UPDATE albumes
  SET duracion = (SELECT ROUND((SUM(duracion))::numeric, 2) 
                  FROM canciones 
                  WHERE id_cancion IN (SELECT id_cancion 
                                       FROM canciones_albumes 
                                       WHERE id_album = NEW.id_album))
  WHERE id_album = NEW.id_album;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER duration_album AFTER INSERT OR UPDATE OR DELETE ON canciones_albumes
FOR EACH ROW EXECUTE PROCEDURE duration_album();


--disparador para eliminar una canción si no tiene ningún autor asociado
CREATE FUNCTION delete_song() returns trigger AS $$
BEGIN
  DELETE FROM canciones
  WHERE id_cancion = OLD.id_cancion
  AND NOT EXISTS (SELECT * FROM canciones_autores WHERE id_cancion = OLD.id_cancion);
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_song AFTER DELETE ON canciones_autores
FOR EACH ROW EXECUTE PROCEDURE delete_song();

--disparador para eliminar una lista de canciones si no tiene ningún usuario asociado
CREATE FUNCTION delete_list() returns trigger AS $$
BEGIN
  DELETE FROM listas_de_canciones
  WHERE id_lista = OLD.id_lista
  AND NOT EXISTS (SELECT * FROM lista_canciones_usuarios WHERE id_lista = OLD.id_lista);
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_list AFTER DELETE ON lista_canciones_usuarios
FOR EACH ROW EXECUTE PROCEDURE delete_list();




/* -- INSERT DATA -- */

INSERT INTO servicio_tecnico (nombre, apellido, dni, fecha_de_alta, fecha_de_baja) VALUES
  ('Roberto', 'Mascarpone Olivares', '12345678P', '02-01-2022', NULL),
  ('Juan', 'Perez Reverte', '12345679A', '02-01-2022', NULL),
  ('Andrés', 'González González', '12345678B', '02-01-2022', NULL);

INSERT INTO problema (nombre_problema, descripcion, resolucion) VALUES
  ('No se puede iniciar sesión', 'No se puede iniciar sesión en la aplicación', 'Comprobar que las credenciales de acceso están bien'),
  ('No se puede reproducir una canción', 'No se puede reproducir una canción', 'Reiniciar la aplicación'),
  ('No se puede reproducir un álbum', 'No se puede reproducir un álbum', 'Reiniciar la aplicación'),
  ('No se puede reproducir una lista de reproducción', 'No se puede reproducir una lista de reproducción', 'Reiniciar la aplicación');


INSERT INTO usuarios (nombre, apellido, dni, username, email, fecha_registro) VALUES
  ('Bruno Lorenzo', 'Arroyo Pedraza', '12345678C', 'brunolarroyo', 'bruno@gmail.com', '02-01-2022'),
  ('Carla Cristina', 'Olivares Rodríguez', '12345679D', 'carlacolivares', 'carla@gmail.com', '02-01-2022'),
  ('Dana Belén', 'Choque Zárate', '12345678E', 'danabelenchoque', 'dana@gmail.com', '02-01-2022'),
  ('Miguel Herradores', 'Tanaisu', '12345678Z', 'miguelisu', 'miguel@gmail.com', '02-01-2022'),
  ('Micaela Belen', 'Pedraza Zuminich', '12345678V', 'zuminica', 'micaela@gmail.com', '02-01-2022');


INSERT INTO canciones (nombre_cancion, año_salida, duracion) VALUES
  ('Que te vaya mal', 2022, 3.39), -- ALL YOU CAN EAT (COMIDA PARA LLEVAR)
  ('Los Gatos', 2022, 3.16), -- ALL YOU CAN EAT (COMIDA PARA LLEVAR)
  ('Gratiné', 2022, 2.23), -- ALL YOU CAN EAT (COMIDA PARA LLEVAR)
  ('Get Into It', 2021, 2.18), -- PLANET HER (DOJA CAT)
  ('Woman', 2021, 2.52), -- PLANET HER (DOJA CAT)
  ('Ojitos lindos', 2022, 4.18), -- UN VERANO SIN TI (BAD BUNNY)
  ('Neverita', 2022, 2.53), -- UN VERANO SIN TI (BAD BUNNY)
  ('Me Fui De Vacaciones', 2022, 3.00), -- UN VERANO SIN TI (BAD BUNNY)
  ('Cuando Olvidaré', 2021, 3.09), -- EL MADRILEÑO (C. TANGANA)
  ('Los Tontos', 2021, 3.12), -- EL MADRILEÑO (C. TANGANA)
  ('Bliss', 2001, 4.11), -- ORIGIN OF SYMMETRY (MUSE)
  ('New Born', 2001, 6.03), -- ORIGIN OF SYMMETRY (MUSE)
  ('Megalomania', 2001, 4.39), -- ORIGIN OF SYMMETRY (MUSE)
  ('Lone Digger', 2015, 3.49), -- <|º_º|> (CARAVAN PALACE)
  ('Wonderland', 2015, 3.10), -- <|º_º|> (CARAVAN PALACE)
  ('Egotistic', 2018, 3.16), -- RED MOON (MAMAMOO)
  ('Sleep In The Car', 2018, 3.22), -- RED MOON (MAMAMOO)
  ('Emperors New Clothes', 2016, 2.38), -- DEATH OF A BACHELOR (PANIC! AT THE DISCO)
  ('Golden Days', 2016, 4.14), -- DEATH OF A BACHELOR (PANIC! AT THE DISCO)
  ('Victorious', 2016, 2.58); -- DEATH OF A BACHELOR (PANIC! AT THE DISCO)
  
INSERT INTO listas_de_canciones (nombre_lista,descripcion, duracion) VALUES
  ('Clásicos del rock', 'Una lista de reproducción con algunos de los grandes éxitos del rock de todos los tiempos', 0),
  ('Hits del pop', 'Una lista de reproducción con algunas de las canciones más populares del pop actual', 0),
  ('Lo mejor del hip hop', 'Una lista de reproducción con algunos de los mejores éxitos del hip hop de todos los tiempos', 0),
  ('Éxitos del K-Pop', 'Una lista de reproducción con algunas de las mejores canciones de K-pop', 0),
  ('Electrónica para bailar', 'Una lista de reproducción con algunos de los éxitos más populares de la música electrónica para bailar', 0),
  ('Lo más nuevo del reggeatón', 'Una lista de reproducción con las canciones más recientes y populares del reggeatón', 0),
  ('Indie rock', 'Una lista de reproducción con algunos de los grandes éxitos del indie rock', 0);

INSERT INTO autores (nombre_autor, discografia) VALUES 
  ('Motherflowers', NULL),
  ('Doja Cat', 'RCA Records'),
  ('Bad Bunny', 'Rimas Entertainment'),
  ('C. Tangana', 'Sony Music'),
  ('MUSE', 'Warner Records'),
  ('Caravan Palace', 'Le Plan Recordings'),
  ('MAMAMOO', 'RBW Entertainment'),
  ('PANIC! AT THE DISCO', 'Atlantic Records'); 


INSERT INTO albumes (id_autor, nombre_album, año_salida, duracion) VALUES
  (1, 'ALL YOU CAN EAT', 2022, 0),
  (2, 'PLANET HER', 2021, 0),
  (3, 'UN VERANO SIN TI', 2022, 0),
  (4, 'EL MADRILEÑO', 2021, 0),
  (5, 'ORIGIN OF SYMMETRY', 2001, 0),
  (6, '<|º_º|>', 2022, 0),
  (7, 'RED MOON', 2022, 0),
  (8, 'DEATH OF A BACHELOR', 2016, 0);

INSERT INTO generos (nombre_genero) VALUES 
  ('Rock'),
  ('Pop'),
  ('Jazz'),
  ('Metal'),
  ('Clásica'),
  ('Reggae'),
  ('Salsa'),
  ('Folk'),
  ('Blues'),
  ('Rap'),
  ('Electrónica'),
  ('Funk'),
  ('Soul'),
  ('Country'),
  ('Reggaeton'),
  ('Disco'),
  ('Indie'),
  ('Punk'),
  ('Hip Hop'),
  ('Alternativa'),
  ('Heavy Metal'),
  ('Cumbia'),
  ('Flamenco'),
  ('Bachata'),
  ('Merengue'),
  ('Ska'),
  ('Música Clásica'),
  ('Música Urbana'),
  ('Música Tropical'),
  ('Música de Cine'),
  ('Música de Baile'),
  ('Kpop');


INSERT INTO comentarios (id_usuario, id_cancion, texto_comentario, fecha_comentario) VALUES 
  (1, 1, 'Esta canción tiene un ritmo increíble, me encanta bailarla', '22-07-2022'),
  (1, 1, 'Me encanta la letra de esta canción, me siento muy identificado con ella', '14-05-2022'),
  (1, 1, 'La voz del cantante en esta canción es impresionante, me emociona cada vez que la escucho', '17-09-2022'),
  (1, 1, 'Este es uno de mis artistas favoritos y esta canción es uno de mis temas preferidos de ellos', '05-12-2022'),
  (1, 1, 'Me encanta la mezcla de géneros en esta canción, es algo completamente nuevo para mí', '28-07-2022'),
  (1, 1, 'La producción de esta canción es impresionante, me encanta cómo suena', '12-03-2022'),
  (2, 1, 'La letra de esta canción es muy profunda y me hace reflexionar cada vez que la escucho', '09-08-2022'),
  (2, 1, 'Me encanta el aire nostálgico de esta canción, me transporta a otro lugar y tiempo', '23-11-2022'),
  (2, 1, 'La combinación de voces en esta canción es increíble, realmente siento la química entre los artistas', '06-10-2022'),
  (2, 1, 'Esta La melodía de esta canción es tan pegajosa, no puedo dejar de tararearla tiene una energía increíble, me hace sentir muy vivo', '20-06-2022'),
  (2, 1, 'La melodía de esta canción es tan pegajosa, no puedo dejar de tararearla', '15-04-2022'),
  (2, 1, 'Me encanta la forma en que esta canción me hace sentir, es tan emotiva', '18-07-2022'),
  (2, 1, 'Este es un artista tan talentoso, cada canción que saca es una joya', '06-01-2022'),
  (3, 1, 'La letra de esta canción es tan honesta y auténtica, realmente siento que me está hablando a mí', '30-09-2022'),
  (3, 1, 'La música de esta canción es tan original, es algo que nunca he escuchado antes', '02-11-2022'),
  (3, 1, 'Me encanta la forma en que esta canción me hace moverme, es tan pegajosa', '25-12-2022'),
  (3, 1, 'La voz del cantante en esta canción es tan potente y emotiva, me siento conectado a ella', '16-02-2022'),
  (3, 1, 'La letra de esta canción es tan profunda y significativa, me hace pensar en mi vida y en las decisiones que he tomado', '08-03-2022'),
  (3, 1, 'Esta canción de K-pop tiene un ritmo increíble, me encanta cantarla', '22-07-2022'),
  (3, 1, 'La música de esta canción es tan pegajosa, no puedo dejar de escucharla una y otra vez', '21-06-2022'),
  (3, 1, 'La letra de esta canción es tan emotiva, me hace sentir conectado a ella', '29-09-2022'),
  (3, 1, 'Muy buena canción', '09-03-2022');

INSERT INTO resuelve (id_tecnico, id_problema, id_usuario, fecha_incidencia, fecha_resolucion, resuelto) VALUES
  (1, 1, 1, '09-03-2022', '09-03-2022', true),
  (1, 2, 3, '09-04-2022', '10-04-2022', true),
  (1, 3, 2, '09-05-2022', '11-05-2022', true),
  (2, 2, 3, '20-03-2022', '21-03-2022', true),
  (2, 1, 3, '24-03-2022', '24-03-2022', true),
  (2, 4, 3, '1-03-2022',  '01-03-2022', true),
  (3, 2, 3, '09-07-2022', '09-07-2022', true),
  (3, 1, 3, '10-04-2022', '10-04-2022', true),
  (3, 3, 3, '11-12-2022', '11-12-2022', true);

INSERT INTO lista_canciones_canciones (id_lista, id_cancion) VALUES
  (1, 11),
  (1, 12),
  (1, 13),
  (1, 18),
  (1, 19),
  (1, 20),
  (2, 4),
  (2, 5),
  (3, 1),
  (3, 2),
  (3, 3),
  (3, 9),
  (3, 10),
  (4, 16),
  (4, 17),
  (5, 14),
  (5, 15),
  (6, 6),
  (6, 7),
  (6, 8);

INSERT INTO lista_canciones_usuarios (id_lista, id_usuario) VALUES
  (1, 1),
  (1, 2),
  (2, 3),
  (2, 1),
  (3, 2),
  (4, 3),
  (5, 1),
  (6, 2),
  (7, 3);

INSERT INTO usuarios_canciones (id_usuario, id_cancion) VALUES
  (1, 5),
  (1, 8),
  (1, 11),
  (1, 13),
  (1, 14),
  (1, 15),
  (1, 18),
  (1, 2),
  (2, 1),
  (2, 2),
  (2, 3),
  (2, 4),
  (2, 6),
  (2, 7),
  (2, 8),
  (2, 12),
  (2, 20),
  (3, 19),
  (3, 16),
  (3, 17),
  (3, 8),
  (3, 9),
  (3, 1),
  (3, 10),
  (3, 5),
  (3, 4);

INSERT INTO canciones_albumes (id_cancion, id_album) VALUES 
  (1, 1),
  (2, 1),
  (3, 1),
  (4, 2),
  (5, 2),
  (6, 3),
  (7, 3),
  (8, 3),
  (9, 4),
  (10, 4),
  (11, 5),
  (12, 5),
  (13, 5),
  (14, 6),
  (15, 6),
  (16, 7),
  (17, 7),
  (18, 8),
  (19, 8),
  (20, 8);

INSERT INTO canciones_autores (id_cancion, id_autor) VALUES
  (1, 1),
  (2, 1),
  (3, 1),
  (4, 2),
  (5, 2),
  (6, 3),
  (7, 3),
  (8, 3),
  (9, 4),
  (10, 4),
  (11, 5),
  (12, 5),
  (13, 5),
  (14, 6),
  (15, 6),
  (16, 7),
  (17, 7),
  (18, 8),
  (19, 8),
  (20, 8);

INSERT INTO canciones_generos (id_cancion, id_genero) VALUES
  (1, 10),
  (1, 19),
  (2, 19),
  (3, 19),
  (4, 2),
  (4, 19),
  (4, 20),
  (5, 2),
  (6, 15),
  (6, 11),
  (7, 15),
  (7, 11),
  (8, 15),
  (8, 6),
  (9, 19),
  (10, 19),
  (11, 1),
  (12, 1),
  (13, 1),
  (14, 11),
  (15, 11),
  (16, 7),
  (17, 32),
  (18, 32),
  (19, 1),
  (19, 2),
  (20, 1),
  (20, 2);

INSERT INTO autores_generos (id_autor, id_genero) VALUES
  (1, 10),
  (1, 19),
  (2, 2),
  (2, 19),
  (2, 20),
  (2, 16),
  (3, 15),
  (3, 11),
  (3, 10),
  (4, 19),
  (5, 1),
  (5, 11),
  (6, 11),
  (7, 32),
  (8, 1),
  (8, 2);

INSERT INTO albumes_generos (id_album, id_genero) VALUES
  (1, 10),
  (1, 19),
  (2, 2),
  (2, 19),
  (2, 20),
  (3, 15),
  (3, 11),
  (3, 6),
  (4, 19),
  (5, 1),
  (6, 11),
  (7, 7),
  (7, 32),
  (8, 1),
  (8, 2),
  (8, 32);

INSERT INTO grupo (id_autor, nombre_integrante) VALUES
  (1, 'Irepelusa'),
  (1, 'Veztalone'),
  (1, 'Frank Lucas'),
  (1, 'Tayko'),
  (5, 'Matt Bellamy'),
  (5, 'Chris Wolstenholme'),
  (5, 'Dominic Howard'),
  (6, 'Zoé Colotis'),
  (6, 'Arnaud Vial'),
  (6, 'Hugues Payen'),
  (6, 'Camille Chapelière'),
  (6, 'Charles Delaporte'),
  (6, 'Antoine Toustou'),
  (6, 'Paul-Marie Barbier'),
  (6, 'Victor Raimondeau'),
  (7, 'Moonbyul'),
  (7, 'Solar'),
  (7, 'Wheein'),
  (7, 'Hwasa');

INSERT INTO artista (id_autor, nombre_artista) VALUES
  (2, 'Doja Cat'),
  (3, 'Bad Bunny'),
  (4, 'C. Tangana'),
  (8, 'Brendon Urie');