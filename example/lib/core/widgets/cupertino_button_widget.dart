import 'package:flutter/cupertino.dart';

class CupertinoButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const CupertinoButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
