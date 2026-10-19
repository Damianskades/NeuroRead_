
Aplicación de escritorio en Python con Kivy que evalúa la comprensión lectora de estudiantes de secundaria, recomienda actividades según su nivel y registra su progreso.

-----------
¿COMO EJECUTAR?
---------------

Requisito: Python 3 instalado (https://www.python.org/downloads/). Durante la instalación hay que marcar la casilla Add Python to PATH.

### Opción A (manual, desde una terminal en la carpeta del proyecto)


PASO 1
python -m venv .venv

PASO 2
.venv\Scripts\activate

PASO 3
pip install -r requirements.txt

PASO 4
python main.py


### Opción B (recomendada)

- Doble clic en `INICIAR_NEUROREAD.bat`.
- La primera vez crea un entorno propio en la carpeta `.venv`, instala Kivy 2.3.1 y abre la aplicación. Tarda unos minutos.
- Las siguientes veces abre la aplicación directamente.


## Usuarios de prueba

- angela, contraseña user123.
- gabriel, contraseña user321.

Para entrar se puede escribir el nombre de usuario o el correo (angela@neuroread.local y gabriel@neuroread.local), sin importar mayúsculas.

## Cómo funciona el registro

- En la pantalla de inicio de sesión, el enlace ¿No tienes cuenta? Regístrate abre el formulario.
- Se piden nombre de usuario, nombre, apellido, grado escolar, correo y contraseña repetida dos veces.
- El nombre de usuario lleva de 3 a 20 caracteres: letras sin tilde, números o guion bajo.
- El nombre y el apellido solo pueden tener letras, espacios y tildes.
- La contraseña debe tener al menos 6 caracteres.
- El nombre de usuario y el correo no pueden repetirse.
- Al registrarse, el estudiante entra directamente a su evaluación inicial. Al terminarla conoce su nivel y llega a la pestaña Inicio.
- Desde la pestaña Perfil se pueden editar los datos, cambiar la contraseña, cerrar sesión y eliminar la cuenta.

## Cómo se usa

- Evaluación inicial: seis módulos (NeuroRead, NeuroTest, NeuroInsight, NeuroCreative, NeuroFocus y NeuroMemory) con un texto al azar. El puntaje define el nivel.
- Ruta: actividades del nivel del estudiante sobre los tres libros, ordenadas desde la habilidad más baja.
- Libros: lectura de los capítulos. Cada actividad pide leer antes su capítulo.
- Evaluación: al completar 4 actividades distintas se desbloquea la evaluación clasificatoria, que actualiza el nivel. El conteo empieza de nuevo después de cada evaluación.
- Perfil: datos del estudiante, evolución, puntajes, recomendación de NeuroCoach y logros.

## Base de datos y copias de seguridad

- La base de datos es el archivo `neuroread.db`, en la carpeta principal del proyecto. Se crea sola la primera vez que se abre la aplicación.
- Guarda usuarios, evaluaciones, capítulos leídos, actividades completadas y el progreso de cada actividad en curso.
- Si se abre una base de una versión anterior, se actualiza sola sin perder usuarios ni evaluaciones.
- Cada vez que se abre la aplicación se guarda una copia de neuroread.db en la carpeta backups
- Para restaurar una copia: cerrar la aplicación, reemplazar neuroread.db por la copia elegida y cambiarle el nombre a neuroread.db.

Para empezar desde cero con una base limpia:

1. Cerrar la aplicación.
2. Mover el archivo `neuroread.db` a la carpeta `backups`. Así se conserva como respaldo.
3. Volver a abrir la aplicación. Se crea una base nueva solo con los usuarios de prueba angela y gabriel.

## Diccionario de datos

Convención: las tablas llevan el prefijo tbl, la llave primaria se llama id_ más la entidad, las llaves foráneas repiten el nombre de la llave a la que apuntan y los demás campos empiezan con las siglas de su tabla.

### tblUsuarios (siglas usu)

Estudiantes registrados.


 `id_usuario` | INTEGER |              Llave primaria autoincremental. 
 `usu_nombreUs` | TEXT |               Nombre de usuario para iniciar sesión. Único, sin distinguir mayúsculas. 
 `usu_nombre` | TEXT |                 Nombre del estudiante. 
 `usu_apellido` | TEXT |               Apellido del estudiante. 
 `usu_grado` | TEXT |                  Grado escolar. 
 `usu_correo` | TEXT |                 Correo. Único, sin distinguir mayúsculas. 
 `usu_contrasenaHash` | TEXT |         Contraseña protegida con PBKDF2. 
 `usu_sal` | TEXT |                    Sal aleatoria de la contraseña. Vacía solo en usuarios antiguos que aún no han vuelto a entrar. 
 `usu_nivel` | TEXT |                  Nivel actual Vacío hasta la evaluación inicial. 
 `usu_evaluacionInicial` | INTEGER |   1 si ya rindió la evaluación inicial, 0 si no. 
 `usu_estado` | TEXT |                 Activo o inactivo. 
 `usu_creado` | TEXT |                 Fecha y hora de registro. 
 `usu_actualizado` | TEXT |            Fecha y hora del último cambio. 

### tblSesiones (siglas ses)

Una fila por cada evaluación terminada.

 `id_sesion` | INTEGER |               Llave primaria autoincremental. 
 `id_usuario` | INTEGER |              Estudiante que rindió la evaluación. 
 `ses_fecha` | TEXT |                  Fecha y hora de la evaluación. 
 `ses_tipo` | TEXT |                   Inicial o clasificatoria. 
 `ses_textoId` | INTEGER |             Texto de lectura usado. 
 `ses_puntajeGlobal` | INTEGER |       Puntaje de 0 a 100. 
 `ses_nivel` | TEXT |                  Nivel obtenido. 
 `ses_velocidad` | INTEGER |           Porcentaje de NeuroRead. 
 `ses_comprension` | INTEGER |         Porcentaje de NeuroTest. 
 `ses_interpretacion` | INTEGER |      Porcentaje de NeuroInsight. 
 `ses_imaginacion` | INTEGER |         Porcentaje de NeuroCreative. 
 `ses_concentracion` | INTEGER |       Porcentaje de NeuroFocus. 
 `ses_retencion` | INTEGER |           Porcentaje de NeuroMemory. 
 `ses_literal` | INTEGER |             Porcentaje de aciertos en preguntas literales. 
 `ses_inferencial` | INTEGER |         Porcentaje de aciertos en preguntas inferenciales. 
 `ses_critica` | INTEGER |             Porcentaje de aciertos en preguntas críticas. 
 `ses_tiempoLectura` | REAL |          Segundos que tardó en leer el texto. 
 `ses_ppm` | INTEGER |                 Palabras por minuto. 


### tblCapitulosLeidos (siglas cap)
Cada estudiante registra un mismo capítulo una sola vez.

 `id_capituloLeido` | INTEGER |        Llave primaria autoincremental. 
 `id_usuario` | INTEGER |              Estudiante que leyó el capítulo. 
 `cap_libroId` | TEXT |                Libro (selva, isla o principe). 
 `cap_capitulo` | INTEGER |            Número de capítulo o cuento. 
 `cap_fecha` | TEXT |                  Fecha y hora en que lo marcó como leído. 

### tblActividadesCompletadas (siglas aco)

Actividades terminadas.



`id_actividadCompletada` | INTEGER |    Llave primaria autoincremental. 
 `id_usuario` | INTEGER |               Estudiante que la completó. 
 `aco_actividadId` | TEXT |             Actividad, por ejemplo isla_constructor_2. 
 `aco_libroId` | TEXT |                 Libro de la actividad. 
 `aco_nivel` | TEXT |                   Nivel de la actividad. 
 `aco_aciertos` | INTEGER |             Pasos respondidos correctamente. 
 `aco_total` | INTEGER |                Total de pasos.
 `aco_respuesta` | TEXT |               Respuestas en formato JSON. 
 `aco_fecha` | TEXT |                   Fecha y hora en que la terminó. 

### tblActividadEnCurso (siglas aec)

La llave primaria es `id_usuario` más `aec_actividadId`.


 `id_usuario` | INTEGER |               Estudiante. 
 `aec_actividadId` | TEXT |             Actividad en curso. 
 `aec_paso` | INTEGER |                 Cantidad de pasos ya respondidos. 
 `aec_respuestas` | TEXT |              Respuestas dadas hasta ahora, en formato JSON. 
 `aec_actualizado` | TEXT |             Fecha y hora del último paso guardado. 

### Relaciones (OJO BASE DE DATOS NO RELACIONAL)

- `tblSesiones.id_usuario` apunta a `tblUsuarios.id_usuario`
- `tblCapitulosLeidos.id_usuario` apunta a `tblUsuarios.id_usuario`
- `tblActividadesCompletadas.id_usuario` apunta a `tblUsuarios.id_usuario`
- `tblActividadEnCurso.id_usuario` apunta a `tblUsuarios.id_usuario`

Una base de una versión anterior se convierte sola a estas tablas al abrir la aplicación, conservando los mismos identificadores. Antes de convertirla se guarda una copia en `backups`.

## Tipografía
- La aplicación usa Century Gothic: `GOTHICB.TTF` para títulos y `GOTHIC.TTF` para el texto.
fonts`.
- Si Century Gothic no está instalada, la aplicación usa Roboto y funciona igual.