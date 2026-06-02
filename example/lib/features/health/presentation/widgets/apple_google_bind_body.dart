import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/features/health/presentation/controllers/apple_google_bind_controller.dart';

class AppleGoogleBindBody extends GetView<AppleGoogleBindController> {
  const AppleGoogleBindBody({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(Platform.isIOS ? textAppleHealth : textGoogleFit),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined),
            onPressed: controller.goBack,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  Platform.isIOS
                      ? 'assets/fit/apple_health.png'
                      : 'assets/fit/gfit.png',
                  width: 70,
                  height: 70,
                ),
              ),
              Center(
                child: Text(
                  Platform.isIOS ? textAppleHealth : textGoogleFit,
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: controller.onBindTap,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          Platform.isIOS ? textAppleHealth : textGoogleFit,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.isBounded.value ? textLinked : textLink,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey.withValues(alpha: 0.7),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
