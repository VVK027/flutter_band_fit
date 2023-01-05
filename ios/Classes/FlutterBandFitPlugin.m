#import "FlutterBandFitPlugin.h"
#if __has_include(<flutter_band_fit/flutter_band_fit-Swift.h>)
#import <flutter_band_fit/flutter_band_fit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_band_fit-Swift.h"
#endif

@implementation FlutterBandFitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBandFitPlugin registerWithRegistrar:registrar];
}
@end
