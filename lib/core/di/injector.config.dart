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

import '../../features/account/data/datasources/account_remote_datasource.dart'
    as _i302;
import '../../features/account/data/datasources/account_remote_datasource_impl.dart'
    as _i598;
import '../../features/account/data/repositories/account_repository_impl.dart'
    as _i857;
import '../../features/account/domain/repositories/account_repository.dart'
    as _i1067;
import '../../features/account/domain/usecases/account_usecases.dart' as _i878;
import '../../features/account/presentation/providers/payment_method_provider.dart'
    as _i505;
import '../../features/account/presentation/providers/subscriptions_provider.dart'
    as _i488;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart'
    as _i1071;
import '../../features/auth/data/datasources/perfil_storage.dart' as _i1033;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/auth/presentation/providers/forgot_password_provider.dart'
    as _i1003;
import '../../features/auth/presentation/providers/login_provider.dart'
    as _i1005;
import '../../features/auth/presentation/providers/perfil_provider.dart'
    as _i801;
import '../../features/auth/presentation/providers/register_provider.dart'
    as _i74;
import '../../features/budget/data/datasources/cotizacion_remote_datasource.dart'
    as _i82;
import '../../features/budget/data/datasources/cotizacion_remote_datasource_impl.dart'
    as _i14;
import '../../features/budget/data/repositories/cotizacion_repository_impl.dart'
    as _i603;
import '../../features/budget/domain/repositories/cotizacion_repository.dart'
    as _i475;
import '../../features/budget/domain/usecases/cotizacion_usecases.dart'
    as _i924;
import '../../features/budget/domain/usecases/crear_cotizacion_use_case.dart'
    as _i978;
import '../../features/budget/domain/usecases/obtener_pdf_use_case.dart'
    as _i963;
import '../../features/budget/domain/usecases/obtener_productos_use_case.dart'
    as _i100;
import '../../features/budget/presentation/providers/export_pdf_provider.dart'
    as _i537;
import '../../features/budget/presentation/providers/nearby_stores_provider.dart'
    as _i453;
import '../../features/devices/data/datasources/dispositivo_remote_datasource.dart'
    as _i992;
import '../../features/devices/data/datasources/dispositivo_remote_datasource_impl.dart'
    as _i977;
import '../../features/devices/data/repositories/dispositivo_repository_impl.dart'
    as _i706;
import '../../features/devices/data/services/device_registrar.dart' as _i330;
import '../../features/devices/domain/repositories/dispositivo_repository.dart'
    as _i251;
import '../../features/devices/domain/usecases/borrar_dispositivo_use_case.dart'
    as _i922;
import '../../features/devices/domain/usecases/dispositivo_usecases.dart'
    as _i580;
import '../../features/devices/domain/usecases/registrar_dispositivo_use_case.dart'
    as _i632;
import '../../features/home/presentation/providers/home_provider.dart' as _i526;
import '../../features/notifications/data/datasources/notificacion_remote_datasource.dart'
    as _i587;
import '../../features/notifications/data/datasources/notificacion_remote_datasource_impl.dart'
    as _i359;
import '../../features/notifications/data/repositories/notificacion_repository_impl.dart'
    as _i40;
import '../../features/notifications/domain/repositories/notificacion_repository.dart'
    as _i382;
import '../../features/notifications/domain/usecases/marcar_notificacion_leida_use_case.dart'
    as _i22;
import '../../features/notifications/domain/usecases/notificacion_usecases.dart'
    as _i331;
import '../../features/notifications/domain/usecases/obtener_notificaciones_use_case.dart'
    as _i1048;
import '../../features/notifications/presentation/providers/notifications_provider.dart'
    as _i506;
import '../../features/project/data/datasources/proyecto_remote_datasource.dart'
    as _i1054;
import '../../features/project/data/datasources/proyecto_remote_datasource_impl.dart'
    as _i91;
import '../../features/project/data/repositories/proyecto_repository_impl.dart'
    as _i893;
import '../../features/project/domain/repositories/proyecto_repository.dart'
    as _i901;
import '../../features/project/domain/usecases/crear_proyecto_use_case.dart'
    as _i957;
import '../../features/project/domain/usecases/obtener_proyectos_use_case.dart'
    as _i828;
import '../../features/project/domain/usecases/proyecto_usecases.dart' as _i836;
import '../../features/recording/data/datasources/grabacion_remote_datasource.dart'
    as _i667;
import '../../features/recording/data/datasources/grabacion_remote_datasource_impl.dart'
    as _i901;
import '../../features/recording/data/repositories/grabacion_repository_impl.dart'
    as _i520;
import '../../features/recording/data/services/audio_recorder_service.dart'
    as _i695;
import '../../features/recording/domain/repositories/grabacion_repository.dart'
    as _i85;
import '../../features/recording/domain/usecases/calcular_metros_use_case.dart'
    as _i682;
import '../../features/recording/domain/usecases/grabacion_usecases.dart'
    as _i540;
import '../../features/recording/domain/usecases/obtener_grabacion_use_case.dart'
    as _i685;
import '../../features/recording/domain/usecases/obtener_historial_use_case.dart'
    as _i420;
import '../../features/recording/domain/usecases/subir_grabacion_use_case.dart'
    as _i393;
import '../../features/recording/presentation/providers/parameters_provider.dart'
    as _i407;
import '../../features/recording/presentation/providers/processing_provider.dart'
    as _i354;
import '../../features/recording/presentation/providers/recording_provider.dart'
    as _i719;
import '../../features/sync/data/datasources/sync_local_datasource.dart'
    as _i705;
import '../../features/sync/services/sync_service.dart' as _i406;
import '../network/api_client.dart' as _i557;
import '../network/connectivity_service.dart' as _i491;
import '../services/location_service.dart' as _i669;
import '../storage/local_database.dart' as _i998;
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
    gh.lazySingleton<_i669.LocationService>(() => _i669.LocationService());
    gh.lazySingleton<_i998.LocalDatabase>(() => _i998.LocalDatabase());
    gh.lazySingleton<_i973.TokenStorage>(() => _i973.TokenStorage());
    gh.lazySingleton<_i695.AudioRecorderService>(
      () => _i695.AudioRecorderService(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i1033.PerfilStorage>(
        () => _i1033.PerfilStorage(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i557.ApiClient>(() => _i557.ApiClient(
          gh<_i519.Client>(),
          gh<_i973.TokenStorage>(),
        ));
    gh.lazySingleton<_i705.SyncLocalDataSource>(
        () => _i705.SyncLocalDataSource(gh<_i998.LocalDatabase>()));
    gh.lazySingleton<_i667.GrabacionRemoteDataSource>(
        () => _i901.GrabacionRemoteDataSourceImpl(
              gh<_i557.ApiClient>(),
              gh<_i973.TokenStorage>(),
            ));
    gh.lazySingleton<_i992.DispositivoRemoteDataSource>(
        () => _i977.DispositivoRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i491.ConnectivityService>(
        () => _i491.ConnectivityService(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i302.AccountRemoteDataSource>(
        () => _i598.AccountRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i587.NotificacionRemoteDataSource>(
        () => _i359.NotificacionRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i1071.AuthRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i406.SyncService>(() => _i406.SyncService(
          gh<_i705.SyncLocalDataSource>(),
          gh<_i557.ApiClient>(),
          gh<_i973.TokenStorage>(),
          gh<_i998.LocalDatabase>(),
        ));
    gh.lazySingleton<_i1054.ProyectoRemoteDataSource>(
        () => _i91.ProyectoRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i82.CotizacionRemoteDataSource>(
        () => _i14.CotizacionRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i901.ProyectoRepository>(
        () => _i893.ProyectoRepositoryImpl(
              gh<_i1054.ProyectoRemoteDataSource>(),
              gh<_i998.LocalDatabase>(),
            ));
    gh.lazySingleton<_i475.CotizacionRepository>(() =>
        _i603.CotizacionRepositoryImpl(gh<_i82.CotizacionRemoteDataSource>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i161.AuthRemoteDataSource>(),
          gh<_i973.TokenStorage>(),
          gh<_i998.LocalDatabase>(),
        ));
    gh.factory<_i924.ObtenerProductosUseCase>(
        () => _i924.ObtenerProductosUseCase(gh<_i475.CotizacionRepository>()));
    gh.factory<_i924.CrearCotizacionUseCase>(
        () => _i924.CrearCotizacionUseCase(gh<_i475.CotizacionRepository>()));
    gh.factory<_i924.ObtenerPdfUseCase>(
        () => _i924.ObtenerPdfUseCase(gh<_i475.CotizacionRepository>()));
    gh.factory<_i978.CrearCotizacionUseCase>(
        () => _i978.CrearCotizacionUseCase(gh<_i475.CotizacionRepository>()));
    gh.factory<_i963.ObtenerPdfUseCase>(
        () => _i963.ObtenerPdfUseCase(gh<_i475.CotizacionRepository>()));
    gh.factory<_i100.ObtenerProductosUseCase>(
        () => _i100.ObtenerProductosUseCase(gh<_i475.CotizacionRepository>()));
    gh.lazySingleton<_i85.GrabacionRepository>(() =>
        _i520.GrabacionRepositoryImpl(gh<_i667.GrabacionRemoteDataSource>()));
    gh.lazySingleton<_i382.NotificacionRepository>(() =>
        _i40.NotificacionRepositoryImpl(
            gh<_i587.NotificacionRemoteDataSource>()));
    gh.factory<_i537.ExportPdfViewModel>(
        () => _i537.ExportPdfViewModel(gh<_i924.ObtenerPdfUseCase>()));
    gh.factory<_i453.NearbyStoresViewModel>(() => _i453.NearbyStoresViewModel(
          gh<_i924.ObtenerProductosUseCase>(),
          gh<_i924.CrearCotizacionUseCase>(),
          gh<_i669.LocationService>(),
        ));
    gh.lazySingleton<_i251.DispositivoRepository>(() =>
        _i706.DispositivoRepositoryImpl(
            gh<_i992.DispositivoRemoteDataSource>()));
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
    gh.factory<_i46.ForgotPasswordUseCase>(
        () => _i46.ForgotPasswordUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.VerifyResetCodeUseCase>(
        () => _i46.VerifyResetCodeUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.ResetPasswordUseCase>(
        () => _i46.ResetPasswordUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.GetPerfilUseCase>(
        () => _i46.GetPerfilUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i46.LogoutUseCase>(
        () => _i46.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i1067.AccountRepository>(
        () => _i857.AccountRepositoryImpl(gh<_i302.AccountRemoteDataSource>()));
    gh.factory<_i957.CrearProyectoUseCase>(
        () => _i957.CrearProyectoUseCase(gh<_i901.ProyectoRepository>()));
    gh.factory<_i828.ObtenerProyectosUseCase>(
        () => _i828.ObtenerProyectosUseCase(gh<_i901.ProyectoRepository>()));
    gh.factory<_i836.ObtenerProyectosUseCase>(
        () => _i836.ObtenerProyectosUseCase(gh<_i901.ProyectoRepository>()));
    gh.factory<_i836.CrearProyectoUseCase>(
        () => _i836.CrearProyectoUseCase(gh<_i901.ProyectoRepository>()));
    gh.factory<_i526.HomeViewModel>(() => _i526.HomeViewModel(
          gh<_i836.ObtenerProyectosUseCase>(),
          gh<_i836.CrearProyectoUseCase>(),
          gh<_i491.ConnectivityService>(),
          gh<_i46.GetPerfilUseCase>(),
        ));
    gh.factory<_i878.ObtenerSuscripcionesUseCase>(() =>
        _i878.ObtenerSuscripcionesUseCase(gh<_i1067.AccountRepository>()));
    gh.factory<_i682.CalcularMetrosUseCase>(
        () => _i682.CalcularMetrosUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i540.SubirGrabacionUseCase>(
        () => _i540.SubirGrabacionUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i540.ObtenerGrabacionUseCase>(
        () => _i540.ObtenerGrabacionUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i540.ObtenerHistorialUseCase>(
        () => _i540.ObtenerHistorialUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i540.CalcularMetrosUseCase>(
        () => _i540.CalcularMetrosUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i540.ActualizarTranscripcionUseCase>(() =>
        _i540.ActualizarTranscripcionUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i685.ObtenerGrabacionUseCase>(
        () => _i685.ObtenerGrabacionUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i420.ObtenerHistorialUseCase>(
        () => _i420.ObtenerHistorialUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i393.SubirGrabacionUseCase>(
        () => _i393.SubirGrabacionUseCase(gh<_i85.GrabacionRepository>()));
    gh.factory<_i22.MarcarNotificacionLeidaUseCase>(() =>
        _i22.MarcarNotificacionLeidaUseCase(
            gh<_i382.NotificacionRepository>()));
    gh.factory<_i331.ObtenerNotificacionesUseCase>(() =>
        _i331.ObtenerNotificacionesUseCase(gh<_i382.NotificacionRepository>()));
    gh.factory<_i331.MarcarNotificacionLeidaUseCase>(() =>
        _i331.MarcarNotificacionLeidaUseCase(
            gh<_i382.NotificacionRepository>()));
    gh.factory<_i1048.ObtenerNotificacionesUseCase>(() =>
        _i1048.ObtenerNotificacionesUseCase(
            gh<_i382.NotificacionRepository>()));
    gh.factory<_i488.SubscriptionsViewModel>(() =>
        _i488.SubscriptionsViewModel(gh<_i878.ObtenerSuscripcionesUseCase>()));
    gh.factory<_i922.BorrarDispositivoUseCase>(() =>
        _i922.BorrarDispositivoUseCase(gh<_i251.DispositivoRepository>()));
    gh.factory<_i580.RegistrarDispositivoUseCase>(() =>
        _i580.RegistrarDispositivoUseCase(gh<_i251.DispositivoRepository>()));
    gh.factory<_i580.BorrarDispositivoUseCase>(() =>
        _i580.BorrarDispositivoUseCase(gh<_i251.DispositivoRepository>()));
    gh.factory<_i632.RegistrarDispositivoUseCase>(() =>
        _i632.RegistrarDispositivoUseCase(gh<_i251.DispositivoRepository>()));
    gh.factory<_i719.RecordingViewModel>(() => _i719.RecordingViewModel(
          gh<_i695.AudioRecorderService>(),
          gh<_i540.SubirGrabacionUseCase>(),
          gh<_i491.ConnectivityService>(),
          gh<_i836.ObtenerProyectosUseCase>(),
          gh<_i406.SyncService>(),
        ));
    gh.factory<_i801.PerfilViewModel>(
        () => _i801.PerfilViewModel(gh<_i46.GetPerfilUseCase>()));
    gh.factory<_i506.NotificationsViewModel>(() => _i506.NotificationsViewModel(
          gh<_i331.ObtenerNotificacionesUseCase>(),
          gh<_i331.MarcarNotificacionLeidaUseCase>(),
        ));
    gh.factory<_i354.ProcessingViewModel>(
        () => _i354.ProcessingViewModel(gh<_i540.ObtenerGrabacionUseCase>()));
    gh.factory<_i505.PaymentMethodViewModel>(() =>
        _i505.PaymentMethodViewModel(gh<_i878.ObtenerSuscripcionesUseCase>()));
    gh.factory<_i407.ParametersViewModel>(() => _i407.ParametersViewModel(
          gh<_i540.ObtenerGrabacionUseCase>(),
          gh<_i540.CalcularMetrosUseCase>(),
          gh<_i540.ActualizarTranscripcionUseCase>(),
        ));
    gh.lazySingleton<_i330.DeviceRegistrar>(() => _i330.DeviceRegistrar(
          gh<_i580.RegistrarDispositivoUseCase>(),
          gh<_i580.BorrarDispositivoUseCase>(),
        ));
    gh.factory<_i74.RegisterViewModel>(() => _i74.RegisterViewModel(
          gh<_i46.RegisterUseCase>(),
          gh<_i46.VerifyTwoFactorUseCase>(),
          gh<_i46.GetRolesUseCase>(),
          gh<_i330.DeviceRegistrar>(),
        ));
    gh.factory<_i1003.ForgotPasswordViewModel>(
        () => _i1003.ForgotPasswordViewModel(
              gh<_i46.ForgotPasswordUseCase>(),
              gh<_i46.VerifyResetCodeUseCase>(),
              gh<_i46.ResetPasswordUseCase>(),
              gh<_i330.DeviceRegistrar>(),
            ));
    gh.factory<_i1005.LoginViewModel>(() => _i1005.LoginViewModel(
          gh<_i46.LoginUseCase>(),
          gh<_i46.VerifyTwoFactorUseCase>(),
          gh<_i46.GoogleLoginUseCase>(),
          gh<_i330.DeviceRegistrar>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
