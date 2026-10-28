const minPalabrasEscrita = 15;

sealed class Paso {
  const Paso();

  String get tipo;
}

class PasoOpcion extends Paso {
  const PasoOpcion({
    required this.pregunta,
    required this.opciones,
    required this.correcta,
  });

  final String pregunta;
  final List<String> opciones;
  final int correcta;

  @override
  String get tipo => 'opcion';
}

class PasoOrdenar extends Paso {
  const PasoOrdenar({required this.instruccion, required this.elementos});

  final String instruccion;
  final List<String> elementos;

  @override
  String get tipo => 'ordenar';
}

class PasoEscrita extends Paso {
  const PasoEscrita({
    required this.consigna,
    this.minPalabras = minPalabrasEscrita,
  });

  final String consigna;
  final int minPalabras;

  @override
  String get tipo => 'escrita';
}

class Actividad {
  const Actividad({
    required this.id,
    required this.libroId,
    required this.nivel,
    required this.orden,
    required this.titulo,
    required this.habilidad,
    required this.capituloRequerido,
    required this.objetivo,
    required this.pasos,
  });

  final String id;
  final String libroId;
  final String nivel;
  final int orden;
  final String titulo;
  final String habilidad;
  final int capituloRequerido;
  final String objetivo;
  final List<Paso> pasos;
}

const actividades = <Actividad>[
  Actividad(
    id: 'selva_explorador_1',
    libroId: 'selva',
    nivel: 'EXPLORADOR',
    orden: 1,
    titulo: 'Leer un cuento seleccionado.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Leer La tortuga gigante y reconocer los datos más importantes del cuento.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Dónde vivía el hombre al comienzo del cuento?',
        opciones: [
          'En Misiones',
          'En el Zoológico',
          'Junto a una laguna',
          'En Buenos Aires',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Por qué el hombre se fue a vivir al monte?',
        opciones: [
          'Para cazar un tigre',
          'Para visitar a sus hermanos',
          'Porque los médicos dijeron que así podría curarse',
          'Para buscar una tortuga',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Quién encontró a la tortuga y al hombre cuando llegaron a la ciudad?',
        opciones: [
          'Un ratón',
          'El director del Zoológico',
          'Un tigre',
          'Un médico',
        ],
        correcta: 0,
      ),
    ],
  ),
  Actividad(
    id: 'selva_explorador_2',
    libroId: 'selva',
    nivel: 'EXPLORADOR',
    orden: 2,
    titulo: 'Identificar personajes, lugar y problema.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Reconocer quiénes participan en el cuento, dónde ocurre y cuál es el problema.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Quiénes son los dos personajes principales del cuento?',
        opciones: [
          'Un tigre y un ratón',
          'Un médico y un director',
          'Dos hermanos',
          'Un cazador y una tortuga',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Dónde ocurre la mayor parte de la historia?',
        opciones: [
          'En una casa de Buenos Aires',
          'En un barco',
          'En el monte, lejos de la ciudad',
          'En el Jardín Zoológico',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Cuál es el problema principal del cazador?',
        opciones: [
          'No sabe cazar',
          'Perdió su escopeta',
          'Se enferma de fiebre y solo en Buenos Aires hay remedios para curarlo',
          'Un tigre lo persigue por el monte',
        ],
        correcta: 2,
      ),
    ],
  ),
  Actividad(
    id: 'selva_explorador_3',
    libroId: 'selva',
    nivel: 'EXPLORADOR',
    orden: 3,
    titulo: 'Responder cinco preguntas literales.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Buscar en el cuento información que aparece escrita de forma explícita.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué animal quería comerse a la tortuga?',
        opciones: ['Un tigre', 'Una víbora', 'Un yacaré', 'Un zorro'],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: '¿Con qué le vendó el hombre la cabeza a la tortuga?',
        opciones: [
          'Con hojas de palmera',
          'Con tiras de género de su camisa',
          'Con una manta',
          'Con enredaderas',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué le daba de comer la tortuga al hombre enfermo?',
        opciones: [
          'Pájaros que cazaba',
          'Frutas de los árboles',
          'Pescados de la laguna',
          'Raíces ricas y yuyitos tiernos',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Con qué sujetó la tortuga al hombre sobre su lomo?',
        opciones: [
          'Con una soga',
          'Con su cinturón',
          'Con enredaderas finas y fuertes',
          'Con tiras de cuero',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Cuántas leguas recorrió la tortuga para salvar al cazador?',
        opciones: ['Trescientas', 'Diez', 'Cincuenta', 'Mil'],
        correcta: 0,
      ),
    ],
  ),
  Actividad(
    id: 'selva_explorador_4',
    libroId: 'selva',
    nivel: 'EXPLORADOR',
    orden: 4,
    titulo: 'Ordenar seis acontecimientos.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Reconstruir la secuencia de los hechos del cuento.',
    pasos: [
      PasoOrdenar(
        instruccion: 'Ordena los acontecimientos del cuento desde el primero hasta el último.',
        elementos: [
          'El hombre enfermo se va a vivir al monte.',
          'El cazador mata al tigre que atacaba a la tortuga.',
          'El hombre cura a la tortuga herida.',
          'La tortuga cuida al hombre cuando le da fiebre.',
          'La tortuga lleva al hombre sobre su lomo hacia Buenos Aires.',
          'El director del Zoológico cura al cazador con remedios.',
        ],
      ),
    ],
  ),
  Actividad(
    id: 'selva_explorador_5',
    libroId: 'selva',
    nivel: 'EXPLORADOR',
    orden: 5,
    titulo: 'Encontrar en el texto la evidencia de cada respuesta.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo:
        'Localizar en el cuento la frase exacta que demuestra cada respuesta.',
    pasos: [
      PasoOpcion(
        pregunta:
            '¿Qué parte del cuento demuestra que la tortuga era muy grande?',
        opciones: [
          'La tortuga quedó arrimada a un rincón.',
          'La tortuga sanó por fin.',
          'Era tan alta como una silla y pesaba como un hombre.',
          'La tortuga recorría el monte buscando raíces.',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Qué parte demuestra que el hombre sintió compasión por la tortuga?',
        opciones: [
          'A pesar del hambre que sentía, tuvo lástima de la pobre tortuga.',
          'Le apuntó al tigre entre los dos ojos.',
          'Había hecho un atado con los cueros de los animales.',
          'Comía pájaros y bichos del monte.',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta:
            '¿Qué parte prueba que la tortuga llegó muy débil a la ciudad?',
        opciones: [
          'Atravesó montes y campos.',
          'Iba a buscar agua y raíces tiernas.',
          'Cruzó a nado ríos de una legua de ancho.',
          'No había comido desde hacía una semana para llegar más pronto.',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Qué parte muestra que el cazador y la tortuga siguen siendo amigos?',
        opciones: [
          'El director se comprometió a cuidarla.',
          'El cazador la va a ver todas las tardes.',
          'La tortuga pasea por todo el jardín.',
          'La casa del cazador era muy chica.',
        ],
        correcta: 1,
      ),
    ],
  ),
  Actividad(
    id: 'selva_constructor_1',
    libroId: 'selva',
    nivel: 'CONSTRUCTOR',
    orden: 1,
    titulo: 'Resumir el cuento en cinco ideas.',
    habilidad: 'inferencial',
    capituloRequerido: 8,
    objetivo: 'Seleccionar las ideas esenciales de La abeja haragana y contarlas con brevedad.',
    pasos: [
      PasoOrdenar(
        instruccion: 'Ordena las cinco ideas principales del cuento.',
        elementos: [
          'Una abeja de la colmena no quería trabajar.',
          'Las abejas guardianas le advierten varias veces que debe trabajar.',
          'Una noche fría no la dejan entrar y cae en la cueva de una culebra.',
          'La abeja se salva escondiéndose en las hojas de una planta sensitiva.',
          'Vuelve a la colmena y se convierte en una abeja muy trabajadora.',
        ],
      ),
      PasoEscrita(
        consigna: 'Escribe con tus propias palabras un resumen del cuento en cinco ideas.',
        minPalabras: 30,
      ),
    ],
  ),
  Actividad(
    id: 'selva_constructor_2',
    libroId: 'selva',
    nivel: 'CONSTRUCTOR',
    orden: 2,
    titulo: 'Identificar tres relaciones de causa y consecuencia.',
    habilidad: 'inferencial',
    capituloRequerido: 8,
    objetivo: 'Relacionar lo que pasa en el cuento con lo que lo provoca.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Por qué las guardianas no dejaron entrar a la abeja el 20 de abril?',
        opciones: [
          'Porque llegó muy tarde',
          'Porque estaba enferma',
          'Porque no había traído ni una gota de miel',
          'Porque la colmena estaba llena',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Qué ocurrió cuando la abeja tocó la planta de la cueva?',
        opciones: [
          'La planta se cayó',
          'Las hojas se cerraron y la ocultaron',
          'La culebra la vio en seguida',
          'La planta empezó a crecer',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Por qué la abeja y la culebra pasaron la noche contra la pared más alta?',
        opciones: [
          'Porque el agua de la tormenta entraba como un río',
          'Porque allí hacía calor',
          'Porque la culebra quería dormir',
          'Porque había otra culebra abajo',
        ],
        correcta: 0,
      ),
    ],
  ),
  Actividad(
    id: 'selva_constructor_3',
    libroId: 'selva',
    nivel: 'CONSTRUCTOR',
    orden: 3,
    titulo: 'Explicar una decisión de un personaje.',
    habilidad: 'inferencial',
    capituloRequerido: 8,
    objetivo: 'Comprender por qué un personaje actúa como lo hace.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Por qué la abeja eligió la prueba de desaparecer?',
        opciones: [
          'Porque sabía volar muy rápido',
          'Porque la culebra no podía ver',
          'Porque conocía un agujero para escapar',
          'Porque mientras bailaba el trompito vio una plantita que cierra sus hojas',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Explica por qué las guardianas decidieron no dejar entrar a la abeja y si te parece una decisión justa.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'selva_constructor_4',
    libroId: 'selva',
    nivel: 'CONSTRUCTOR',
    orden: 4,
    titulo: 'Justificar dos inferencias mediante pistas del texto.',
    habilidad: 'inferencial',
    capituloRequerido: 8,
    objetivo: 'Usar pistas del cuento para sostener lo que se deduce.',
    pasos: [
      PasoOpcion(
        pregunta: 'Se puede inferir que las guardianas eran sabias. ¿Qué pista lo apoya?',
        opciones: [
          'Tienen el lomo pelado.',
          'Son abejas viejas, con gran experiencia de la vida.',
          'Están siempre en la puerta.',
          'Hablan muy fuerte.',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: 'Se puede inferir que la abeja cambió de verdad. ¿Qué pista lo apoya?',
        opciones: [
          'Lloró en silencio frente a la colmena.',
          'Recordaba la colmena calentita.',
          'En adelante ninguna recogió tanto polen ni fabricó tanta miel como ella.',
          'Voló cuando salió el sol.',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna: 'Escribe otra inferencia sobre el cuento y la pista del texto que la apoya.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'selva_estratega_1',
    libroId: 'selva',
    nivel: 'ESTRATEGA',
    orden: 1,
    titulo: 'Analizar una decisión y sus consecuencias.',
    habilidad: 'inferencial',
    capituloRequerido: 4,
    objetivo: 'Analizar cómo las decisiones de los yacarés cambian el curso de la historia.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué decidieron los yacarés cuando comprendieron que el vapor pasaría siempre?',
        opciones: [
          'Irse a otro río',
          'Hacer un dique',
          'Atacar el vapor',
          'Pedir ayuda al Surubí',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué consecuencia tuvo el primer dique?',
        opciones: [
          'El vapor se hundió',
          'Los pescados volvieron para siempre',
          'Llegó un buque de guerra que lo deshizo a cañonazos',
          'Los hombres se hicieron amigos de los yacarés',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna: 'Analiza la decisión de pedir el torpedo al Surubí. ¿Qué consecuencias tuvo para los yacarés y para los hombres del buque?',
        minPalabras: 25,
      ),
    ],
  ),
  Actividad(
    id: 'selva_estratega_2',
    libroId: 'selva',
    nivel: 'ESTRATEGA',
    orden: 2,
    titulo: 'Proponer una alternativa.',
    habilidad: 'critica',
    capituloRequerido: 4,
    objetivo: 'Imaginar otra solución al conflicto y valorar sus resultados.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Por qué al principio el Surubí no quería tener relación con los yacarés?',
        opciones: [
          'Porque le habían robado el torpedo',
          'Porque eran muy ruidosos',
          'Porque vivían lejos',
          'Porque se habían comido a su sobrinito',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Propón otra forma en que los yacarés podrían haber resuelto el problema del buque sin destruirlo. Explica qué pasaría con tu propuesta.',
        minPalabras: 25,
      ),
    ],
  ),
  Actividad(
    id: 'selva_estratega_3',
    libroId: 'selva',
    nivel: 'ESTRATEGA',
    orden: 3,
    titulo: 'Distinguir hechos, inferencias y afirmaciones sin respaldo suficiente.',
    habilidad: 'critica',
    capituloRequerido: 4,
    objetivo: 'Separar lo que el cuento afirma de lo que se deduce y de lo que no tiene apoyo.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Cuál de estas afirmaciones es un hecho que dice el texto?',
        opciones: [
          'Los yacarés construyeron el dique con lapachos y quebrachos.',
          'Los yacarés eran los animales más inteligentes del río.',
          'El oficial era el peor de los marineros.',
          'El Surubí quería vengarse de los hombres.',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: '¿Cuál es una inferencia razonable a partir del cuento?',
        opciones: [
          'Los yacarés no sabían nadar.',
          'El viejo yacaré reconoció el buque de guerra porque había viajado hasta el mar.',
          'El vapor quería atacar a los yacarés desde el principio.',
          'Los pescados avisaron a los hombres del dique.',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Cuál afirmación no tiene respaldo suficiente en el texto?',
        opciones: [
          'El buque de guerra destruyó dos diques.',
          'El Surubí sabía hacer reventar el torpedo.',
          'Los yacarés odian a todos los seres humanos.',
          'Los pescados se fueron por el ruido del vapor.',
        ],
        correcta: 2,
      ),
    ],
  ),
  Actividad(
    id: 'selva_estratega_4',
    libroId: 'selva',
    nivel: 'ESTRATEGA',
    orden: 4,
    titulo: 'Comparar dos personajes a partir de sus acciones.',
    habilidad: 'critica',
    capituloRequerido: 4,
    objetivo: 'Comparar a los personajes por lo que hacen y no solo por lo que dicen.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué diferencia muestran las acciones del viejo yacaré frente a las de los yacarés jóvenes?',
        opciones: [
          'El viejo reconoce el peligro y ordena esconderse bajo el agua',
          'El viejo se queda dormido mientras los otros trabajan',
          'Los jóvenes conocen mejor los barcos',
          'El viejo no quiere hacer el dique',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: 'Compara al viejo yacaré y al Surubí. ¿En qué se parecen y en qué se diferencian por sus acciones?',
        minPalabras: 25,
      ),
    ],
  ),
  Actividad(
    id: 'selva_maestro_1',
    libroId: 'selva',
    nivel: 'MAESTRO',
    orden: 1,
    titulo: 'Interpretar el conflicto desde dos perspectivas.',
    habilidad: 'critica',
    capituloRequerido: 7,
    objetivo: 'Comprender el conflicto del cuento desde el punto de vista de cada bando.',
    pasos: [
      PasoOpcion(
        pregunta: 'Desde la perspectiva de las rayas, ¿por qué defienden el paso del río?',
        opciones: [
          'Porque el tigre les robaba los pescados',
          'Porque el hombre las había protegido al impedir las bombas de dinamita',
          'Porque el zorro se lo ordenó',
          'Porque querían quedarse con la isla',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué argumento usa el tigre para exigir que lo dejen pasar?',
        opciones: [
          'Que el río era suyo',
          'Que tenía mucha hambre',
          'Que el hombre lo había herido a él',
          'Que las rayas le debían un favor',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna: 'Interpreta el conflicto desde la perspectiva de las rayas y desde la del tigre. ¿Qué tiene de razonable cada una?',
        minPalabras: 30,
      ),
    ],
  ),
  Actividad(
    id: 'selva_maestro_2',
    libroId: 'selva',
    nivel: 'MAESTRO',
    orden: 2,
    titulo: 'Reescribir una escena desde otro personaje.',
    habilidad: 'critica',
    capituloRequerido: 7,
    objetivo: 'Contar una escena del cuento desde los ojos de otro personaje.',
    pasos: [
      PasoOpcion(
        pregunta:
            '¿Qué llevaba el carpinchito cuando cruzó nadando el Yabebirí?',
        opciones: [
          'Una carta del hombre',
          'Comida para el herido',
          'Un remedio para las rayas',
          'El winchester y las balas sobre la cabeza',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Reescribe la escena en que el carpinchito cruza el río, contada por el propio carpinchito.',
        minPalabras: 40,
      ),
    ],
  ),
  Actividad(
    id: 'selva_maestro_3',
    libroId: 'selva',
    nivel: 'MAESTRO',
    orden: 3,
    titulo: 'Crear un final alternativo coherente.',
    habilidad: 'critica',
    capituloRequerido: 7,
    objetivo: 'Crear un final distinto que respete a los personajes y los hechos del cuento.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué hizo el hombre al final del cuento original?',
        opciones: [
          'Se fue a vivir a la isla',
          'Volvió a la ciudad',
          'Se hizo cazador de tigres',
          'Se fue del Yabebirí',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: 'Escribe un final alternativo para el cuento que sea coherente con lo que ocurrió antes.',
        minPalabras: 40,
      ),
    ],
  ),
  Actividad(
    id: 'selva_maestro_4',
    libroId: 'selva',
    nivel: 'MAESTRO',
    orden: 4,
    titulo: 'Elaborar cinco preguntas con respuestas justificadas.',
    habilidad: 'critica',
    capituloRequerido: 7,
    objetivo: 'Formular preguntas de distinto tipo y justificar sus respuestas con el texto.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Cuál de estas preguntas es crítica y no solo literal?',
        opciones: [
          '¿Qué llevaba el carpinchito?',
          '¿Cuántos tigres murieron?',
          '¿Dónde está el río Yabebirí?',
          '¿Fue justo que las rayas arriesgaran su vida por el hombre?',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Escribe cinco preguntas sobre el cuento. A cada una agrégale su respuesta y la parte del texto que la justifica.',
        minPalabras: 60,
      ),
    ],
  ),
  Actividad(
    id: 'isla_explorador_1',
    libroId: 'isla',
    nivel: 'EXPLORADOR',
    orden: 1,
    titulo: 'Leer un fragmento breve.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Leer el capítulo I y reconocer los datos principales del comienzo de la novela.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Cómo se llamaba la posada del padre del narrador?',
        opciones: [
          'Royal George',
          'El Vigía',
          'Almirante Benbow',
          'La Española',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Qué marca tenía el viejo marino en una mejilla?',
        opciones: [
          'Un tatuaje',
          'Una mancha negra',
          'Una venda',
          'Una gran cicatriz de sable',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Qué le pedía el Capitán al narrador a cambio de cuatro peniques al mes?',
        opciones: [
          'Que le trajera rom todas las noches',
          'Que cuidara su cofre',
          'Que vigilara el camino de Brístol',
          'Que le avisara si aparecía un marino con una sola pierna',
        ],
        correcta: 3,
      ),
    ],
  ),
  Actividad(
    id: 'isla_explorador_2',
    libroId: 'isla',
    nivel: 'EXPLORADOR',
    orden: 2,
    titulo: 'Identificar personajes, lugar y acontecimientos.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Reconocer quiénes aparecen en el capítulo I, dónde están y qué ocurre.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Quién se enfrentó al Capitán en la sala de la posada?',
        opciones: [
          'El Doctor Livesey',
          'El padre del narrador',
          'Black Dog',
          'El jardinero',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: '¿Cómo pasaba el día el Capitán?',
        opciones: [
          'Durmiendo en su cuarto',
          'Vagando por la caleta o sobre las rocas con un anteojo',
          'Trabajando en la posada',
          'Pescando en el puerto',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué ocurrió cuando el Capitán sacó su navaja?',
        opciones: [
          'Hirió al Doctor',
          'Todos huyeron de la posada',
          'El Doctor lo amenazó con hacerlo ahorcar y el Capitán guardó el arma',
          'El padre del narrador llamó a los guardias',
        ],
        correcta: 2,
      ),
    ],
  ),
  Actividad(
    id: 'isla_explorador_3',
    libroId: 'isla',
    nivel: 'EXPLORADOR',
    orden: 3,
    titulo: 'Completar una ficha por escena.',
    habilidad: 'literal',
    capituloRequerido: 3,
    objetivo:
        'Organizar en una ficha los datos de la escena del mendigo ciego.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Quién llega a la posada en esta escena?',
        opciones: [
          'Un marino con una sola pierna',
          'Un mendigo ciego con una venda verde sobre los ojos',
          'Black Dog con la mano herida',
          'El Doctor Livesey',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué hace el ciego para obligar al narrador a guiarlo?',
        opciones: [
          'Le ofrece dinero',
          'Le promete un secreto',
          'Lo amenaza con su bastón',
          'Le aprieta y le retuerce el brazo',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Cómo termina la escena?',
        opciones: [
          'El Capitán cae muerto por un ataque',
          'El ciego se queda a dormir en la posada',
          'El Capitán persigue al ciego por el camino',
          'El narrador se desmaya',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: 'Completa la ficha de la escena: escribe los personajes, el lugar y el hecho principal.',
        minPalabras: 20,
      ),
    ],
  ),
  Actividad(
    id: 'isla_explorador_4',
    libroId: 'isla',
    nivel: 'EXPLORADOR',
    orden: 4,
    titulo: 'Ordenar cinco acontecimientos.',
    habilidad: 'literal',
    capituloRequerido: 2,
    objetivo: 'Reconstruir el orden de los hechos del capítulo II.',
    pasos: [
      PasoOrdenar(
        instruccion: 'Ordena los acontecimientos del capítulo II.',
        elementos: [
          'Un desconocido al que le faltan dos dedos entra a la posada y pregunta por Bill.',
          'El desconocido y el narrador se esconden detrás de la puerta.',
          'El Capitán entra y reconoce a Black Dog.',
          'Pelean con sus cuchillas y Black Dog huye herido.',
          'El Capitán cae al suelo y el Doctor Livesey lo atiende.',
        ],
      ),
    ],
  ),
  Actividad(
    id: 'isla_explorador_5',
    libroId: 'isla',
    nivel: 'EXPLORADOR',
    orden: 5,
    titulo: 'Responder preguntas literales buscando evidencia.',
    habilidad: 'literal',
    capituloRequerido: 3,
    objetivo: 'Responder preguntas buscando la información exacta en el capítulo III.',
    pasos: [
      PasoOpcion(
        pregunta: 'Según el Capitán, ¿qué buscan sus enemigos?',
        opciones: [
          'Su viejo cofre de a bordo',
          'Su anteojo',
          'Su dinero del banco',
          'Al narrador',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: '¿De quién había sido primer piloto el Capitán?',
        opciones: [
          'De Black Dog',
          'Del Capitán Smollet',
          'Del Capitán Flint',
          'De John Silver',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Qué le ocurrió al padre del narrador en este capítulo?',
        opciones: [
          'Se fue de viaje',
          'Murió casi repentinamente esa noche',
          'Discutió con el Capitán',
          'Vendió la posada',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué le entregó el ciego al Capitán?',
        opciones: [
          'Una carta',
          'Una moneda de oro',
          'Algo que puso en su mano y que el Capitán apretó con fuerza',
          'Un mapa',
        ],
        correcta: 2,
      ),
    ],
  ),
  Actividad(
    id: 'isla_constructor_1',
    libroId: 'isla',
    nivel: 'CONSTRUCTOR',
    orden: 1,
    titulo: 'Elaborar una tabla de dos personajes.',
    habilidad: 'inferencial',
    capituloRequerido: 8,
    objetivo: 'Organizar en una tabla el aspecto, la actitud y las intenciones de dos personajes.',
    pasos: [
      PasoOpcion(
        pregunta:
            '¿Qué rasgo corresponde a John Silver según el capítulo VIII?',
        opciones: [
          'Le faltan dos dedos de una mano',
          'Le falta la pierna izquierda y se apoya en una muleta',
          'Es ciego y usa una venda verde',
          'Tiene una cicatriz en la mejilla',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué rasgo corresponde a Black Dog?',
        opciones: [
          'Tiene la cara enjuta y le faltan dos dedos de una mano',
          'Es alto, fuerte y risueño',
          'Es el dueño de la taberna',
          'Es el cocinero de la goleta',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: 'Completa una tabla de John Silver y Black Dog: aspecto, actitud y lo que parece querer cada uno.',
        minPalabras: 25,
      ),
    ],
  ),
  Actividad(
    id: 'isla_constructor_2',
    libroId: 'isla',
    nivel: 'CONSTRUCTOR',
    orden: 2,
    titulo: 'Describir sus acciones e intenciones.',
    habilidad: 'inferencial',
    capituloRequerido: 11,
    objetivo: 'Deducir las intenciones de los personajes a partir de lo que dicen y hacen.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué intención revela Silver en la conversación que el narrador oye desde el barril?',
        opciones: [
          'Volver a su taberna de Brístol',
          'Obedecer siempre al Capitán Smollet',
          'Esperar a que encuentren el tesoro y después matar a los leales',
          'Repartir el tesoro con toda la tripulación',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Por qué Silver le dice al joven marinero las mismas palabras que antes le dijo al narrador?',
        opciones: [
          'Porque es su sobrino',
          'Porque olvidó lo que había dicho',
          'Porque era la contraseña de los piratas',
          'Porque usa halagos para ganarse su confianza',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Describe una acción de Silver y otra de Israel Hands en este capítulo, y explica qué intención tiene cada uno.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'isla_constructor_3',
    libroId: 'isla',
    nivel: 'CONSTRUCTOR',
    orden: 3,
    titulo: 'Predecir qué ocurrirá en el siguiente capítulo.',
    habilidad: 'inferencial',
    capituloRequerido: 11,
    objetivo: 'Anticipar lo que viene usando las pistas del capítulo XI.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué pista del final del capítulo XI anuncia un cambio en la historia?',
        opciones: [
          'El vigía grita que ven tierra',
          'Silver se queda dormido',
          'El barril se rompe',
          'El Capitán llama a todos a cubierta',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: 'Predice qué hará el narrador en el capítulo siguiente después de lo que oyó. Explica en qué pistas te basas.',
        minPalabras: 20,
      ),
    ],
  ),
  Actividad(
    id: 'isla_constructor_4',
    libroId: 'isla',
    nivel: 'CONSTRUCTOR',
    orden: 4,
    titulo: 'Comparar la predicción con la historia y explicar qué pistas fueron útiles.',
    habilidad: 'inferencial',
    capituloRequerido: 12,
    objetivo: 'Contrastar lo que imaginaste con lo que realmente ocurre.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué hace el narrador en el capítulo XII?',
        opciones: [
          'Se esconde de nuevo en el barril',
          'Enfrenta a Silver delante de todos',
          'Huye a la isla',
          'Les cuenta al Doctor, al Capitán y al Caballero lo que oyó',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Qué decide el Capitán Smollet después de escucharlo?',
        opciones: [
          'Volver a Inglaterra de inmediato',
          'Encerrar a Silver',
          'Seguir adelante, vigilar y esperar el momento oportuno',
          'Repartir armas a toda la tripulación',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna: 'Compara tu predicción con lo que pasó en el capítulo XII. ¿Qué pistas te ayudaron y cuáles no?',
        minPalabras: 20,
      ),
    ],
  ),
  Actividad(
    id: 'isla_estratega_1',
    libroId: 'isla',
    nivel: 'ESTRATEGA',
    orden: 1,
    titulo: 'Analizar la confiabilidad de un personaje.',
    habilidad: 'critica',
    capituloRequerido: 20,
    objetivo: 'Evaluar si se puede confiar en Silver a partir de sus palabras y sus actos.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué propone Silver al Capitán cuando llega con la bandera de paz?',
        opciones: [
          'Rendirse sin condiciones',
          'Que le entreguen el mapa a cambio de llevarlos a una costa segura o dejarles provisiones',
          'Compartir la goleta en partes iguales',
          'Luchar al día siguiente',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Por qué el Capitán no cree en su oferta?',
        opciones: [
          'Porque ya saben lo que los amotinados se proponían hacer',
          'Porque Silver llegó tarde',
          'Porque Silver no trajo el tesoro',
          'Porque Gray le dijo que mentía',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: '¿Es Silver un personaje confiable? Argumenta tu respuesta con dos acciones suyas en la novela.',
        minPalabras: 25,
      ),
    ],
  ),
  Actividad(
    id: 'isla_estratega_2',
    libroId: 'isla',
    nivel: 'ESTRATEGA',
    orden: 2,
    titulo: 'Identificar señales de confianza o desconfianza.',
    habilidad: 'inferencial',
    capituloRequerido: 15,
    objetivo: 'Reconocer en Ben Gunn gestos que muestran confianza o recelo.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué señal de desconfianza muestra Ben Gunn?',
        opciones: [
          'Le pide queso al narrador',
          'Le cuenta cómo era su madre',
          'Le muestra el cementerio',
          'Pregunta si el narrador fue enviado por John Silver',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Qué señal de confianza muestra Ben Gunn hacia el narrador?',
        opciones: [
          'Le cuenta su historia y le habla de su bote escondido',
          'Le apunta con un mosquete',
          'Se esconde detrás de un árbol',
          'Le pide que se vaya',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: 'Explica si el narrador hizo bien en confiar en Ben Gunn. Usa señales del capítulo.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'isla_estratega_3',
    libroId: 'isla',
    nivel: 'ESTRATEGA',
    orden: 3,
    titulo: 'Explicar una decisión y sus consecuencias.',
    habilidad: 'inferencial',
    capituloRequerido: 22,
    objetivo: 'Analizar la decisión del narrador de salir de la estacada y lo que provoca.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué decide hacer el narrador en el capítulo XXII?',
        opciones: [
          'Rendirse a los piratas',
          'Escapar de la estacada sin permiso',
          'Curar a los heridos',
          'Buscar al Doctor',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué plan forma al encontrar el bote de Ben Gunn?',
        opciones: [
          'Volver a Inglaterra',
          'Esconder el tesoro',
          'Llegar hasta La Española y cortar el cable del ancla',
          'Rescatar al Capitán Smollet',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna: 'Explica la decisión del narrador. ¿Fue valiente o imprudente? ¿Qué consecuencias podía traer para él y para sus compañeros?',
        minPalabras: 25,
      ),
    ],
  ),
  Actividad(
    id: 'isla_estratega_4',
    libroId: 'isla',
    nivel: 'ESTRATEGA',
    orden: 4,
    titulo:
        'Diferenciar lo que el narrador confirma de lo que el lector infiere.',
    habilidad: 'critica',
    capituloRequerido: 16,
    objetivo: 'Separar lo que el narrador afirma de lo que el lector deduce.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Quién narra el capítulo XVI?',
        opciones: [
          'El Capitán Smollet',
          'El Doctor Livesey',
          'El Caballero Trelawney',
          'Abraham Gray',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué hecho confirma el narrador?',
        opciones: [
          'Gray se unió a ellos con una herida en la mejilla',
          'Gray había planeado escapar desde el inicio',
          'Los seis amotinados querían rendirse',
          'Silver vio todo desde la playa',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: '¿Cuál de estas ideas es una inferencia del lector y no algo que el narrador confirma?',
        opciones: [
          'El Capitán dio treinta segundos a Gray.',
          'Arrojaron armas y pólvora al agua.',
          'Gray dudó porque temía lo que harían los otros amotinados.',
          'El Doctor fue soldado y médico.',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna: 'Escribe un hecho que el narrador confirma en el capítulo y una inferencia tuya. Explica la diferencia.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'isla_maestro_1',
    libroId: 'isla',
    nivel: 'MAESTRO',
    orden: 1,
    titulo: 'Reconstruir un conflicto a partir de varios capítulos.',
    habilidad: 'critica',
    capituloRequerido: 33,
    objetivo: 'Integrar información de varios capítulos para explicar el conflicto central.',
    pasos: [
      PasoOrdenar(
        instruccion: 'Ordena estos momentos del conflicto entre los leales y los amotinados.',
        elementos: [
          'El narrador oye desde un barril el plan de Silver.',
          'Los leales abandonan la goleta y se refugian en la estacada.',
          'Silver ofrece un trato bajo bandera de paz.',
          'El narrador cae prisionero y Silver lo protege.',
          'Los piratas encuentran vacío el lugar del tesoro.',
        ],
      ),
      PasoEscrita(
        consigna: 'Reconstruye el conflicto entre Silver y el Capitán Smollet usando hechos de al menos tres capítulos.',
        minPalabras: 40,
      ),
    ],
  ),
  Actividad(
    id: 'isla_maestro_2',
    libroId: 'isla',
    nivel: 'MAESTRO',
    orden: 2,
    titulo: 'Analizar las estrategias de los personajes.',
    habilidad: 'critica',
    capituloRequerido: 33,
    objetivo:
        'Analizar cómo cada personaje usa lo que sabe para lograr sus fines.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Por qué Silver protege al narrador en el campo enemigo?',
        opciones: [
          'Porque le tiene cariño desde la taberna',
          'Porque el Doctor se lo pidió',
          'Porque quiere el mapa del narrador',
          'Para que el narrador sea su testigo y lo salve de la horca',
        ],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Qué estrategia usó Ben Gunn con el tesoro?',
        opciones: [
          'Lo trasladó a su gruta dos meses antes',
          'Lo enterró de nuevo junto al pino',
          'Lo cambió por provisiones',
          'Lo escondió en la goleta',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: 'Compara la estrategia de Silver con la de Ben Gunn. ¿Cuál fue más eficaz y por qué?',
        minPalabras: 30,
      ),
    ],
  ),
  Actividad(
    id: 'isla_maestro_3',
    libroId: 'isla',
    nivel: 'MAESTRO',
    orden: 3,
    titulo: 'Proponer una decisión alternativa.',
    habilidad: 'critica',
    capituloRequerido: 34,
    objetivo:
        'Proponer otra decisión para un momento clave y pensar en sus efectos.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué decisión tomó Ben Gunn al final de la novela?',
        opciones: [
          'Quedarse a vivir en la isla',
          'Ayudar a escapar a Silver en un lanchón',
          'Entregar a Silver a las autoridades',
          'Darle a Silver el mapa',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Qué se llevó Silver al escapar?',
        opciones: [
          'El loro y el mapa',
          'La goleta',
          'Un saco con unas quinientas guineas',
          'Nada',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna: 'Propón una decisión distinta para Ben Gunn o para el Doctor frente a Silver. Explica qué habría cambiado.',
        minPalabras: 30,
      ),
    ],
  ),
  Actividad(
    id: 'isla_maestro_4',
    libroId: 'isla',
    nivel: 'MAESTRO',
    orden: 4,
    titulo:
        'Argumentar cómo cambiaría la historia y comparar las consecuencias.',
    habilidad: 'critica',
    capituloRequerido: 33,
    objetivo: 'Argumentar sobre un cambio en la historia y comparar sus consecuencias.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué encuentran los piratas en el lugar marcado del tesoro?',
        opciones: [
          'Las cajas del tesoro completas',
          'Un mapa nuevo',
          'A Ben Gunn esperándolos',
          'Una excavación vieja, sin el tesoro, con tablas de cajas y el mango roto de una azada',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Imagina que Ben Gunn no hubiera movido el tesoro. Argumenta cómo cambiaría la historia y compara las consecuencias con el final real.',
        minPalabras: 40,
      ),
    ],
  ),
  Actividad(
    id: 'principe_explorador_1',
    libroId: 'principe',
    nivel: 'EXPLORADOR',
    orden: 1,
    titulo: 'Identificar personajes y acciones.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Reconocer a los personajes del cuento y lo que hace cada uno.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Quién llevó el rubí a la costurera?',
        opciones: ['El Príncipe', 'La Golondrina', 'El alcalde', 'Un ángel'],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta:
            '¿Qué hacía el Príncipe cuando la Golondrina llegó a sus pies?',
        opciones: ['Cantaba', 'Dormía', 'Hablaba con el Junco', 'Lloraba'],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Qué hizo la Golondrina con el oro fino del Príncipe?',
        opciones: [
          'Lo repartió hoja por hoja entre los pobres',
          'Se lo llevó a Egipto',
          'Lo vendió a un joyero',
          'Lo escondió en su nido',
        ],
        correcta: 0,
      ),
    ],
  ),
  Actividad(
    id: 'principe_explorador_2',
    libroId: 'principe',
    nivel: 'EXPLORADOR',
    orden: 2,
    titulo: 'Responder cinco preguntas literales.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Buscar en el cuento información que aparece escrita de forma explícita.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Dónde estaba la estatua del Príncipe Feliz?',
        opciones: [
          'En el palacio real',
          'Junto al río',
          'En la parte más alta de la ciudad, sobre una columnita',
          'En la puerta de la catedral',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Qué tenía la estatua en lugar de ojos?',
        opciones: ['Dos rubíes', 'Dos perlas', 'Dos esmeraldas', 'Dos zafiros'],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿Adónde querían viajar las golondrinas?',
        opciones: [
          'A Egipto',
          'A la India',
          'Al norte de Europa',
          'A las montañas',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: '¿Qué pedía el hijo enfermo de la costurera?',
        opciones: ['Agua', 'Pan', 'Juguetes', 'Naranjas'],
        correcta: 3,
      ),
      PasoOpcion(
        pregunta: '¿De qué material era el corazón del Príncipe?',
        opciones: ['De oro', 'De cristal', 'De plomo', 'De mármol'],
        correcta: 2,
      ),
    ],
  ),
  Actividad(
    id: 'principe_explorador_3',
    libroId: 'principe',
    nivel: 'EXPLORADOR',
    orden: 3,
    titulo: 'Explicar el significado de tres palabras según el contexto.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Deducir el significado de palabras nuevas por el contexto.',
    pasos: [
      PasoOpcion(
        pregunta: 'El Príncipe ve a un joven en una buhardilla, y la Golondrina entra por un agujero del techo. ¿Qué es una buhardilla?',
        opciones: [
          'Un cuarto pequeño bajo el techo de una casa',
          'Una tienda de libros',
          'Un teatro',
          'Un barco',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: 'El alcalde dice que el Príncipe está andrajoso porque ya no tiene ojos ni oro. ¿Qué significa andrajoso?',
        opciones: [
          'Muy alto',
          'Brillante y nuevo',
          'Que se ve roto, viejo y en mal estado',
          'Enojado',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: 'Largos carámbanos, semejantes a puñales de cristal, colgaban de los tejados. ¿Qué son los carámbanos?',
        opciones: [
          'Adornos de fiesta',
          'Pájaros del invierno',
          'Gotas de lluvia',
          'Trozos de hielo largos y puntiagudos',
        ],
        correcta: 3,
      ),
    ],
  ),
  Actividad(
    id: 'principe_explorador_4',
    libroId: 'principe',
    nivel: 'EXPLORADOR',
    orden: 4,
    titulo: 'Ordenar los acontecimientos principales.',
    habilidad: 'literal',
    capituloRequerido: 1,
    objetivo: 'Reconstruir la secuencia de los hechos principales del cuento.',
    pasos: [
      PasoOrdenar(
        instruccion: 'Ordena los acontecimientos principales del cuento.',
        elementos: [
          'La Golondrina se queda en la ciudad y se posa a los pies del Príncipe.',
          'La Golondrina lleva el rubí a la costurera.',
          'La Golondrina lleva un zafiro al joven de la buhardilla.',
          'La Golondrina entrega el otro zafiro a la niña de las cerillas.',
          'La Golondrina reparte el oro del Príncipe entre los pobres.',
          'La Golondrina muere y el corazón de plomo del Príncipe se parte.',
        ],
      ),
    ],
  ),
  Actividad(
    id: 'principe_constructor_1',
    libroId: 'principe',
    nivel: 'CONSTRUCTOR',
    orden: 1,
    titulo: 'Explicar dos decisiones de los personajes.',
    habilidad: 'inferencial',
    capituloRequerido: 1,
    objetivo: 'Explicar por qué los personajes toman sus decisiones.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Por qué la Golondrina decidió quedarse para siempre con el Príncipe?',
        opciones: [
          'Porque no le gustaba Egipto',
          'Porque el Príncipe se había quedado ciego',
          'Porque sus amigas no la esperaban',
          'Porque hacía buen tiempo',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Para qué pidió el Príncipe que le arrancaran los zafiros?',
        opciones: [
          'Para ayudar al joven de la buhardilla y a la niña de las cerillas',
          'Para pagar a la Golondrina',
          'Para no ver la ciudad',
          'Para adornar el palacio',
        ],
        correcta: 0,
      ),
      PasoEscrita(
        consigna: 'Elige una de estas decisiones y explica qué dice de la forma de ser del personaje.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'principe_constructor_2',
    libroId: 'principe',
    nivel: 'CONSTRUCTOR',
    orden: 2,
    titulo: 'Identificar sus motivaciones.',
    habilidad: 'inferencial',
    capituloRequerido: 1,
    objetivo: 'Descubrir qué mueve a los personajes a actuar.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué motiva al Príncipe a regalar sus joyas y su oro?',
        opciones: [
          'Quiere ser más famoso',
          'Quiere quedar más liviano',
          'Ve desde lo alto la miseria de su ciudad',
          'Se lo pidió el alcalde',
        ],
        correcta: 2,
      ),
      PasoOpcion(
        pregunta: '¿Por qué las autoridades derribaron la estatua?',
        opciones: [
          'Porque era muy antigua',
          'Porque estorbaba el paso',
          'Porque estaba rota por el frío',
          'Porque ya no era bella ni dorada',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Compara lo que motiva al Príncipe con lo que motiva al alcalde y a los concejales.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'principe_constructor_3',
    libroId: 'principe',
    nivel: 'CONSTRUCTOR',
    orden: 3,
    titulo: 'Formular la idea principal.',
    habilidad: 'inferencial',
    capituloRequerido: 1,
    objetivo: 'Expresar en una oración el mensaje central del cuento.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Cuál de estas oraciones expresa mejor la idea principal del cuento?',
        opciones: [
          'Las golondrinas deben viajar antes del invierno.',
          'La verdadera riqueza está en ayudar a los demás, aunque cueste lo propio.',
          'Las estatuas de oro son las más valiosas.',
          'Los alcaldes saben lo que es mejor para la ciudad.',
        ],
        correcta: 1,
      ),
      PasoEscrita(
        consigna:
            'Formula con tus propias palabras la idea principal del cuento.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'principe_constructor_4',
    libroId: 'principe',
    nivel: 'CONSTRUCTOR',
    orden: 4,
    titulo: 'Seleccionar dos acontecimientos que respalden esa interpretación.',
    habilidad: 'inferencial',
    capituloRequerido: 1,
    objetivo: 'Elegir hechos del cuento que sostengan la idea principal.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué acontecimiento respalda la idea de que ayudar es lo más valioso?',
        opciones: [
          'El Príncipe da su oro a los pobres hasta quedarse sin brillo',
          'El profesor escribe una carta al periódico',
          'Los concejales discuten por la nueva estatua',
          'La Golondrina visita los monumentos',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: '¿Qué otro acontecimiento respalda esa misma idea?',
        opciones: [
          'El alcalde quiere su propia estatua',
          'La Golondrina se baña en el río',
          'Los gorriones admiran a la Golondrina',
          'Dios elige el corazón de plomo y el pájaro muerto como lo más precioso',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Explica cómo estos dos acontecimientos respaldan la idea principal.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'principe_estratega_1',
    libroId: 'principe',
    nivel: 'ESTRATEGA',
    orden: 1,
    titulo: 'Elegir una decisión importante.',
    habilidad: 'critica',
    capituloRequerido: 1,
    objetivo: 'Identificar la decisión que cambia el rumbo del cuento.',
    pasos: [
      PasoOpcion(
        pregunta:
            '¿Qué decisión cambió por completo el destino de la Golondrina?',
        opciones: [
          'Enamorarse del Junco',
          'Visitar el campanario',
          'Quedarse con el Príncipe en invierno en lugar de ir a Egipto',
          'Bañarse en el río',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna:
            'Explica por qué esa decisión es la más importante del cuento.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'principe_estratega_2',
    libroId: 'principe',
    nivel: 'ESTRATEGA',
    orden: 2,
    titulo: 'Formular una opinión fundamentada.',
    habilidad: 'critica',
    capituloRequerido: 1,
    objetivo: 'Expresar una opinión propia y sostenerla con razones del texto.',
    pasos: [
      PasoOpcion(
        pregunta:
            '¿Qué propuso el alcalde hacer con el metal de la estatua fundida?',
        opciones: [
          'Repartirlo entre los pobres',
          'Hacer otra estatua, la suya',
          'Construir una escuela',
          'Venderlo',
        ],
        correcta: 1,
      ),
      PasoEscrita(
        consigna: '¿Fue justo que la ciudad derribara la estatua del Príncipe? Da tu opinión con dos razones.',
        minPalabras: 25,
      ),
    ],
  ),
  Actividad(
    id: 'principe_estratega_3',
    libroId: 'principe',
    nivel: 'ESTRATEGA',
    orden: 3,
    titulo: 'Presentar dos evidencias.',
    habilidad: 'critica',
    capituloRequerido: 1,
    objetivo: 'Sostener una afirmación con pruebas tomadas del cuento.',
    pasos: [
      PasoOpcion(
        pregunta: 'Afirmación: las autoridades solo valoraban la apariencia. ¿Qué evidencia la apoya?',
        opciones: [
          'El profesor de estética dijo que, al no ser ya bello, de nada servía',
          'La Golondrina amaba al Príncipe',
          'El joven terminó su obra',
          'Los niños jugaban en la calle',
        ],
        correcta: 0,
      ),
      PasoOpcion(
        pregunta: '¿Qué otra evidencia apoya la misma afirmación?',
        opciones: [
          'La niña corrió a su casa',
          'El Príncipe lloraba de noche',
          'Los marineros sacaban cajas del barco',
          'Los concejales dijeron que el Príncipe parecía un pordiosero',
        ],
        correcta: 3,
      ),
      PasoEscrita(
        consigna: 'Escribe con tus palabras por qué estas dos evidencias apoyan la afirmación.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'principe_estratega_4',
    libroId: 'principe',
    nivel: 'ESTRATEGA',
    orden: 4,
    titulo: 'Distinguir hechos de interpretaciones y explicar qué aspectos pueden debatirse.',
    habilidad: 'critica',
    capituloRequerido: 1,
    objetivo:
        'Separar lo que ocurre en el cuento de lo que interpretamos sobre él.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Cuál de estas oraciones es un hecho del cuento?',
        opciones: [
          'El autor critica a los gobernantes.',
          'La Golondrina murió a los pies del Príncipe.',
          'El Príncipe fue el mejor gobernante.',
          'El cuento es triste.',
        ],
        correcta: 1,
      ),
      PasoOpcion(
        pregunta: '¿Cuál de estas oraciones es una interpretación?',
        opciones: [
          'La estatua fue fundida en un horno.',
          'El corazón de plomo no se fundió.',
          'El autor critica a las autoridades que solo piensan en sí mismas.',
          'La Golondrina llevó el rubí a la costurera.',
        ],
        correcta: 2,
      ),
      PasoEscrita(
        consigna: 'Explica un aspecto del cuento que se puede debatir y por qué hay más de una opinión posible.',
        minPalabras: 15,
      ),
    ],
  ),
  Actividad(
    id: 'principe_maestro_1',
    libroId: 'principe',
    nivel: 'MAESTRO',
    orden: 1,
    titulo: 'Analizar el relato desde dos perspectivas.',
    habilidad: 'critica',
    capituloRequerido: 1,
    objetivo: 'Mirar la historia desde el punto de vista de dos personajes distintos.',
    pasos: [
      PasoEscrita(
        consigna: 'Cuenta cómo ve la Golondrina lo que ocurre en la ciudad.',
        minPalabras: 25,
      ),
      PasoEscrita(
        consigna: 'Cuenta cómo ve el alcalde lo que ocurre con la estatua. Compara ambas perspectivas.',
        minPalabras: 25,
      ),
    ],
  ),
  Actividad(
    id: 'principe_maestro_2',
    libroId: 'principe',
    nivel: 'MAESTRO',
    orden: 2,
    titulo: 'Formular argumentos para cada interpretación.',
    habilidad: 'critica',
    capituloRequerido: 1,
    objetivo:
        'Sostener con argumentos dos interpretaciones distintas del cuento.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué parte del cuento apoya la interpretación de que es una crítica social?',
        opciones: [
          'La Golondrina se enamora del Junco',
          'Los ricos festejan en sus palacios mientras los mendigos esperan a sus puertas',
          'Las golondrinas viajan a Egipto',
          'El Príncipe tiene ojos de zafiro',
        ],
        correcta: 1,
      ),
      PasoEscrita(
        consigna: 'Escribe un argumento para la interpretación de que el cuento trata del sacrificio por amor y otro para la de que es una crítica social.',
        minPalabras: 35,
      ),
    ],
  ),
  Actividad(
    id: 'principe_maestro_3',
    libroId: 'principe',
    nivel: 'MAESTRO',
    orden: 3,
    titulo: 'Evaluar cuál está mejor sustentada.',
    habilidad: 'critica',
    capituloRequerido: 1,
    objetivo:
        'Comparar interpretaciones y decidir cuál tiene más apoyo en el texto.',
    pasos: [
      PasoOpcion(
        pregunta: '¿Qué hace que una interpretación esté mejor sustentada?',
        opciones: [
          'Que sea la más corta',
          'Que tenga más evidencias del texto que la respalden',
          'Que la diga un adulto',
          'Que tenga un final feliz',
        ],
        correcta: 1,
      ),
      PasoEscrita(
        consigna: 'Evalúa cuál de las dos interpretaciones del cuento está mejor sustentada y justifica tu elección con evidencias.',
        minPalabras: 30,
      ),
    ],
  ),
  Actividad(
    id: 'principe_maestro_4',
    libroId: 'principe',
    nivel: 'MAESTRO',
    orden: 4,
    titulo: 'Crear un final alternativo y explicar cómo cambiaría el mensaje.',
    habilidad: 'critica',
    capituloRequerido: 1,
    objetivo:
        'Crear otro final y analizar cómo cambia el sentido de la historia.',
    pasos: [
      PasoEscrita(
        consigna: 'Escribe un final alternativo para el cuento.',
        minPalabras: 40,
      ),
      PasoEscrita(
        consigna:
            'Explica cómo cambiaría el mensaje del cuento con tu nuevo final.',
        minPalabras: 20,
      ),
    ],
  ),
];

final Map<String, Actividad> _porId = {
  for (final actividad in actividades) actividad.id: actividad,
};

Actividad? actividadPorId(String? id) => _porId[id];

List<Actividad> actividadesDeNivel(String? nivel) =>
    actividades.where((actividad) => actividad.nivel == nivel).toList();

List<Actividad> actividadesDeLibroNivel(String libroId, String? nivel) =>
    actividades
        .where(
          (actividad) =>
              actividad.libroId == libroId && actividad.nivel == nivel,
        )
        .toList();
