import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText, prefixText, label, text;
  final Function? specialFunc, onSaved;
  final String? Function(String?)? onFieldSubmit, onChanged, validator;
  final bool? obscureText, enabled, readOnly;
  final Widget? icon, suffixIcon, suffix;
  final int? maxLenght;
  final IconData? prefixI;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextCapitalization? textCapitalization;
  final void Function()? onTap;

  const AppTextFormField(
      {Key? key,
      this.prefixI,
      this.icon,
      this.specialFunc,
      this.keyboardType,
      this.validator,
      this.onSaved,
      this.suffixIcon,
      this.inputFormatters,
      this.onFieldSubmit,
      this.hintText,
      this.obscureText,
      this.label,
      this.enabled,
      this.text,
      required this.controller,
      this.maxLenght,
      this.prefixText,
      this.textInputAction,
      this.focusNode,
      this.readOnly,
      this.textCapitalization,
      this.suffix,
      this.onChanged,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly ?? false,
      enableInteractiveSelection: true,
      keyboardType: keyboardType,
      enabled: enabled ?? true,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      maxLength: maxLenght,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: onFieldSubmit,
      validator: validator,
      onTap: onTap,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: InputDecoration(
        counterText: '',
        prefixText: prefixText,
        hintText: hintText,
        labelText: text,
        icon: icon,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        suffixIcon: suffixIcon,
        suffix: suffix,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color(0xFFF8F8F8), style: BorderStyle.solid),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color(0xFFF8F8F8), style: BorderStyle.solid),
        ),
      ),
    );
  }
}
