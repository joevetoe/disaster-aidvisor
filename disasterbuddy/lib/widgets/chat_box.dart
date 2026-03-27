import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'custom_text_field.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    super.key,
    this.onChanged,
    this.onTap,
    this.controller,
    required this.focusNode,
  });

  final Function(String)? onChanged;
  final FocusNode focusNode;
  final Function()? onTap;
  final TextEditingController? controller;

  static const iconSize = 23.0;
  static final double screenWidth =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                color: kAppBarColor,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      child: CustomTextField(
                        maxLines: (controller?.text.length ?? 0) > 80
                            ? 3
                            : (controller?.text.length ?? 0) > 40
                                ? 2
                                : 1,
                        focusNode: focusNode,
                        onChanged: onChanged,
                        keyBoardType: TextInputType.multiline,
                        controller: controller,
                        hideBorder: true,
                        // suffix: IconButton(
                        //   icon: const Icon(Icons.attachment),
                        //   onPressed: onTap,
                        // ),
                        // prefix: const Icon(
                        //   Icons.emoji_emotions_rounded,
                        //   color: kSecondaryColor,
                        // ),
                        hintText: 'Message',
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(right: 8.0),
                  //   width: MediaQuery.of(context).size.width * 0.06,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: onTap,
                  //         child: Transform.rotate(
                  //           angle: 3.8,
                  //           child: const Icon(
                  //             Icons.attachment_rounded,
                  //             color: kSecondaryColor,
                  //             size: iconSize,
                  //           ),
                  //         ),
                  //       ),
                  //       // const Icon(
                  //       //   Icons.photo_camera_rounded,
                  //       //   color: kSecondaryColor,
                  //       //   size: 23.0,
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
