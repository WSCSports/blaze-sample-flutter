import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:blaze_flutter_sdk/blaze_flutter_sdk.dart';
import 'package:blaze_flutter_gam_ads/blaze_flutter_gam_ads.dart';
import 'package:blaze_flutter_ima_ads/blaze_flutter_ima_ads.dart';

/// Global flag to control whether error dialogs should be shown
bool showAlerts = true;

/// Global context for showing dialogs
BuildContext? _globalContext;

/// Set the global context for error dialogs
void setGlobalContext(BuildContext context) {
  _globalContext = context;
}

/// Show error dialog to user
void _showAlert(String message) {
  if (showAlerts && _globalContext != null) {
    showDialog(
      context: _globalContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

/// Set whether to show error alerts
void setShowAlerts(bool show) {
  showAlerts = show;
}

/// Play a single story
void playStory({required String storyId, String? pageId}) {
  BlazeSDK.playStory(storyId: storyId, pageId: pageId).then((_) {
    debugPrint('playStory success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error playing Story: $error');
  });
}

/// Play stories with data source
void playStories({required BlazeDataSourceType dataSource}) {
  BlazeSDK.playStories(dataSource: dataSource).then((_) {
    debugPrint('playStories success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error playing stories: $error');
    debugPrint('Error playing stories: $error');
  });
}

/// Prepare stories
void prepareStories({required BlazeDataSourceType dataSource}) {
  BlazeSDK.prepareStories(dataSource: dataSource).then((_) {
    debugPrint('prepareStories success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error prepareStories: $error');
    debugPrint('Error prepareStories: $error');
  });
}

/// Play a single moment
void playMoment({required String momentId}) {
  BlazeSDK.playMoment(momentId: momentId).then((_) {
    debugPrint('playMoment success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error playing moment: $error');
  });
}

/// Play moments with data source
void playMoments({required BlazeDataSourceType dataSource}) {
  BlazeSDK.playMoments(dataSource: dataSource).then((_) {
    debugPrint('playMoments success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error playing moments: $error');
    debugPrint('Error playing moments: $error');
  });
}

/// Prepare moments
void prepareMoments({required BlazeDataSourceType dataSource}) {
  BlazeSDK.prepareMoments(dataSource: dataSource).then((_) {
    debugPrint('prepareMoments success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error prepareMoments: $error');
    debugPrint('Error prepareMoments: $error');
  });
}

/// Play videos with data source
void playVideos({required BlazeDataSourceType dataSource}) {
  BlazeSDK.playVideos(dataSource: dataSource).then((_) {
    debugPrint('playVideos success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error playing videos: $error');
    debugPrint('Error playing videos: $error');
  });
}

/// Play a single video
void playVideo({required String videoId}) {
  BlazeSDK.playVideo(videoId: videoId).then((_) {
    debugPrint('playVideo success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error playing video: $error');
  });
}

/// Prepare videos
void prepareVideos({required BlazeDataSourceType dataSource}) {
  BlazeSDK.prepareVideos(dataSource: dataSource).then((_) {
    debugPrint('prepareVideos success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error prepareVideos: $error');
    debugPrint('Error prepareVideos: $error');
  });
}

/// Set do not track
void setDoNotTrack() {
  BlazeSDK.setDoNotTrack(true).then((_) {
    debugPrint('set Do Not Track success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error set Do Not Track: $error');
  });
}

/// Dismiss the current player
void dismissPlayer() {
  BlazeSDK.dismissPlayer().then((_) {
    debugPrint('dismissPlayer success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error dismiss Player: $error');
  });
}

/// Set external user ID
void setExternalUserId([String? userId]) {
  BlazeSDK.setExternalUserId(userId).then((_) {
    debugPrint('setExternalUserId success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error set External UserId: $error');
  });
}

/// Handle universal link
void handleUniversalLink(String link) {
  BlazeSDK.handleUniversalLink(link).then((_) {
    debugPrint('set universal link success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error set universal link: $error');
  });
}

/// Check if can handle universal link
Future<bool> canHandleUniversalLink(String link) async {
  try {
    final result = await BlazeSDK.canHandleUniversalLink(link);
    debugPrint('canHandleUniversalLink success, result -> $result');
    return result;
  } catch (error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error handle universal link: $error');
    return false;
  }
}

/// Update geo restriction
void updateGeoRestriction(String geoLocation) {
  BlazeSDK.updateGeoRestriction(geoLocation).then((_) {
    debugPrint('updateGeoRestriction success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error updateGeoRestriction: $error');
  });
}

/// Google custom native ads delegate
final googleCustomNativeAdsDelegate = BlazeGAMCustomNativeAdsDelegate(
  onGAMAdEvent: (params) {
    debugPrint(
        'BlazeGAMDelegate - CustomNativeAds  - onGAMAdEvent - params: ${params.asJsonString()}');
  },
  onGAMAdError: (errorMessage) {
    debugPrint(
        'BlazeGAMDelegate - CustomNativeAds  - onGAMAdError - errorMessage: $errorMessage');
  },
  customGAMTargetingProperties: (params) async {
    debugPrint(
        'BlazeGAMDelegate - CustomNativeAds - customGAMTargetingProperties - params: ${params.asJsonString()}');
    // return {
    //   'test_1': 'custom_targeting_value 1',
    //   'test_2': 'custom_targeting_value 2'
    // };
    return {};
  },
  publisherProvidedId: (params) async {
    debugPrint(
        'BlazeGAMDelegate - CustomNativeAds - publisherProvidedId - params: ${params.asJsonString()}');
    // return 'test_publisherProvidedId';
    return null;
  },
  networkExtras: (params) async {
    debugPrint(
        'BlazeGAMDelegate - CustomNativeAds - networkExtras - params: ${params.asJsonString()}');
    // return {
    //   'test_string': 'custom_targeting_value 1',
    //   'test_double': 5.5,
    //   'test_bool': true
    // };
    return {};
  },
);

/// Google banner ads delegate
final googleBannerAdsDelegate = BlazeGAMBannerAdsDelegate(
  onGAMBannerAdsAdEvent: (params) {
    debugPrint(
        'BlazeGAMDelegate - BannerAds - onGAMBannerAdsAdEvent - params: ${params.asJsonString()}');
  },
  onGAMBannerAdsAdError: (errorMessage) {
    debugPrint(
        'BlazeGAMDelegate - BannerAds - onGAMBannerAdsAdError - errorMessage: $errorMessage');
  },
);

/// IMA ads delegate
final imaAdsDelegate = BlazeIMADelegate(
  onIMAAdEvent: (params) {
    debugPrint(
        'BlazeIMADelegate - onIMAAdEvent - eventType: ${params.asJsonString()}');
  },
  onIMAAdError: (errorMessage) {
    debugPrint('BlazeIMADelegate - onIMAAdError - errorMessage: $errorMessage');
  },
  additionalIMATagQueryParams: (params) async {
    debugPrint(
        'BlazeIMADelegate - additionalIMATagQueryParams - params: ${params.asJsonString()}');
    // Uncomment to return custom params:
    // return {'test_1': 'param 1', 'test_2': 'param 2'};
    return {};
  },
  customIMASettings: (params) async {
    debugPrint(
        'BlazeIMADelegate - customIMASettings - params: ${params.asJsonString()}');
    // Uncomment to return custom settings:
    // return BlazeIMASettings(
    //   ppid: 'test_ppid',
    //   language: 'es',
    //   sessionId: 'test_session_id',
    // );
    return null;
  },
  overrideAdTagUrl: (params) async {
    debugPrint(
        'BlazeIMADelegate - overrideAdTagUrl - params: ${params.asJsonString()}');
    // Uncomment to return custom ad tag URL:
    // return 'https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_preroll_skippable&sz=640x480&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=';
    return null;
  },
);

/// Global delegate implementation
final globalDelegate = BlazeGlobalDelegate(
  onEventTriggered: (params) {
    debugPrint(
        'BlazeGlobalDelegate - onEventTriggered - params: ${params.asJsonString()}');
  },
  onErrorThrown: (params) {
    debugPrint(
        'BlazeGlobalDelegate - onErrorThrown - params: ${params.asJsonString()}');
    if (showAlerts) _showAlert('SDK Error: ${params.error.message}');
  },
);

/// Player entry point delegate implementation
final playerEntryPointDelegate = BlazePlayerEntryPointDelegate(
  onDataLoadStarted: (params) {
    debugPrint(
        'BlazePlayerEntryPointDelegate - onDataLoadStarted - params: ${params.asJsonString()}');
  },
  onDataLoadComplete: (params) {
    debugPrint(
        'BlazePlayerEntryPointDelegate - onDataLoadComplete - params: ${params.asJsonString()}');
  },
  onPlayerDidAppear: (params) {
    debugPrint(
        'BlazePlayerEntryPointDelegate - onPlayerDidAppear - params: ${params.asJsonString()}');
  },
  onPlayerDidDismiss: (params) {
    debugPrint(
        'BlazePlayerEntryPointDelegate - onPlayerDidDismiss - params: ${params.asJsonString()}');
  },
  onTriggerCTA: (params) {
    debugPrint(
        'BlazePlayerEntryPointDelegate - onTriggerCTA - params: ${params.asJsonString()}');
  },
  onTriggerPlayerBodyTextLink: (params) {
    debugPrint(
        'BlazePlayerEntryPointDelegate - onTriggerPlayerBodyTextLink - params: ${params.asJsonString()}');
  },
  onPlayerEventTriggered: (params) {
    switch (params.event) {
      case BlazePlayerEventOnMomentStart event:
        debugPrint(
            'EntryPointDelegate - onPlayerEventTriggered - playerType: ${params.playerType.name} sourceId: ${params.sourceId} playerEvent: MomentId ${event.momentId}');
      case BlazePlayerEventOnStoryStart event:
        debugPrint(
            'EntryPointDelegate - onPlayerEventTriggered - playerType: ${params.playerType.name} sourceId: ${params.sourceId} playerEvent: StoryId ${event.storyId}');
      case BlazePlayerEventOnVideoStart event:
        debugPrint(
            'EntryPointDelegate - onPlayerEventTriggered - playerType: ${params.playerType.name} sourceId: ${params.sourceId} playerEvent: VideoId ${event.videoId}');
    }
  },
);

/// Create widget delegate instance for a specific widget ID
BlazeWidgetDelegate createWidgetDelegate(String widgetId) {
  return BlazeWidgetDelegate(
    onDataLoadStarted: (params) {
      debugPrint(
          'BlazeWidgetDelegate - widgetId: $widgetId - onDataLoadStarted - params: ${params.asJsonString()}');
    },
    onDataLoadComplete: (params) {
      debugPrint(
          'BlazeWidgetDelegate - widgetId: $widgetId - onDataLoadComplete - params: ${params.asJsonString()}');
    },
    onPlayerDidAppear: (params) {
      debugPrint(
          'BlazeWidgetDelegate - widgetId: $widgetId - onPlayerDidAppear - params: ${params.asJsonString()}');
    },
    onPlayerDidDismiss: (params) {
      debugPrint(
          'BlazeWidgetDelegate - widgetId: $widgetId - onPlayerDidDismiss - params: ${params.asJsonString()}');
    },
    onTriggerCTA: (params) {
      debugPrint(
          'BlazeWidgetDelegate - widgetId: $widgetId - onTriggerCTA - params: ${params.asJsonString()}');
    },
    onTriggerPlayerBodyTextLink: (params) {
      debugPrint(
          'BlazeWidgetDelegate - widgetId: $widgetId - onTriggerPlayerBodyTextLink - params: ${params.asJsonString()}');
    },
    onPlayerEventTriggered: (params) {
      switch (params.event) {
        case BlazePlayerEventOnMomentStart event:
          debugPrint(
              'BlazeWidgetDelegate - widgetId: $widgetId - onPlayerEventTriggered - playerType: ${params.playerType.name} sourceId: ${params.sourceId} playerEvent: MomentId ${event.momentId}');
        case BlazePlayerEventOnStoryStart event:
          debugPrint(
              'BlazeWidgetDelegate - widgetId: $widgetId - onPlayerEventTriggered - playerType: ${params.playerType.name} sourceId: ${params.sourceId} playerEvent: StoryId ${event.storyId}');
        case BlazePlayerEventOnVideoStart event:
          debugPrint(
              'BlazeWidgetDelegate - widgetId: $widgetId - onPlayerEventTriggered - playerType: ${params.playerType.name} sourceId: ${params.sourceId} playerEvent: VideoId ${event.videoId}');
      }
    },
    onWidgetItemClicked: (event) {
      debugPrint(
          'BlazeWidgetDelegate - widgetId: $widgetId - onWidgetItemClicked - event: ${event.asJsonString()}');
    },
  );
}

/// Extension to add pretty print functionality to any object
extension PrettyPrint on Object? {
  /// Pretty print any object as a formatted string
  String asJsonString() {
    if (this == null) return 'null';

    try {
      if (this is Map || this is List) {
        const encoder = JsonEncoder();
        return encoder.convert(this);
      } else {
        // Try to use toJson method if available
        final dynamic dynamicObject = this;
        final jsonData = dynamicObject.toJson();
        const encoder = JsonEncoder();
        return encoder.convert(jsonData);
      }
    } catch (e) {
      // If toJson fails or doesn't exist, use toString
      return toString();
    }
  }
}
