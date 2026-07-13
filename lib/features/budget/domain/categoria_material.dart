import '../../recording/domain/entities/superficie_entity.dart';
import 'entities/producto_entity.dart';

/// Lógica para identificar el material (categoría) de un item de la cotización.
///
/// El ML entrega superficies con un `tipo` ('piso', 'pared'…) y una
/// `descripcion` ('cambio de pintura', 'piso sala'…). A partir de ese texto
/// resolvemos la **categoría canónica** del material (ej. "cambio de pintura"
/// → `pintura`). Esa categoría viaja al backend para que el microservicio solo
/// devuelva la ubicación y los productos de los proveedores que venden ese
/// material.
///
/// Cada categoría canónica coincide con las reglas del backend
/// (`/cotizaciones/materiales`): piso, azulejo, zoclo, pintura, impermeabilizante.
class CategoriaMaterial {
  const CategoriaMaterial._();

  /// Palabras clave por categoría canónica. Se comparan sin acentos ni
  /// mayúsculas contra el `tipo`/`descripcion` de la superficie o la
  /// `categoria` del producto.
  static const Map<String, List<String>> _sinonimos = {
    'pintura': [
      'pintura',
      'pintar',
      'color',
      'recubrimiento',
      'esmalte',
      'vinilica',
      'laca',
      'barniz',
    ],
    'impermeabilizante': [
      'impermeabilizante',
      'impermeabilizar',
      'impermeabilizacion',
      'sellador',
    ],
    'piso': ['piso', 'loseta', 'losa', 'ceramica', 'porcelanato', 'porcelanico'],
    'azulejo': ['azulejo', 'mosaico', 'revestimiento', 'talavera'],
    'zoclo': ['zoclo', 'zocalo', 'rodapie'],
  };

  /// Categoría canónica de una superficie, o `null` si no se pudo identificar
  /// (en ese caso no se filtra: se muestran todos los materiales).
  static String? deSuperficie(SuperficieEntity s) {
    // La descripción es más específica ("cambio de pintura"); si no clasifica,
    // se intenta con el tipo ('piso', 'pared').
    return _clasificar('${s.descripcion} ${s.tipo}');
  }

  /// Conjunto de categorías canónicas distintas de una lista de superficies,
  /// para pedir al backend solo los proveedores de esos materiales.
  static List<String> deSuperficies(Iterable<SuperficieEntity>? superficies) {
    if (superficies == null) return const [];
    final set = <String>{};
    for (final s in superficies) {
      final cat = deSuperficie(s);
      if (cat != null) set.add(cat);
    }
    return set.toList();
  }

  /// Categoría canónica de un producto según su `categoria` de catálogo.
  static String? deProducto(ProductoEntity p) => _clasificar(p.categoria);

  /// ¿El producto corresponde al material de la superficie? Cuando alguno de los
  /// dos no se puede clasificar, se asume que sí (no ocultamos de más).
  static bool productoAplicaA(ProductoEntity p, SuperficieEntity s) {
    final catSup = deSuperficie(s);
    final catProd = deProducto(p);
    if (catSup == null || catProd == null) return true;
    return catSup == catProd;
  }

  /// Devuelve la categoría canónica cuyo sinónimo aparezca en [texto], o `null`.
  static String? _clasificar(String texto) {
    final t = _normalizar(texto);
    if (t.isEmpty) return null;
    for (final entry in _sinonimos.entries) {
      for (final syn in entry.value) {
        if (t.contains(syn)) return entry.key;
      }
    }
    return null;
  }

  static String _normalizar(String s) {
    s = s.toLowerCase().trim();
    const acentos = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
      'ñ': 'n',
    };
    final b = StringBuffer();
    for (final ch in s.split('')) {
      b.write(acentos[ch] ?? ch);
    }
    return b.toString();
  }
}
