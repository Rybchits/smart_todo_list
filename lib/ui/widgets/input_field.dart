import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class CustomInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const CustomInputField({Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget != null,
                    autofocus: false,
                    cursorColor: Get.isDarkMode? Colors.grey.shade100 : Colors.grey.shade700,
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).backgroundColor,
                          width: 0
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                            width: 0
                        ),
                      ),
                    ),
                  ),
                ),
                widget == null? Container() : Container(child: widget)
              ],
            ),
          )
        ],
      ),
    );
  }
}
