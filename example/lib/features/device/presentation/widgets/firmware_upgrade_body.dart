import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/features/device/presentation/controllers/firmware_upgrade_controller.dart';

class FirmwareUpgradeBody extends GetView<FirmwareUpgradeController> {
  const FirmwareUpgradeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            color: Colors.green,
            child: const Column(
              children: [
                SizedBox(height: 44),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: GlobalMethods.navigatePopBack,
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Text(
                      textFirmwareUpgrade,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              textNewestVersion,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.13,
        child: Column(
          children: [
            Container(
              height: 44,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(30),
              ),
              child: MaterialButton(
                onPressed: () {},
                child: const Text(
                  textCheckForUpdates,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
