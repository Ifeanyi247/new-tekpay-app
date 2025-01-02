import 'package:flutter/material.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const RoundedButtonWidget({
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: 25.sp,
        ),
      ),
    );
  }
}
