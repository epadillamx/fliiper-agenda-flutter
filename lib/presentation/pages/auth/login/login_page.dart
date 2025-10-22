import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/auth/login/usecases/send_code_use_case.dart';
import '../../../../domain/auth/login/usecases/verify_code_use_case.dart';
import '../../../../infrastructure/auth/login/adapters/login_repository_impl.dart';
import '../../../widgets/code_verification_modal.dart';
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
        final type = _isProfessional ? 'professional' : 'client';
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
      final type = _isProfessional ? 'professional' : 'client';
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
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [AppColors.primary.withValues(alpha: 0.4), AppColors.primary.withValues(alpha: 0.2)],
                  [AppColors.primary.withValues(alpha: 0.3), AppColors.primary.withValues(alpha: 0.1)],
                  [AppColors.primary.withValues(alpha: 0.2), AppColors.primary.withValues(alpha: 0.05)],
                ],
                durations: [8000, 6000, 5000],
                heightPercentages: [0.45, 0.50, 0.55],
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
              size: Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: 450,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.slate100.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 40,
                            offset: const Offset(0, 15),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SvgPicture.asset(
                              'lib/presentation/assets/logo.svg',
                              height: 80,
                              width: 80,
                              fit: BoxFit.contain,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Bienvenido',
                              style: TextStyle(
                                fontSize: 28,
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
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: AppColors.slate50.withValues(alpha: 0.4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: AppColors.slate200.withValues(alpha: 0.4),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
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
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isProfessional,
                                  onChanged: (value) {
                                    setState(() {
                                      _isProfessional = value ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const Text(
                                  '¿Eres Profesional?',
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleRequestCode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        'Iniciar Sesión',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '¿No tienes cuenta? ',
                                  style: TextStyle(color: AppColors.textLight),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Regístrate',
                                    style: TextStyle(
                                      color: AppColors.primary,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
