import 'package:vvk_ui_kit/vvk_ui_kit.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';

Future<T?> showThemedPickerBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  double height = 300,
}) {
  return ui.showPickerBottomSheet<T>(
    context: context,
    builder: builder,
    height: height,
  );
}

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
    return ui.UIPickerSheetHeader(
      onCancel: onCancel,
      onDone: onDone,
      cancelLabel: cancelLabel,
      doneLabel: doneLabel,
    );
  }
}

Color themedPickerBackground(BuildContext context) =>
    ui.pickerSheetBackground(context);

TextStyle themedPickerItemStyle(BuildContext context) =>
    ui.pickerSheetItemStyle(context);

class CupertinoButtonWidget extends StatelessWidget {
  const CupertinoButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ui.UICupertinoTextButton(onPressed: onPressed, title: title);
  }
}

List<Tab> buildDWMTabs() {
  return ui.buildDwmTabs(
    dayLabel: textDay,
    weekLabel: textWeek,
    monthLabel: textMonth,
  );
}
