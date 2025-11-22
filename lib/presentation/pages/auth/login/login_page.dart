import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/auth/login/usecases/send_code_use_case.dart';
import '../../../../domain/auth/login/usecases/verify_code_use_case.dart';
import '../../../../infrastructure/auth/login/adapters/login_repository_impl.dart';
import '../../../widgets/code_verification_modal.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/glass_card.dart';
import '../../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isProfessional = false;
  late final SendCodeUseCase _sendCodeUseCase;
  late final VerifyCodeUseCase _verifyCodeUseCase;

  @override
  void initState() {
    super.initState();
    final repository = LoginRepositoryImpl();
    _sendCodeUseCase = SendCodeUseCase(repository);
    _verifyCodeUseCase = VerifyCodeUseCase(repository);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleRequestCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final type = _isProfessional ? '1' : '0';
        await _sendCodeUseCase.execute(_emailController.text.trim(), type);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          _showCodeVerificationModal();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  void _showCodeVerificationModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CodeVerificationModal(
        email: _emailController.text.trim(),
        onVerify: (code) => _handleLogin(code),
      ),
    );
  }

  Future<void> _handleLogin(String code) async {
    Navigator.of(context).pop();

    setState(() {
      _isLoading = true;
    });

    try {
      final type = _isProfessional ? '1' : '0';
      final user = await _verifyCodeUseCase.execute(
        _emailController.text.trim(),
        code,
        type,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(
              username: user.username,
              email: user.email,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: GradientBackground(),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  width: 450,
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SvgPicture.asset(
                          'lib/presentation/assets/logo.svg',
                          height: 90,
                          width: 90,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Bienvenido',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Inicia sesión para continuar',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: TextStyle(
                              color: AppColors.textLight.withValues(alpha: 0.8),
                            ),
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(12),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.email_outlined,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.white.withValues(alpha: 0.6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: AppColors.slate200.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu correo';
                            }
                            if (!value.contains('@')) {
                              return 'Ingresa un correo válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.slate200.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  gradient: _isProfessional
                                      ? AppColors.primaryGradient
                                      : null,
                                  color: _isProfessional
                                      ? null
                                      : AppColors.slate200,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _isProfessional
                                        ? AppColors.primary
                                        : AppColors.slate300,
                                    width: 2,
                                  ),
                                ),
                                child: _isProfessional
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: AppColors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  '¿Eres Profesional?',
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).onTap(() {
                          setState(() {
                            _isProfessional = !_isProfessional;
                          });
                        }),
                        const SizedBox(height: 32),
                        GradientButton(
                          text: 'Iniciar Sesión',
                          onPressed: _handleRequestCode,
                          isLoading: _isLoading,
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '¿No tienes cuenta? ',
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    AppColors.primaryGradient.createShader(bounds),
                                child: const Text(
                                  'Regístrate',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
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
          ),
        ],
      ),
    );
  }
}

extension on Widget {
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}
