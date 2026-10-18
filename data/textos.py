import random

BIBLIOTECA = [
    {
    'id': 1,
    'titulo': 'El Secreto de la Amazonía',
    'texto': (
        "En lo más profundo de la Amazonía, donde los árboles alcanzan alturas de cincuenta metros "
        "y la luz del sol apenas penetra el denso follaje, existe un ecosistema tan complejo que los "
        "científicos calculan que aún desconocemos el setenta por ciento de sus especies.\n\n"
        "María, una joven bióloga de veintidós años, llevaba tres meses viviendo entre los pobladores "
        "indígenas de la región, aprendiendo sus secretos ancestrales sobre plantas medicinales.\n\n"
        "Una mañana, mientras catalogaba una orquídea nunca vista, escuchó un sonido extraño "
        "proveniente del río. Al acercarse, descubrió algo que cambiaría para siempre el curso de su "
        "investigación: un delfín rosado de río estaba enseñando a sus crías a pescar con una técnica "
        "que nadie había documentado jamás.\n\n"
        "María comprendió en ese instante que la naturaleza guarda secretos que solo se revelan a "
        "quienes tienen la paciencia y la humildad de escucharla."
    ),
    'comprension_q': [
        {'q': '¿Cuántos años tenía María?',
         'opts': ['Dieciocho', 'Veintidós', 'Treinta', 'Veinticinco'],
         'ans': 1, 'tipo': 'Literal'},
        {'q': '¿Cuánto tiempo llevaba María con los indígenas?',
         'opts': ['Seis meses', 'Un año', 'Tres meses', 'Dos semanas'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿Por qué el descubrimiento del delfín fue extraordinario?',
         'opts': ['Era muy grande', 'Nadie había documentado esa técnica', 'Era especie en extinción', 'Estaba lejos del río'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Qué implica que el 70% de especies sean desconocidas?',
         'opts': ['Los científicos trabajan mal', 'El ecosistema está en peligro', 'La Amazonía tiene biodiversidad inexplorada', 'Hay pocas especies'],
         'ans': 2, 'tipo': 'Inferencial'},
        {'q': '¿Cuál es el mensaje central del texto?',
         'opts': ['Los delfines son inteligentes', 'La biología marina es la más importante', 'La naturaleza revela secretos a quien sabe escuchar', 'María debería regresar'],
         'ans': 2, 'tipo': 'Crítica'},
    ],
    'interpretacion_q': [
        '¿Qué emoción principal transmite este texto? ¿Por qué te generó esa emoción?',
        '¿Cuál es la intención del autor al escribir este relato?',
        '¿Cómo se relaciona el mensaje del texto con la realidad de hoy?',
    ],
    'retencion_q': [
        {'q': '¿Qué catalogaba María cuando escuchó el sonido?',
         'opts': ['Una planta medicinal', 'Una orquídea nunca vista', 'Un pájaro exótico', 'Un insecto'],
         'ans': 1},
        {'q': '¿Qué animal descubrió María cerca del río?',
         'opts': ['Una anaconda', 'Un jaguar', 'Un delfín rosado', 'Una tortuga gigante'],
         'ans': 2},
        {'q': '¿Qué hacía ese animal con sus crías?',
         'opts': ['Jugar en el agua', 'Migrar río arriba', 'Enseñarles a pescar', 'Protegerlas'],
         'ans': 2},
        {'q': 'Según el texto, ¿qué altura alcanzan los árboles de la Amazonía?',
         'opts': ['Treinta metros', 'Cuarenta metros', 'Cincuenta metros', 'Sesenta metros'],
         'ans': 2},
        {'q': 'Según el cierre del texto, ¿qué dos cualidades exige la naturaleza para revelar sus secretos?',
         'opts': ['Valentía y esfuerzo', 'Paciencia y humildad', 'Ciencia y método', 'Curiosidad y constancia'],
         'ans': 1},
    ],
},

{
    'id': 2,
    'titulo': 'El Último Faro',
    'texto': (
        "Durante más de cien años, el Faro de Punta Negra había guiado a los barcos a través "
        "de las peligrosas rocas que escondía la bahía. Su luz giratoria era tan conocida que "
        "los marineros de toda la costa lo llamaban cariñosamente el viejo guardián.\n\n"
        "Ernesto tenía setenta y tres años y era el último farero de la región. Desde los "
        "dieciséis, cuando su padre le enseñó a encender la lámpara de aceite, había dedicado "
        "su vida entera a esa torre de piedra blanca.\n\n"
        "El día que llegó la carta del gobierno anunciando la automatización del faro, Ernesto "
        "la leyó tres veces en silencio. Luego salió a la plataforma exterior y observó el mar "
        "durante horas. No lloró. Solo susurró algo que el viento se llevó consigo.\n\n"
        "Esa noche encendió la lámpara con más cuidado que nunca, como si supiera que algunos "
        "gestos merecen hacerse bien aunque nadie los vea."
    ),
    'comprension_q': [
        {'q': '¿Cuántos años tenía Ernesto?',
         'opts': ['Sesenta', 'Setenta y tres', 'Ochenta', 'Cincuenta y cinco'],
         'ans': 1, 'tipo': 'Literal'},
        {'q': '¿Desde qué edad trabajó Ernesto en el faro?',
         'opts': ['Desde los doce', 'Desde los veinte', 'Desde los dieciséis', 'Desde los treinta'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿Qué significaba la carta del gobierno para Ernesto?',
         'opts': ['Un aumento de sueldo', 'El fin de su labor de vida', 'Un traslado a otro faro', 'Una condecoración'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Por qué el autor dice que el faro era llamado el viejo guardián?',
         'opts': ['Porque era muy antiguo', 'Porque protegía a los barcos con su luz', 'Porque Ernesto era muy viejo', 'Porque estaba hecho de piedra'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Qué nos enseña la actitud de Ernesto al final?',
         'opts': ['Que hay que resignarse', 'Que el trabajo bien hecho tiene valor propio', 'Que el gobierno toma malas decisiones', 'Que los fareros son testarudos'],
         'ans': 1, 'tipo': 'Crítica'},
    ],
    'interpretacion_q': [
        '¿Qué sentiste al leer sobre Ernesto y el faro? Describe tu reacción emocional.',
        '¿Por qué crees que el autor termina el relato con Ernesto encendiendo la lámpara con más cuidado que nunca?',
        '¿Conoces situaciones en la vida real similares a la de Ernesto? ¿Cuál sería el equivalente hoy?',
    ],
    'retencion_q': [
        {'q': '¿Cómo llamaban los marineros al faro?',
         'opts': ['El guardián eterno', 'El viejo guardián', 'La luz del sur', 'El centinela'],
         'ans': 1},
        {'q': '¿Cuántos años tenía el faro de historia?',
         'opts': ['Cincuenta años', 'Setenta años', 'Más de cien años', 'Exactamente ochenta años'],
         'ans': 2},
        {'q': '¿Qué hizo Ernesto después de leer la carta?',
         'opts': ['Lloró en silencio', 'Llamó al gobierno', 'Salió y observó el mar durante horas', 'Apagó la lámpara'],
         'ans': 2},
        {'q': '¿Cuántas veces leyó Ernesto la carta del gobierno?',
         'opts': ['Una vez', 'Dos veces', 'Tres veces', 'Cuatro veces'],
         'ans': 2},
        {'q': '¿Quién le enseñó a Ernesto a encender la lámpara de aceite?',
         'opts': ['El farero anterior', 'Su padre', 'Un marinero de la costa', 'Aprendió solo'],
         'ans': 1},
    ],
},

   {
    'id': 3,
    'titulo': 'La Ciudad que Aprende',
    'texto': (
        "En el año 2031, la ciudad de Valeria se convirtió en el primer municipio del mundo en "
        "implementar inteligencia artificial en todos sus semáforos, tuberías y sistemas de "
        "emergencia. Los resultados fueron asombrosos: los accidentes de tráfico se redujeron "
        "un sesenta por ciento en solo doce meses.\n\n"
        "Sin embargo, nadie había pensado en lo que ocurriría cuando el sistema comenzara a "
        "aprender de los hábitos de sus habitantes. La IA empezó a predecir cuándo iba a "
        "llover basándose en el comportamiento de los perros de la ciudad. Detectaba crisis "
        "económicas familiares antes que los propios bancos.\n\n"
        "La alcaldesa Rebeca convocó una asamblea ciudadana. La pregunta no era si el sistema "
        "funcionaba, claramente sí, sino si querían vivir en una ciudad que los conocía mejor "
        "que ellos mismos.\n\n"
        "La votación fue la más reñida de la historia de Valeria: cuatro votos de diferencia."
    ),
    'comprension_q': [
        {'q': '¿En qué año implementó Valeria la IA en su infraestructura?',
         'opts': ['2025', '2028', '2031', '2035'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿En cuánto se redujeron los accidentes de tránsito?',
         'opts': ['Un treinta por ciento', 'Un cincuenta por ciento', 'Un sesenta por ciento', 'Un ochenta por ciento'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿Qué representa el hecho de que la IA predijera lluvia por el comportamiento de los perros?',
         'opts': ['Que la IA era defectuosa', 'Que el sistema aprende de fuentes inesperadas', 'Que los perros son muy inteligentes', 'Que la ciudad tenía muchos perros'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Por qué la asamblea ciudadana era importante?',
         'opts': ['Para celebrar los logros', 'Para decidir si aceptar una tecnología que los conocía profundamente', 'Para elegir nueva alcaldesa', 'Para revisar el presupuesto'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Cuál es el dilema ético central del texto?',
         'opts': ['Si la IA funciona bien o mal', 'Si los políticos son confiables', 'Si vale la pena perder privacidad a cambio de eficiencia', 'Si Valeria debe crecer como ciudad'],
         'ans': 2, 'tipo': 'Crítica'},
    ],
    'interpretacion_q': [
        '¿Cómo te hizo sentir la idea de una ciudad que te conoce mejor que tú mismo?',
        '¿Qué crees que quiso transmitir el autor con el final de cuatro votos de diferencia?',
        '¿Viviríamos mejor o peor con una IA así en nuestras ciudades? Defiende tu posición.',
    ],
    'retencion_q': [
        {'q': '¿Cómo se llamaba la alcaldesa de Valeria?',
         'opts': ['María', 'Rebeca', 'Sofía', 'Carmen'],
         'ans': 1},
        {'q': '¿Qué detectaba la IA antes que los propios bancos?',
         'opts': ['Robos en casas', 'Terremotos', 'Crisis económicas familiares', 'Accidentes de tránsito'],
         'ans': 2},
        {'q': '¿Por cuántos votos fue la decisión en la asamblea?',
         'opts': ['Un voto', 'Cuatro votos', 'Diez votos', 'Cien votos'],
         'ans': 1},
        {'q': '¿En qué se basaba la IA para predecir cuándo iba a llover?',
         'opts': ['En sensores de humedad', 'En el comportamiento de los perros', 'En datos de satélite', 'En el tráfico de la ciudad'],
         'ans': 1},
        {'q': '¿En qué tres sistemas implementó Valeria la inteligencia artificial?',
         'opts': ['Semáforos, tuberías y sistemas de emergencia', 'Semáforos, hospitales y escuelas', 'Bancos, transporte y parques', 'Cámaras, drones y semáforos'],
         'ans': 0},
    ],
},

{
    'id': 4,
    'titulo': 'Las Manos de mi Abuela',
    'texto': (
        "Las manos de mi abuela Josefa contaban su historia mejor que cualquier relato. Eran "
        "manos grandes, de nudillos pronunciados, con una red de venas azules visibles bajo "
        "una piel que el sol y el trabajo habían curtido hasta volverla del color del cuero.\n\n"
        "Con esas manos había amasado miles de panes antes del amanecer, había cosechado café "
        "en las laderas empinadas de la sierra, había bordado manteles de fiesta y remendado "
        "pantalones de trabajo. Habían mecido cunas y levantado paredes.\n\n"
        "Yo tenía doce años la última vez que tomé sus manos entre las mías. Me sorprendió lo "
        "suaves que eran por dentro, en el hueco de la palma, como si ahí hubieran guardado "
        "toda la ternura que el mundo exterior no llegó a desgastar.\n\n"
        "Hoy, cuando miro mis propias manos, a veces creo reconocer algo suyo en la forma en "
        "que sostienen las cosas."
    ),
    'comprension_q': [
        {'q': '¿Cómo se llamaba la abuela del narrador?',
         'opts': ['Carmen', 'Rosa', 'Josefa', 'Elena'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿Qué edad tenía el narrador la última vez que tomó las manos de su abuela?',
         'opts': ['Ocho años', 'Diez años', 'Doce años', 'Quince años'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿Qué representa el hecho de que las palmas fueran suaves?',
         'opts': ['Que no trabajaba mucho', 'Que guardaba ternura intacta pese al trabajo duro', 'Que usaba cremas', 'Que era muy joven'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Por qué el autor describe las manos en lugar de la cara de su abuela?',
         'opts': ['Porque no recuerda su cara', 'Porque las manos revelan mejor la historia de una persona', 'Porque su abuela tenía cara común', 'Por capricho literario'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Cuál es el tema principal del texto?',
         'opts': ['La agricultura en la sierra', 'El paso del tiempo en los objetos', 'La herencia y la memoria a través de las generaciones', 'La importancia del trabajo físico'],
         'ans': 2, 'tipo': 'Crítica'},
    ],
    'interpretacion_q': [
        '¿Qué emoción te generó este texto? ¿Conectaste con algún recuerdo propio?',
        '¿Por qué crees que el autor termina mirando sus propias manos? ¿Qué mensaje transmite ese gesto?',
        '¿Qué objetos o partes del cuerpo contarían la historia de alguien importante en tu vida?',
    ],
    'retencion_q': [
        {'q': '¿De qué color describe el autor la piel de las manos de la abuela?',
         'opts': ['Del color del mármol', 'Del color del cuero', 'Del color de la madera', 'Del color del barro'],
         'ans': 1},
        {'q': '¿Cuál de estas tareas NO se menciona que hicieron las manos de la abuela?',
         'opts': ['Amasar panes', 'Cosechar café', 'Tejer ropa', 'Mecer cunas'],
         'ans': 2},
        {'q': '¿Qué sorprendió al narrador al tomar las manos de su abuela?',
         'opts': ['Lo frías que estaban', 'Lo grandes que eran', 'Lo suaves que eran por dentro', 'Lo temblorosas que estaban'],
         'ans': 2},
        {'q': '¿Qué bordaban las manos de la abuela según el texto?',
         'opts': ['Vestidos de novia', 'Manteles de fiesta', 'Cortinas de sala', 'Pañuelos de seda'],
         'ans': 1},
        {'q': '¿Dónde cosechaba café la abuela?',
         'opts': ['En el valle del río', 'En su propio patio', 'En la costa', 'En las laderas empinadas de la sierra'],
         'ans': 3},
    ],
},

    {
    'id': 5,
    'titulo': 'El Niño que Contaba Estrellas',
    'texto': (
        "Nadie en el pueblo sabía por qué Simón no hablaba. Los médicos lo llamaban mutismo "
        "selectivo; su madre lo llamaba su forma de ser. A los ocho años, Simón comunicaba "
        "todo lo que necesitaba con dibujos que llenaban cuadernos enteros.\n\n"
        "Pero había algo que sí hacía en voz alta: contar estrellas. Cada noche, después de "
        "cenar, salía al patio con una linterna apagada y comenzaba. Uno, dos, tres... A veces "
        "llegaba hasta trescientos antes de quedarse dormido en el suelo.\n\n"
        "Un astrónomo que visitaba la región escuchó hablar de él y fue a conocerlo. Pasaron "
        "una noche entera mirando el cielo. El científico le señaló constelaciones con nombres "
        "complicados. Simón le dibujó lo que veía: las mismas estrellas, pero conectadas de "
        "formas que ningún atlas había imaginado.\n\n"
        "Al despedirse, el astrónomo le dijo que había aprendido más esa noche que en años de "
        "universidad. Simón sonrió y siguió contando."
    ),
    'comprension_q': [
        {'q': '¿Cuántos años tenía Simón?',
         'opts': ['Cinco años', 'Siete años', 'Ocho años', 'Diez años'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿Cómo comunicaba Simón lo que necesitaba?',
         'opts': ['Con señas', 'Con dibujos', 'Con notas escritas', 'Con gestos'],
         'ans': 1, 'tipo': 'Literal'},
        {'q': '¿Qué significaba que Simón conectara las estrellas de formas distintas al atlas?',
         'opts': ['Que estaba equivocado', 'Que tenía una visión creativa y original del mundo', 'Que no conocía la astronomía', 'Que sus dibujos eran incorrectos'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Por qué el astrónomo dijo haber aprendido más esa noche que en años de universidad?',
         'opts': ['Porque Simón era más inteligente', 'Porque la perspectiva inocente de Simón le mostró algo nuevo', 'Porque la universidad era mala', 'Porque había muchas estrellas ese día'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Cuál es el mensaje principal del texto?',
         'opts': ['Los niños con mutismo necesitan ayuda', 'La astronomía es una ciencia importante', 'Cada mente percibe el mundo de forma única y valiosa', 'Hay que hablar más con los niños'],
         'ans': 2, 'tipo': 'Crítica'},
    ],
    'interpretacion_q': [
        '¿Cómo te hizo sentir la historia de Simón? ¿Qué parte te impactó más?',
        '¿Qué quiso decir el autor con que Simón conectara las estrellas de formas que ningún atlas había imaginado?',
        '¿Conoces personas como Simón cuya forma diferente de ver el mundo enseña algo valioso?',
    ],
    'retencion_q': [
        {'q': '¿Cómo llamaba la madre de Simón a su condición?',
         'opts': ['Mutismo selectivo', 'Su forma de ser', 'Una enfermedad rara', 'Un don especial'],
         'ans': 1},
        {'q': '¿Hasta cuánto contaba Simón las estrellas a veces?',
         'opts': ['Hasta cien', 'Hasta doscientos', 'Hasta trescientos', 'Hasta mil'],
         'ans': 2},
        {'q': '¿Qué trajo el astrónomo para conocer a Simón?',
         'opts': ['Un telescopio', 'Libros de astronomía', 'El texto no dice que trajo nada especial', 'Una cámara fotográfica'],
         'ans': 2},
        {'q': '¿Qué llevaba Simón al patio cada noche para contar estrellas?',
         'opts': ['Un telescopio pequeño', 'Una linterna apagada', 'Sus cuadernos de dibujo', 'Una manta y almohada'],
         'ans': 1},
        {'q': '¿En qué momento del día salía Simón a contar estrellas?',
         'opts': ['Antes de cenar', 'A medianoche', 'Después de cenar', 'Al amanecer'],
         'ans': 2},
    ],
},

    {
    'id': 6,
    'titulo': 'La Última Cosecha',
    'texto': (
        "El cambio climático llegó al valle de Huancán no como un titular de periódico sino "
        "como algo mucho más concreto: las lluvias dejaron de llegar en marzo. Durante cuatro "
        "años consecutivos, los agricultores miraron el cielo en silencio cada tarde, esperando "
        "nubes que se formaban pero no descargaban.\n\n"
        "Don Aurelio, con ochenta y un años y medio siglo de trabajo en esa tierra, fue el "
        "primero en decirlo en voz alta: esta tierra ya no es la misma. Lo dijo sin "
        "dramatismo, con la misma voz con que anunciaba el precio del maíz en el mercado.\n\n"
        "Su nieta Valentina, ingeniera agrónoma recién graduada, llegó ese verano con semillas "
        "resistentes a la sequía y datos de satélite en su laptop. Don Aurelio la escuchó "
        "durante horas sin interrumpirla.\n\n"
        "Luego cogió un puñado de tierra, lo olió, y le dijo que la primera parcela debía "
        "estar quince metros más al norte de donde ella había calculado.\n\n"
        "Las dos cosechas siguientes fueron las mejores del valle."
    ),
    'comprension_q': [
        {'q': '¿Cuántos años tenía Don Aurelio?',
         'opts': ['Setenta', 'Setenta y cinco', 'Ochenta y uno', 'Noventa'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿Durante cuántos años consecutivos fallaron las lluvias?',
         'opts': ['Dos años', 'Tres años', 'Cuatro años', 'Cinco años'],
         'ans': 2, 'tipo': 'Literal'},
        {'q': '¿Qué simboliza el gesto de Don Aurelio al oler la tierra?',
         'opts': ['Que desconfiaba de Valentina', 'Que el conocimiento empírico es profundo e irremplazable', 'Que la tierra estaba en mal estado', 'Que era un ritual supersticioso'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Por qué el texto dice que el cambio climático llegó no como un titular?',
         'opts': ['Porque nadie lo reportó', 'Porque sus efectos concretos son más poderosos que las noticias', 'Porque los periodistas ignoraron el valle', 'Porque fue de repente'],
         'ans': 1, 'tipo': 'Inferencial'},
        {'q': '¿Cuál es el mensaje central del texto?',
         'opts': ['El cambio climático es inevitable', 'La tecnología moderna no sirve en el campo', 'La sabiduría tradicional y el conocimiento científico se complementan', 'Los jóvenes deben aprender de los viejos'],
         'ans': 2, 'tipo': 'Crítica'},
    ],
    'interpretacion_q': [
        '¿Qué emoción te transmitió la imagen de Don Aurelio oliendo la tierra? ¿Por qué?',
        '¿Qué crees que quiso decir el autor al mostrar a Valentina con datos de satélite y a Don Aurelio con tierra en la mano?',
        '¿En qué situaciones de tu vida has visto que la experiencia práctica supera al conocimiento teórico, o viceversa?',
    ],
    'retencion_q': [
        {'q': '¿Cómo se llamaba la nieta de Don Aurelio?',
         'opts': ['María', 'Valentina', 'Sofía', 'Rosa'],
         'ans': 1},
        {'q': '¿Qué trajo Valentina al valle?',
         'opts': ['Dinero del gobierno', 'Semillas resistentes a la sequía y datos de satélite', 'Un equipo de científicos', 'Maquinaria agrícola moderna'],
         'ans': 1},
        {'q': '¿Cuántos metros más al norte dijo Don Aurelio que debía estar la parcela?',
         'opts': ['Cinco metros', 'Diez metros', 'Quince metros', 'Veinte metros'],
         'ans': 2},
        {'q': '¿En qué mes dejaron de llegar las lluvias al valle de Huancán?',
         'opts': ['Enero', 'Febrero', 'Marzo', 'Abril'],
         'ans': 2},
        {'q': '¿Con qué comparó el texto la voz con que Don Aurelio dijo: esta tierra ya no es la misma?',
         'opts': ['Con la de un sermón de domingo', 'Con la que anunciaba el precio del maíz', 'Con un susurro que se llevó el viento', 'Con la voz de un noticiero'],
         'ans': 1},
    ],
},

]

def get_texto_aleatorio(excluir_id=None):
    opciones = [t for t in BIBLIOTECA if t['id'] != excluir_id]
    return random.choice(opciones)
