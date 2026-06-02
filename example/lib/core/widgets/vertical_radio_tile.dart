import 'package:flutter/material.dart';

class VerticalRadioTile extends StatelessWidget {
  final String title;
  final int radioValue;
  final int radioGroupValue;
  final VoidCallback? onTap;
  final ValueChanged<int?> onChange;

  const VerticalRadioTile({
    super.key,
    required this.title,
    required this.radioValue,
    required this.radioGroupValue,
    required this.onTap,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: RadioGroup<int>(
          groupValue: radioGroupValue,
          onChanged: onChange,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio<int>(value: radioValue),
              Expanded(child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }
}
