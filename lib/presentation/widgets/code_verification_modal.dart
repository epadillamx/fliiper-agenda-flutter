import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(text: newValue.text, selection: newValue.selection);
  }
}

class CodeVerificationModal extends StatefulWidget {
  final String email;
  final Function(String code) onVerify;

  const CodeVerificationModal({
    super.key,
    required this.email,
    required this.onVerify,
  });

  @override
  State<CodeVerificationModal> createState() => _CodeVerificationModalState();
}

class _CodeVerificationModalState extends State<CodeVerificationModal> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final code = _controllers.map((c) => c.text).join();
      widget.onVerify(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight <= 700 || screenWidth <= 360;

    final iconSize = isSmallScreen ? 36.0 : 48.0;
    final titleSize = isSmallScreen ? 20.0 : 24.0;
    final subtitleSize = isSmallScreen ? 12.0 : 14.0;
    final inputWidth = isSmallScreen ? 40.0 : 50.0;
    final inputHeight = isSmallScreen ? 50.0 : 60.0;
    final inputFontSize = isSmallScreen ? 20.0 : 24.0;
    final horizontalPadding = isSmallScreen ? 20.0 : 32.0;
    final verticalPadding = isSmallScreen ? 20.0 : 32.0;
    final spacing = isSmallScreen ? 16.0 : 24.0;
    final smallSpacing = isSmallScreen ? 8.0 : 12.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 40,
        vertical: isSmallScreen ? 24 : 40,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: screenHeight * 0.9,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        size: iconSize,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(
                      'Verificación de Código',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: smallSpacing),
                    Text(
                      'Ingresa el código de 6 caracteres enviado a',
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing + 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 2 : 4,
                          ),
                          width: inputWidth,
                          height: inputHeight,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            maxLength: 1,
                            textCapitalization: TextCapitalization.characters,
                            style: TextStyle(
                              fontSize: inputFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'),
                              ),
                              UpperCaseTextFormatter(),
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.slate50.withValues(
                                alpha: 0.5,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.slate200.withValues(
                                    alpha: 0.4,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 12 : 16,
                              ),
                            ),
                            onChanged: (value) => _onDigitChanged(index, value),
                            onTap: () {
                              _controllers[index].selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: _controllers[index].text.length,
                              );
                            },
                            onSubmitted: (value) {
                              if (index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: spacing + 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 12 : 16,
                              ),
                              side: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: smallSpacing),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final code = _controllers
                                  .map((c) => c.text)
                                  .join();
                              if (code.length == 6) {
                                widget.onVerify(code);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 12 : 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Verificar',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: smallSpacing + 4),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '¿No recibiste el código? Reenviar',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
