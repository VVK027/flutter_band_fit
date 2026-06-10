import 'package:flutter/material.dart';
import 'package:flutter_band_fit/flutter_band_fit.dart' show debugPrintI;

enum OrderType { ascending, descending, none }

class BarAsset {
  const BarAsset({required this.size, required this.color});

  final double size;
  final Color color;
}

/// Segmented progress bar; sorts segments in [initState] / [didUpdateWidget], not in [build].
class CustomAssetsBar extends StatefulWidget {
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

  @override
  State<CustomAssetsBar> createState() => _CustomAssetsBarState();
}

class _CustomAssetsBarState extends State<CustomAssetsBar> {
  late List<BarAsset> _sortedAssets;
  late double _valuesSum;

  @override
  void initState() {
    super.initState();
    _recomputeSegments();
  }

  @override
  void didUpdateWidget(CustomAssetsBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assets != widget.assets ||
        oldWidget.order != widget.order ||
        oldWidget.assetsLimit != widget.assetsLimit) {
      _recomputeSegments();
    }
  }

  void _recomputeSegments() {
    _valuesSum = 0;
    for (final single in widget.assets) {
      _valuesSum += single.size;
    }
    _sortedAssets = List<BarAsset>.from(widget.assets);
    switch (widget.order) {
      case OrderType.ascending:
        _sortedAssets.sort((a, b) => a.size.compareTo(b.size));
      case OrderType.descending:
        _sortedAssets.sort((a, b) => b.size.compareTo(a.size));
      case OrderType.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetsLimit < _valuesSum) {
      debugPrintI('assetsSum < _getValuesSum() - Check your values!');
      return const SizedBox.shrink();
    }
    final double rad = widget.radius > 0 ? widget.radius : (widget.height / 2);
    return RepaintBoundary(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.all(Radius.circular(rad)),
        ),
        width: widget.width,
        height: widget.height,
        child: Row(
          children: [
            for (final segment in _sortedAssets)
              _BarSegment(
                asset: segment,
                barWidth: widget.width,
                assetsLimit: widget.assetsLimit,
              ),
          ],
        ),
      ),
    );
  }
}

class _BarSegment extends StatelessWidget {
  const _BarSegment({
    required this.asset,
    required this.barWidth,
    required this.assetsLimit,
  });

  final BarAsset asset;
  final double barWidth;
  final double assetsLimit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (asset.size * barWidth) / assetsLimit,
      child: ColoredBox(color: asset.color),
    );
  }
}
