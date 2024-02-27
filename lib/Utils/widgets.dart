import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Source Serif 4',
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
