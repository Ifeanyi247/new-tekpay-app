import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tekpayapp/constants/colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? bgColor;

  const CustomButtonWidget({
    super.key,
    required this.text,
    this.onTap,
    this.bgColor = primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: bgColor != primaryColor ? primaryColor : Colors.white,
            fontSize: 17.sp,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: bgColor != primaryColor
                ? BorderSide(
                    color: Colors.grey.shade300,
                  )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
