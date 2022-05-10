import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({
    Key? key,
    required this.title,
    required this.isChecked,
  }) : super(key: key);

  final String title;
  final bool isChecked;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Text(
        title,
        style: TextStyle(
          color: isChecked ? Colors.white : Colors.grey.shade100,
        ),
      ),
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xffe7c763) : Colors.grey.shade400,
        border: Border.all(
          color: isChecked ? const Color(0xffe7c763) : Colors.grey.shade400,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );
  }
}
