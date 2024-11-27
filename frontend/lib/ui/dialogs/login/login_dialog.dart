import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:stacked/stacked.dart';

import 'login_dialog_model.dart';

class LoginDialog extends StackedView<LoginDialogModel> {
  const LoginDialog({super.key});

  @override
  Widget builder(BuildContext context, LoginDialogModel viewModel, Widget? child) {
    return LayoutBuilder(builder: (context, _) {
      final screenWidth = context.mediaQuery.size.width;
      var dialogWidth = screenWidth;

      if (dialogWidth > 700) {
        dialogWidth = 700;
      }

      return Dialog(
        child: SizedBox(
          width: dialogWidth,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  viewModel.registerNewAccount ? context.t.register : context.t.login,
                  style: context.theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: viewModel.usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: context.t.username,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: viewModel.passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: context.t.password,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: viewModel.registerNewAccount,
                      onChanged: (value) {
                        if (value == null) return;
                        viewModel.setRegisterNewAccount(value);
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(context.t.registerNewAccount),
                  ],
                ),
                const SizedBox(height: 32),
                FilledButton.tonal(
                  onPressed: viewModel.loginOrRegister,
                  child: Text(viewModel.registerNewAccount ? context.t.register : context.t.login),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  LoginDialogModel viewModelBuilder(BuildContext context) => LoginDialogModel();
}
