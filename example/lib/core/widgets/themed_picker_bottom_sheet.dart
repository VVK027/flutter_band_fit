import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:flutter_band_fit_app/core/widgets/cupertino_button_widget.dart';

/// Theme-aware modal bottom sheet for Cupertino pickers and date pickers.
Future<T?> showThemedPickerBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  double height = 300,
}) {
  final surface = Theme.of(context).colorScheme.surface;
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: surface,
    isScrollControlled: true,
    builder: (sheetContext) {
      final bottom = MediaQuery.paddingOf(sheetContext).bottom;
      return SafeArea(
        top: false,
        child: Material(
          color: Theme.of(sheetContext).colorScheme.surface,
          child: SizedBox(
            height: height + bottom,
            child: builder(sheetContext),
          ),
        ),
      );
    },
  );
}

/// Standard Cancel / Done header row for picker sheets.
class PickerSheetHeader extends StatelessWidget {
  const PickerSheetHeader({
    super.key,
    required this.onCancel,
    required this.onDone,
    this.cancelLabel = cancelText,
    this.doneLabel = doneText,
  });

  final VoidCallback onCancel;
  final VoidCallback onDone;
  final String cancelLabel;
  final String doneLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoButtonWidget(title: cancelLabel, onPressed: onCancel),
        CupertinoButtonWidget(title: doneLabel, onPressed: onDone),
      ],
    );
  }
}

Color themedPickerBackground(BuildContext context) =>
    Theme.of(context).colorScheme.surface;

TextStyle themedPickerItemStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyLarge ??
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
