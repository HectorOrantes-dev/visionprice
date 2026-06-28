import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

/// Contrato del datasource remoto de autenticación.
abstract interface class AuthRemoteDatasource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

/// Implementación del datasource con datos mock.
@Injectable(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // TODO: reemplazar con Dio/Firebase Auth real
    await Future.delayed(const Duration(milliseconds: 800));
    return UserModel(
      id: 'user_demo',
      name: 'Usuario Demo',
      email: email,
      role: 'maestro_obra', // TODO: obtener desde el backend
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: role,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Retorna null si no hay sesión activa
    return null;
  }
}
