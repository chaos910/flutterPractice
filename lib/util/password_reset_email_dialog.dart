import 'package:flutter/cupertino.dart';
import 'package:flutterpractice/util/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Password Reset",
    content:
        "We have now sent you a password reset link. Please check your email for more information",
    optionsBuilder: () => {
      "Okay": null,
    },
  );
}
