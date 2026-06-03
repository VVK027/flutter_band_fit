import 'package:flutter/material.dart';

/// Visual style for [BatteryIndicator].
enum BatteryIndicatorStyle {
  /// Flat outline with rounded body.
  flat,

  /// Skeuomorphic body with a separate positive terminal cap.
  skeumorphism,
}

/// Custom-painted battery level indicator for the device settings UI.
class BatteryIndicator extends StatefulWidget {
  /// [BatteryIndicatorStyle.flat] is minimal; [BatteryIndicatorStyle.skeumorphism] draws a cap.
  final BatteryIndicatorStyle style;

  /// Width-to-height ratio of the widget (default 2.5).
  final double ratio;

  /// Border color and fill color when [colorful] is false.
  final Color mainColor;

  /// When true, fill color follows battery level (green / amber / red).
  final bool colorful;

  /// Whether to paint the filled portion for the current level.
  final bool showPercentSlide;

  /// Whether to show the numeric percentage. Prefer false when [colorful] is false.
  final bool showPercentNum;

  /// Overall height in logical pixels (default 14.0).
  final double size;

  /// Font size for the percentage label.
  final double percentNumSize;

  /// When true, level is read from the host device (not used when [batteryLevel] is set externally).
  final bool batteryFromPhone;

  /// Battery percentage (0–100) when not using the phone battery.
  final int batteryLevel;

  const BatteryIndicator({
    super.key,
    this.batteryFromPhone = true,
    this.batteryLevel = 25,
    this.style = BatteryIndicatorStyle.flat,
    this.ratio = 2.5,
    this.mainColor = Colors.black,
    this.colorful = true,
    this.showPercentNum = true,
    this.showPercentSlide = true,
    required this.percentNumSize,
    this.size = 14.0,
  });

  @override
  State<BatteryIndicator> createState() => _BatteryIndicatorState();
}

class _BatteryIndicatorState extends State<BatteryIndicator> {
  late int batteryLv;

  @override
  void initState() {
    super.initState();
    batteryLv = widget.batteryLevel;
  }

  @override
  void didUpdateWidget(covariant BatteryIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.batteryLevel != widget.batteryLevel) {
      batteryLv = widget.batteryLevel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size * widget.ratio,
      child: CustomPaint(
        painter: BatteryIndicatorPainter(
          batteryLv,
          widget.style,
          widget.showPercentSlide,
          widget.colorful,
          widget.mainColor,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              right: widget.style == BatteryIndicatorStyle.flat
                  ? 0.0
                  : widget.size * widget.ratio * 0.04,
            ),
            child: widget.showPercentNum
                ? Text(
                    '$batteryLv%',
                    style: TextStyle(fontSize: widget.percentNumSize),
                  )
                : Text(
                    '',
                    style: TextStyle(fontSize: widget.percentNumSize),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Paints the battery outline and optional fill for [BatteryIndicator].
class BatteryIndicatorPainter extends CustomPainter {
  BatteryIndicatorPainter(
    this.batteryLv,
    this.style,
    this.showPercentSlide,
    this.colorful,
    this.mainColor,
  );

  int batteryLv;
  BatteryIndicatorStyle style;
  bool colorful;
  bool showPercentSlide;
  Color mainColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == BatteryIndicatorStyle.flat) {
      // Flat style: rounded rectangle outline.
      canvas.drawRRect(
        RRect.fromLTRBR(
          0.0,
          size.height * 0.05,
          size.width,
          size.height * 0.95,
          const Radius.circular(100.0),
        ),
        Paint()
          ..color = mainColor
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke,
      );

      if (showPercentSlide) {
        // Clip to the filled width for the current level.
        canvas.clipRect(
          Rect.fromLTWH(
            0.0,
            size.height * 0.05,
            size.width * fixedBatteryLv / 100,
            size.height * 0.95,
          ),
        );

        final offset = size.height * 0.1;

        // Fill inside the clipped region.
        canvas.drawRRect(
          RRect.fromLTRBR(
            offset,
            size.height * 0.05 + offset,
            size.width - offset,
            size.height * 0.95 - offset,
            const Radius.circular(100.0),
          ),
          Paint()
            ..color = colorful ? getBatteryLvColor : mainColor
            ..style = PaintingStyle.fill,
        );
      }
    } else {
      // Skeuomorphic style: body plus positive terminal.
      canvas.drawRRect(
        RRect.fromLTRBR(
          0.0,
          size.height * 0.05,
          size.width * 0.92,
          size.height * 0.95,
          Radius.circular(size.height * 0.1),
        ),
        Paint()
          ..color = mainColor
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke,
      );

      canvas.drawRRect(
        RRect.fromLTRBR(
          size.width * 0.92,
          size.height * 0.25,
          size.width,
          size.height * 0.75,
          Radius.circular(size.height * 0.1),
        ),
        Paint()
          ..color = mainColor
          ..style = PaintingStyle.fill,
      );

      if (showPercentSlide) {
        canvas.clipRect(
          Rect.fromLTWH(
            0.0,
            size.height * 0.05,
            size.width * 0.92 * fixedBatteryLv / 100,
            size.height * 0.95,
          ),
        );

        final offset = size.height * 0.1;

        canvas.drawRRect(
          RRect.fromLTRBR(
            offset,
            size.height * 0.05 + offset,
            size.width * 0.92 - offset,
            size.height * 0.95 - offset,
            Radius.circular(size.height * 0.1),
          ),
          Paint()
            ..color = colorful ? getBatteryLvColor : mainColor
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  double get fixedBatteryLv => batteryLv.clamp(0, 100).toDouble();

  Color get getBatteryLvColor {
    if (batteryLv >= 60) {
      return Colors.green;
    }
    if (batteryLv >= 20) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant BatteryIndicatorPainter oldDelegate) {
    return oldDelegate.batteryLv != batteryLv ||
        oldDelegate.style != style ||
        oldDelegate.showPercentSlide != showPercentSlide ||
        oldDelegate.colorful != colorful ||
        oldDelegate.mainColor != mainColor;
  }
}
