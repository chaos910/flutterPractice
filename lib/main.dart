import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpractice/helpers/loading/loading_screen.dart';
import 'package:flutterpractice/services/auth/bloc/auth_bloc.dart';
import 'package:flutterpractice/services/auth/bloc/auth_event.dart';
import 'package:flutterpractice/services/auth/bloc/auth_state.dart';
import 'package:flutterpractice/services/auth/firebase_auth_provider.dart';
import 'package:flutterpractice/util/show_error_dialog.dart';
import 'package:flutterpractice/views/home_page_view.dart';
import 'package:flutterpractice/views/login_view.dart';
import 'package:flutterpractice/views/register_view.dart';
import 'package:flutterpractice/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
            context: context, text: state.loadingText ?? "Please wait...");
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const HomePageView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else if (state is AuthStateGetUserName) {
        return const Scaffold(
          body: Text("We got your Username"),
        );
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
