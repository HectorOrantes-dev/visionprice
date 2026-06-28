import 'package:equatable/equatable.dart';

/// Tipos de trabajo soportados por VisionPrice
enum WorkType {
  floor('Piso', 'floor_plan'),
  wall('Pared', 'wall'),
  ceiling('Techo', 'ceiling'),
  mixed('Mixto', 'construction');

  const WorkType(this.label, this.iconName);
  final String label;
  final String iconName;
}

/// Estado del proyecto
enum ProjectStatus {
  active('Activo'),
  completed('Completado'),
  archived('Archivado');

  const ProjectStatus(this.label);
  final String label;
}

/// Entidad pura Project — capa Domain
/// No depende de ningún framework externo
class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    required this.workType,
    required this.city,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.estimateId,
  });

  final String id;
  final String name;
  final WorkType workType;
  final String city;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? estimateId;

  /// ¿Tiene presupuesto generado?
  bool get hasEstimate => estimateId != null;

  /// Porcentaje de progreso del flujo (0.0 a 1.0)
  double get completionProgress {
    switch (status) {
      case ProjectStatus.active:
        return 0.5;
      case ProjectStatus.completed:
        return 1.0;
      case ProjectStatus.archived:
        return 1.0;
    }
  }

  Project copyWith({
    String? id,
    String? name,
    WorkType? workType,
    String? city,
    ProjectStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? estimateId,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      workType: workType ?? this.workType,
      city: city ?? this.city,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      estimateId: estimateId ?? this.estimateId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        workType,
        city,
        status,
        createdAt,
        updatedAt,
        estimateId,
      ];

  @override
  String toString() =>
      'Project(id: $id, name: $name, workType: ${workType.label}, city: $city, status: ${status.label})';
}
