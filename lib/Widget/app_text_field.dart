import 'package:flutter/material.dart';

import '../Common/app_colors.dart';

class AppTextFormWidget extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final Widget? sufixIcon;
  final Widget? prifixIcon;
  final VoidCallback? onTap;
  final VoidCallback? onEditing;

  final TextStyle? hintStyle;
  final TextStyle? style;
  final FocusNode? focusNode;
  final double? radius;
  final TextEditingController controller;
  final bool obscureText;

  final bool enable;

  final bool readOnly;

  final int maxLines;

  final int minLine;

  final int? maxLength;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onComplete;
  final TextInputType? keyBoardType;
  final double? width;
  final double? height;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextFormWidget({
    Key? key,
    this.readOnly = false,
    required this.hintText,
    this.maxLength,
    this.sufixIcon,
    this.prifixIcon,
    required this.controller,
    this.obscureText = false,
    this.enable = true,
    this.labelText,
    this.maxLines = 5,
    this.minLine = 1,
    this.validator,
    this.keyBoardType,
    this.onChanged,
    required this.hintStyle,
    this.onTap,
    this.width,
    this.height,
    this.onEditing,
    this.focusNode,
    this.onComplete,
    this.style,
    this.contentPadding,
    this.radius,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Center(
        child: TextFormField(
          onTap: onTap,
          readOnly: readOnly,
          minLines: minLine,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enable,
          controller: controller,
          obscureText: obscureText,
          onEditingComplete: onEditing,
          onFieldSubmitted: onComplete,
          focusNode: focusNode,
          cursorColor: AppColors.primary,
          textAlign: textAlign ?? TextAlign.start,
          style: style,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            counterText: "",

            contentPadding: contentPadding,
            filled: true,
            fillColor: AppColors.white,

            hintText: hintText,
            suffixIcon: sufixIcon,
            prefixIcon: prifixIcon,
            // prefixIcon: Image.asset("assets/images/location.png"),
            hintStyle: hintStyle,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(radius ?? 10)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(radius ?? 10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(radius ?? 10)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(radius ?? 10)),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(radius ?? 10)),
          ),
          validator: validator,
          onChanged: onChanged,

        ),
      ),
    );
  }
}
