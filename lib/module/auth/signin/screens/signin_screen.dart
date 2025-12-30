import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/providers/auth_provider.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
      child: const _SignInContent(),
    );
  }
}

class _SignInContent extends StatefulWidget {
  const _SignInContent();
  @override
  State<_SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<_SignInContent> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.widthPercentage(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.heightPercentage(2)),
              Text(
                "Welcome\nBack",
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  fontSize: context.responsiveTextSize(32),
                ),
              ),
              SizedBox(height: context.heightPercentage(1.5)),
              Text(
                "Log in to continue your green journey.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  fontSize: context.responsiveTextSize(16),
                ),
              ),
              SizedBox(height: context.heightPercentage(6)),

              CommonTextField(ctrl: _emailCtrl, label: "Email", hint: "hello@example.com"),
              SizedBox(height: context.heightPercentage(2.5)),
              CommonTextField(
                ctrl: _passCtrl,
                label: "Password",
                hint: "Enter your password",
                isObscure: true,
              ),
              SizedBox(height: context.heightPercentage(2.5)),

              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: AppTheme.primary,
                    onChanged: (v) => setState(() => _rememberMe = v!),
                  ),
                  Text(
                    "Remember me",
                    style: TextStyle(
                      fontSize: context.responsiveTextSize(14),
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: context.responsiveTextSize(14),
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.heightPercentage(4)),

              SizedBox(
                width: double.infinity,
                height: context.hightForButton(56),
                child: ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          try {
                            await provider.signIn(_emailCtrl.text, _passCtrl.text, context);
                            if (context.mounted) context.go('/home');
                          } catch (e) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        },
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : Text("Log In", style: TextStyle(fontSize: context.responsiveTextSize(16))),
                ),
              ),

              SizedBox(height: context.heightPercentage(4)),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                      children: const [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
