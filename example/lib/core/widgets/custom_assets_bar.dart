import 'package:flutter/material.dart';

enum OrderType { ascending, descending, none }

class BarAsset {
  final double size;
  final Color color;

  BarAsset({required this.size, required this.color});
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

  double _getValuesSum() {
    double sum = 0;
    for (final single in assets) {
      sum += single.size;
    }
    return sum;
  }

  void _orderAssets() {
    switch (order) {
      case OrderType.ascending:
        assets.sort((a, b) => a.size.compareTo(b.size));
      case OrderType.descending:
        assets.sort((a, b) => b.size.compareTo(a.size));
      case OrderType.none:
        break;
    }
  }

  Widget _createSingle(BarAsset singleAsset) {
    return SizedBox(
      width: (singleAsset.size * width) / assetsLimit,
      child: Container(color: singleAsset.color),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (assetsLimit < _getValuesSum()) {
      debugPrint('assetsSum < _getValuesSum() - Check your values!');
      return const SizedBox.shrink();
    }
    _orderAssets();
    final double rad = radius > 0 ? radius : (height / 2);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(rad)),
      child: Container(
        decoration: BoxDecoration(color: background),
        width: width,
        height: height,
        child: Row(
          children: assets.map(_createSingle).toList(),
        ),
      ),
    );
  }
}
