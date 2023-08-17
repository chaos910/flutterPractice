import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../constants/routes.dart';
import '../services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your email"),
          const Text(
              "If you haven't received the email yet, press the button below"),
          TextButton(
              onPressed: () async {
                AuthService.firebase().sendEmailVerification();
              },
              child: const Text("Send email verification")),
          TextButton(
            onPressed: () {
              final user = AuthService.firebase().currentUser;
              devtools.log(user?.email ??
                  "null\n${(user?.isEmailVerified ?? false) as String}");
            },
            child: const Text("User Name"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }
}
