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
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/auth/presentation/providers/login_provider.dart'
    as _i1005;
import '../../features/auth/presentation/providers/perfil_provider.dart'
    as _i801;
import '../../features/auth/presentation/providers/register_provider.dart'
    as _i74;
import '../../features/home/presentation/providers/home_provider.dart' as _i526;
import '../../features/project/data/datasources/proyecto_remote_datasource.dart'
    as _i1054;
import '../../features/project/data/repositories/proyecto_repository_impl.dart'
    as _i893;
import '../../features/project/domain/repositories/proyecto_repository.dart'
    as _i901;
import '../../features/project/domain/usecases/proyecto_usecases.dart' as _i836;
import '../../features/recording/data/datasources/grabacion_remote_datasource.dart'
    as _i667;
import '../../features/recording/data/repositories/grabacion_repository_impl.dart'
    as _i520;
import '../../features/recording/data/services/audio_recorder_service.dart'
    as _i695;
import '../../features/recording/domain/repositories/grabacion_repository.dart'
    as _i85;
import '../../features/recording/domain/usecases/grabacion_usecases.dart'
    as _i540;
import '../../features/recording/presentation/providers/parameters_provider.dart'
    as _i407;
import '../../features/recording/presentation/providers/processing_provider.dart'
    as _i354;
import '../../features/recording/presentation/providers/recording_provider.dart'
    as _i719;
import '../network/api_client.dart' as _i557;
import '../network/connectivity_service.dart' as _i491;
import '../storage/token_storage.dart' as _i973;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i973.TokenStorage>(() => _i973.TokenStorage());
    gh.lazySingleton<_i695.AudioRecorderService>(
      () => _i695.AudioRecorderService(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i557.ApiClient>(() => _i557.ApiClient(
          gh<_i519.Client>(),
          gh<_i973.TokenStorage>(),
        ));
    gh.lazySingleton<_i491.ConnectivityService>(
        () => _i491.ConnectivityService(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i667.GrabacionRemoteDataSource>(
        () => _i667.GrabacionRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i1054.ProyectoRemoteDataSource>(
        () => _i1054.ProyectoRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i901.ProyectoRepository>(() =>
        _i893.ProyectoRepositoryImpl(gh<_i1054.ProyectoRemoteDataSource>()));
    gh.factory<_i836.ObtenerProyectosUseCase>(
        () => _i836.ObtenerProyectosUseCase(gh<_i901.ProyectoRepository>()));
    gh.factory<_i836.CrearProyectoUseCase>(
        () => _i836.CrearProyectoUseCase(gh<_i901.ProyectoRepository>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i161.AuthRemoteDataSource>(),
          gh<_i973.TokenStorage>(),
        ));
    gh.factory<_i526.HomeViewModel>(() => _i526.HomeViewModel(
          gh<_i836.ObtenerProyectosUseCase>(),
          gh<_i836.CrearProyectoUseCase>(),
          gh<_i491.ConnectivityService>(),
        ));
    gh.lazySingleton<_i85.GrabacionRepository>(() =>
        _i520.GrabacionRepositoryImpl(gh<_i667.GrabacionRemoteDataSource>()));
    gh.factory<_i46.LoginUseCase>(
        () => _i46.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.VerifyTwoFactorUseCase>(
        () => _i46.VerifyTwoFactorUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.GetRolesUseCase>(
        () => _i46.GetRolesUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.RegisterUseCase>(
        () => _i46.RegisterUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.GoogleLoginUseCase>(
        () => _i46.GoogleLoginUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.GoogleRegisterUseCase>(
        () => _i46.GoogleRegisterUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.GetPerfilUseCase>(
        () => _i46.GetPerfilUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.LogoutUseCase>(
        () => _i46.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i74.RegisterViewModel>(() => _i74.RegisterViewModel(
          gh<_i46.RegisterUseCase>(),
          gh<_i46.VerifyTwoFactorUseCase>(),
          gh<_i46.GetRolesUseCase>(),
        ));
    gh.factory<_i540.SubirGrabacionUseCase>(
        () => _i540.SubirGrabacionUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i540.ObtenerGrabacionUseCase>(
        () => _i540.ObtenerGrabacionUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i540.ObtenerHistorialUseCase>(
        () => _i540.ObtenerHistorialUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i540.CalcularMetrosUseCase>(
        () => _i540.CalcularMetrosUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i407.ParametersViewModel>(() => _i407.ParametersViewModel(
          gh<_i540.ObtenerGrabacionUseCase>(),
          gh<_i540.CalcularMetrosUseCase>(),
        ));
    gh.factory<_i719.RecordingViewModel>(() => _i719.RecordingViewModel(
          gh<_i695.AudioRecorderService>(),
          gh<_i540.SubirGrabacionUseCase>(),
          gh<_i491.ConnectivityService>(),
          gh<_i836.ObtenerProyectosUseCase>(),
        ));
    gh.factory<_i1005.LoginViewModel>(() => _i1005.LoginViewModel(
          gh<_i46.LoginUseCase>(),
          gh<_i46.VerifyTwoFactorUseCase>(),
          gh<_i46.GoogleLoginUseCase>(),
        ));
    gh.factory<_i801.PerfilViewModel>(
        () => _i801.PerfilViewModel(gh<_i46.GetPerfilUseCase>()));
    gh.factory<_i354.ProcessingViewModel>(
        () => _i354.ProcessingViewModel(gh<_i540.ObtenerGrabacionUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
