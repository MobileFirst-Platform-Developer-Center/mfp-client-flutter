#import "MobilefoundationPlugin.h"
#if __has_include(<mobilefoundation/mobilefoundation-Swift.h>)
#import <mobilefoundation/mobilefoundation-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mobilefoundation-Swift.h"
#endif

@implementation MobilefoundationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMobilefoundationPlugin registerWithRegistrar:registrar];
}
@end
