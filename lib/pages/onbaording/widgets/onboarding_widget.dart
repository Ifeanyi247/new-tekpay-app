import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardWidget extends StatelessWidget {
  final String image;
  final String bigText;
  final String smallText;

  const OnBoardWidget({
    super.key,
    required this.image,
    required this.bigText,
    required this.smallText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          scale: 2,
        ),
        SizedBox(
          height: 30.h,
        ),
        Text(
          bigText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Text(
          smallText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }
}
