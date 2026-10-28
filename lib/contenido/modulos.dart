const codigosModulos = <String>['VEL', 'COM', 'INT', 'IMA', 'CON', 'RET'];

const nombresModulos = <String, String>{
  'VEL': 'NeuroRead',
  'COM': 'NeuroTest',
  'INT': 'NeuroInsight',
  'IMA': 'NeuroCreative',
  'CON': 'NeuroFocus',
  'RET': 'NeuroMemory',
};

const habilidadesModulos = <String, String>{
  'VEL': 'Velocidad lectora',
  'COM': 'Comprensión',
  'INT': 'Interpretación',
  'IMA': 'Creatividad',
  'CON': 'Concentración',
  'RET': 'Memoria',
};

const camposModulos = <String, String>{
  'VEL': 'velocidad',
  'COM': 'comprension',
  'INT': 'interpretacion',
  'IMA': 'imaginacion',
  'CON': 'concentracion',
  'RET': 'retencion',
};

const nombresNivelFocus = <String, String>{
  'FACIL': 'Fácil',
  'NORMAL': 'Normal',
  'DIFICIL': 'Difícil',
  'ULTRA': 'Ultra',
};

const mensajesComparacion = <int, String>{
  1: 'Subiste de nivel',
  0: 'Mantienes tu nivel',
  -1: 'Bajaste de nivel. Sigue practicando con tu ruta',
};

const detalleRetencion =
    'Memoria diferida: recordar detalles minutos después de leer consolida el aprendizaje.';

const lectorPromedio = 'Un lector adulto promedio está entre 180 y 240 PPM.';

const ppmMaximo = 800;
const ppmVelocista = 200;
const ppmReferencia = 240;
