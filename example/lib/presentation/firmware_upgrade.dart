import 'package:flutter_band_fit_app/common/common_imports.dart';

class FirmwareUpgrade extends StatefulWidget {
  const FirmwareUpgrade({Key? key}) : super(key: key);

  @override
  State<FirmwareUpgrade> createState() => _FirmwareUpgradeState();
}

class _FirmwareUpgradeState extends State<FirmwareUpgrade> {
  double value = 4000;
  double totalValue = 10000;
  double radius = 200;
  late Color gaugeColor;
  late Color gaugeBackgroundColor;
  late double gaugeWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: firmwareUpgradeForm(),
      bottomNavigationBar:  SizedBox(
        height: MediaQuery.of(context).size.height*0.13,
        child: Column(
          children: [
            Container(
                height: 44,
                margin: const EdgeInsets.only(left: 10,right: 10,bottom: 50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: MaterialButton(
                  disabledColor: Colors.grey[200],
                  onPressed: () {},
                  child: Text('Check for updates',  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                )),

          ],
        ),
      ),
    );
  }

  firmwareUpgradeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: Colors.green,
          child: Column(
            children: [
              const SizedBox(
                height: 44,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  const Text(
                    'Firmware Upgrade',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: 40,
                  )
                ],
              ),
              //vSpacer(30),
             // getStepsGauge()
            ],
          ),
        ),
        //vSpacer(10),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Text(
            'Newest Version',  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)

          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Text(
             'Newest Version',  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Text(
             'Newest Version', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Text(
             'Newest Version',  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)
          ),
        ),

      ],
    );
  }

  /*Widget getStepsGauge() {
    return SizedBox(
        width: 150,
        height: 150,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              radiusFactor: 1,
              maximum: totalValue,
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              axisLineStyle: AxisLineStyle(
                thickness: gaugeWidth ?? 0.05,
                color:
                gaugeBackgroundColor ?? Colors.white.withOpacity(0.4),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: value,
                  width: gaugeWidth ?? 0.05,
                  color: gaugeColor ?? Colors.white,
                  sizeUnit: GaugeSizeUnit.factor,
                  cornerStyle: value >= totalValue
                      ? CornerStyle.bothFlat
                      : CornerStyle.bothCurve,
                  enableAnimation: true,
                )
              ],
              annotations: const <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0,
                    angle: 90,
                    widget: Text(
                      'Checking',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ))
              ])
        ]));
  }*/
}

