NeuroRead: evaluación cognitiva de lectura

Aplicación de escritorio en Python con Kivy que evalúa la comprensión lectora de estudiantes de secundaria, recomienda actividades según su nivel y registra su progreso.

CÓMO EJECUTAR

Requisito: Python 3 instalado (https://www.python.org/downloads/). Durante la instalación hay que marcar la casilla Add Python to PATH.

Opción A (recomendada):
Doble clic en INICIAR_NEUROREAD.bat.
La primera vez crea un entorno propio en la carpeta .venv, instala Kivy 2.3.1 y abre la aplicación. Tarda unos minutos.
Las siguientes veces abre la aplicación directamente.

Opción B (manual, desde una terminal en la carpeta del proyecto):
Paso 1. pip install -r requirements.txt
Paso 2. python main.py

ESTRUCTURA DE CARPETAS

main.py: punto de entrada.
app.py: clase principal y navegación entre pantallas.
session.py: estado de la sesión actual (usuario, texto activo, tipo de evaluación y respuestas).
theme.py: colores y registro de la tipografía.
widgets.py: componentes visuales (tarjetas, botones, insignias, barras, iconos y barra inferior).
requirements.txt: dependencias (kivy 2.3.1).
INICIAR_NEUROREAD.bat: instalador y lanzador para Windows.
ui/kv_string.py: diseño de todas las pantallas.
screens: lógica de cada pantalla.
Inicio de la aplicación: splash.py, login.py, registro.py.
Pantalla principal con barra inferior: principal.py, inicio.py, ruta.py, evaluacion.py, libros.py, perfil.py.
Pantallas a pantalla completa: bienvenida_evaluacion.py, velocidad.py, comprension.py, interpretacion.py, imaginacion.py, concentracion.py, retencion.py, resultados.py, lector.py, actividad.py, editar_perfil.py.
common.py: funciones compartidas para opciones y etiquetas.
data: datos y base de datos.
db.py: base de datos SQLite, usuarios, sesiones, lecturas, actividades y copias de seguridad.
config.py: grados escolares y número de actividades para desbloquear la evaluación clasificatoria.
niveles.py: niveles Explorador, Constructor, Estratega y Maestro, con su retroalimentación, recomendación y objetivo.
textos.py: los 6 textos de la evaluación.
focus.py: niveles de NeuroFocus.
palabras_ricas.py y validacion.py: análisis de las respuestas escritas.
libros.py: catálogo de los tres libros.
actividades.py: las 50 actividades de la matriz de NeuroCoach.
logros.py: logros del estudiante.
data/libros: textos de Cuentos de la selva (Horacio Quiroga), La isla del tesoro (Robert Louis Stevenson, traducción de Manuel Caballero, 1901) y El príncipe feliz (Oscar Wilde), tomados de Wikisource. Son obras de dominio público y se conservan tal como aparecen en la fuente.
assets/fonts: carpeta opcional para colocar GOTHIC.TTF y GOTHICB.TTF.
backups: copias de seguridad de la base de datos. Se crea sola.

USUARIOS DE PRUEBA

angela, contraseña user123.
gabriel, contraseña user321.
Para entrar se puede escribir el nombre de usuario o el correo (angela@neuroread.local y gabriel@neuroread.local), sin importar mayúsculas.

CÓMO FUNCIONA EL REGISTRO

En la pantalla de inicio de sesión, el enlace ¿No tienes cuenta? Regístrate abre el formulario.
Se piden nombre de usuario, nombre, apellido, grado escolar, correo y contraseña repetida dos veces.
El nombre de usuario lleva de 3 a 20 caracteres: letras sin tilde, números o guion bajo.
El nombre y el apellido solo pueden tener letras, espacios y tildes.
La contraseña debe tener al menos 6 caracteres.
El nombre de usuario y el correo no pueden repetirse.
Al registrarse, el estudiante entra directamente a su evaluación inicial. Al terminarla conoce su nivel y llega a la pestaña Inicio.
Desde la pestaña Perfil se pueden editar los datos, cambiar la contraseña, cerrar sesión y eliminar la cuenta.

CÓMO SE USA

Evaluación inicial: seis módulos (NeuroRead, NeuroTest, NeuroInsight, NeuroCreative, NeuroFocus y NeuroMemory) con un texto al azar. El puntaje define el nivel.
Ruta: actividades del nivel del estudiante sobre los tres libros, ordenadas desde la habilidad más baja.
Libros: lectura de los capítulos. Cada actividad pide leer antes su capítulo.
Evaluación: al completar 4 actividades distintas se desbloquea la evaluación clasificatoria, que actualiza el nivel. El conteo empieza de nuevo después de cada evaluación.
Perfil: datos del estudiante, evolución, puntajes, recomendación de NeuroCoach y logros.

BASE DE DATOS Y COPIAS DE SEGURIDAD

La base de datos es el archivo neuroread.db, en la carpeta principal del proyecto. Se crea sola la primera vez que se abre la aplicación.
Guarda usuarios, evaluaciones, capítulos leídos, actividades completadas y el progreso de cada actividad en curso.
Las contraseñas se guardan protegidas con PBKDF2 y una sal distinta por usuario.
Si se abre una base de una versión anterior, se actualiza sola sin perder usuarios ni evaluaciones.
Cada vez que se abre la aplicación se guarda una copia de neuroread.db en la carpeta backups, con la fecha y la hora en el nombre. Se conservan las 5 copias más recientes.
Para restaurar una copia: cerrar la aplicación, reemplazar neuroread.db por la copia elegida y cambiarle el nombre a neuroread.db.
Para empezar desde cero con una base limpia:
Paso 1. Cerrar la aplicación.
Paso 2. Mover el archivo neuroread.db a la carpeta backups. Así se conserva como respaldo.
Paso 3. Volver a abrir la aplicación. Se crea una base nueva solo con los usuarios de prueba angela y gabriel.

DICCIONARIO DE DATOS

Convención: las tablas llevan el prefijo tbl, la llave primaria se llama id_ más la entidad, las llaves foráneas repiten el nombre de la llave a la que apuntan y los demás campos empiezan con las siglas de su tabla.

tblUsuarios (siglas usu): estudiantes registrados.
id_usuario, INTEGER: llave primaria autoincremental.
usu_nombreUs, TEXT: nombre de usuario para iniciar sesión. Único, sin distinguir mayúsculas.
usu_nombre, TEXT: nombre del estudiante.
usu_apellido, TEXT: apellido del estudiante.
usu_grado, TEXT: grado escolar.
usu_correo, TEXT: correo. Único, sin distinguir mayúsculas.
usu_contrasenaHash, TEXT: contraseña protegida con PBKDF2.
usu_sal, TEXT: sal aleatoria de la contraseña. Vacía solo en usuarios antiguos que aún no han vuelto a entrar.
usu_nivel, TEXT: nivel actual (EXPLORADOR, CONSTRUCTOR, ESTRATEGA o MAESTRO). Vacío hasta la evaluación inicial.
usu_evaluacionInicial, INTEGER: 1 si ya rindió la evaluación inicial, 0 si no.
usu_estado, TEXT: activo o inactivo.
usu_creado, TEXT: fecha y hora de registro.
usu_actualizado, TEXT: fecha y hora del último cambio.

tblSesiones (siglas ses): una fila por cada evaluación terminada.
id_sesion, INTEGER: llave primaria autoincremental.
id_usuario, INTEGER: estudiante que rindió la evaluación.
ses_fecha, TEXT: fecha y hora de la evaluación.
ses_tipo, TEXT: inicial o clasificatoria.
ses_textoId, INTEGER: texto de lectura usado.
ses_puntajeGlobal, INTEGER: puntaje de 0 a 100.
ses_nivel, TEXT: nivel obtenido.
ses_velocidad, INTEGER: porcentaje de NeuroRead.
ses_comprension, INTEGER: porcentaje de NeuroTest.
ses_interpretacion, INTEGER: porcentaje de NeuroInsight.
ses_imaginacion, INTEGER: porcentaje de NeuroCreative.
ses_concentracion, INTEGER: porcentaje de NeuroFocus.
ses_retencion, INTEGER: porcentaje de NeuroMemory.
ses_literal, INTEGER: porcentaje de aciertos en preguntas literales.
ses_inferencial, INTEGER: porcentaje de aciertos en preguntas inferenciales.
ses_critica, INTEGER: porcentaje de aciertos en preguntas críticas.
ses_tiempoLectura, REAL: segundos que tardó en leer el texto.
ses_ppm, INTEGER: palabras por minuto.

tblCapitulosLeidos (siglas cap): capítulos que el estudiante marcó como leídos.
id_capituloLeido, INTEGER: llave primaria autoincremental.
id_usuario, INTEGER: estudiante que leyó el capítulo.
cap_libroId, TEXT: libro (selva, isla o principe).
cap_capitulo, INTEGER: número de capítulo o cuento.
cap_fecha, TEXT: fecha y hora en que lo marcó como leído.
Cada estudiante registra un mismo capítulo una sola vez.

tblActividadesCompletadas (siglas aco): actividades terminadas.
id_actividadCompletada, INTEGER: llave primaria autoincremental.
id_usuario, INTEGER: estudiante que la completó.
aco_actividadId, TEXT: actividad, por ejemplo isla_constructor_2.
aco_libroId, TEXT: libro de la actividad.
aco_nivel, TEXT: nivel de la actividad.
aco_aciertos, INTEGER: pasos respondidos correctamente.
aco_total, INTEGER: total de pasos.
aco_respuesta, TEXT: respuestas en formato JSON.
aco_fecha, TEXT: fecha y hora en que la terminó.

tblActividadEnCurso (siglas aec): progreso guardado de las actividades sin terminar. La llave primaria es id_usuario más aec_actividadId.
id_usuario, INTEGER: estudiante.
aec_actividadId, TEXT: actividad en curso.
aec_paso, INTEGER: cantidad de pasos ya respondidos.
aec_respuestas, TEXT: respuestas dadas hasta ahora, en formato JSON.
aec_actualizado, TEXT: fecha y hora del último paso guardado.

Relaciones:
tblSesiones.id_usuario apunta a tblUsuarios.id_usuario
tblCapitulosLeidos.id_usuario apunta a tblUsuarios.id_usuario
tblActividadesCompletadas.id_usuario apunta a tblUsuarios.id_usuario
tblActividadEnCurso.id_usuario apunta a tblUsuarios.id_usuario

Una base de una versión anterior se convierte sola a estas tablas al abrir la aplicación, conservando los mismos identificadores. Antes de convertirla se guarda una copia en backups.

TIPOGRAFÍA

La aplicación usa Century Gothic: GOTHICB.TTF para títulos y GOTHIC.TTF para el texto.
La fuente se toma de Windows (C:/Windows/Fonts o la carpeta de fuentes del usuario). También se puede copiar en assets/fonts.
Si Century Gothic no está instalada, la aplicación usa Roboto y funciona igual.
