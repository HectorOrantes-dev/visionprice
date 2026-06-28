import 'package:injectable/injectable.dart';

@lazySingleton
class TokenStorage {
  String? _token;

  bool get hasToken => _token != null && _token!.isNotEmpty;
  
  String? get token => _token;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }
}
