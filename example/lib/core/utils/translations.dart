import 'package:get/get.dart';

class Messages extends Translations {


  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
        },
        'de_DE': {
          'hello': 'Hallo Welt',
        }
      };

}
//Text('hello'.tr);

// Obx(
// () => Text(
// storeController.followerCount.value.toString(),
// style: const TextStyle(fontSize: 48),
// ),
// )

// for named routes
//Get.toNamed('/second'),
// to close, then navigate to named route
//Get.offAndToNamed('/second'),