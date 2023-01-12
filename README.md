# Datos
- Universidad de La Laguna
- Asignatura de Diseño y Administración de Bases de Datos
- Proyecto Final: ULL Music Database
## Integrantes
- Bruno Lorenzo Arroyo Pedraza - alu0101123677
- Carla Cristina Olivares Rodríguez - alu0101120218
- Dana Belén Choque Zárate - alu0101328348
## Descripción
Proyecto final de la asignatura de Diseño y Administración de Bases de Datos. El proyecto consiste en el diseño de una Base de Datos y su posterior implementación con una API REST para realizar operaciones CRUD.
La base de datos diseñada se basa en una aplicación para escuchar música, en la que los usuarios pueden, escuchar canciones, crear listas de reproducción, compartirlas con otros usuarios y comentar canciones, así como acceder a un servicio técnico. La aplicación estaría desarrollada por la Universidad de La Laguna y se llamaría ULL Music, por tanto su base de datos, y mismo nombre que el proyecto es, ULL Music Database.
## Contenido
En el repositorio github se encuentra:
- El fichero ull_music.sql con la inicialización de la base de datos y la carga de datos
- El fichero app.py con la implementación de la API REST
- El fichero Proyecto final.pdf que contiene el informe del proyecto
- La carpeta templates con el front-end de la API REST
- La carpeta imagenes con las imagenes del módelo relacional y el modelo entidad/relación 
## Despliegue
Adicionalmente hay un comprimido .zip, que dentro contiene el fichero 
ull_music.sql, el fichero app.py, la carpeta templates y entorno virtual. Descomprimir el comprimido y situarse dentro.

Para desplegar la base de datos, situandose en una terminal abierta desde la carpeta del comprimido, entrar a postgres y posteriormente a psql. Una vez dentro de psql, ejecutar el comando `\i ull_music.sql`para inicializar la base de datos y cargar los datos. 

Para desplegar la API, hay realizar los siguientes instrucciones:

- Antes de nada, comprobar que en el fichero app.py, el usuario y contraseña de la base de datos coinciden con los de la base de datos desplegada.
- Primero activar el entorno virtual con `source venv/bin/activate`
- Dentro del entorno virtual, ejecutar el comando `flask --app app run --host 0.0.0.0 --port=8080`
- Si todo ha ido bien, la API se desplegará en la dirección http://localhost:8080/
- Para terminar la ejecución CRTL+C y para salir del entorno virtual ejecutar el comando `deactivate`


 
 