import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter_dew/shared/services/auth/auth_service.dart';
import 'package:mockito/mockito.dart';

// Mock class for the AuthService
class MockAuthService implements AuthService {
  @override
  late String url;

  @override
  Map<String, String> get header => {'Content-Type': 'application/json'};

  @override
  Future<http.Response> login(
      String email, String password, BuildContext context) async {
    // ทำการ mock response ที่ต้องการ
    if (email == 'valid@email.com' && password == 'validPassword') {
      return http.Response('{"token":"valid_token"}', 200);
    } else {
      return http.Response('{"error":"Invalid credentials"}', 401);
    }
  }

  @override
  Future<void> logout(context) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<http.Response> signUp(firstName, lastName, email, password, context) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    test('login should return valid token for valid credentials', () async {
      final response = await authService.login('valid@email.com',
          'validPassword', MockBuildContext() as BuildContext);

      expect(response.statusCode, 200);
      expect(response.body, '{"token":"valid_token"}');
    });

    test('login should return error for invalid credentials', () async {
      final response = await authService.login('invalid@email.com',
          'invalidPassword', MockBuildContext() as BuildContext);

      expect(response.statusCode, 401);
      expect(response.body, '{"error":"Invalid credentials"}');
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
