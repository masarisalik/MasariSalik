import 'package:flutter/material.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:masari_salik_app/style/fonts.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSubmitted;

  const TextInputWidget(
      {required this.textController, required this.onSubmitted, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
        IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_sharp)),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: textController,
                minLines: 1,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                style: robotoMediumBold,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Enter your message...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 12.0),
                ),
                onFieldSubmitted: (_) => onSubmitted,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: onSubmitted,
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
