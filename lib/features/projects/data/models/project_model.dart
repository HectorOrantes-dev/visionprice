import '../../domain/entities/project.dart';

/// Modelo DTO de Project — capa Data con serialización JSON.
class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.workType,
    required super.city,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.estimateId,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      workType: WorkType.values.firstWhere(
        (e) => e.name == json['work_type'],
        orElse: () => WorkType.mixed,
      ),
      city: json['city'] as String,
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProjectStatus.active,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      estimateId: json['estimate_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'work_type': workType.name,
        'city': city,
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'estimate_id': estimateId,
      };

  factory ProjectModel.fromEntity(Project entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      workType: entity.workType,
      city: entity.city,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      estimateId: entity.estimateId,
    );
  }
}
