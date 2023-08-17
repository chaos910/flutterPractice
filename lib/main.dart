import 'package:flutter/material.dart';
import 'package:flutterpractice/constants/routes.dart';
import 'package:flutterpractice/services/auth/auth_service.dart';
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
    home: const HomePage(),
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
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            final emailVerified = user?.isEmailVerified ?? false;
            if (user != null) {
              if (emailVerified) {
                return const HomePageView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
