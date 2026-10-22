import 'package:vvk_ui_kit/vvk_ui_kit.dart' as ui;
import 'package:flutter/material.dart';

enum OrderType { ascending, descending, none }

class BarAsset {
  const BarAsset({required this.size, required this.color});

  final double size;
  final Color color;
}

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

  ui.UISegmentOrder _mapOrder(OrderType value) {
    switch (value) {
      case OrderType.ascending:
        return ui.UISegmentOrder.ascending;
      case OrderType.descending:
        return ui.UISegmentOrder.descending;
      case OrderType.none:
        return ui.UISegmentOrder.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ui.UISegmentedBar(
      width: width,
      height: height,
      radius: radius,
      segments: assets
          .map((asset) => ui.UISegmentValue(size: asset.size, color: asset.color))
          .toList(),
      segmentLimit: assetsLimit,
      order: _mapOrder(order),
      background: background,
    );
  }
}
