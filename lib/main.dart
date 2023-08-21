import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpractice/constants/routes.dart';
import 'package:flutterpractice/services/auth/auth_service.dart';
import 'package:flutterpractice/services/auth/bloc/auth_bloc.dart';
import 'package:flutterpractice/services/auth/bloc/auth_event.dart';
import 'package:flutterpractice/services/auth/bloc/auth_state.dart';
import 'package:flutterpractice/services/auth/firebase_auth_provider.dart';
import 'package:flutterpractice/views/home_page_view.dart';
import 'package:flutterpractice/views/login_view.dart';
import 'package:flutterpractice/views/register_view.dart';
import 'package:flutterpractice/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo App',
    theme: ThemeData(
      useMaterial3: true,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      homeRoute: (context) => const HomePageView(),
      verityEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const HomePageView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
