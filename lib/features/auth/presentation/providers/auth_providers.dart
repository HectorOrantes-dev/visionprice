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
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) =>
    AuthRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepositoryImpl(
      ref.watch(authRemoteDataSourceProvider),
      ref.watch(tokenStorageProvider),
      ref.watch(localDatabaseProvider),
    );

// --- Use cases (uno por acción de negocio) ---

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
VerifyTwoFactorUseCase verifyTwoFactorUseCase(VerifyTwoFactorUseCaseRef ref) =>
    VerifyTwoFactorUseCase(ref.watch(authRepositoryProvider));

@riverpod
GoogleLoginUseCase googleLoginUseCase(GoogleLoginUseCaseRef ref) =>
    GoogleLoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
GoogleRegisterUseCase googleRegisterUseCase(GoogleRegisterUseCaseRef ref) =>
    GoogleRegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
GetRolesUseCase getRolesUseCase(GetRolesUseCaseRef ref) =>
    GetRolesUseCase(ref.watch(authRepositoryProvider));

@riverpod
RegisterUseCase registerUseCase(RegisterUseCaseRef ref) =>
    RegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(ForgotPasswordUseCaseRef ref) =>
    ForgotPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
VerifyResetCodeUseCase verifyResetCodeUseCase(VerifyResetCodeUseCaseRef ref) =>
    VerifyResetCodeUseCase(ref.watch(authRepositoryProvider));

@riverpod
ResetPasswordUseCase resetPasswordUseCase(ResetPasswordUseCaseRef ref) =>
    ResetPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
GetPerfilUseCase getPerfilUseCase(GetPerfilUseCaseRef ref) =>
    GetPerfilUseCase(ref.watch(authRepositoryProvider));

@riverpod
LogoutUseCase logoutUseCase(LogoutUseCaseRef ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider));
