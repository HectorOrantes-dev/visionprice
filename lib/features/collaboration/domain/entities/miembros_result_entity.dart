import 'miembro_entity.dart';

class MiembrosResultEntity {
  final bool esDueno;
  final List<MiembroEntity> miembros;

  const MiembrosResultEntity({
    required this.esDueno,
    required this.miembros,
  });

  factory MiembrosResultEntity.fromJson(Map<String, dynamic> json) {
    final miembrosList = json['miembros'] as List<dynamic>? ?? [];
    return MiembrosResultEntity(
      esDueno: json['es_dueno'] == true,
      miembros: miembrosList
          .whereType<Map<String, dynamic>>()
          .map((m) => MiembroEntity.fromJson(m))
          .toList(),
    );
  }
}
