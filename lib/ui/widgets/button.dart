import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTab;
  const CustomButton({Key? key, required this.text, this.onTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bluishClr
        ),
        child: Center(
            child: Text(text,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center)
        ),
      ),
    );
  }
}
