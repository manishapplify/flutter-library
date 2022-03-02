import 'package:flutter/material.dart';

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    Key? key,
    required this.title,
    required this.isChecked,
  }) : super(key: key);

  final String title;
  final bool isChecked;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(
            isChecked ? Icons.check_circle : Icons.circle,
            color: isChecked ? const Color(0xffe7c763) : Colors.grey,
          ),
          const SizedBox(width: 10.0),
          Text(title)
        ],
      ),
    );
  }
}
