import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';

class CupertinoButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final String title;

  const CupertinoButtonWidget({
    required this.onPressed,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}

class VitalDataWidget extends StatelessWidget {
  const VitalDataWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.value,
    required this.units,
    required this.minutes,
    required this.time,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String value;
  final String units;
  final String minutes;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(4.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            // color: Colors.blue,
                            //fontWeight: FontWeight.bold,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0, top: 4.0, bottom: 4.0, right: 2.0),
                        child: Text(
                          value,
                          style: const TextStyle(
                            // color: Colors.blue,
                            //fontWeight: FontWeight.bold,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Text((minutes != null && minutes.isNotEmpty)
                          ? ' Hrs $minutes Minutes'
                          : ' $units'),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(time,
                            style: const TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    Key? key,
    required this.imagePath,
    required this.mainTitle,
    required this.subMainTitle,
  }) : super(key: key);

  final String imagePath;
  final String mainTitle;
  final String subMainTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            imagePath,
            width: 40.0,
            height: 40.0,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                mainTitle,
                style: const TextStyle(
                  // color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              /*Text(subMainTitle, style:  TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey.withOpacity(0.8),
                fontSize: 14.0,
              ),),*/
              Text(subMainTitle,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
            ],
          ),
        ),
      ],
    );
  }
}

enum OrderType { ascending, descending, none }
class BarAsset {
  final double size;
  final Color color;
  BarAsset({required this.size, required this.color});
}

class CustomAssetsBar extends StatelessWidget {
  const CustomAssetsBar(
      {Key? key,
        required this.width,
        this.height = 8,
        required this.radius,
        required this.assets,
        required this.assetsLimit,
        required this.order,
        this.background = Colors.grey})
      : super(key: key);

  final double width;
  final double height;
  final double radius ;
  final List<BarAsset> assets;
  final double assetsLimit;
  final OrderType order;
  final Color background;

  double _getValuesSum() {
    double sum = 0;
    for (var single in assets) {
      sum += single.size;
    }
    return sum;
  }

  void orderMyAssetsList() {
    switch (order) {
      case OrderType.ascending:
        {
          //From the smallest to the largest
          assets.sort((a, b) {
            return a.size.compareTo(b.size);
          });
          break;
        }
      case OrderType.descending:
        {
          //From largest to smallest
          assets.sort((a, b) {
            return b.size.compareTo(a.size);
          });
          break;
        }
      case OrderType.none:
      default:
        {
          break;
        }
    }
  }

  //single.size : assetsSum = x : width
  Widget _createSingle(BarAsset singleAsset) {
    return SizedBox(
      width: (singleAsset.size * width) / (assetsLimit ?? _getValuesSum()),
      child: Container(color: singleAsset.color),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (assetsLimit < _getValuesSum()) {
      debugPrint("assetsSum < _getValuesSum() - Check your values!");
      return Container();
    }
    //Order assetsList
    orderMyAssetsList();
    final double rad = radius != null ? radius : (height / 2);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(rad)),
      child: Container(
        decoration: BoxDecoration(
          color: background,
        ),
        width: width,
        height: height,
        child: Row(children: assets.map((singleAsset) => _createSingle(singleAsset)).toList()),
      ),
    );
  }
}

class Popover extends StatelessWidget {
  const Popover({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      //margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        // borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
           Expanded(child: child)
        ],
      ),
    );
  }
  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: Container(
          height: 4.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}

class VerticalRadioTile extends StatelessWidget {
  final String title;
  final int radioValue;
  final int radioGroupValue;
 // final VoidCallback onTap; or below
  final void Function()? onTap;
  final void Function(dynamic) onChange;

  const VerticalRadioTile({Key? key, required this.title,
    required this.radioValue,
    required this.radioGroupValue,
    required this.onTap,
    required this.onChange}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(value: radioValue, groupValue: radioGroupValue, onChanged: onChange),
            Expanded(child: Text(title))
          ],
        ),
      ),
    );
  }
}

List<Widget> buildDWMTabs() {
  return <Widget>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(textDay),
      ),
      //text: "Day",
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(textWeek),
      ),
      //text: "Day",
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(textMonth),
      ),
      //text: "Day",
    ),
  ];
}
//Material App Theming add the below theme

/*ThemeData _buildShrineTheme () {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    toggleableActiveColor: shrinePink400,
    accentColor: shrineBrown900,
    primaryColor: shrinePink100,
    buttonColor: shrinePink100,
    scaffoldBackgroundColor: shrineBackgroundWhite,
    cardColor: shrineBackgroundWhite,
    textSelectionColor: shrinePink100,
    errorColor: shrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: defaultLetterSpacing,
    ),
    button: base.button.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: defaultLetterSpacing,
    ),
  )
      .apply(
    fontFamily: 'Rubik',
    displayColor: shrineBrown900,
    bodyColor: shrineBrown900,
  );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink400,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;*/
