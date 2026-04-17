import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendBubble extends StatelessWidget {
  final String message;
  final String messagetype;
  final bool isSender;

  const SendBubble({
    super.key,
    required this.message,
    required this.messagetype,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(text: message));
          Fluttertoast.showToast(msg: "Copied to clipboard");
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xff1B2E4B),
            borderRadius: BorderRadius.circular(18).copyWith(
              bottomRight: const Radius.circular(4),
            ),
          ),
          child: Text(
            message,
            softWrap: true,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class RecieveChatBubble extends StatelessWidget {
  final String message;
  final String messagetype;
  final bool isSender;

  const RecieveChatBubble({
    super.key,
    required this.message,
    required this.messagetype,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xffF0F2F5),
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: message == "loading"
            ? Image.asset(
                "assets/images/loading.gif",
                height: 24,
              )
            : MarkdownBody(
                data: message,
                shrinkWrap: true,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    fontSize: 15,
                    color: Color(0xff1a1a1a),
                    height: 1.45,
                  ),
                  strong: const TextStyle(
                    fontSize: 15,
                    color: Color(0xff1B2E4B),
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                  listBullet: const TextStyle(
                    fontSize: 15,
                    color: Color(0xff1a1a1a),
                    height: 1.45,
                  ),
                  h1: const TextStyle(
                    fontSize: 17,
                    color: Color(0xff1B2E4B),
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                  h2: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff1B2E4B),
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                  h3: const TextStyle(
                    fontSize: 15,
                    color: Color(0xff1B2E4B),
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                  blockSpacing: 8,
                  listIndent: 18,
                ),
              ),
      ),
    );
  }
}
