import 'package:flutter/material.dart';
import '../Common/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Color? bgColor;
  final int? type;

  const AppButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.style,
    this.width,
    this.height,
    this.padding,
    this.textColor,
    this.bgColor,
    this.radius, this.type=0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.sizeOf(context).width,
      height: height ?? 40,
      decoration: BoxDecoration(
        color: bgColor,

        borderRadius: BorderRadius.circular(radius ?? 30),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            // shadowColor: Colors.transparent,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 30))),
        child: Text(
          title,
          style: style ??
              TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppColors.white),
        ),
      ),
    );
  }
}
