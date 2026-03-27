import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/colors.dart';

class MyCustomButton extends StatelessWidget {
  final Function()? ontap;
  final String text;
  final Color? color;
  final Color? textcolor;
  final double? radius;
  final double? width;
  final double? height;
  final double? iconsize;
  final double? fontSize;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final BoxShadow? shadow;
  final Color? bordercolor;
  const MyCustomButton(
      {super.key,
      this.ontap,
      required this.text,
      this.color,
      this.radius,
      this.textcolor,
      this.width,
      this.height,
      this.suffixIcon,
      this.prefixIcon,
      this.shadow,
      this.iconsize,
      this.bordercolor,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: shadow != null ? [shadow!] : [],
      ),
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 10),
                side: BorderSide(
                  width: 1,
                  color: bordercolor ??
                      color ??
                      MyColors.blackColor.withOpacity(0.8),
                ),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              color ?? MyColors.blackColor.withOpacity(0.8),
            )),
        onPressed: ontap ?? () {},
        child: Row(
          mainAxisAlignment: suffixIcon != null || prefixIcon != null
              ? MainAxisAlignment.center
              : MainAxisAlignment.center,
          children: [
            prefixIcon != null
                ? Lottie.asset(
                    prefixIcon!,
                    height: iconsize,
                  )
                : const SizedBox.shrink(),
            // SizedBox(
            //   width: Get.width * 0.03,
            // ),
            // prefixIcon != null
            //     ? SizedBox(
            //         width: Get.width * 0.01,
            //       )
            //     : const SizedBox.shrink(),
            Center(
              child: Text(
                text,
                style: TextStyle(
                    color: textcolor,
                    fontSize: fontSize ?? 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            // suffixIcon != null
            //     ? SizedBox(
            //         width: Get.width * 0.02,
            //       )
            //     : const SizedBox.shrink(),
            // suffixIcon != null ? suffixIcon! : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
