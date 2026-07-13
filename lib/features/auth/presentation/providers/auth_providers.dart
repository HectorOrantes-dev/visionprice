import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../../../core/di/local_database_provider.dart';
import '../../../../core/di/token_storage_provider.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_remote_datasource_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_providers.g.dart';

/// Cadena de dependencias de auth expresada como providers de Riverpod
/// (composición declarativa). Reemplaza el registro get_it para esta feature.
/// keepAlive: el repositorio cachea el perfil en memoria durante la sesión.

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      ref.watch(authRemoteDataSourceProvider),
      ref.watch(tokenStorageProvider),
      ref.watch(localDatabaseProvider),
    );

// --- Use cases (uno por acción de negocio) ---

@riverpod
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
VerifyTwoFactorUseCase verifyTwoFactorUseCase(Ref ref) =>
    VerifyTwoFactorUseCase(ref.watch(authRepositoryProvider));

@riverpod
GoogleLoginUseCase googleLoginUseCase(Ref ref) =>
    GoogleLoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
GoogleRegisterUseCase googleRegisterUseCase(Ref ref) =>
    GoogleRegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
GetRolesUseCase getRolesUseCase(Ref ref) =>
    GetRolesUseCase(ref.watch(authRepositoryProvider));

@riverpod
RegisterUseCase registerUseCase(Ref ref) =>
    RegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) =>
    ForgotPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
VerifyResetCodeUseCase verifyResetCodeUseCase(Ref ref) =>
    VerifyResetCodeUseCase(ref.watch(authRepositoryProvider));

@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) =>
    ResetPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
GetPerfilUseCase getPerfilUseCase(Ref ref) =>
    GetPerfilUseCase(ref.watch(authRepositoryProvider));

@riverpod
LogoutUseCase logoutUseCase(Ref ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider));
