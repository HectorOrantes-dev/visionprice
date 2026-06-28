// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/budget/data/datasources/budget_remote_datasource.dart'
    as _i985;
import '../../features/budget/data/repositories/budget_repository_impl.dart'
    as _i74;
import '../../features/budget/domain/repositories/budget_repository.dart'
    as _i438;
import '../../features/budget/domain/usecases/calculate_budget_usecase.dart'
    as _i432;
import '../../features/materials/data/datasources/materials_remote_datasource.dart'
    as _i692;
import '../../features/materials/data/repositories/materials_repository_impl.dart'
    as _i620;
import '../../features/materials/domain/repositories/materials_repository.dart'
    as _i1005;
import '../../features/materials/domain/usecases/get_materials_usecase.dart'
    as _i364;
import '../../features/projects/data/datasources/project_remote_datasource.dart'
    as _i1059;
import '../../features/projects/data/repositories/project_repository_impl.dart'
    as _i62;
import '../../features/projects/domain/repositories/project_repository.dart'
    as _i338;
import '../../features/projects/domain/usecases/get_projects_usecase.dart'
    as _i393;
import '../network/api_client.dart' as _i557;
import '../storage/token_storage.dart' as _i973;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i973.TokenStorage>(() => _i973.TokenStorage());
    gh.factory<_i1059.ProjectRemoteDatasource>(
        () => const _i1059.ProjectRemoteDatasourceImpl());
    gh.factory<_i985.BudgetRemoteDatasource>(
        () => const _i985.BudgetRemoteDatasourceImpl());
    gh.factory<_i692.MaterialsRemoteDatasource>(
        () => const _i692.MaterialsRemoteDatasourceImpl());
    gh.factory<_i438.BudgetRepository>(
        () => _i74.BudgetRepositoryImpl(gh<_i985.BudgetRemoteDatasource>()));
    gh.factory<_i161.AuthRemoteDatasource>(
        () => const _i161.AuthRemoteDatasourceImpl());
    gh.factory<_i432.GetBudgetUseCase>(
        () => _i432.GetBudgetUseCase(gh<_i438.BudgetRepository>()));
    gh.factory<_i432.ExportPdfUseCase>(
        () => _i432.ExportPdfUseCase(gh<_i438.BudgetRepository>()));
    gh.factory<_i432.UpdateContingencyUseCase>(
        () => _i432.UpdateContingencyUseCase(gh<_i438.BudgetRepository>()));
    gh.factory<_i338.ProjectRepository>(
        () => _i62.ProjectRepositoryImpl(gh<_i1059.ProjectRemoteDatasource>()));
    gh.factory<_i1005.MaterialsRepository>(() =>
        _i620.MaterialsRepositoryImpl(gh<_i692.MaterialsRemoteDatasource>()));
    gh.lazySingleton<_i557.ApiClient>(() => _i557.ApiClient(
          gh<_i519.Client>(),
          gh<_i973.TokenStorage>(),
        ));
    gh.factory<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i161.AuthRemoteDatasource>()));
    gh.factory<_i393.GetProjectsUseCase>(
        () => _i393.GetProjectsUseCase(gh<_i338.ProjectRepository>()));
    gh.factory<_i393.CreateProjectUseCase>(
        () => _i393.CreateProjectUseCase(gh<_i338.ProjectRepository>()));
    gh.factory<_i364.GetMaterialsUseCase>(
        () => _i364.GetMaterialsUseCase(gh<_i1005.MaterialsRepository>()));
    gh.factory<_i364.UpdateMaterialWasteUseCase>(() =>
        _i364.UpdateMaterialWasteUseCase(gh<_i1005.MaterialsRepository>()));
    gh.factory<_i46.LoginUseCase>(
        () => _i46.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.RegisterUseCase>(
        () => _i46.RegisterUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.LogoutUseCase>(
        () => _i46.LogoutUseCase(gh<_i787.AuthRepository>()));
    return this;
  }
}
