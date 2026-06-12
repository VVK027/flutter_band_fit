import 'package:flutter/material.dart';
import 'package:flutter_band_fit/flutter_band_fit.dart' show debugPrintI;

enum OrderType { ascending, descending, none }

class BarAsset {
  const BarAsset({required this.size, required this.color});

  final double size;
  final Color color;
}

/// Segmented progress bar for sleep stage proportions.
class CustomAssetsBar extends StatelessWidget {
  const CustomAssetsBar({
    super.key,
    required this.width,
    this.height = 8,
    required this.radius,
    required this.assets,
    required this.assetsLimit,
    required this.order,
    this.background = Colors.grey,
  });

  final double width;
  final double height;
  final double radius;
  final List<BarAsset> assets;
  final double assetsLimit;
  final OrderType order;
  final Color background;

  double _valuesSum(List<BarAsset> segments) {
    var sum = 0.0;
    for (final segment in segments) {
      sum += segment.size;
    }
    return sum;
  }

  List<BarAsset> _orderedAssets() {
    final segments = List<BarAsset>.from(assets);
    switch (order) {
      case OrderType.ascending:
        segments.sort((a, b) => a.size.compareTo(b.size));
      case OrderType.descending:
        segments.sort((a, b) => b.size.compareTo(a.size));
      case OrderType.none:
        break;
    }
    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final segments = _orderedAssets();
    final valuesSum = _valuesSum(segments);
    if (valuesSum <= 0) {
      final rad = radius > 0 ? radius : (height / 2);
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.all(Radius.circular(rad)),
        ),
        width: width,
        height: height,
      );
    }
    final renderLimit = valuesSum > assetsLimit ? valuesSum : assetsLimit;
    if (valuesSum > assetsLimit) {
      debugPrintI(
        'assetsSum > assetsLimit - normalizing bar segments '
        '($valuesSum > $assetsLimit)',
      );
    }
    final rad = radius > 0 ? radius : (height / 2);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.all(Radius.circular(rad)),
      ),
      width: width,
      height: height,
      child: Row(
        children: [
          for (final segment in segments)
            SizedBox(
              width: (segment.size * width) / renderLimit,
              height: height,
              child: ColoredBox(color: segment.color),
            ),
        ],
      ),
    );
  }
}
