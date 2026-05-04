// lib/views/widgets/agro_text_field.dart
//
// Widget reutilizable para todos los campos de texto de AgroTrace.
// Sigue las especificaciones visuales del diseno Figma.

import 'package:flutter/material.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';

class AgroTextField extends StatelessWidget {
  const AgroTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.focusNode,
    this.autofillHints,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelField),
        const SizedBox(height: AppDimens.spaceXS + 2),
        TextFormField(
          controller:       controller,
          focusNode:        focusNode,
          obscureText:      obscureText,
          keyboardType:     keyboardType,
          textInputAction:  textInputAction,
          validator:        validator,
          onChanged:        onChanged,
          autofillHints:    autofillHints,
          style:            AppTextStyles.bodyRegular.copyWith(
            color: const Color(0xFF1B1B1B),
          ),
          decoration: InputDecoration(
            hintText:   hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}