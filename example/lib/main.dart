import 'package:flutter_band_fit_app/app_theme.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/controllers/theme_controller.dart';
import 'package:flutter_band_fit_app/splash_screen.dart';
import 'package:get/get.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  //final _flutterBandFitPlugin = FlutterBandFit();

  final themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Band Fit',
      //initialBinding: ActivityServiceProvider(),
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: themeController.theme,
      initialRoute: '/',
      //localizationsDelegates: [
      // GlobalMaterialLocalizations.delegate,
      // GlobalCupertinoLocalizations.delegate,
      // GlobalWidgetsLocalizations.delegate,
      // DefaultCupertinoLocalizations.delegate,
      //  ],
      getPages: [
        GetPage(
          name: '/',
          page: () => const Splash(),
        ),
        // GetPage(name: '/edit_name', page: () => UpdateStoreName()),
        // GetPage(name: '/add_followers', page: () => AddFollowers()),
        // GetPage(name: '/toggle_status', page: () => StoreStatus()),
        // GetPage(name: '/edit_follower_count', page: () => AddFollowerCount()),
        // GetPage(name: '/add_reviews', page: () => AddReviews()),
        // GetPage(name: '/update_menu', page: () => const UpdateMenu()),
      ],
      home: const Splash(),
    );
  }
}
