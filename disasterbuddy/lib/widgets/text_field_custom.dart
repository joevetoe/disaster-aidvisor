import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/colors.dart';

class MyTextFieldCustom extends StatelessWidget {
  const MyTextFieldCustom(
      {required this.controller,
      this.hintText,
      this.labelText,
      this.needValidator,
      this.validatorText,
      this.onChanged,
      this.disabledbordercolor,
      this.needToHideIcon,
      this.icon,
      this.iconCustomColor,
      this.needToDisableField,
      this.border,
      this.textInputType,
      this.inputFormatters,
      this.maxlength,
      this.counterText,
      this.needToHideBorder,
      this.customValidator,
      this.focusedBorderColor,
      this.maxLines,
      this.suffix,
      this.prefix,
      this.isObscureText,
      this.readOnly,
      super.key,
      this.focusNode,
      this.contentPadding});

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final Color? disabledbordercolor;
  final bool? needValidator;
  final String? validatorText;
  final bool? needToHideIcon;
  final IconData? icon;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final Color? iconCustomColor;
  final Color? focusedBorderColor;
  final bool? needToDisableField;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxlength;
  final String? counterText;
  final bool? needToHideBorder;
  final Widget? suffix;
  final Widget? prefix;
  final bool? isObscureText;
  final bool? readOnly;

  final InputBorder? border;

  final Function(String a)? onChanged;
  final String? Function(String?)? customValidator;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: focusNode != null
          ? (val) {}
          : (val) {
              focusNode?.unfocus();
            },
      // textInputAction: TextInputAction.done,
      // focusNode: focusNode,
      maxLength: maxlength,
      controller: controller,
      enabled: needToDisableField == true ? false : true,
      keyboardType: textInputType,

      inputFormatters: inputFormatters,
      obscureText: isObscureText ?? false,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        errorMaxLines: 4,
        counterText: counterText,
        hintText: hintText,
        labelText: labelText,
        // enabledBorder: OutlineInputBorder(
        //     borderRadius: const BorderRadius.all(Radius.circular(7)),
        //     borderSide: BorderSide(
        //         color: disabledbordercolor ?? MyColors.tetxFieldIconsColor)),
        hintStyle: TextStyle(color: MyColors.tetxFieldIconsColor),
        border: border ??
            (needToHideBorder == true
                ? null
                : UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(
                      width: 0,
                      color: MyColors.blackColor,
                    ),
                  )),
        // focusedBorder: OutlineInputBorder(
        //     borderRadius: const BorderRadius.all(Radius.circular(7)),
        //     borderSide: BorderSide(
        //         color: focusedBorderColor ?? MyColors.tetxFieldIconsColor)),
        fillColor: MyColors.greyColor.withOpacity(0.3),
        //  needToDisableField == true
        //     ? MyColors.textFieldFillColor
        //     : const Color.fromARGB(0, 102, 94, 94),
        filled: true,
        suffixIcon: suffix,
        prefixIcon: prefix,

        focusColor: MyColors.greyColor.withOpacity(0.3),
      ),
      cursorColor: MyColors.whiteColor,
      validator: customValidator ??
          (needValidator == true
              ? (text) {
                  if (text == null || text.toString().trim().isEmpty) {
                    return validatorText ?? "Field is required";
                  } else {
                    return null;
                  }
                }
              : null),
      onChanged: onChanged ?? (a) {},
      maxLines: isObscureText == true ? 1 : maxLines ?? 1,
    );
  }
}
