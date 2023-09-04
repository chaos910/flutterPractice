import 'package:flutter_test/flutter_test.dart';
import 'package:flutterpractice/services/auth/auth_exceptions.dart';
import 'package:flutterpractice/services/auth/auth_provider.dart';
import 'package:flutterpractice/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test("Should not be initialized to begin with", () {
      expect(
        provider.isInitialized,
        false,
      );
    });

    test("Cannot log out if not initialized", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test("Should be able to be initialized", () async {
      await provider.initialize();
      expect(
        provider.isInitialized,
        true,
      );
    });

    test("User should be null after initialization", () {
      expect(
        provider.currentUser,
        null,
      );
    });

    test(
      "Should be able to initialize in less than 2 seconds",
      () async {
        await provider.initialize();
        expect(
          provider.isInitialized,
          true,
        );
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test("Create user should delegate to logIn function", () async {
      await provider.initialize();
      final badEmailUser = provider.createUser(
        email: "dinurasathsindu@2001gmail.com",
        password: "ds910hv",
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      final badPasswordUser = provider.createUser(
        email: "dinurasatsindu@2001gmail.com",
        password: "ds910hvr",
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );

      final user = await provider.createUser(
        email: "dinuwork@gmail.com",
        password: "password",
      );
      expect(
        provider.currentUser,
        user,
      );
    });
    test("Logged in user should be able to get verified", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
      expect(user.email, "dinurawork@gmail.com");
    });

    test("Should be able to logout and login again", () async {
      await provider.logOut();
      await provider.logIn(
        email: "email",
        password: "password",
      );
      final user = provider.currentUser;
      expect(
        user,
        isNotNull,
      );
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "dinurasathsindu@2001gmail.com")
      throw UserNotFoundAuthException();
    if (password == "ds910hvr") throw WrongPasswordAuthException();
    const user = AuthUser(
        isEmailVerified: false, email: "dinurasathsindu2001@gmail.com");
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser =
        AuthUser(isEmailVerified: true, email: "dinurawork@gmail.com");
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}
