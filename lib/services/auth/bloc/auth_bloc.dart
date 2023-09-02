import 'package:bloc/bloc.dart';
import 'package:flutterpractice/services/auth/auth_provider.dart';
import 'package:flutterpractice/services/auth/bloc/auth_event.dart';
import 'package:flutterpractice/services/auth/bloc/auth_state.dart';
import 'dart:developer' as devtools show log;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // Get user
    on<AuthEventGetUser>((event, emit) {
      final user = provider.currentUser;
      devtools.log(
        user?.email ?? "null\n${(user?.isEmailVerified ?? false) as String}",
      );
      emit(AuthStateGetUserName(
        user: user,
        isLoading: false,
      ));
    });

    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    // Log in
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
              loadingText: "Please wait while I load you in",
            ),
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      }
    });

    // Log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    // Send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // Register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });
  }
}
