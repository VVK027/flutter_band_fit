import 'package:flutter/cupertino.dart';

class CupertinoButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const CupertinoButtonWidget({
    required this.onPressed,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
