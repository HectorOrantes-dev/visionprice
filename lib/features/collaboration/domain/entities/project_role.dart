enum ProjectRole {
  arquitecto('arquitecto', 'Arquitecto'),
  ingenieroCivil('ingeniero_civil', 'Ingeniero Civil'),
  maestroObra('maestro_obra', 'Maestro de Obra'),
  colaborador('colaborador', 'Colaborador');

  final String apiValue;
  final String label;

  const ProjectRole(this.apiValue, this.label);

  static ProjectRole fromApi(String value) {
    return ProjectRole.values.firstWhere(
      (r) => r.apiValue == value,
      orElse: () => ProjectRole.colaborador,
    );
  }
}
