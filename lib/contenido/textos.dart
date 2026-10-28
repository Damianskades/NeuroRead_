import 'dart:math';

class PreguntaOpciones {
  const PreguntaOpciones({
    required this.pregunta,
    required this.opciones,
    required this.respuesta,
    this.tipo,
  });

  final String pregunta;
  final List<String> opciones;
  final int respuesta;
  final String? tipo;
}

class TextoEvaluacion {
  const TextoEvaluacion({
    required this.id,
    required this.titulo,
    required this.texto,
    required this.comprension,
    required this.interpretacion,
    required this.retencion,
  });

  final int id;
  final String titulo;
  final String texto;
  final List<PreguntaOpciones> comprension;
  final List<String> interpretacion;
  final List<PreguntaOpciones> retencion;
}

const biblioteca = <TextoEvaluacion>[
  TextoEvaluacion(
    id: 1,
    titulo: 'El Secreto de la Amazonía',
    texto: 'En lo más profundo de la Amazonía, donde los árboles alcanzan alturas de cincuenta metros y la luz del sol apenas penetra el denso follaje, existe un ecosistema tan complejo que los científicos calculan que aún desconocemos el setenta por ciento de sus especies.\n\nMaría, una joven bióloga de veintidós años, llevaba tres meses viviendo entre los pobladores indígenas de la región, aprendiendo sus secretos ancestrales sobre plantas medicinales.\n\nUna mañana, mientras catalogaba una orquídea nunca vista, escuchó un sonido extraño proveniente del río. Al acercarse, descubrió algo que cambiaría para siempre el curso de su investigación: un delfín rosado de río estaba enseñando a sus crías a pescar con una técnica que nadie había documentado jamás.\n\nMaría comprendió en ese instante que la naturaleza guarda secretos que solo se revelan a quienes tienen la paciencia y la humildad de escucharla.',
    comprension: [
      PreguntaOpciones(
        pregunta: '¿Cuántos años tenía María?',
        opciones: ['Dieciocho', 'Veintidós', 'Treinta', 'Veinticinco'],
        respuesta: 1,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Cuánto tiempo llevaba María con los indígenas?',
        opciones: ['Seis meses', 'Un año', 'Tres meses', 'Dos semanas'],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Por qué el descubrimiento del delfín fue extraordinario?',
        opciones: [
          'Era muy grande',
          'Nadie había documentado esa técnica',
          'Era especie en extinción',
          'Estaba lejos del río',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Qué implica que el 70% de especies sean desconocidas?',
        opciones: [
          'Los científicos trabajan mal',
          'El ecosistema está en peligro',
          'La Amazonía tiene biodiversidad inexplorada',
          'Hay pocas especies',
        ],
        respuesta: 2,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Cuál es el mensaje central del texto?',
        opciones: [
          'Los delfines son inteligentes',
          'La biología marina es la más importante',
          'La naturaleza revela secretos a quien sabe escuchar',
          'María debería regresar',
        ],
        respuesta: 2,
        tipo: 'Crítica',
      ),
    ],
    interpretacion: [
      '¿Qué emoción principal transmite este texto? ¿Por qué te generó esa emoción?',
      '¿Cuál es la intención del autor al escribir este relato?',
      '¿Cómo se relaciona el mensaje del texto con la realidad de hoy?',
    ],
    retencion: [
      PreguntaOpciones(
        pregunta: '¿Qué catalogaba María cuando escuchó el sonido?',
        opciones: [
          'Una planta medicinal',
          'Una orquídea nunca vista',
          'Un pájaro exótico',
          'Un insecto',
        ],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿Qué animal descubrió María cerca del río?',
        opciones: [
          'Una anaconda',
          'Un jaguar',
          'Un delfín rosado',
          'Una tortuga gigante',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: '¿Qué hacía ese animal con sus crías?',
        opciones: [
          'Jugar en el agua',
          'Migrar río arriba',
          'Enseñarles a pescar',
          'Protegerlas',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta:
            'Según el texto, ¿qué altura alcanzan los árboles de la Amazonía?',
        opciones: [
          'Treinta metros',
          'Cuarenta metros',
          'Cincuenta metros',
          'Sesenta metros',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: 'Según el cierre del texto, ¿qué dos cualidades exige la naturaleza para revelar sus secretos?',
        opciones: [
          'Valentía y esfuerzo',
          'Paciencia y humildad',
          'Ciencia y método',
          'Curiosidad y constancia',
        ],
        respuesta: 1,
      ),
    ],
  ),
  TextoEvaluacion(
    id: 2,
    titulo: 'El Último Faro',
    texto: 'Durante más de cien años, el Faro de Punta Negra había guiado a los barcos a través de las peligrosas rocas que escondía la bahía. Su luz giratoria era tan conocida que los marineros de toda la costa lo llamaban cariñosamente el viejo guardián.\n\nErnesto tenía setenta y tres años y era el último farero de la región. Desde los dieciséis, cuando su padre le enseñó a encender la lámpara de aceite, había dedicado su vida entera a esa torre de piedra blanca.\n\nEl día que llegó la carta del gobierno anunciando la automatización del faro, Ernesto la leyó tres veces en silencio. Luego salió a la plataforma exterior y observó el mar durante horas. No lloró. Solo susurró algo que el viento se llevó consigo.\n\nEsa noche encendió la lámpara con más cuidado que nunca, como si supiera que algunos gestos merecen hacerse bien aunque nadie los vea.',
    comprension: [
      PreguntaOpciones(
        pregunta: '¿Cuántos años tenía Ernesto?',
        opciones: ['Sesenta', 'Setenta y tres', 'Ochenta', 'Cincuenta y cinco'],
        respuesta: 1,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Desde qué edad trabajó Ernesto en el faro?',
        opciones: [
          'Desde los doce',
          'Desde los veinte',
          'Desde los dieciséis',
          'Desde los treinta',
        ],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Qué significaba la carta del gobierno para Ernesto?',
        opciones: [
          'Un aumento de sueldo',
          'El fin de su labor de vida',
          'Un traslado a otro faro',
          'Una condecoración',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta:
            '¿Por qué el autor dice que el faro era llamado el viejo guardián?',
        opciones: [
          'Porque era muy antiguo',
          'Porque protegía a los barcos con su luz',
          'Porque Ernesto era muy viejo',
          'Porque estaba hecho de piedra',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Qué nos enseña la actitud de Ernesto al final?',
        opciones: [
          'Que hay que resignarse',
          'Que el trabajo bien hecho tiene valor propio',
          'Que el gobierno toma malas decisiones',
          'Que los fareros son testarudos',
        ],
        respuesta: 1,
        tipo: 'Crítica',
      ),
    ],
    interpretacion: [
      '¿Qué sentiste al leer sobre Ernesto y el faro? Describe tu reacción emocional.',
      '¿Por qué crees que el autor termina el relato con Ernesto encendiendo la lámpara con más cuidado que nunca?',
      '¿Conoces situaciones en la vida real similares a la de Ernesto? ¿Cuál sería el equivalente hoy?',
    ],
    retencion: [
      PreguntaOpciones(
        pregunta: '¿Cómo llamaban los marineros al faro?',
        opciones: [
          'El guardián eterno',
          'El viejo guardián',
          'La luz del sur',
          'El centinela',
        ],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿Cuántos años tenía el faro de historia?',
        opciones: [
          'Cincuenta años',
          'Setenta años',
          'Más de cien años',
          'Exactamente ochenta años',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: '¿Qué hizo Ernesto después de leer la carta?',
        opciones: [
          'Lloró en silencio',
          'Llamó al gobierno',
          'Salió y observó el mar durante horas',
          'Apagó la lámpara',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: '¿Cuántas veces leyó Ernesto la carta del gobierno?',
        opciones: ['Una vez', 'Dos veces', 'Tres veces', 'Cuatro veces'],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: '¿Quién le enseñó a Ernesto a encender la lámpara de aceite?',
        opciones: [
          'El farero anterior',
          'Su padre',
          'Un marinero de la costa',
          'Aprendió solo',
        ],
        respuesta: 1,
      ),
    ],
  ),
  TextoEvaluacion(
    id: 3,
    titulo: 'La Ciudad que Aprende',
    texto: 'En el año 2031, la ciudad de Valeria se convirtió en el primer municipio del mundo en implementar inteligencia artificial en todos sus semáforos, tuberías y sistemas de emergencia. Los resultados fueron asombrosos: los accidentes de tráfico se redujeron un sesenta por ciento en solo doce meses.\n\nSin embargo, nadie había pensado en lo que ocurriría cuando el sistema comenzara a aprender de los hábitos de sus habitantes. La IA empezó a predecir cuándo iba a llover basándose en el comportamiento de los perros de la ciudad. Detectaba crisis económicas familiares antes que los propios bancos.\n\nLa alcaldesa Rebeca convocó una asamblea ciudadana. La pregunta no era si el sistema funcionaba, claramente sí, sino si querían vivir en una ciudad que los conocía mejor que ellos mismos.\n\nLa votación fue la más reñida de la historia de Valeria: cuatro votos de diferencia.',
    comprension: [
      PreguntaOpciones(
        pregunta: '¿En qué año implementó Valeria la IA en su infraestructura?',
        opciones: ['2025', '2028', '2031', '2035'],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿En cuánto se redujeron los accidentes de tránsito?',
        opciones: [
          'Un treinta por ciento',
          'Un cincuenta por ciento',
          'Un sesenta por ciento',
          'Un ochenta por ciento',
        ],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Qué representa el hecho de que la IA predijera lluvia por el comportamiento de los perros?',
        opciones: [
          'Que la IA era defectuosa',
          'Que el sistema aprende de fuentes inesperadas',
          'Que los perros son muy inteligentes',
          'Que la ciudad tenía muchos perros',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Por qué la asamblea ciudadana era importante?',
        opciones: [
          'Para celebrar los logros',
          'Para decidir si aceptar una tecnología que los conocía profundamente',
          'Para elegir nueva alcaldesa',
          'Para revisar el presupuesto',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Cuál es el dilema ético central del texto?',
        opciones: [
          'Si la IA funciona bien o mal',
          'Si los políticos son confiables',
          'Si vale la pena perder privacidad a cambio de eficiencia',
          'Si Valeria debe crecer como ciudad',
        ],
        respuesta: 2,
        tipo: 'Crítica',
      ),
    ],
    interpretacion: [
      '¿Cómo te hizo sentir la idea de una ciudad que te conoce mejor que tú mismo?',
      '¿Qué crees que quiso transmitir el autor con el final de cuatro votos de diferencia?',
      '¿Viviríamos mejor o peor con una IA así en nuestras ciudades? Defiende tu posición.',
    ],
    retencion: [
      PreguntaOpciones(
        pregunta: '¿Cómo se llamaba la alcaldesa de Valeria?',
        opciones: ['María', 'Rebeca', 'Sofía', 'Carmen'],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿Qué detectaba la IA antes que los propios bancos?',
        opciones: [
          'Robos en casas',
          'Terremotos',
          'Crisis económicas familiares',
          'Accidentes de tránsito',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: '¿Por cuántos votos fue la decisión en la asamblea?',
        opciones: ['Un voto', 'Cuatro votos', 'Diez votos', 'Cien votos'],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿En qué se basaba la IA para predecir cuándo iba a llover?',
        opciones: [
          'En sensores de humedad',
          'En el comportamiento de los perros',
          'En datos de satélite',
          'En el tráfico de la ciudad',
        ],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿En qué tres sistemas implementó Valeria la inteligencia artificial?',
        opciones: [
          'Semáforos, tuberías y sistemas de emergencia',
          'Semáforos, hospitales y escuelas',
          'Bancos, transporte y parques',
          'Cámaras, drones y semáforos',
        ],
        respuesta: 0,
      ),
    ],
  ),
  TextoEvaluacion(
    id: 4,
    titulo: 'Las Manos de mi Abuela',
    texto: 'Las manos de mi abuela Josefa contaban su historia mejor que cualquier relato. Eran manos grandes, de nudillos pronunciados, con una red de venas azules visibles bajo una piel que el sol y el trabajo habían curtido hasta volverla del color del cuero.\n\nCon esas manos había amasado miles de panes antes del amanecer, había cosechado café en las laderas empinadas de la sierra, había bordado manteles de fiesta y remendado pantalones de trabajo. Habían mecido cunas y levantado paredes.\n\nYo tenía doce años la última vez que tomé sus manos entre las mías. Me sorprendió lo suaves que eran por dentro, en el hueco de la palma, como si ahí hubieran guardado toda la ternura que el mundo exterior no llegó a desgastar.\n\nHoy, cuando miro mis propias manos, a veces creo reconocer algo suyo en la forma en que sostienen las cosas.',
    comprension: [
      PreguntaOpciones(
        pregunta: '¿Cómo se llamaba la abuela del narrador?',
        opciones: ['Carmen', 'Rosa', 'Josefa', 'Elena'],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Qué edad tenía el narrador la última vez que tomó las manos de su abuela?',
        opciones: ['Ocho años', 'Diez años', 'Doce años', 'Quince años'],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Qué representa el hecho de que las palmas fueran suaves?',
        opciones: [
          'Que no trabajaba mucho',
          'Que guardaba ternura intacta pese al trabajo duro',
          'Que usaba cremas',
          'Que era muy joven',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Por qué el autor describe las manos en lugar de la cara de su abuela?',
        opciones: [
          'Porque no recuerda su cara',
          'Porque las manos revelan mejor la historia de una persona',
          'Porque su abuela tenía cara común',
          'Por capricho literario',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Cuál es el tema principal del texto?',
        opciones: [
          'La agricultura en la sierra',
          'El paso del tiempo en los objetos',
          'La herencia y la memoria a través de las generaciones',
          'La importancia del trabajo físico',
        ],
        respuesta: 2,
        tipo: 'Crítica',
      ),
    ],
    interpretacion: [
      '¿Qué emoción te generó este texto? ¿Conectaste con algún recuerdo propio?',
      '¿Por qué crees que el autor termina mirando sus propias manos? ¿Qué mensaje transmite ese gesto?',
      '¿Qué objetos o partes del cuerpo contarían la historia de alguien importante en tu vida?',
    ],
    retencion: [
      PreguntaOpciones(
        pregunta: '¿De qué color describe el autor la piel de las manos de la abuela?',
        opciones: [
          'Del color del mármol',
          'Del color del cuero',
          'Del color de la madera',
          'Del color del barro',
        ],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿Cuál de estas tareas NO se menciona que hicieron las manos de la abuela?',
        opciones: [
          'Amasar panes',
          'Cosechar café',
          'Tejer ropa',
          'Mecer cunas',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta:
            '¿Qué sorprendió al narrador al tomar las manos de su abuela?',
        opciones: [
          'Lo frías que estaban',
          'Lo grandes que eran',
          'Lo suaves que eran por dentro',
          'Lo temblorosas que estaban',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: '¿Qué bordaban las manos de la abuela según el texto?',
        opciones: [
          'Vestidos de novia',
          'Manteles de fiesta',
          'Cortinas de sala',
          'Pañuelos de seda',
        ],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿Dónde cosechaba café la abuela?',
        opciones: [
          'En el valle del río',
          'En su propio patio',
          'En la costa',
          'En las laderas empinadas de la sierra',
        ],
        respuesta: 3,
      ),
    ],
  ),
  TextoEvaluacion(
    id: 5,
    titulo: 'El Niño que Contaba Estrellas',
    texto: 'Nadie en el pueblo sabía por qué Simón no hablaba. Los médicos lo llamaban mutismo selectivo; su madre lo llamaba su forma de ser. A los ocho años, Simón comunicaba todo lo que necesitaba con dibujos que llenaban cuadernos enteros.\n\nPero había algo que sí hacía en voz alta: contar estrellas. Cada noche, después de cenar, salía al patio con una linterna apagada y comenzaba. Uno, dos, tres... A veces llegaba hasta trescientos antes de quedarse dormido en el suelo.\n\nUn astrónomo que visitaba la región escuchó hablar de él y fue a conocerlo. Pasaron una noche entera mirando el cielo. El científico le señaló constelaciones con nombres complicados. Simón le dibujó lo que veía: las mismas estrellas, pero conectadas de formas que ningún atlas había imaginado.\n\nAl despedirse, el astrónomo le dijo que había aprendido más esa noche que en años de universidad. Simón sonrió y siguió contando.',
    comprension: [
      PreguntaOpciones(
        pregunta: '¿Cuántos años tenía Simón?',
        opciones: ['Cinco años', 'Siete años', 'Ocho años', 'Diez años'],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Cómo comunicaba Simón lo que necesitaba?',
        opciones: [
          'Con señas',
          'Con dibujos',
          'Con notas escritas',
          'Con gestos',
        ],
        respuesta: 1,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Qué significaba que Simón conectara las estrellas de formas distintas al atlas?',
        opciones: [
          'Que estaba equivocado',
          'Que tenía una visión creativa y original del mundo',
          'Que no conocía la astronomía',
          'Que sus dibujos eran incorrectos',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Por qué el astrónomo dijo haber aprendido más esa noche que en años de universidad?',
        opciones: [
          'Porque Simón era más inteligente',
          'Porque la perspectiva inocente de Simón le mostró algo nuevo',
          'Porque la universidad era mala',
          'Porque había muchas estrellas ese día',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Cuál es el mensaje principal del texto?',
        opciones: [
          'Los niños con mutismo necesitan ayuda',
          'La astronomía es una ciencia importante',
          'Cada mente percibe el mundo de forma única y valiosa',
          'Hay que hablar más con los niños',
        ],
        respuesta: 2,
        tipo: 'Crítica',
      ),
    ],
    interpretacion: [
      '¿Cómo te hizo sentir la historia de Simón? ¿Qué parte te impactó más?',
      '¿Qué quiso decir el autor con que Simón conectara las estrellas de formas que ningún atlas había imaginado?',
      '¿Conoces personas como Simón cuya forma diferente de ver el mundo enseña algo valioso?',
    ],
    retencion: [
      PreguntaOpciones(
        pregunta: '¿Cómo llamaba la madre de Simón a su condición?',
        opciones: [
          'Mutismo selectivo',
          'Su forma de ser',
          'Una enfermedad rara',
          'Un don especial',
        ],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿Hasta cuánto contaba Simón las estrellas a veces?',
        opciones: [
          'Hasta cien',
          'Hasta doscientos',
          'Hasta trescientos',
          'Hasta mil',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: '¿Qué trajo el astrónomo para conocer a Simón?',
        opciones: [
          'Un telescopio',
          'Libros de astronomía',
          'El texto no dice que trajo nada especial',
          'Una cámara fotográfica',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta:
            '¿Qué llevaba Simón al patio cada noche para contar estrellas?',
        opciones: [
          'Un telescopio pequeño',
          'Una linterna apagada',
          'Sus cuadernos de dibujo',
          'Una manta y almohada',
        ],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿En qué momento del día salía Simón a contar estrellas?',
        opciones: [
          'Antes de cenar',
          'A medianoche',
          'Después de cenar',
          'Al amanecer',
        ],
        respuesta: 2,
      ),
    ],
  ),
  TextoEvaluacion(
    id: 6,
    titulo: 'La Última Cosecha',
    texto: 'El cambio climático llegó al valle de Huancán no como un titular de periódico sino como algo mucho más concreto: las lluvias dejaron de llegar en marzo. Durante cuatro años consecutivos, los agricultores miraron el cielo en silencio cada tarde, esperando nubes que se formaban pero no descargaban.\n\nDon Aurelio, con ochenta y un años y medio siglo de trabajo en esa tierra, fue el primero en decirlo en voz alta: esta tierra ya no es la misma. Lo dijo sin dramatismo, con la misma voz con que anunciaba el precio del maíz en el mercado.\n\nSu nieta Valentina, ingeniera agrónoma recién graduada, llegó ese verano con semillas resistentes a la sequía y datos de satélite en su laptop. Don Aurelio la escuchó durante horas sin interrumpirla.\n\nLuego cogió un puñado de tierra, lo olió, y le dijo que la primera parcela debía estar quince metros más al norte de donde ella había calculado.\n\nLas dos cosechas siguientes fueron las mejores del valle.',
    comprension: [
      PreguntaOpciones(
        pregunta: '¿Cuántos años tenía Don Aurelio?',
        opciones: ['Setenta', 'Setenta y cinco', 'Ochenta y uno', 'Noventa'],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Durante cuántos años consecutivos fallaron las lluvias?',
        opciones: ['Dos años', 'Tres años', 'Cuatro años', 'Cinco años'],
        respuesta: 2,
        tipo: 'Literal',
      ),
      PreguntaOpciones(
        pregunta: '¿Qué simboliza el gesto de Don Aurelio al oler la tierra?',
        opciones: [
          'Que desconfiaba de Valentina',
          'Que el conocimiento empírico es profundo e irremplazable',
          'Que la tierra estaba en mal estado',
          'Que era un ritual supersticioso',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Por qué el texto dice que el cambio climático llegó no como un titular?',
        opciones: [
          'Porque nadie lo reportó',
          'Porque sus efectos concretos son más poderosos que las noticias',
          'Porque los periodistas ignoraron el valle',
          'Porque fue de repente',
        ],
        respuesta: 1,
        tipo: 'Inferencial',
      ),
      PreguntaOpciones(
        pregunta: '¿Cuál es el mensaje central del texto?',
        opciones: [
          'El cambio climático es inevitable',
          'La tecnología moderna no sirve en el campo',
          'La sabiduría tradicional y el conocimiento científico se complementan',
          'Los jóvenes deben aprender de los viejos',
        ],
        respuesta: 2,
        tipo: 'Crítica',
      ),
    ],
    interpretacion: [
      '¿Qué emoción te transmitió la imagen de Don Aurelio oliendo la tierra? ¿Por qué?',
      '¿Qué crees que quiso decir el autor al mostrar a Valentina con datos de satélite y a Don Aurelio con tierra en la mano?',
      '¿En qué situaciones de tu vida has visto que la experiencia práctica supera al conocimiento teórico, o viceversa?',
    ],
    retencion: [
      PreguntaOpciones(
        pregunta: '¿Cómo se llamaba la nieta de Don Aurelio?',
        opciones: ['María', 'Valentina', 'Sofía', 'Rosa'],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿Qué trajo Valentina al valle?',
        opciones: [
          'Dinero del gobierno',
          'Semillas resistentes a la sequía y datos de satélite',
          'Un equipo de científicos',
          'Maquinaria agrícola moderna',
        ],
        respuesta: 1,
      ),
      PreguntaOpciones(
        pregunta: '¿Cuántos metros más al norte dijo Don Aurelio que debía estar la parcela?',
        opciones: [
          'Cinco metros',
          'Diez metros',
          'Quince metros',
          'Veinte metros',
        ],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta:
            '¿En qué mes dejaron de llegar las lluvias al valle de Huancán?',
        opciones: ['Enero', 'Febrero', 'Marzo', 'Abril'],
        respuesta: 2,
      ),
      PreguntaOpciones(
        pregunta: '¿Con qué comparó el texto la voz con que Don Aurelio dijo: esta tierra ya no es la misma?',
        opciones: [
          'Con la de un sermón de domingo',
          'Con la que anunciaba el precio del maíz',
          'Con un susurro que se llevó el viento',
          'Con la voz de un noticiero',
        ],
        respuesta: 1,
      ),
    ],
  ),
];

TextoEvaluacion textoAleatorio({int? excluirId, Random? azar}) {
  final opciones = biblioteca.where((t) => t.id != excluirId).toList();
  return opciones[(azar ?? Random()).nextInt(opciones.length)];
}

TextoEvaluacion? textoPorId(int? id) {
  for (final texto in biblioteca) {
    if (texto.id == id) {
      return texto;
    }
  }
  return null;
}
