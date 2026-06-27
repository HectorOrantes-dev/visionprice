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
import '../../features/auth/presentation/providers/register_provider.dart'
    as _i74;
import '../network/api_client.dart' as _i557;
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
    gh.lazySingleton<_i973.TokenStorage>(
        () => _i973.TokenStorage(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i557.ApiClient>(() => _i557.ApiClient(
          gh<_i519.Client>(),
          gh<_i973.TokenStorage>(),
        ));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSourceImpl(gh<_i557.ApiClient>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i161.AuthRemoteDataSource>(),
          gh<_i973.TokenStorage>(),
        ));
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
    gh.factory<_i46.LogoutUseCase>(
        () => _i46.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i1005.LoginViewModel>(() => _i1005.LoginViewModel(
          gh<_i46.LoginUseCase>(),
          gh<_i46.VerifyTwoFactorUseCase>(),
          gh<_i46.GoogleLoginUseCase>(),
        ));
    gh.factory<_i74.RegisterViewModel>(() => _i74.RegisterViewModel(
          gh<_i46.RegisterUseCase>(),
          gh<_i46.VerifyTwoFactorUseCase>(),
          gh<_i46.GetRolesUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
