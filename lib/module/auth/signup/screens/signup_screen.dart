import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/services/di.dart';
import 'package:flutter_projects_week_6/core/providers/auth_provider.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:flutter_projects_week_6/utils/widgets/common_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
      child: const _SignUpContent(),
    );
  }
}

class _SignUpContent extends StatefulWidget {
  const _SignUpContent();
  @override
  State<_SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<_SignUpContent> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _agreeToTerms = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text("Step 1 of 3", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Create your\naccount",
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Sign up to start buying and selling rare plants today.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              CommonTextField(
                ctrl: _nameCtrl,
                label: 'Full Name',
                hint: 'e.g. Oliver Green',
                isObscure: false,
              ),
              const SizedBox(height: 20),
              CommonTextField(
                ctrl: _emailCtrl,
                label: 'Email',
                hint: 'hello@example.com',
                isObscure: false,
              ),
              const SizedBox(height: 20),
              CommonTextField(
                ctrl: _passCtrl,
                isObscure: true,
                label: 'Password',
                hint: 'Min. 8 characters',
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    activeColor: AppTheme.primary,
                    onChanged: (v) => (_agreeToTerms = v!),
                  ),
                  Expanded(
                    child: Text(
                      "I agree to the Terms of Service and Privacy Policy.",
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          try {
                            await provider.signUp(
                              _nameCtrl.text,
                              _emailCtrl.text,
                              _passCtrl.text,
                              context,
                            );
                            if (context.mounted) context.go('/home');
                          } catch (e) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        },
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
