import 'privacy_block.dart';
import 'privacy_bullet.dart';
import 'privacy_note.dart';
import 'privacy_paragraph.dart';
import 'privacy_section.dart';
import 'privacy_title.dart';

/// Contenido íntegro del aviso de privacidad. Antes el privado `_blocks`.
const List<PrivacyBlock> privacyNoticeBlocks = [
  PrivacyTitle('AVISO DE PRIVACIDAD INTEGRAL'),
  PrivacyParagraph(
    'De conformidad con lo establecido en la Ley Federal de Protección de '
    'Datos Personales en Posesión de los Particulares (en adelante, la '
    '"Ley"), su Reglamento y los Lineamientos del Aviso de Privacidad, se '
    'pone a su disposición el presente Aviso de Privacidad.',
  ),

  PrivacySection('I. IDENTIDAD Y DOMICILIO DEL RESPONSABLE'),
  PrivacyParagraph(
    'Hector Roman Robles Orantes (en adelante, el "Responsable"), con '
    'domicilio en Calle Colinas 338, Colonia Las Águilas, Tuxtla Gutiérrez, '
    'Chiapas, es el responsable del uso y protección de sus datos personales, '
    'y al respecto le informa lo siguiente:',
  ),

  PrivacySection('II. DATOS PERSONALES QUE RECABAMOS'),
  PrivacyParagraph(
    'Para llevar a cabo las finalidades descritas en el presente aviso de '
    'privacidad, recabaremos y utilizaremos los siguientes datos personales:',
  ),
  PrivacyBullet('Nombre completo.'),
  PrivacyBullet('Correo electrónico.'),
  PrivacyBullet('Número de teléfono.'),
  PrivacyBullet('Contraseña de la cuenta.'),
  PrivacyParagraph(
    'Asimismo, para el correcto funcionamiento de nuestra aplicación móvil, '
    'requeriremos de su autorización explícita a través de los permisos de su '
    'dispositivo para acceder a:',
  ),
  PrivacyBullet('Ubicación GPS.'),
  PrivacyBullet('Cámara.'),
  PrivacyBullet('Galería de fotos.'),
  PrivacyBullet('Micrófono.'),

  PrivacySection('III. DATOS PERSONALES SENSIBLES'),
  PrivacyParagraph(
    'Además de los datos personales mencionados anteriormente, le informamos '
    'que, para cumplir con las finalidades de nuestra aplicación, recabaremos '
    'y trataremos los siguientes datos personales sensibles, los cuales '
    'requieren de especial protección:',
  ),
  PrivacyBullet(
    'Datos financieros y patrimoniales: Información de tarjetas de crédito '
    'para el procesamiento de pagos.',
  ),
  PrivacyNote(
    'Importante: Al tratarse de datos sensibles, patrimoniales y financieros, '
    'la ley exige requerir de su consentimiento expreso para su tratamiento. '
    'Este se recabará electrónicamente al momento de aceptar los términos y el '
    'presente aviso de privacidad dentro de la aplicación antes de recopilar '
    'dicha información.',
  ),

  PrivacySection('IV. FINALIDADES DEL TRATAMIENTO'),
  PrivacyParagraph(
    'Los datos personales que recabamos de usted, los utilizaremos para las '
    'siguientes finalidades principales que son estrictamente necesarias para '
    'el servicio que solicita:',
  ),
  PrivacyBullet('Crear y administrar su cuenta de usuario dentro de la aplicación.'),
  PrivacyBullet(
    'Procesar cobros y pagos derivados de los servicios o productos ofrecidos '
    'dentro de la app.',
  ),
  PrivacyBullet(
    'Brindar, operar y mantener el servicio principal de la aplicación móvil '
    'de acuerdo con sus funcionalidades.',
  ),
  PrivacyNote(
    '(Nota: El Responsable no tratará sus datos personales para finalidades '
    'secundarias o accesorias, tales como envío de publicidad o mercadotecnia, '
    'por lo que su información se limita a la provisión del servicio).',
  ),

  PrivacySection('V. TRANSFERENCIA DE DATOS PERSONALES'),
  PrivacyParagraph(
    'Le informamos que sus datos personales (incluyendo los financieros) son '
    'compartidos dentro y fuera del país con las siguientes empresas u '
    'organizaciones distintas a nosotros, exclusivamente para los siguientes '
    'fines que son necesarios para la prestación de nuestros servicios y la '
    'operatividad de la aplicación:',
  ),
  PrivacyBullet(
    'Firebase / Google Console: Para el alojamiento de bases de datos, '
    'autenticación de usuarios, análisis de rendimiento y funcionamiento '
    'general de la infraestructura de la nube de la aplicación.',
  ),
  PrivacyBullet(
    'Conekta / PayPal: Proveedores y pasarelas de pago para realizar de forma '
    'segura la validación, autorización y procesamiento de las transacciones '
    'realizadas mediante tarjetas de crédito.',
  ),
  PrivacyParagraph(
    'Las empresas mencionadas operan bajo sus propias políticas de privacidad '
    'y estrictos estándares de seguridad. Si usted no manifiesta su negativa u '
    'oposición, entenderemos que nos ha otorgado su consentimiento para estas '
    'transferencias, indispensables para usar la app.',
  ),

  PrivacySection('VI. DERECHOS ARCO Y REVOCACIÓN DEL CONSENTIMIENTO'),
  PrivacyParagraph(
    'Usted tiene derecho a conocer qué datos personales tenemos de usted, para '
    'qué los utilizamos y las condiciones del uso que les damos (Acceso). '
    'Asimismo, es su derecho solicitar la corrección de su información personal '
    'en caso de que esté desactualizada, sea inexacta o incompleta '
    '(Rectificación); que la eliminemos de nuestros registros o bases de datos '
    'cuando considere que la misma no está siendo utilizada adecuadamente '
    '(Cancelación); así como oponerse al uso de sus datos personales para '
    'fines específicos (Oposición). Estos derechos se conocen como derechos '
    'ARCO.',
  ),
  PrivacyParagraph(
    'Para el ejercicio de cualquiera de los derechos ARCO, o para revocar el '
    'consentimiento que nos haya otorgado para el tratamiento de sus datos '
    'personales, usted deberá enviar una solicitud por escrito al siguiente '
    'correo electrónico:',
  ),
  PrivacyNote('Correo electrónico de atención: fastcodeope@gmail.com'),
  PrivacyParagraph('Su solicitud deberá contener, por lo menos:'),
  PrivacyBullet(
    'Su nombre completo y la cuenta de correo electrónico registrada en la '
    'app.',
  ),
  PrivacyBullet(
    'Los documentos que acrediten su identidad (copia de identificación '
    'oficial).',
  ),
  PrivacyBullet(
    'La descripción clara y precisa de los datos personales respecto de los '
    'que busca ejercer alguno de los derechos ARCO.',
  ),
  PrivacyBullet(
    'Cualquier otro elemento o documento que facilite la localización de sus '
    'datos personales.',
  ),
  PrivacyParagraph(
    'Daremos respuesta a su solicitud en un plazo máximo de 20 días hábiles '
    'contados a partir de la recepción, a través del mismo medio (correo '
    'electrónico).',
  ),

  PrivacySection('VII. USO DE TECNOLOGÍAS DE RASTREO'),
  PrivacyParagraph(
    'Le informamos que en nuestra aplicación móvil no utilizamos cookies, web '
    'beacons u otras tecnologías de rastreo, no contamos con vistas web '
    'integradas para fines de monitoreo y no implementamos motores de '
    'publicidad de terceros para recabar datos de comportamiento sobre sus '
    'hábitos de navegación.',
  ),

  PrivacySection('VIII. CAMBIOS AL AVISO DE PRIVACIDAD'),
  PrivacyParagraph(
    'El presente aviso de privacidad puede sufrir modificaciones, cambios o '
    'actualizaciones derivadas de nuevos requerimientos legales; de nuestras '
    'propias necesidades por los productos o servicios que ofrecemos; de '
    'nuestras prácticas de privacidad; de cambios en nuestro modelo de '
    'negocio, o por otras causas.',
  ),
  PrivacyParagraph(
    'Nos comprometemos a mantenerlo informado sobre los cambios que pueda '
    'sufrir el presente aviso de privacidad, publicando cualquier '
    'actualización directamente dentro de la aplicación móvil en la sección '
    'correspondiente a "Aviso de Privacidad" o "Términos Legales".',
  ),
  PrivacyNote('Última actualización: 26 de junio de 2026'),
];
