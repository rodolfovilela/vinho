import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:vinho/services/auth_service.dart';
import 'package:vinho/theme/gradient_border_container.dart';
import 'package:vinho/theme/ov_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OVTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: OVTheme.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title:  Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              '/assets/assets/images/glass.png',
              height: 40,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bem-vindo de volta',
                style: OVTheme.titlesBase.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Faça login para continuar',
                style: OVTheme.bodyBase.copyWith(
                  color: OVTheme.muted,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: GradientBorderContainer(
                  borderRadius: BorderRadius.circular(16),
                  gradientColors: [
                    OVTheme.semiTransparent,
                    OVTheme.semiTransparent
                  ],
                  backgroundColor: Colors.white,
                  borderWidth: 1.5,
                  child: FormBuilder(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            style: OVTheme.bodyBase.copyWith(fontSize: 16),
                            name: 'email',
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: OVTheme.muted,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: OVTheme.semiTransparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: OVTheme.primaryRed, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          FormBuilderTextField(
                            style: OVTheme.bodyBase.copyWith(fontSize: 16),
                            name: 'password',
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: Icon(
                                Icons.lock_outlined,
                                color: OVTheme.muted,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: OVTheme.semiTransparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: OVTheme.primaryRed, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Esqueceu a senha?',
                                style: OVTheme.bodyBase.copyWith(
                                  color: OVTheme.primaryRed,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: OVTheme.primaryColor,
                                foregroundColor: OVTheme.backgroundColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: OVTheme.semiTransparent,
                                    width: 0.6,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  final values = _formKey.currentState!.value;
                                  final authService = AuthService();
                                  final userCredential = await authService.signInWithEmailAndPassword(
                                    values['email'],
                                    values['password'],
                                  );
                                  if (userCredential != null) {
                                    context.go('/');
                                  }
                                }
                              },
                              child: Text(
                                'Entrar',
                                style: OVTheme.bodyBase.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Não tem conta?',
                                style: OVTheme.bodyBase.copyWith(color: OVTheme.muted),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to signup
                                },
                                child: Text(
                                  'Cadastre-se',
                                  style: OVTheme.bodyBase.copyWith(
                                    color: OVTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

