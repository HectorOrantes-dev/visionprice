import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Aviso de Privacidad Integral. Se muestra como pantalla completa desde el
/// enlace ubicado en la vista de login (y reutilizable desde otras vistas).
class PrivacyNoticeScreen extends StatelessWidget {
  const PrivacyNoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'Aviso de Privacidad',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _blocks.map((b) => b.build(context)).toList(),
          ),
        ),
      ),
    );
  }
}

/// Un bloque de contenido del aviso. Cada variante se renderiza con su propio
/// estilo (título, sección, párrafo, viñeta o nota destacada).
abstract class _Block {
  const _Block();
  Widget build(BuildContext context);
}

class _Title extends _Block {
  final String text;
  const _Title(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
            height: 1.3,
          ),
        ),
      );
}

class _Section extends _Block {
  final String text;
  const _Section(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: context.colors.primary,
            height: 1.4,
          ),
        ),
      );
}

class _Paragraph extends _Block {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: context.colors.textSecondary,
            height: 1.6,
          ),
        ),
      );
}

class _Bullet extends _Block {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 7, right: 10),
              child: Icon(Icons.circle, size: 6, color: context.colors.primary),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
}

class _Note extends _Block {
  final String text;
  const _Note(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.colors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.border),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.5,
              color: context.colors.textPrimary,
              height: 1.6,
            ),
          ),
        ),
      );
}

/// Contenido íntegro del aviso de privacidad.
const List<_Block> _blocks = [
  _Title('AVISO DE PRIVACIDAD INTEGRAL'),
  _Paragraph(
    'De conformidad con lo establecido en la Ley Federal de Protección de '
    'Datos Personales en Posesión de los Particulares (en adelante, la '
    '"Ley"), su Reglamento y los Lineamientos del Aviso de Privacidad, se '
    'pone a su disposición el presente Aviso de Privacidad.',
  ),

  _Section('I. IDENTIDAD Y DOMICILIO DEL RESPONSABLE'),
  _Paragraph(
    'Hector Roman Robles Orantes (en adelante, el "Responsable"), con '
    'domicilio en Calle Colinas 338, Colonia Las Águilas, Tuxtla Gutiérrez, '
    'Chiapas, es el responsable del uso y protección de sus datos personales, '
    'y al respecto le informa lo siguiente:',
  ),

  _Section('II. DATOS PERSONALES QUE RECABAMOS'),
  _Paragraph(
    'Para llevar a cabo las finalidades descritas en el presente aviso de '
    'privacidad, recabaremos y utilizaremos los siguientes datos personales:',
  ),
  _Bullet('Nombre completo.'),
  _Bullet('Correo electrónico.'),
  _Bullet('Número de teléfono.'),
  _Bullet('Contraseña de la cuenta.'),
  _Paragraph(
    'Asimismo, para el correcto funcionamiento de nuestra aplicación móvil, '
    'requeriremos de su autorización explícita a través de los permisos de su '
    'dispositivo para acceder a:',
  ),
  _Bullet('Ubicación GPS.'),
  _Bullet('Cámara.'),
  _Bullet('Galería de fotos.'),
  _Bullet('Micrófono.'),

  _Section('III. DATOS PERSONALES SENSIBLES'),
  _Paragraph(
    'Además de los datos personales mencionados anteriormente, le informamos '
    'que, para cumplir con las finalidades de nuestra aplicación, recabaremos '
    'y trataremos los siguientes datos personales sensibles, los cuales '
    'requieren de especial protección:',
  ),
  _Bullet(
    'Datos financieros y patrimoniales: Información de tarjetas de crédito '
    'para el procesamiento de pagos.',
  ),
  _Note(
    'Importante: Al tratarse de datos sensibles, patrimoniales y financieros, '
    'la ley exige requerir de su consentimiento expreso para su tratamiento. '
    'Este se recabará electrónicamente al momento de aceptar los términos y el '
    'presente aviso de privacidad dentro de la aplicación antes de recopilar '
    'dicha información.',
  ),

  _Section('IV. FINALIDADES DEL TRATAMIENTO'),
  _Paragraph(
    'Los datos personales que recabamos de usted, los utilizaremos para las '
    'siguientes finalidades principales que son estrictamente necesarias para '
    'el servicio que solicita:',
  ),
  _Bullet('Crear y administrar su cuenta de usuario dentro de la aplicación.'),
  _Bullet(
    'Procesar cobros y pagos derivados de los servicios o productos ofrecidos '
    'dentro de la app.',
  ),
  _Bullet(
    'Brindar, operar y mantener el servicio principal de la aplicación móvil '
    'de acuerdo con sus funcionalidades.',
  ),
  _Note(
    '(Nota: El Responsable no tratará sus datos personales para finalidades '
    'secundarias o accesorias, tales como envío de publicidad o mercadotecnia, '
    'por lo que su información se limita a la provisión del servicio).',
  ),

  _Section('V. TRANSFERENCIA DE DATOS PERSONALES'),
  _Paragraph(
    'Le informamos que sus datos personales (incluyendo los financieros) son '
    'compartidos dentro y fuera del país con las siguientes empresas u '
    'organizaciones distintas a nosotros, exclusivamente para los siguientes '
    'fines que son necesarios para la prestación de nuestros servicios y la '
    'operatividad de la aplicación:',
  ),
  _Bullet(
    'Firebase / Google Console: Para el alojamiento de bases de datos, '
    'autenticación de usuarios, análisis de rendimiento y funcionamiento '
    'general de la infraestructura de la nube de la aplicación.',
  ),
  _Bullet(
    'Conekta / PayPal: Proveedores y pasarelas de pago para realizar de forma '
    'segura la validación, autorización y procesamiento de las transacciones '
    'realizadas mediante tarjetas de crédito.',
  ),
  _Paragraph(
    'Las empresas mencionadas operan bajo sus propias políticas de privacidad '
    'y estrictos estándares de seguridad. Si usted no manifiesta su negativa u '
    'oposición, entenderemos que nos ha otorgado su consentimiento para estas '
    'transferencias, indispensables para usar la app.',
  ),

  _Section('VI. DERECHOS ARCO Y REVOCACIÓN DEL CONSENTIMIENTO'),
  _Paragraph(
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
  _Paragraph(
    'Para el ejercicio de cualquiera de los derechos ARCO, o para revocar el '
    'consentimiento que nos haya otorgado para el tratamiento de sus datos '
    'personales, usted deberá enviar una solicitud por escrito al siguiente '
    'correo electrónico:',
  ),
  _Note('Correo electrónico de atención: fastcodeope@gmail.com'),
  _Paragraph('Su solicitud deberá contener, por lo menos:'),
  _Bullet(
    'Su nombre completo y la cuenta de correo electrónico registrada en la '
    'app.',
  ),
  _Bullet(
    'Los documentos que acrediten su identidad (copia de identificación '
    'oficial).',
  ),
  _Bullet(
    'La descripción clara y precisa de los datos personales respecto de los '
    'que busca ejercer alguno de los derechos ARCO.',
  ),
  _Bullet(
    'Cualquier otro elemento o documento que facilite la localización de sus '
    'datos personales.',
  ),
  _Paragraph(
    'Daremos respuesta a su solicitud en un plazo máximo de 20 días hábiles '
    'contados a partir de la recepción, a través del mismo medio (correo '
    'electrónico).',
  ),

  _Section('VII. USO DE TECNOLOGÍAS DE RASTREO'),
  _Paragraph(
    'Le informamos que en nuestra aplicación móvil no utilizamos cookies, web '
    'beacons u otras tecnologías de rastreo, no contamos con vistas web '
    'integradas para fines de monitoreo y no implementamos motores de '
    'publicidad de terceros para recabar datos de comportamiento sobre sus '
    'hábitos de navegación.',
  ),

  _Section('VIII. CAMBIOS AL AVISO DE PRIVACIDAD'),
  _Paragraph(
    'El presente aviso de privacidad puede sufrir modificaciones, cambios o '
    'actualizaciones derivadas de nuevos requerimientos legales; de nuestras '
    'propias necesidades por los productos o servicios que ofrecemos; de '
    'nuestras prácticas de privacidad; de cambios en nuestro modelo de '
    'negocio, o por otras causas.',
  ),
  _Paragraph(
    'Nos comprometemos a mantenerlo informado sobre los cambios que pueda '
    'sufrir el presente aviso de privacidad, publicando cualquier '
    'actualización directamente dentro de la aplicación móvil en la sección '
    'correspondiente a "Aviso de Privacidad" o "Términos Legales".',
  ),
  _Note('Última actualización: 26 de junio de 2026'),
];
