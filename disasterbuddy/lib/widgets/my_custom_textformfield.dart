import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/colors.dart';

class MyCustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool? isobsecure;
  final Color? textcolor;
  final String? label;
  final double? radius;
  final bool? padding;
  final double? paddingsize;
  final Widget? suffix;
  final TextInputType? keyboardtype;
  final bool? isenabled;
  final int? maxlines;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatter;
  final String? Function(String?)? validator;
  final void Function()? ontap;
  final void Function(String)? onchaged;

  const MyCustomTextFormField(
      {super.key,
      this.hint,
      this.isobsecure,
      this.label,
      this.controller,
      this.textcolor,
      this.radius,
      this.padding,
      this.paddingsize,
      this.suffix,
      this.validator,
      this.ontap,
      this.isenabled,
      this.prefixIcon,
      this.onchaged,
      this.maxlines,
      this.inputFormatter,
      this.keyboardtype});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: TextFormField(
        keyboardType: keyboardtype,
        inputFormatters: inputFormatter,
        onChanged: onchaged,
        // onTap: ontap,
        enabled: isenabled,
        validator: validator,
        maxLines: maxlines ?? 1,
        controller: controller,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MyColors.whiteColor,
        ),
        decoration: InputDecoration(
          // label: label != null ? Text(label!) : null,
          // contentPadding: const EdgeInsets.all(10¢.0),

          labelText: label,
          labelStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyColors.whiteColor,
          ),

          //     padding == true ? EdgeInsets.all(paddingsize ?? 10) : null,
          hintStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyColors.whiteColor,
          ),

          fillColor: MyColors.greyColor.withOpacity(0.3),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: MyColors.greyColor.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.transparent,
            ),
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.transparent,
            ),
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: MyColors.transparent,
            ),
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
          // prefix: prefixIcon,
          prefixIcon: prefixIcon,
          suffixIcon: suffix,
          hintText: hint,
        ),

        obscureText: isobsecure ?? false,
      ),
    );
  }
}
