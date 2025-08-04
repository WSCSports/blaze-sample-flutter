import 'dart:ui';

import 'package:blaze_flutter_sdk_example/navigation/app_navigation.dart';
import 'package:blaze_flutter_sdk/blaze_flutter_sdk.dart';
import 'package:blaze_flutter_gam_ads/blaze_flutter_gam_ads.dart';
import 'package:blaze_flutter_ima_ads/blaze_flutter_ima_ads.dart';
import 'package:blaze_flutter_sdk_example/utils/player_style_utils.dart';
import 'package:blaze_flutter_sdk_example/utils/sdk_utils.dart' as sdk_utils;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

sealed class ScreenState {}

class LoadingState extends ScreenState {}

class LoadedState extends ScreenState {}

class ErrorState extends ScreenState {
  final String? message;

  ErrorState(this.message);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScreenState _screenState = LoadingState(); // Default to loading state

  @override
  void initState() {
    super.initState();
    initBlazeSDK();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_screenState) {
      case LoadingState():
        content = const Center(child: CircularProgressIndicator());
        break;
      case ErrorState(message: var errorMessage):
        content = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('An error occurred: $errorMessage',
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: retryLoading,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
        break;
      case LoadedState():
        content = const AppNavigation();
        break;
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('he', ''), // Hebrew
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: content,
    );
  }

  // Initialize the Blaze SDK.
  Future<void> initBlazeSDK() async {
    try {
      final isBlazeSDKInitialized = await BlazeSDK.isInitialized();
      if (!isBlazeSDKInitialized) {
        await BlazeSDK.initSDK(
            apiKey: '<API_KEY>',
            cachingSize: 512,
            cachingLevel: BlazeCachingLevel.defaultLevel,
            // defaultStoryPlayerStyle: testStoryPlayerStyle,
            // defaultMomentsPlayerStyle: testMomentsPlayerStyle,
            // defaultVideosPlayerStyle: testVideosPlayerStyle,
            globalDelegate: sdk_utils.globalDelegate,
            playerEntryPointDelegate: sdk_utils.playerEntryPointDelegate);
      }

      // GAM Custom Native Ads Setup (If you want to support Google's CustomNative ads)
      await BlazeGAM.enableCustomNativeAds(
        defaultAdConfig: BlazeGAMCustomNativeAdsDefaultConfig(
          adUnit: "[Your default ad unit id]",
          templateId: "[Your default template id]",
        ),
        delegate: sdk_utils.googleCustomNativeAdsDelegate,
      );

      // GAM Banner Ads Setup (If you want to support Google's Banner ads)
      await BlazeGAM.enableBannerAds(
          delegate: sdk_utils.googleBannerAdsDelegate);

      // IMA Ads Setup (If you want to support Google's IMA ads)
      await BlazeIMA.enableAds(
        delegate: sdk_utils.imaAdsDelegate,
      );

      debugPrint('initBlazeSDK success');

      setState(() {
        _screenState = LoadedState();
      });
    } catch (e) {
      debugPrint('BlazeSDK.init error: $e');

      setState(() {
        String errorMessage;
        if (e is BlazeException) {
          errorMessage = e.blazeError.asJsonString();
        } else {
          errorMessage = "$e";
        }
        _screenState = ErrorState(errorMessage);
      });
    }
  }

  void retryLoading() {
    setState(() {
      _screenState = LoadingState();
    });

    initBlazeSDK();
  }
}
