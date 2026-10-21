
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

### tblPalabrasUsadas (siglas pal)

Palabras que se mostraron a cada estudiante en NeuroFocus. Sirve para no repetirlas en sus 3 evaluaciones siguientes.

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `id_palabraUsada` | INTEGER | Llave primaria autoincremental. |
| `id_usuario` | INTEGER | Estudiante que vio la palabra. |
| `pal_nivel` | TEXT | Nivel de NeuroFocus (FACIL, NORMAL o DIFICIL). |
| `pal_palabra` | TEXT | Palabra mostrada. |
| `pal_fecha` | TEXT | Fecha y hora de la evaluación. Todas las palabras de una misma evaluación comparten esta fecha. |

### Relaciones (OJO BASE DE DATOS NO RELACIONAL)

- `tblSesiones.id_usuario` apunta a `tblUsuarios.id_usuario`
- `tblCapitulosLeidos.id_usuario` apunta a `tblUsuarios.id_usuario`
- `tblActividadesCompletadas.id_usuario` apunta a `tblUsuarios.id_usuario`
- `tblActividadEnCurso.id_usuario` apunta a `tblUsuarios.id_usuario`
- `tblPalabrasUsadas.id_usuario` apunta a `tblUsuarios.id_usuario`

Una base de una versión anterior se convierte sola a estas tablas al abrir la aplicación, conservando los mismos identificadores. Antes de convertirla se guarda una copia en `backups`.

## Tipografía
- La aplicación usa Century Gothic: `GOTHICB.TTF` para títulos y `GOTHIC.TTF` para el texto.
fonts`.
- Si Century Gothic no está instalada, la aplicación usa Roboto y funciona igual.

## Tamaño de la ventana

- La ventana tiene la proporción de un celular (390 por 844) y se ajusta sola a la pantalla donde se abre: ocupa el 90 % del alto disponible sobre la barra de tareas y se abre centrada.
- Todo el diseño se escala en la misma proporción, así que se ve igual en una laptop pequeña y en un monitor 4K.
- La ventana no se puede maximizar ni cambiar de tamaño.
