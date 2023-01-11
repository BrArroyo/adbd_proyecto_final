# Carla Cristina Olivares Rodríguez - alu0101120218
# Bruno Lorenzo Arroyo Pedraza - alu0101123677
# Dana Belén Choque Zárate - alu0101328348

import os
import psycopg2
from flask import Flask, render_template, request, url_for, redirect

app = Flask(__name__)

def get_db_connection():
  conn = psycopg2.connect(host='localhost',
     	database="ull_music",
      # user=os.environ['DB_USERNAME'],
	  	user="postgres",
		  # password=os.environ['DB_PASSWORD']
      password="postgres")
  return conn


@app.route('/')
def about():
  return render_template('about.html')


@app.route('/insert/', methods=('GET', 'POST'))
def insert():
  if request.method == 'POST':
    type = request.form['type']
    if type == 'user':
      firstname = request.form['firstname']
      lastname = request.form['lastname']
      dni = request.form['dni']  
      username = request.form['username']
      email = request.form['email']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO usuarios (nombre, apellido, dni, username, email) VALUES (%s, %s, %s, %s, %s)", (firstname, lastname, dni, username, email))
      conn.commit()
      cur.close()
      conn.close()

    if type == 'user_song':
      id_user = request.form['id_user']
      id_song = request.form['id_song']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO usuarios_canciones (id_usuario, id_cancion) VALUES (%s, %s)", (id_user, id_song))
      conn.commit()
      cur.close()
      conn.close()
      
    if type == 'song_list':
      name_list = request.form['name_list']
      description = request.form['description']
      id_song_string = request.form['id_song']
      id_user_string = request.form['id_user']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO listas_de_canciones (nombre_lista, descripcion, duracion) VALUES (%s, %s, %s)", (name_list, description, 0))
      cur.execute("SELECT id_lista FROM listas_de_canciones ORDER BY id_lista DESC LIMIT 1")
      id_list = cur.fetchone()[0]

      id_song_list = list(map(int,id_song_string.split(',')))
      for i in id_song_list:
        cur.execute("INSERT INTO lista_canciones_canciones (id_lista, id_cancion) VALUES (%s, %s)", (id_list,i))
      
      id_user_list = list(map(int,id_user_string.split(',')))
      for i in id_user_list:
        cur.execute("INSERT INTO lista_canciones_usuarios (id_lista, id_usuario) VALUES (%s, %s)", (id_list,i))
            
      conn.commit()
      cur.close()
      conn.close()      

    if type == 'song_list_song':
      id_list = request.form['id_list']
      id_song = request.form['id_song']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO lista_canciones_canciones (id_lista, id_cancion) VALUES (%s, %s)", (id_list, id_song))
      
      conn.commit()
      cur.close()
      conn.close()
      
    if type == 'song_list_user':
      id_list = request.form['id_list']
      id_user = request.form['id_user']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO lista_canciones_usuarios (id_lista, id_usuario) VALUES (%s, %s)", (id_list, id_user))

      conn.commit()
      cur.close()
      conn.close()
      
    if type == 'comment':
      id_user = request.form['id_user']
      id_song = request.form['id_song']
      text_comment = request.form['text_comment']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO comentarios (id_usuario, id_cancion, texto_comentario) VALUES (%s, %s, %s)", (id_user, id_song, text_comment))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'author':
      name_author = request.form['name_author']
      name_discography = request.form['name_discography']
      names_artist_string = request.form['names_artist']
      id_genre_string = request.form['id_genre']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO autores (nombre_autor, discografia) VALUES (%s, %s)", (name_author, name_discography))
      cur.execute("SELECT id_autor FROM autores ORDER BY id_autor DESC LIMIT 1")
      id_author = cur.fetchone()[0]

      names_artist_list = list(names_artist_string.split(','))
      if len(names_artist_list) > 1:
        for i in names_artist_list:
          cur.execute("INSERT INTO grupo (id_autor, nombre_integrante) VALUES (%s, %s)", (id_author,i))
      else:
        cur.execute("INSERT INTO artista (id_autor, nombre_artista) VALUES (%s, %s)", (id_author, names_artist_list[0]))
      
      id_genre_list = list(map(int, id_genre_string.split(',')))
      for i in id_genre_list:
        cur.execute("INSERT INTO autores_generos (id_autor, id_genero) VALUES (%s, %s)", (id_author, i))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'author_member':
      id_author = request.form['id_author']
      name_artist = request.form['name_artist']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO grupo (id_autor, nombre_integrante) VALUES (%s, %s)", (id_author, name_artist))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'author_genre':
      id_author = request.form['id_author']
      id_genre = request.form['id_genre']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO autores_generos (id_autor, id_genero) VALUES (%s, %s)", (id_author, id_genre))
      
      conn.commit()
      cur.close()
      conn.close()
          
    if type == 'song':
      song_name = request.form['song_name']
      year = request.form['year']
      duration = request.form['duration']
      id_author_string = request.form['id_author']
      id_genre_string = request.form['id_genre']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO canciones (nombre_cancion, año_salida, duracion) VALUES (%s, %s, %s)", (song_name, year, duration))
      cur.execute("SELECT id_cancion FROM canciones ORDER BY id_cancion DESC LIMIT 1")
      id_song = cur.fetchone()[0]

      id_author_list = list(map(int,id_author_string.split(',')))
      for i in id_author_list:
        cur.execute("INSERT INTO canciones_autores (id_cancion, id_autor) VALUES (%s, %s)", (id_song,i))
      
      id_genre_list = list(map(int,id_genre_string.split(',')))
      for i in id_genre_list:
        cur.execute("INSERT INTO canciones_generos (id_cancion, id_genero) VALUES (%s, %s)", (id_song,i))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'song_author':
      id_song = request.form['id_song']
      id_author = request.form['id_author']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO canciones_autores (id_cancion, id_autor) VALUES (%s, %s)", (id_song, id_author))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'song_genre':
      id_song = request.form['id_song']
      id_genre = request.form['id_genre']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO canciones_generos (id_cancion, id_genero) VALUES (%s, %s)", (id_song, id_genre))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'album':
      name_album = request.form['name_album']
      id_author = request.form['id_author']
      year = request.form['year']
      id_song_string = request.form['id_song']
      id_genre_string = request.form['id_genre']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO albumes (id_autor, nombre_album, año_salida, duracion) VALUES (%s, %s, %s, %s)", (id_author, name_album, year, 0))
      cur.execute("SELECT id_album FROM albumes ORDER BY id_album DESC LIMIT 1")
      id_album = cur.fetchone()[0]
      
      id_song_list = list(map(int, id_song_string.split(',')))
      for i in id_song_list:
        cur.execute("INSERT INTO canciones_albumes (id_cancion, id_album) VALUES (%s, %s)", (i, id_album))
      
      id_genre_string = list(map(int, id_genre_string.split(',')))
      for i in id_genre_string:
        cur.execute("INSERT INTO albumes_generos (id_album, id_genero) VALUES (%s, %s)", (id_album, i))
      
      conn.commit()
      cur.close()
      conn.close()

    if type == 'album_song':
      id_song = request.form['id_song']
      id_album = request.form['id_album']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO canciones_albumes (id_cancion, id_album) VALUES (%s, %s)", (id_song, id_album))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'album_genre':
      id_album = request.form['id_album']
      id_genre = request.form['id_genre']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO albumes_generos (id_album, id_genero) VALUES (%s, %s)", (id_album, id_genre))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'genre':
      name_genre = request.form['name_genre']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO generos (nombre_genero) VALUES (%s)", (name_genre, ))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'technician':
      firstname = request.form['firstname']
      lastname = request.form['lastname']
      dni = request.form['dni']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO servicio_tecnico (nombre, apellido, dni) VALUES (%s, %s, %s)", (firstname, lastname, dni))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'problem':
      name_problem = request.form['name_problem']
      description = request.form['description']
      resolution = request.form['resolution']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO problema (nombre_problema, descripcion, resolucion) VALUES (%s, %s, %s)", (name_problem, description, resolution))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'incidence':
      id_technician = request.form['id_technician']
      id_problem = request.form['id_problem']
      id_user = request.form['id_user']
      date_incidence = request.form['date_incidence']
      date_resolution = request.form['date_resolution']
      resolution = request.form['resolution']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("INSERT INTO resuelve (id_tecnico, id_problema, id_usuario, fecha_incidencia, fecha_resolucion, resuelto) VALUES (%s, %s, %s, %s, %s, %s)", (id_technician, id_problem, id_user, date_incidence, date_resolution, resolution))

      conn.commit()
      cur.close()
      conn.close()

    
  return render_template('insert.html')

@app.route('/delete/', methods=('GET', 'POST'))
def delete():
  if request.method == 'POST':
    type = request.form['type']
  
    if type == 'user':
      id_user = request.form['id_user']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM usuarios WHERE id_usuario = %s", (id_user, ))

      conn.commit()
      cur.close()
      conn.close()

    if type == 'user_song':
      id_user = request.form['id_user']
      id_song = request.form['id_song']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM usuarios_canciones WHERE id_usuario = %s AND id_cancion = %s", (id_user, id_song))           
      conn.commit()
      cur.close()
      conn.close()

    if type == 'song_list':
      id_list = request.form['id_list']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM listas_de_canciones WHERE id_lista = %s", (id_list, ))

      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'song_list_song':
      id_list = request.form['id_list']
      id_song = request.form['id_song']
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM lista_canciones_canciones WHERE id_lista = %s AND id_cancion = %s", (id_list, id_song)) 
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'song_list_user':
      id_list = request.form['id_list']
      id_user = request.form['id_user']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM lista_canciones_usuarios WHERE id_lista = %s AND id_usuario = %s", (id_list, id_user))

      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'comment':
      id_comment = request.form['id_comment']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM comentarios WHERE id_comentario = %s", (id_comment, ))
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'author':
      id_author = request.form['id_author']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM autores WHERE id_autor = %s", (id_author, ))

      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'author_member':
      id_author = request.form['id_author']
      name_member = request.form['name_member']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM grupo WHERE id_autor = %s AND nombre_integrante = %s", (id_author, name_member))
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'author_genre':
      id_author = request.form['id_author']
      id_genre = request.form['id_genre']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM autores_generos WHERE id_autor = %s AND id_genero = %s", (id_author, id_genre))
      conn.commit()
      cur.close()
      conn.close()      
    
    if type == 'song':
      id_song = request.form['id_song']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM canciones WHERE id_cancion = %s", (id_song, ))
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'song_author':
      id_song = request.form['id_song']
      id_author = request.form['id_author']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM canciones_autores WHERE id_cancion = %s AND id_autor = %s", (id_song, id_author))
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'song_genre':
      id_song = request.form['id_song']
      id_genre = request.form['id_genre']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM canciones_generos WHERE id_cancion = %s AND id_genero = %s", (id_song, id_genre))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'album':
      id_album = request.form['id_album']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM generos WHERE id_album = %s", (id_album, ))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'album_song':
      id_song = request.form['id_song']
      id_album = request.form['id_album']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM canciones_albumes WHERE id_cancion = %s AND id_album = %s", (id_song, id_album))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'album_genre':
      id_album = request.form['id_album']
      id_genre = request.form['id_genre']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM albumes_generos WHERE id_album = %s AND id_genero = %s", (id_album, id_genre))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'genre':
      id_genre = request.form['id_genre']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM generos WHERE id_genero = %s", (id_genre, ))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'technician':
      id_technician = request.form['id_technician']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM servicio_tecnico WHERE id_tecnico = %s", (id_technician, ))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'problem':
      id_problem = request.form['id_problem']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("DELETE FROM problema WHERE id_problema = %s", (id_problem, ))
      
      conn.commit()
      cur.close()
      conn.close()

  return render_template('delete.html')

@app.route('/update/', methods=('GET', 'POST'))
def update():
  if request.method == 'POST':
    type = request.form['type'] 
    
    if type == 'user':
      id_user = request.form['id_user']
      firstname = request.form['firstname']
      lastname = request.form['lastname']
      username = request.form['username']
      dni = request.form['dni']
      email = request.form['email']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE usuarios SET nombre = %s, apellido = %s, dni = %s, username = %s, email = %s WHERE id_usuario = %s", (firstname, lastname, username, dni, email, id_user))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'song_list':
      id_list = request.form['id_list']
      name_list = request.form['name_list']
      description = request.form['description']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE listas_de_canciones SET nombre_lista = %s, descripcion = %s WHERE id_lista = %s", (name_list, description, id_list))
      
      conn.commit()
      cur.close()
      conn.close()

    if type == 'comment':
      id_comment = request.form['id_comment']
      id_user = request.form['id_user']
      id_song = request.form['id_song']
      text_comment = request.form['text_comment']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE comentarios SET id_usuario = %s, id_cancion = %s, texto_comentario = %s WHERE id_comentario = %s", (id_user, id_song, text_comment, id_comment))
      
      conn.commit()
      cur.close()
      conn.close()

    if type == 'author':
      id_author = request.form['id_author']
      name_author = request.form['name_author']
      name_discography = request.form['name_discography']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE autores SET nombre_autor = %s, discografia = %s WHERE id_autor = %s", (name_author, name_discography, id_author))

      conn.commit()
      cur.close()
      conn.close()
      
    
    if type == 'song':
      id_song = request.form['id_song']
      song_name = request.form['song_name']
      year = request.form['year']
      duration = request.form['duration']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE canciones SET nombre_cancion = %s, año_salida = %s, duracion = %s WHERE id_cancion = %s", (song_name, year, duration, id_song))
      
      conn.commit()
      cur.close()
      conn.close()

    if type == 'album':
      id_album = request.form['id_album']
      name_album = request.form['name_album']
      id_author = request.form['id_author']
      year = request.form['year']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE albumes SET nombre_album = %s, id_autor = %s, año_salida = %s WHERE id_album = %s", (name_album, id_author, year, id_album))
      
      conn.commit()
      cur.close()
      conn.close()

    if type == 'genre':
      id_genre = request.form['id_genre']
      name_genre = request.form['name_genre']

      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE generos SET nombre_genero = %s WHERE id_genero = %s", (name_genre, id_genre))

      conn.commit()
      cur.close()
      conn.close()

    if type == 'technician':
      id_technician = request.form['id_technician']
      firstname = request.form['firstname']
      lastname = request.form['lastname']
      dni = request.form['dni']
      date_up = request.form['date_up']
      date_down = request.form['date_down']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE servicio_tecnico SET nombre = %s, apellido = %s, dni = %s, fecha_de_alta = %s, fecha_de_baja = %s WHERE id_tecnico = %s", (firstname, lastname, dni, date_up, date_down, id_technician))
      
      conn.commit()
      cur.close()
      conn.close()
    
    if type == 'problem':
      id_problem = request.form['id_problem']
      name_problem = request.form['name_problem']
      description = request.form['description']
      resolution = request.form['resolution']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE problema SET nombre_problema = %s, descripcion = %s, resolucion = %s WHERE id_problema = %s", (name_problem, description, resolution, id_problem))
      
      conn.commit()
      cur.close()
      conn.close()

    if type == 'incidence':
      id_technician = request.form['id_technician']
      id_problem = request.form['id_problem']
      id_user = request.form['id_user']
      date_incidence = request.form['date_incidence']
      date_resolution = request.form['date_resolution']
      resolution = request.form['resolution']
      
      conn = get_db_connection()
      cur = conn.cursor()
      cur.execute("UPDATE resuelve SET fecha_incidencia = %s, fecha_resolucion = %s, resuelto = %s WHERE id_tecnico = %s AND id_problema = %s AND id_usuario = %s", (date_incidence, date_resolution, resolution, id_technician, id_problem, id_user))
      
      conn.commit()
      cur.close()
      conn.close()
         
  return render_template('update.html')

@app.route('/index/', methods=('GET', 'POST'))
def index():
  content = []
  if request.method == 'POST':
    type = request.form['type']
    conn = get_db_connection()
    cur = conn.cursor()
    
    if type == 'usuarios':
      cur.execute("SELECT json_build_object ('id_usuario', id_usuario, 'nombre', nombre, 'apellido', apellido, 'dni', dni, 'username', username, 'email', email, 'fecha_registro', fecha_registro) FROM usuarios")
      content = cur.fetchall()
    
    if type == 'servicio_tecnico':
      cur.execute("SELECT json_build_object ('id_tecnico', id_tecnico, 'nombre', nombre, 'apellido', apellido, 'dni', dni, 'fecha_de_alta', fecha_de_alta, 'fecha_de_baja', fecha_de_baja) FROM servicio_tecnico")
      content = cur.fetchall()

    if type == 'problema':
      cur.execute("SELECT json_build_object ('id_problema', id_problema, 'nombre_problema', nombre_problema, 'descripcion', descripcion, 'resolucion', resolucion) FROM problema")
      content = cur.fetchall()
    
    if type == 'canciones':
      cur.execute("SELECT json_build_object ('id_cancion', id_cancion, 'nombre_cancion', nombre_cancion, 'año_salida', año_salida, 'duracion', duracion) FROM canciones")
      content = cur.fetchall()
    
    if type == 'listas_de_canciones':
      cur.execute("SELECT json_build_object ('id_lista', id_lista, 'nombre_lista', nombre_lista, 'descripcion', descripcion, 'duracion', duracion) FROM listas_de_canciones")
      content = cur.fetchall()

    if type == 'autores':
      cur.execute("SELECT json_build_object ('id_autor', id_autor, 'nombre_autor', nombre_autor, 'discografia', discografia) FROM autores")
      content = cur.fetchall()

    if type == 'albumes':
      cur.execute("SELECT json_build_object ('id_album', id_album, 'id_autor', id_autor, 'nombre_album', nombre_album, 'año_salida', año_salida, 'duracion', duracion) FROM albumes")
      content = cur.fetchall()

    if type == 'generos':
      cur.execute("SELECT json_build_object ('id_genero', id_genero, 'nombre_genero', nombre_genero) FROM generos")
      content = cur.fetchall()

    if type == 'comentarios':
      cur.execute("SELECT json_build_object ('id_comentario', id_comentario, 'id_usuario', id_usuario, 'id_cancion', id_cancion, 'texto_comentario', texto_comentario, 'fecha_comentario', fecha_comentario) FROM comentarios")
      content = cur.fetchall()
    
    cur.close()
    conn.close()
  return render_template('index.html', content=content)


# @app.errorhandler(404)
# def id_not_found(error):
#  return render_template("id_not_found.html"), 404