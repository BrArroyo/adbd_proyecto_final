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
      return redirect(url_for('about'))

    if type == 'song':
      return redirect(url_for('delete'))      
  return render_template('insert.html')

@app.route('/delete/', methods=('GET', 'POST'))
def delete():  
  return render_template('delete.html')

@app.route('/update/', methods=('GET', 'POST'))
def update():
  return render_template('update.html')