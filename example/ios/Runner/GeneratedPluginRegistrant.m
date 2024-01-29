//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<connectivity/FLTConnectivityPlugin.h>)
#import <connectivity/FLTConnectivityPlugin.h>
#else
@import connectivity;
#endif

#if __has_include(<flutter_aliplayer/FlutterAliplayerPlugin.h>)
#import <flutter_aliplayer/FlutterAliplayerPlugin.h>
#else
@import flutter_aliplayer;
#endif

#if __has_include(<fluttertoast/FluttertoastPlugin.h>)
#import <fluttertoast/FluttertoastPlugin.h>
#else
@import fluttertoast;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<qrcode_reader/QRCodeReaderPlugin.h>)
#import <qrcode_reader/QRCodeReaderPlugin.h>
#else
@import qrcode_reader;
#endif

#if __has_include(<sqflite/SqflitePlugin.h>)
#import <sqflite/SqflitePlugin.h>
#else
@import sqflite;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTConnectivityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTConnectivityPlugin"]];
  [FlutterAliplayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterAliplayerPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [QRCodeReaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"QRCodeReaderPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
}

@end
