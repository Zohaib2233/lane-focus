// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';

class SendField extends StatelessWidget {
  SendField({
    Key? key,
    this.controller,
    this.onChanged,
    this.onSend,
    this.onMic,
    this.onGallery,
    this.onAttach,
    this.chatId,
  }) : super(key: key);

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  String? chatId;
  final VoidCallback? onSend, onMic, onGallery, onAttach;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizes.DEFAULT,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: kInputBorderColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: controller,
                onChanged: onChanged,
                cursorWidth: 1.0,
                style: TextStyle(
                  fontSize: 12,
                  color: kTertiaryColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFonts.SPLINE_SANS,
                ),
                decoration: InputDecoration(
                  fillColor: kInputColor,
                  filled: true,
                  hintText: 'Type a message.',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: kQuaternaryColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.SPLINE_SANS,
                  ),
                  constraints: BoxConstraints(maxHeight: 38),
                  suffixIconConstraints: BoxConstraints(maxHeight: 38),
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Wrap(
                          spacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // GestureDetector(
                            //   onTap: onAttach,
                            //   child: Image.asset(
                            //     Assets.imagesCopy2,
                            //     height: 12,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: onSend,
            child: Image.asset(
              Assets.imagesSendIcon,
              height: 38,
            ),
          ),
        ],
      ),
    );
  }
}
