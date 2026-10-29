# NeuroRead

NeuroRead evalúa la comprensión lectora de estudiantes de secundaria, recomienda actividades según su nivel y registra su progreso.

La evaluación tiene seis módulos sobre un mismo texto:

- NeuroRead: velocidad lectora en palabras por minuto.
- NeuroTest: comprensión literal, inferencial y crítica.
- NeuroInsight: interpretación de la emoción y la intención del autor.
- NeuroCreative: imaginación y riqueza del vocabulario.
- NeuroFocus: atención y tiempo de reacción en cuatro niveles, hasta NeuroUltra.
- NeuroMemory: memoria diferida.

Con los resultados, NeuroScore calcula el puntaje global y el nivel (EXPLORADOR, CONSTRUCTOR, ESTRATEGA o MAESTRO). La ruta propone actividades de lectura de tres libros (Cuentos de la selva, La isla del tesoro y El príncipe feliz) y, al completar cuatro, se desbloquea la evaluación clasificatoria para subir de nivel. El perfil muestra la evolución, el puntaje por módulo y los logros.

## Tecnologías

- Flutter 3.47 y Dart 3.13.
- Firebase Authentication (correo y contraseña) y Cloud Firestore con persistencia sin conexión.
- Paquetes: firebase_core, firebase_auth, cloud_firestore, provider, crypto y flutter_localizations.
- Fuentes libres incluidas con licencia SIL OFL 1.1: Jost y Comic Neue. En Windows se usan Century Gothic y Comic Sans MS del sistema.

## Plataformas

- Android: probado en el emulador Pixel_7.
- Web: publicada en Firebase Hosting. En pantallas anchas la app se muestra en un marco de 390 por 844 escalado y centrado.
- iOS: nombre, iconos y pantalla de arranque configurados. No se ha compilado porque requiere macOS.
- Windows: pendiente. Para compilar hace falta Visual Studio con el componente de desarrollo para escritorio con C++.

## Cómo ejecutar el proyecto

1. Instalar Flutter 3.47 o superior y el SDK de Android.
2. Descargar las dependencias:

```
flutter pub get
```

3. Ejecutar en un emulador de Android o en el navegador:

```
flutter run -d emulator-5554
flutter run -d chrome
```

La configuración de Firebase está en lib/firebase_options.dart y android/app/google-services.json, generados con flutterfire configure para el proyecto neuroreadhyo.

### Pruebas con el emulador local de Firebase

Para no tocar los datos reales, las pruebas se hacen con Firebase Local Emulator Suite y el proyecto demo-neuroread. La CLI de Firebase necesita Java 21 o superior.

```
firebase emulators:start --only auth,firestore --project demo-neuroread
```

## Cómo generar el APK

```
flutter build apk --release
```

El archivo queda en build/app/outputs/flutter-apk/app-release.apk. Está firmado con la llave de depuración de Flutter, que sirve para instalarlo en dispositivos y emuladores. Para publicarlo en una tienda hay que crear una llave de producción y configurarla en android/app/build.gradle.kts.

Instalación en un emulador o dispositivo conectado:

```
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Cómo generar y publicar la web

```
flutter build web --release
firebase deploy --only hosting --project neuroreadhyo
```

La compilación queda en build/web. Firebase Hosting la sirve según la sección hosting de firebase.json, con todas las rutas dirigidas a index.html. La versión publicada está en https://neuroreadhyo.web.app.

Las reglas de seguridad de Firestore están en firestore.rules y se despliegan con:

```
firebase deploy --only firestore:rules --project neuroreadhyo
```

## Estructura de carpetas

```
lib/
  main.dart              arranque: inicia Firebase, activa la persistencia y lanza la app
  firebase_options.dart  configuración generada por flutterfire configure
  app/                   widget raíz, navegación entre pantallas, botón atrás y marco de 390 por 844
  tema/                  colores, tipografías, escala de texto, medidas y signo de porcentaje
  widgets/               componentes neobrutalistas: tarjetas, botones, chips, barras, iconos, campos y modales
  logos/                 los cinco logos animados de la pantalla de carga
  contenido/             contenido fijo: niveles, textos de evaluación, actividades, libros, NeuroFocus y logros
  logica/                cálculos sin interfaz: puntajes, validación de redacción, riqueza, ruta, racha, logros y fechas
  modelos/               conversión de los documentos de Firestore
  servicios/             autenticación y repositorio de Firestore
  estado/                usuario actual y sus datos, evaluación en curso y navegación
  pantallas/
    acceso/              pantalla de carga, inicio de sesión y registro
    principal/           barra inferior y pestañas Inicio, Ruta, Evaluación, Libros y Perfil
    lectura/             lector de capítulos y actividades
    evaluacion/          bienvenida y los seis módulos
    resultados/          NeuroScore
    perfil/              editar perfil y eliminar cuenta
assets/
  iconos/                iconos blancos que se tiñen en la app
  libros/                capítulos de los tres libros (libro/NN.txt)
  fuentes/               Jost y Comic Neue
  imagenes/              icono y pantalla de inicio
android/ ios/ web/ windows/  proyectos de cada plataforma
firebase.json            configuración de Firestore, Hosting y emuladores
firestore.rules          reglas de seguridad de Firestore
```

## Modelo de datos de Firestore

Los nombres siguen esta convención: la llave primaria es el id del documento, las llaves foráneas usan el mismo nombre que la llave a la que apuntan (id_usuario) y los demás campos llevan las siglas de su colección, un guion bajo y el nombre en camelCase. Las fechas son Timestamp.

### usuarios/{id_usuario}

El id es el uid de Firebase Authentication.

- id_usuario: string.
- usu_nombreUs, usu_nombre, usu_apellido, usu_grado, usu_correo: string. El correo se guarda en minúsculas.
- usu_nivel: string o null (EXPLORADOR, CONSTRUCTOR, ESTRATEGA o MAESTRO).
- usu_evaluacionInicial: bool.
- usu_estado: string, activo o inactivo.
- usu_creado, usu_actualizado: Timestamp.

### usuarios/{id_usuario}/sesiones/{id_sesion}

Una evaluación terminada. Id automático.

- id_usuario, ses_fecha, ses_tipo (inicial o clasificatoria), ses_textoId (int), ses_puntajeGlobal (int), ses_nivel (string).
- ses_velocidad, ses_comprension, ses_interpretacion, ses_imaginacion, ses_concentracion, ses_retencion: int de 0 a 100.
- ses_literal, ses_inferencial, ses_critica: int o null.
- ses_tiempoLectura: double. ses_ppm: int.

### usuarios/{id_usuario}/capitulosLeidos/{id_capituloLeido}

El id es el libro y el capítulo, por ejemplo selva_01.

- id_usuario, cap_libroId (string), cap_capitulo (int), cap_fecha.

### usuarios/{id_usuario}/actividadesCompletadas/{id_actividadCompletada}

Id automático.

- id_usuario, aco_actividadId, aco_libroId, aco_nivel (string), aco_aciertos, aco_total (int), aco_respuesta (lista de mapas con paso, tipo, correcta y valor), aco_fecha.

### usuarios/{id_usuario}/actividadesEnCurso/{aec_actividadId}

El id es el de la actividad.

- id_usuario, aec_actividadId, aec_paso (int), aec_respuestas (lista de mapas), aec_actualizado.

### usuarios/{id_usuario}/palabrasUsadas/{id_palabraUsada}

Palabras mostradas en NeuroFocus, para no repetirlas en las tres evaluaciones siguientes. Se escriben en un solo lote por evaluación.

- id_usuario, pal_nivel (FACIL, NORMAL o DIFICIL), pal_palabra (string), pal_fecha.

### accesos/{clave}

Permite entrar con nombre de usuario o correo y evita que se repitan. Hay dos documentos por estudiante: u_ más el nombre de usuario en minúsculas, y c_ más el SHA-256 del correo en minúsculas.

- id_usuario: el uid dueño.
- acc_cuenta: el correo interno de la cuenta de Authentication.

La cuenta de Authentication usa un correo interno generado al registrarse; el correo real solo se guarda en el perfil privado. Los documentos de accesos no contienen el nombre ni el correo del estudiante.

### Seguridad

- Cada estudiante solo puede leer y escribir sus propios documentos. Nadie puede listar colecciones ni leer datos de otros.
- Las reglas validan los campos permitidos, sus tipos, sus largos y los rangos de puntaje.
- Eliminar la cuenta borra todos sus documentos, sus accesos y la cuenta de Authentication.
- Al cerrar sesión o eliminar la cuenta se borra la caché local del dispositivo.

## Contenido

Los textos de los libros provienen de Wikisource y son de dominio público. El contenido fijo (libros, textos de evaluación, actividades, bancos de palabras de NeuroFocus, niveles y logros) está incluido en la app y no se guarda en Firestore.
