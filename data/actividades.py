MIN_PALABRAS = 15


def _op(pregunta, opciones, correcta):
    return {'tipo': 'opcion', 'pregunta': pregunta, 'opciones': opciones,
            'correcta': correcta}


def _ord(instruccion, elementos):
    return {'tipo': 'ordenar', 'instruccion': instruccion, 'elementos': elementos}


def _esc(consigna, min_palabras=MIN_PALABRAS):
    return {'tipo': 'escrita', 'consigna': consigna, 'min_palabras': min_palabras}


def _act(libro_id, nivel, orden, titulo, habilidad, capitulo, objetivo, pasos):
    return {'id': f'{libro_id}_{nivel.lower()}_{orden}', 'libro_id': libro_id,
            'nivel': nivel, 'orden': orden, 'titulo': titulo, 'habilidad': habilidad,
            'capitulo_requerido': capitulo, 'objetivo': objetivo, 'pasos': pasos}


SELVA = [
    _act('selva', 'EXPLORADOR', 1, 'Leer un cuento seleccionado.', 'literal', 1,
         'Leer La tortuga gigante y reconocer los datos más importantes del cuento.', [
             _op('¿Dónde vivía el hombre al comienzo del cuento?',
                 ['En Misiones', 'En el Zoológico', 'Junto a una laguna', 'En Buenos Aires'], 3),
             _op('¿Por qué el hombre se fue a vivir al monte?',
                 ['Para cazar un tigre', 'Para visitar a sus hermanos',
                  'Porque los médicos dijeron que así podría curarse', 'Para buscar una tortuga'], 2),
             _op('¿Quién encontró a la tortuga y al hombre cuando llegaron a la ciudad?',
                 ['Un ratón', 'El director del Zoológico', 'Un tigre', 'Un médico'], 0),
         ]),
    _act('selva', 'EXPLORADOR', 2, 'Identificar personajes, lugar y problema.', 'literal', 1,
         'Reconocer quiénes participan en el cuento, dónde ocurre y cuál es el problema.', [
             _op('¿Quiénes son los dos personajes principales del cuento?',
                 ['Un tigre y un ratón', 'Un médico y un director', 'Dos hermanos',
                  'Un cazador y una tortuga'], 3),
             _op('¿Dónde ocurre la mayor parte de la historia?',
                 ['En una casa de Buenos Aires', 'En un barco', 'En el monte, lejos de la ciudad',
                  'En el Jardín Zoológico'], 2),
             _op('¿Cuál es el problema principal del cazador?',
                 ['No sabe cazar', 'Perdió su escopeta',
                  'Se enferma de fiebre y solo en Buenos Aires hay remedios para curarlo',
                  'Un tigre lo persigue por el monte'], 2),
         ]),
    _act('selva', 'EXPLORADOR', 3, 'Responder cinco preguntas literales.', 'literal', 1,
         'Buscar en el cuento información que aparece escrita de forma explícita.', [
             _op('¿Qué animal quería comerse a la tortuga?',
                 ['Un tigre', 'Una víbora', 'Un yacaré', 'Un zorro'], 0),
             _op('¿Con qué le vendó el hombre la cabeza a la tortuga?',
                 ['Con hojas de palmera', 'Con tiras de género de su camisa',
                  'Con una manta', 'Con enredaderas'], 1),
             _op('¿Qué le daba de comer la tortuga al hombre enfermo?',
                 ['Pájaros que cazaba', 'Frutas de los árboles', 'Pescados de la laguna',
                  'Raíces ricas y yuyitos tiernos'], 3),
             _op('¿Con qué sujetó la tortuga al hombre sobre su lomo?',
                 ['Con una soga', 'Con su cinturón', 'Con enredaderas finas y fuertes',
                  'Con tiras de cuero'], 2),
             _op('¿Cuántas leguas recorrió la tortuga para salvar al cazador?',
                 ['Trescientas', 'Diez', 'Cincuenta', 'Mil'], 0),
         ]),
    _act('selva', 'EXPLORADOR', 4, 'Ordenar seis acontecimientos.', 'literal', 1,
         'Reconstruir la secuencia de los hechos del cuento.', [
             _ord('Ordena los acontecimientos del cuento desde el primero hasta el último.', [
                 'El hombre enfermo se va a vivir al monte.',
                 'El cazador mata al tigre que atacaba a la tortuga.',
                 'El hombre cura a la tortuga herida.',
                 'La tortuga cuida al hombre cuando le da fiebre.',
                 'La tortuga lleva al hombre sobre su lomo hacia Buenos Aires.',
                 'El director del Zoológico cura al cazador con remedios.',
             ]),
         ]),
    _act('selva', 'EXPLORADOR', 5, 'Encontrar en el texto la evidencia de cada respuesta.',
         'literal', 1,
         'Localizar en el cuento la frase exacta que demuestra cada respuesta.', [
             _op('¿Qué parte del cuento demuestra que la tortuga era muy grande?',
                 ['La tortuga quedó arrimada a un rincón.',
                  'La tortuga sanó por fin.',
                  'Era tan alta como una silla y pesaba como un hombre.',
                  'La tortuga recorría el monte buscando raíces.'], 2),
             _op('¿Qué parte demuestra que el hombre sintió compasión por la tortuga?',
                 ['A pesar del hambre que sentía, tuvo lástima de la pobre tortuga.',
                  'Le apuntó al tigre entre los dos ojos.',
                  'Había hecho un atado con los cueros de los animales.',
                  'Comía pájaros y bichos del monte.'], 0),
             _op('¿Qué parte prueba que la tortuga llegó muy débil a la ciudad?',
                 ['Atravesó montes y campos.',
                  'Iba a buscar agua y raíces tiernas.',
                  'Cruzó a nado ríos de una legua de ancho.',
                  'No había comido desde hacía una semana para llegar más pronto.'], 3),
             _op('¿Qué parte muestra que el cazador y la tortuga siguen siendo amigos?',
                 ['El director se comprometió a cuidarla.',
                  'El cazador la va a ver todas las tardes.',
                  'La tortuga pasea por todo el jardín.',
                  'La casa del cazador era muy chica.'], 1),
         ]),
    _act('selva', 'CONSTRUCTOR', 1, 'Resumir el cuento en cinco ideas.', 'inferencial', 8,
         'Seleccionar las ideas esenciales de La abeja haragana y contarlas con brevedad.', [
             _ord('Ordena las cinco ideas principales del cuento.', [
                 'Una abeja de la colmena no quería trabajar.',
                 'Las abejas guardianas le advierten varias veces que debe trabajar.',
                 'Una noche fría no la dejan entrar y cae en la cueva de una culebra.',
                 'La abeja se salva escondiéndose en las hojas de una planta sensitiva.',
                 'Vuelve a la colmena y se convierte en una abeja muy trabajadora.',
             ]),
             _esc('Escribe con tus propias palabras un resumen del cuento en cinco ideas.', 30),
         ]),
    _act('selva', 'CONSTRUCTOR', 2, 'Identificar tres relaciones de causa y consecuencia.',
         'inferencial', 8,
         'Relacionar lo que pasa en el cuento con lo que lo provoca.', [
             _op('¿Por qué las guardianas no dejaron entrar a la abeja el 20 de abril?',
                 ['Porque llegó muy tarde', 'Porque estaba enferma',
                  'Porque no había traído ni una gota de miel',
                  'Porque la colmena estaba llena'], 2),
             _op('¿Qué ocurrió cuando la abeja tocó la planta de la cueva?',
                 ['La planta se cayó', 'Las hojas se cerraron y la ocultaron',
                  'La culebra la vio en seguida', 'La planta empezó a crecer'], 1),
             _op('¿Por qué la abeja y la culebra pasaron la noche contra la pared más alta?',
                 ['Porque el agua de la tormenta entraba como un río',
                  'Porque allí hacía calor', 'Porque la culebra quería dormir',
                  'Porque había otra culebra abajo'], 0),
         ]),
    _act('selva', 'CONSTRUCTOR', 3, 'Explicar una decisión de un personaje.', 'inferencial', 8,
         'Comprender por qué un personaje actúa como lo hace.', [
             _op('¿Por qué la abeja eligió la prueba de desaparecer?',
                 ['Porque sabía volar muy rápido',
                  'Porque la culebra no podía ver',
                  'Porque conocía un agujero para escapar',
                  'Porque mientras bailaba el trompito vio una plantita que cierra sus hojas'], 3),
             _esc('Explica por qué las guardianas decidieron no dejar entrar a la abeja y si '
                  'te parece una decisión justa.'),
         ]),
    _act('selva', 'CONSTRUCTOR', 4, 'Justificar dos inferencias mediante pistas del texto.',
         'inferencial', 8,
         'Usar pistas del cuento para sostener lo que se deduce.', [
             _op('Se puede inferir que las guardianas eran sabias. ¿Qué pista lo apoya?',
                 ['Tienen el lomo pelado.',
                  'Son abejas viejas, con gran experiencia de la vida.',
                  'Están siempre en la puerta.',
                  'Hablan muy fuerte.'], 1),
             _op('Se puede inferir que la abeja cambió de verdad. ¿Qué pista lo apoya?',
                 ['Lloró en silencio frente a la colmena.',
                  'Recordaba la colmena calentita.',
                  'En adelante ninguna recogió tanto polen ni fabricó tanta miel como ella.',
                  'Voló cuando salió el sol.'], 2),
             _esc('Escribe otra inferencia sobre el cuento y la pista del texto que la apoya.'),
         ]),
    _act('selva', 'ESTRATEGA', 1, 'Analizar una decisión y sus consecuencias.', 'inferencial', 4,
         'Analizar cómo las decisiones de los yacarés cambian el curso de la historia.', [
             _op('¿Qué decidieron los yacarés cuando comprendieron que el vapor pasaría siempre?',
                 ['Irse a otro río', 'Hacer un dique', 'Atacar el vapor',
                  'Pedir ayuda al Surubí'], 1),
             _op('¿Qué consecuencia tuvo el primer dique?',
                 ['El vapor se hundió',
                  'Los pescados volvieron para siempre',
                  'Llegó un buque de guerra que lo deshizo a cañonazos',
                  'Los hombres se hicieron amigos de los yacarés'], 2),
             _esc('Analiza la decisión de pedir el torpedo al Surubí. ¿Qué consecuencias tuvo '
                  'para los yacarés y para los hombres del buque?', 25),
         ]),
    _act('selva', 'ESTRATEGA', 2, 'Proponer una alternativa.', 'critica', 4,
         'Imaginar otra solución al conflicto y valorar sus resultados.', [
             _op('¿Por qué al principio el Surubí no quería tener relación con los yacarés?',
                 ['Porque le habían robado el torpedo',
                  'Porque eran muy ruidosos',
                  'Porque vivían lejos',
                  'Porque se habían comido a su sobrinito'], 3),
             _esc('Propón otra forma en que los yacarés podrían haber resuelto el problema del '
                  'buque sin destruirlo. Explica qué pasaría con tu propuesta.', 25),
         ]),
    _act('selva', 'ESTRATEGA', 3,
         'Distinguir hechos, inferencias y afirmaciones sin respaldo suficiente.', 'critica', 4,
         'Separar lo que el cuento afirma de lo que se deduce y de lo que no tiene apoyo.', [
             _op('¿Cuál de estas afirmaciones es un hecho que dice el texto?',
                 ['Los yacarés construyeron el dique con lapachos y quebrachos.',
                  'Los yacarés eran los animales más inteligentes del río.',
                  'El oficial era el peor de los marineros.',
                  'El Surubí quería vengarse de los hombres.'], 0),
             _op('¿Cuál es una inferencia razonable a partir del cuento?',
                 ['Los yacarés no sabían nadar.',
                  'El viejo yacaré reconoció el buque de guerra porque había viajado hasta el mar.',
                  'El vapor quería atacar a los yacarés desde el principio.',
                  'Los pescados avisaron a los hombres del dique.'], 1),
             _op('¿Cuál afirmación no tiene respaldo suficiente en el texto?',
                 ['El buque de guerra destruyó dos diques.',
                  'El Surubí sabía hacer reventar el torpedo.',
                  'Los yacarés odian a todos los seres humanos.',
                  'Los pescados se fueron por el ruido del vapor.'], 2),
         ]),
    _act('selva', 'ESTRATEGA', 4, 'Comparar dos personajes a partir de sus acciones.', 'critica',
         4, 'Comparar a los personajes por lo que hacen y no solo por lo que dicen.', [
             _op('¿Qué diferencia muestran las acciones del viejo yacaré frente a las de los '
                 'yacarés jóvenes?',
                 ['El viejo reconoce el peligro y ordena esconderse bajo el agua',
                  'El viejo se queda dormido mientras los otros trabajan',
                  'Los jóvenes conocen mejor los barcos',
                  'El viejo no quiere hacer el dique'], 0),
             _esc('Compara al viejo yacaré y al Surubí. ¿En qué se parecen y en qué se '
                  'diferencian por sus acciones?', 25),
         ]),
    _act('selva', 'MAESTRO', 1, 'Interpretar el conflicto desde dos perspectivas.', 'critica', 7,
         'Comprender el conflicto del cuento desde el punto de vista de cada bando.', [
             _op('Desde la perspectiva de las rayas, ¿por qué defienden el paso del río?',
                 ['Porque el tigre les robaba los pescados',
                  'Porque el hombre las había protegido al impedir las bombas de dinamita',
                  'Porque el zorro se lo ordenó',
                  'Porque querían quedarse con la isla'], 1),
             _op('¿Qué argumento usa el tigre para exigir que lo dejen pasar?',
                 ['Que el río era suyo', 'Que tenía mucha hambre',
                  'Que el hombre lo había herido a él', 'Que las rayas le debían un favor'], 2),
             _esc('Interpreta el conflicto desde la perspectiva de las rayas y desde la del '
                  'tigre. ¿Qué tiene de razonable cada una?', 30),
         ]),
    _act('selva', 'MAESTRO', 2, 'Reescribir una escena desde otro personaje.', 'critica', 7,
         'Contar una escena del cuento desde los ojos de otro personaje.', [
             _op('¿Qué llevaba el carpinchito cuando cruzó nadando el Yabebirí?',
                 ['Una carta del hombre', 'Comida para el herido',
                  'Un remedio para las rayas', 'El winchester y las balas sobre la cabeza'], 3),
             _esc('Reescribe la escena en que el carpinchito cruza el río, contada por el '
                  'propio carpinchito.', 40),
         ]),
    _act('selva', 'MAESTRO', 3, 'Crear un final alternativo coherente.', 'critica', 7,
         'Crear un final distinto que respete a los personajes y los hechos del cuento.', [
             _op('¿Qué hizo el hombre al final del cuento original?',
                 ['Se fue a vivir a la isla', 'Volvió a la ciudad',
                  'Se hizo cazador de tigres', 'Se fue del Yabebirí'], 0),
             _esc('Escribe un final alternativo para el cuento que sea coherente con lo que '
                  'ocurrió antes.', 40),
         ]),
    _act('selva', 'MAESTRO', 4, 'Elaborar cinco preguntas con respuestas justificadas.',
         'critica', 7,
         'Formular preguntas de distinto tipo y justificar sus respuestas con el texto.', [
             _op('¿Cuál de estas preguntas es crítica y no solo literal?',
                 ['¿Qué llevaba el carpinchito?',
                  '¿Cuántos tigres murieron?',
                  '¿Dónde está el río Yabebirí?',
                  '¿Fue justo que las rayas arriesgaran su vida por el hombre?'], 3),
             _esc('Escribe cinco preguntas sobre el cuento. A cada una agrégale su respuesta y '
                  'la parte del texto que la justifica.', 60),
         ]),
]

ISLA = [
    _act('isla', 'EXPLORADOR', 1, 'Leer un fragmento breve.', 'literal', 1,
         'Leer el capítulo I y reconocer los datos principales del comienzo de la novela.', [
             _op('¿Cómo se llamaba la posada del padre del narrador?',
                 ['Royal George', 'El Vigía', 'Almirante Benbow', 'La Española'], 2),
             _op('¿Qué marca tenía el viejo marino en una mejilla?',
                 ['Un tatuaje', 'Una mancha negra', 'Una venda', 'Una gran cicatriz de sable'], 3),
             _op('¿Qué le pedía el Capitán al narrador a cambio de cuatro peniques al mes?',
                 ['Que le trajera rom todas las noches',
                  'Que cuidara su cofre',
                  'Que vigilara el camino de Brístol',
                  'Que le avisara si aparecía un marino con una sola pierna'], 3),
         ]),
    _act('isla', 'EXPLORADOR', 2, 'Identificar personajes, lugar y acontecimientos.', 'literal',
         1, 'Reconocer quiénes aparecen en el capítulo I, dónde están y qué ocurre.', [
             _op('¿Quién se enfrentó al Capitán en la sala de la posada?',
                 ['El Doctor Livesey', 'El padre del narrador', 'Black Dog', 'El jardinero'], 0),
             _op('¿Cómo pasaba el día el Capitán?',
                 ['Durmiendo en su cuarto',
                  'Vagando por la caleta o sobre las rocas con un anteojo',
                  'Trabajando en la posada', 'Pescando en el puerto'], 1),
             _op('¿Qué ocurrió cuando el Capitán sacó su navaja?',
                 ['Hirió al Doctor',
                  'Todos huyeron de la posada',
                  'El Doctor lo amenazó con hacerlo ahorcar y el Capitán guardó el arma',
                  'El padre del narrador llamó a los guardias'], 2),
         ]),
    _act('isla', 'EXPLORADOR', 3, 'Completar una ficha por escena.', 'literal', 3,
         'Organizar en una ficha los datos de la escena del mendigo ciego.', [
             _op('¿Quién llega a la posada en esta escena?',
                 ['Un marino con una sola pierna',
                  'Un mendigo ciego con una venda verde sobre los ojos',
                  'Black Dog con la mano herida', 'El Doctor Livesey'], 1),
             _op('¿Qué hace el ciego para obligar al narrador a guiarlo?',
                 ['Le ofrece dinero', 'Le promete un secreto',
                  'Lo amenaza con su bastón', 'Le aprieta y le retuerce el brazo'], 3),
             _op('¿Cómo termina la escena?',
                 ['El Capitán cae muerto por un ataque',
                  'El ciego se queda a dormir en la posada',
                  'El Capitán persigue al ciego por el camino',
                  'El narrador se desmaya'], 0),
             _esc('Completa la ficha de la escena: escribe los personajes, el lugar y el hecho '
                  'principal.', 20),
         ]),
    _act('isla', 'EXPLORADOR', 4, 'Ordenar cinco acontecimientos.', 'literal', 2,
         'Reconstruir el orden de los hechos del capítulo II.', [
             _ord('Ordena los acontecimientos del capítulo II.', [
                 'Un desconocido al que le faltan dos dedos entra a la posada y pregunta por Bill.',
                 'El desconocido y el narrador se esconden detrás de la puerta.',
                 'El Capitán entra y reconoce a Black Dog.',
                 'Pelean con sus cuchillas y Black Dog huye herido.',
                 'El Capitán cae al suelo y el Doctor Livesey lo atiende.',
             ]),
         ]),
    _act('isla', 'EXPLORADOR', 5, 'Responder preguntas literales buscando evidencia.', 'literal',
         3, 'Responder preguntas buscando la información exacta en el capítulo III.', [
             _op('Según el Capitán, ¿qué buscan sus enemigos?',
                 ['Su viejo cofre de a bordo', 'Su anteojo', 'Su dinero del banco',
                  'Al narrador'], 0),
             _op('¿De quién había sido primer piloto el Capitán?',
                 ['De Black Dog', 'Del Capitán Smollet', 'Del Capitán Flint', 'De John Silver'], 2),
             _op('¿Qué le ocurrió al padre del narrador en este capítulo?',
                 ['Se fue de viaje', 'Murió casi repentinamente esa noche',
                  'Discutió con el Capitán', 'Vendió la posada'], 1),
             _op('¿Qué le entregó el ciego al Capitán?',
                 ['Una carta', 'Una moneda de oro',
                  'Algo que puso en su mano y que el Capitán apretó con fuerza',
                  'Un mapa'], 2),
         ]),
    _act('isla', 'CONSTRUCTOR', 1, 'Elaborar una tabla de dos personajes.', 'inferencial', 8,
         'Organizar en una tabla el aspecto, la actitud y las intenciones de dos personajes.', [
             _op('¿Qué rasgo corresponde a John Silver según el capítulo VIII?',
                 ['Le faltan dos dedos de una mano',
                  'Le falta la pierna izquierda y se apoya en una muleta',
                  'Es ciego y usa una venda verde', 'Tiene una cicatriz en la mejilla'], 1),
             _op('¿Qué rasgo corresponde a Black Dog?',
                 ['Tiene la cara enjuta y le faltan dos dedos de una mano',
                  'Es alto, fuerte y risueño', 'Es el dueño de la taberna',
                  'Es el cocinero de la goleta'], 0),
             _esc('Completa una tabla de John Silver y Black Dog: aspecto, actitud y lo que '
                  'parece querer cada uno.', 25),
         ]),
    _act('isla', 'CONSTRUCTOR', 2, 'Describir sus acciones e intenciones.', 'inferencial', 11,
         'Deducir las intenciones de los personajes a partir de lo que dicen y hacen.', [
             _op('¿Qué intención revela Silver en la conversación que el narrador oye desde el '
                 'barril?',
                 ['Volver a su taberna de Brístol',
                  'Obedecer siempre al Capitán Smollet',
                  'Esperar a que encuentren el tesoro y después matar a los leales',
                  'Repartir el tesoro con toda la tripulación'], 2),
             _op('¿Por qué Silver le dice al joven marinero las mismas palabras que antes le '
                 'dijo al narrador?',
                 ['Porque es su sobrino', 'Porque olvidó lo que había dicho',
                  'Porque era la contraseña de los piratas',
                  'Porque usa halagos para ganarse su confianza'], 3),
             _esc('Describe una acción de Silver y otra de Israel Hands en este capítulo, y '
                  'explica qué intención tiene cada uno.'),
         ]),
    _act('isla', 'CONSTRUCTOR', 3, 'Predecir qué ocurrirá en el siguiente capítulo.',
         'inferencial', 11, 'Anticipar lo que viene usando las pistas del capítulo XI.', [
             _op('¿Qué pista del final del capítulo XI anuncia un cambio en la historia?',
                 ['El vigía grita que ven tierra', 'Silver se queda dormido',
                  'El barril se rompe', 'El Capitán llama a todos a cubierta'], 0),
             _esc('Predice qué hará el narrador en el capítulo siguiente después de lo que oyó. '
                  'Explica en qué pistas te basas.', 20),
         ]),
    _act('isla', 'CONSTRUCTOR', 4,
         'Comparar la predicción con la historia y explicar qué pistas fueron útiles.',
         'inferencial', 12, 'Contrastar lo que imaginaste con lo que realmente ocurre.', [
             _op('¿Qué hace el narrador en el capítulo XII?',
                 ['Se esconde de nuevo en el barril',
                  'Enfrenta a Silver delante de todos', 'Huye a la isla',
                  'Les cuenta al Doctor, al Capitán y al Caballero lo que oyó'], 3),
             _op('¿Qué decide el Capitán Smollet después de escucharlo?',
                 ['Volver a Inglaterra de inmediato',
                  'Encerrar a Silver',
                  'Seguir adelante, vigilar y esperar el momento oportuno',
                  'Repartir armas a toda la tripulación'], 2),
             _esc('Compara tu predicción con lo que pasó en el capítulo XII. ¿Qué pistas te '
                  'ayudaron y cuáles no?', 20),
         ]),
    _act('isla', 'ESTRATEGA', 1, 'Analizar la confiabilidad de un personaje.', 'critica', 20,
         'Evaluar si se puede confiar en Silver a partir de sus palabras y sus actos.', [
             _op('¿Qué propone Silver al Capitán cuando llega con la bandera de paz?',
                 ['Rendirse sin condiciones',
                  'Que le entreguen el mapa a cambio de llevarlos a una costa segura o dejarles '
                  'provisiones',
                  'Compartir la goleta en partes iguales', 'Luchar al día siguiente'], 1),
             _op('¿Por qué el Capitán no cree en su oferta?',
                 ['Porque ya saben lo que los amotinados se proponían hacer',
                  'Porque Silver llegó tarde', 'Porque Silver no trajo el tesoro',
                  'Porque Gray le dijo que mentía'], 0),
             _esc('¿Es Silver un personaje confiable? Argumenta tu respuesta con dos acciones '
                  'suyas en la novela.', 25),
         ]),
    _act('isla', 'ESTRATEGA', 2, 'Identificar señales de confianza o desconfianza.',
         'inferencial', 15, 'Reconocer en Ben Gunn gestos que muestran confianza o recelo.', [
             _op('¿Qué señal de desconfianza muestra Ben Gunn?',
                 ['Le pide queso al narrador',
                  'Le cuenta cómo era su madre',
                  'Le muestra el cementerio',
                  'Pregunta si el narrador fue enviado por John Silver'], 3),
             _op('¿Qué señal de confianza muestra Ben Gunn hacia el narrador?',
                 ['Le cuenta su historia y le habla de su bote escondido',
                  'Le apunta con un mosquete', 'Se esconde detrás de un árbol',
                  'Le pide que se vaya'], 0),
             _esc('Explica si el narrador hizo bien en confiar en Ben Gunn. Usa señales del '
                  'capítulo.'),
         ]),
    _act('isla', 'ESTRATEGA', 3, 'Explicar una decisión y sus consecuencias.', 'inferencial', 22,
         'Analizar la decisión del narrador de salir de la estacada y lo que provoca.', [
             _op('¿Qué decide hacer el narrador en el capítulo XXII?',
                 ['Rendirse a los piratas',
                  'Escapar de la estacada sin permiso',
                  'Curar a los heridos', 'Buscar al Doctor'], 1),
             _op('¿Qué plan forma al encontrar el bote de Ben Gunn?',
                 ['Volver a Inglaterra',
                  'Esconder el tesoro',
                  'Llegar hasta La Española y cortar el cable del ancla',
                  'Rescatar al Capitán Smollet'], 2),
             _esc('Explica la decisión del narrador. ¿Fue valiente o imprudente? ¿Qué '
                  'consecuencias podía traer para él y para sus compañeros?', 25),
         ]),
    _act('isla', 'ESTRATEGA', 4,
         'Diferenciar lo que el narrador confirma de lo que el lector infiere.', 'critica', 16,
         'Separar lo que el narrador afirma de lo que el lector deduce.', [
             _op('¿Quién narra el capítulo XVI?',
                 ['El Capitán Smollet', 'El Doctor Livesey', 'El Caballero Trelawney',
                  'Abraham Gray'], 1),
             _op('¿Qué hecho confirma el narrador?',
                 ['Gray se unió a ellos con una herida en la mejilla',
                  'Gray había planeado escapar desde el inicio',
                  'Los seis amotinados querían rendirse',
                  'Silver vio todo desde la playa'], 0),
             _op('¿Cuál de estas ideas es una inferencia del lector y no algo que el narrador '
                 'confirma?',
                 ['El Capitán dio treinta segundos a Gray.',
                  'Arrojaron armas y pólvora al agua.',
                  'Gray dudó porque temía lo que harían los otros amotinados.',
                  'El Doctor fue soldado y médico.'], 2),
             _esc('Escribe un hecho que el narrador confirma en el capítulo y una inferencia '
                  'tuya. Explica la diferencia.'),
         ]),
    _act('isla', 'MAESTRO', 1, 'Reconstruir un conflicto a partir de varios capítulos.',
         'critica', 33,
         'Integrar información de varios capítulos para explicar el conflicto central.', [
             _ord('Ordena estos momentos del conflicto entre los leales y los amotinados.', [
                 'El narrador oye desde un barril el plan de Silver.',
                 'Los leales abandonan la goleta y se refugian en la estacada.',
                 'Silver ofrece un trato bajo bandera de paz.',
                 'El narrador cae prisionero y Silver lo protege.',
                 'Los piratas encuentran vacío el lugar del tesoro.',
             ]),
             _esc('Reconstruye el conflicto entre Silver y el Capitán Smollet usando hechos de '
                  'al menos tres capítulos.', 40),
         ]),
    _act('isla', 'MAESTRO', 2, 'Analizar las estrategias de los personajes.', 'critica', 33,
         'Analizar cómo cada personaje usa lo que sabe para lograr sus fines.', [
             _op('¿Por qué Silver protege al narrador en el campo enemigo?',
                 ['Porque le tiene cariño desde la taberna',
                  'Porque el Doctor se lo pidió',
                  'Porque quiere el mapa del narrador',
                  'Para que el narrador sea su testigo y lo salve de la horca'], 3),
             _op('¿Qué estrategia usó Ben Gunn con el tesoro?',
                 ['Lo trasladó a su gruta dos meses antes',
                  'Lo enterró de nuevo junto al pino',
                  'Lo cambió por provisiones', 'Lo escondió en la goleta'], 0),
             _esc('Compara la estrategia de Silver con la de Ben Gunn. ¿Cuál fue más eficaz y '
                  'por qué?', 30),
         ]),
    _act('isla', 'MAESTRO', 3, 'Proponer una decisión alternativa.', 'critica', 34,
         'Proponer otra decisión para un momento clave y pensar en sus efectos.', [
             _op('¿Qué decisión tomó Ben Gunn al final de la novela?',
                 ['Quedarse a vivir en la isla',
                  'Ayudar a escapar a Silver en un lanchón',
                  'Entregar a Silver a las autoridades', 'Darle a Silver el mapa'], 1),
             _op('¿Qué se llevó Silver al escapar?',
                 ['El loro y el mapa', 'La goleta',
                  'Un saco con unas quinientas guineas', 'Nada'], 2),
             _esc('Propón una decisión distinta para Ben Gunn o para el Doctor frente a Silver. '
                  'Explica qué habría cambiado.', 30),
         ]),
    _act('isla', 'MAESTRO', 4,
         'Argumentar cómo cambiaría la historia y comparar las consecuencias.', 'critica', 33,
         'Argumentar sobre un cambio en la historia y comparar sus consecuencias.', [
             _op('¿Qué encuentran los piratas en el lugar marcado del tesoro?',
                 ['Las cajas del tesoro completas',
                  'Un mapa nuevo',
                  'A Ben Gunn esperándolos',
                  'Una excavación vieja, sin el tesoro, con tablas de cajas y el mango roto de '
                  'una azada'], 3),
             _esc('Imagina que Ben Gunn no hubiera movido el tesoro. Argumenta cómo cambiaría '
                  'la historia y compara las consecuencias con el final real.', 40),
         ]),
]

PRINCIPE = [
    _act('principe', 'EXPLORADOR', 1, 'Identificar personajes y acciones.', 'literal', 1,
         'Reconocer a los personajes del cuento y lo que hace cada uno.', [
             _op('¿Quién llevó el rubí a la costurera?',
                 ['El Príncipe', 'La Golondrina', 'El alcalde', 'Un ángel'], 1),
             _op('¿Qué hacía el Príncipe cuando la Golondrina llegó a sus pies?',
                 ['Cantaba', 'Dormía', 'Hablaba con el Junco', 'Lloraba'], 3),
             _op('¿Qué hizo la Golondrina con el oro fino del Príncipe?',
                 ['Lo repartió hoja por hoja entre los pobres', 'Se lo llevó a Egipto',
                  'Lo vendió a un joyero', 'Lo escondió en su nido'], 0),
         ]),
    _act('principe', 'EXPLORADOR', 2, 'Responder cinco preguntas literales.', 'literal', 1,
         'Buscar en el cuento información que aparece escrita de forma explícita.', [
             _op('¿Dónde estaba la estatua del Príncipe Feliz?',
                 ['En el palacio real', 'Junto al río',
                  'En la parte más alta de la ciudad, sobre una columnita',
                  'En la puerta de la catedral'], 2),
             _op('¿Qué tenía la estatua en lugar de ojos?',
                 ['Dos rubíes', 'Dos perlas', 'Dos esmeraldas', 'Dos zafiros'], 3),
             _op('¿Adónde querían viajar las golondrinas?',
                 ['A Egipto', 'A la India', 'Al norte de Europa', 'A las montañas'], 0),
             _op('¿Qué pedía el hijo enfermo de la costurera?',
                 ['Agua', 'Pan', 'Juguetes', 'Naranjas'], 3),
             _op('¿De qué material era el corazón del Príncipe?',
                 ['De oro', 'De cristal', 'De plomo', 'De mármol'], 2),
         ]),
    _act('principe', 'EXPLORADOR', 3, 'Explicar el significado de tres palabras según el contexto.',
         'literal', 1, 'Deducir el significado de palabras nuevas por el contexto.', [
             _op('El Príncipe ve a un joven en una buhardilla, y la Golondrina entra por un '
                 'agujero del techo. ¿Qué es una buhardilla?',
                 ['Un cuarto pequeño bajo el techo de una casa', 'Una tienda de libros',
                  'Un teatro', 'Un barco'], 0),
             _op('El alcalde dice que el Príncipe está andrajoso porque ya no tiene ojos ni oro. '
                 '¿Qué significa andrajoso?',
                 ['Muy alto', 'Brillante y nuevo', 'Que se ve roto, viejo y en mal estado',
                  'Enojado'], 2),
             _op('Largos carámbanos, semejantes a puñales de cristal, colgaban de los tejados. '
                 '¿Qué son los carámbanos?',
                 ['Adornos de fiesta', 'Pájaros del invierno', 'Gotas de lluvia',
                  'Trozos de hielo largos y puntiagudos'], 3),
         ]),
    _act('principe', 'EXPLORADOR', 4, 'Ordenar los acontecimientos principales.', 'literal', 1,
         'Reconstruir la secuencia de los hechos principales del cuento.', [
             _ord('Ordena los acontecimientos principales del cuento.', [
                 'La Golondrina se queda en la ciudad y se posa a los pies del Príncipe.',
                 'La Golondrina lleva el rubí a la costurera.',
                 'La Golondrina lleva un zafiro al joven de la buhardilla.',
                 'La Golondrina entrega el otro zafiro a la niña de las cerillas.',
                 'La Golondrina reparte el oro del Príncipe entre los pobres.',
                 'La Golondrina muere y el corazón de plomo del Príncipe se parte.',
             ]),
         ]),
    _act('principe', 'CONSTRUCTOR', 1, 'Explicar dos decisiones de los personajes.',
         'inferencial', 1, 'Explicar por qué los personajes toman sus decisiones.', [
             _op('¿Por qué la Golondrina decidió quedarse para siempre con el Príncipe?',
                 ['Porque no le gustaba Egipto', 'Porque el Príncipe se había quedado ciego',
                  'Porque sus amigas no la esperaban', 'Porque hacía buen tiempo'], 1),
             _op('¿Para qué pidió el Príncipe que le arrancaran los zafiros?',
                 ['Para ayudar al joven de la buhardilla y a la niña de las cerillas',
                  'Para pagar a la Golondrina', 'Para no ver la ciudad',
                  'Para adornar el palacio'], 0),
             _esc('Elige una de estas decisiones y explica qué dice de la forma de ser del '
                  'personaje.'),
         ]),
    _act('principe', 'CONSTRUCTOR', 2, 'Identificar sus motivaciones.', 'inferencial', 1,
         'Descubrir qué mueve a los personajes a actuar.', [
             _op('¿Qué motiva al Príncipe a regalar sus joyas y su oro?',
                 ['Quiere ser más famoso', 'Quiere quedar más liviano',
                  'Ve desde lo alto la miseria de su ciudad', 'Se lo pidió el alcalde'], 2),
             _op('¿Por qué las autoridades derribaron la estatua?',
                 ['Porque era muy antigua', 'Porque estorbaba el paso',
                  'Porque estaba rota por el frío',
                  'Porque ya no era bella ni dorada'], 3),
             _esc('Compara lo que motiva al Príncipe con lo que motiva al alcalde y a los '
                  'concejales.'),
         ]),
    _act('principe', 'CONSTRUCTOR', 3, 'Formular la idea principal.', 'inferencial', 1,
         'Expresar en una oración el mensaje central del cuento.', [
             _op('¿Cuál de estas oraciones expresa mejor la idea principal del cuento?',
                 ['Las golondrinas deben viajar antes del invierno.',
                  'La verdadera riqueza está en ayudar a los demás, aunque cueste lo propio.',
                  'Las estatuas de oro son las más valiosas.',
                  'Los alcaldes saben lo que es mejor para la ciudad.'], 1),
             _esc('Formula con tus propias palabras la idea principal del cuento.'),
         ]),
    _act('principe', 'CONSTRUCTOR', 4,
         'Seleccionar dos acontecimientos que respalden esa interpretación.', 'inferencial', 1,
         'Elegir hechos del cuento que sostengan la idea principal.', [
             _op('¿Qué acontecimiento respalda la idea de que ayudar es lo más valioso?',
                 ['El Príncipe da su oro a los pobres hasta quedarse sin brillo',
                  'El profesor escribe una carta al periódico',
                  'Los concejales discuten por la nueva estatua',
                  'La Golondrina visita los monumentos'], 0),
             _op('¿Qué otro acontecimiento respalda esa misma idea?',
                 ['El alcalde quiere su propia estatua',
                  'La Golondrina se baña en el río',
                  'Los gorriones admiran a la Golondrina',
                  'Dios elige el corazón de plomo y el pájaro muerto como lo más precioso'], 3),
             _esc('Explica cómo estos dos acontecimientos respaldan la idea principal.'),
         ]),
    _act('principe', 'ESTRATEGA', 1, 'Elegir una decisión importante.', 'critica', 1,
         'Identificar la decisión que cambia el rumbo del cuento.', [
             _op('¿Qué decisión cambió por completo el destino de la Golondrina?',
                 ['Enamorarse del Junco',
                  'Visitar el campanario',
                  'Quedarse con el Príncipe en invierno en lugar de ir a Egipto',
                  'Bañarse en el río'], 2),
             _esc('Explica por qué esa decisión es la más importante del cuento.'),
         ]),
    _act('principe', 'ESTRATEGA', 2, 'Formular una opinión fundamentada.', 'critica', 1,
         'Expresar una opinión propia y sostenerla con razones del texto.', [
             _op('¿Qué propuso el alcalde hacer con el metal de la estatua fundida?',
                 ['Repartirlo entre los pobres', 'Hacer otra estatua, la suya',
                  'Construir una escuela', 'Venderlo'], 1),
             _esc('¿Fue justo que la ciudad derribara la estatua del Príncipe? Da tu opinión '
                  'con dos razones.', 25),
         ]),
    _act('principe', 'ESTRATEGA', 3, 'Presentar dos evidencias.', 'critica', 1,
         'Sostener una afirmación con pruebas tomadas del cuento.', [
             _op('Afirmación: las autoridades solo valoraban la apariencia. ¿Qué evidencia la '
                 'apoya?',
                 ['El profesor de estética dijo que, al no ser ya bello, de nada servía',
                  'La Golondrina amaba al Príncipe',
                  'El joven terminó su obra',
                  'Los niños jugaban en la calle'], 0),
             _op('¿Qué otra evidencia apoya la misma afirmación?',
                 ['La niña corrió a su casa',
                  'El Príncipe lloraba de noche',
                  'Los marineros sacaban cajas del barco',
                  'Los concejales dijeron que el Príncipe parecía un pordiosero'], 3),
             _esc('Escribe con tus palabras por qué estas dos evidencias apoyan la afirmación.'),
         ]),
    _act('principe', 'ESTRATEGA', 4,
         'Distinguir hechos de interpretaciones y explicar qué aspectos pueden debatirse.',
         'critica', 1, 'Separar lo que ocurre en el cuento de lo que interpretamos sobre él.', [
             _op('¿Cuál de estas oraciones es un hecho del cuento?',
                 ['El autor critica a los gobernantes.',
                  'La Golondrina murió a los pies del Príncipe.',
                  'El Príncipe fue el mejor gobernante.',
                  'El cuento es triste.'], 1),
             _op('¿Cuál de estas oraciones es una interpretación?',
                 ['La estatua fue fundida en un horno.',
                  'El corazón de plomo no se fundió.',
                  'El autor critica a las autoridades que solo piensan en sí mismas.',
                  'La Golondrina llevó el rubí a la costurera.'], 2),
             _esc('Explica un aspecto del cuento que se puede debatir y por qué hay más de una '
                  'opinión posible.'),
         ]),
    _act('principe', 'MAESTRO', 1, 'Analizar el relato desde dos perspectivas.', 'critica', 1,
         'Mirar la historia desde el punto de vista de dos personajes distintos.', [
             _esc('Cuenta cómo ve la Golondrina lo que ocurre en la ciudad.', 25),
             _esc('Cuenta cómo ve el alcalde lo que ocurre con la estatua. Compara ambas '
                  'perspectivas.', 25),
         ]),
    _act('principe', 'MAESTRO', 2, 'Formular argumentos para cada interpretación.', 'critica', 1,
         'Sostener con argumentos dos interpretaciones distintas del cuento.', [
             _op('¿Qué parte del cuento apoya la interpretación de que es una crítica social?',
                 ['La Golondrina se enamora del Junco',
                  'Los ricos festejan en sus palacios mientras los mendigos esperan a sus '
                  'puertas',
                  'Las golondrinas viajan a Egipto', 'El Príncipe tiene ojos de zafiro'], 1),
             _esc('Escribe un argumento para la interpretación de que el cuento trata del '
                  'sacrificio por amor y otro para la de que es una crítica social.', 35),
         ]),
    _act('principe', 'MAESTRO', 3, 'Evaluar cuál está mejor sustentada.', 'critica', 1,
         'Comparar interpretaciones y decidir cuál tiene más apoyo en el texto.', [
             _op('¿Qué hace que una interpretación esté mejor sustentada?',
                 ['Que sea la más corta',
                  'Que tenga más evidencias del texto que la respalden',
                  'Que la diga un adulto', 'Que tenga un final feliz'], 1),
             _esc('Evalúa cuál de las dos interpretaciones del cuento está mejor sustentada y '
                  'justifica tu elección con evidencias.', 30),
         ]),
    _act('principe', 'MAESTRO', 4,
         'Crear un final alternativo y explicar cómo cambiaría el mensaje.', 'critica', 1,
         'Crear otro final y analizar cómo cambia el sentido de la historia.', [
             _esc('Escribe un final alternativo para el cuento.', 40),
             _esc('Explica cómo cambiaría el mensaje del cuento con tu nuevo final.', 20),
         ]),
]

ACTIVIDADES = SELVA + ISLA + PRINCIPE
POR_ID = {a['id']: a for a in ACTIVIDADES}


def por_id(actividad_id):
    return POR_ID.get(actividad_id)


def de_nivel(nivel):
    return [a for a in ACTIVIDADES if a['nivel'] == nivel]


def de_libro_nivel(libro_id, nivel):
    return [a for a in ACTIVIDADES if a['libro_id'] == libro_id and a['nivel'] == nivel]
