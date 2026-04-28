import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xffF0F2F5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xff1B2E4B)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                minLines: 1,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xff1a1a1a),
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.chatInputPlaceholder,
                  hintStyle: const TextStyle(
                    color: Color(0xff999999),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
