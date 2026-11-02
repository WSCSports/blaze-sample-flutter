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

/// Show alert dialog to user
void _showAlert(String message, {String title = 'Error'}) {
  if (showAlerts && _globalContext != null) {
    showDialog(
      context: _globalContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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

/// Blocks rapid double-taps on the play buttons so we don't launch two
/// entry-point players at once (black screen). The guard flag is set before
/// the launch and cleared when the play call completes.
const Duration _playCooldown = Duration(milliseconds: 1500);
bool _isPlayLaunching = false;
DateTime? _lastPlayLaunch;

bool _shouldBlockPlayLaunch() {
  final now = DateTime.now();
  if (_isPlayLaunching ||
      (_lastPlayLaunch != null &&
          now.difference(_lastPlayLaunch!) < _playCooldown)) {
    return true;
  }
  _isPlayLaunching = true;
  _lastPlayLaunch = now;
  return false;
}

/// Play a single story
void playStory({required String storyId, String? pageId}) {
  if (_shouldBlockPlayLaunch()) return;
  BlazeSDK.playStory(
    storyId: storyId,
    pageId: pageId,
    // playbackConfiguration: const BlazeStoriesPlaybackConfiguration(
    //   bufferingSpinnerDelayMs: 500,
    // ), // Uncomment this if you want to customize the playback configuration.
  ).then((_) {
    debugPrint('playStory success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error playing Story: $error');
  }).whenComplete(() => _isPlayLaunching = false);
}

/// Play stories with data source
void playStories({
  required BlazeDataSourceType dataSource,
  String? entryContentId,
}) {
  if (_shouldBlockPlayLaunch()) return;
  BlazeSDK.playStories(
    dataSource: dataSource,
    entryContentId: entryContentId,
    // playbackConfiguration: const BlazeStoriesPlaybackConfiguration(
    //   bufferingSpinnerDelayMs: 500,
    // ), // Uncomment this if you want to customize the playback configuration.
  ).then((_) {
    debugPrint('playStories success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error playing stories: $error');
    debugPrint('Error playing stories: $error');
  }).whenComplete(() => _isPlayLaunching = false);
}

/// Prepare stories
void prepareStories({
  required BlazeDataSourceType dataSource,
  String? entryContentId,
}) {
  BlazeSDK.prepareStories(dataSource: dataSource, entryContentId: entryContentId)
      .then((_) {
    debugPrint('prepareStories success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error prepareStories: $error');
    debugPrint('Error prepareStories: $error');
  });
}

/// Play a single moment
void playMoment({required String momentId}) {
  if (_shouldBlockPlayLaunch()) return;
  BlazeSDK.playMoment(momentId: momentId).then((_) {
    debugPrint('playMoment success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error playing moment: $error');
  }).whenComplete(() => _isPlayLaunching = false);
}

/// Play moments with data source
void playMoments({
  required BlazeDataSourceType dataSource,
  String? entryContentId,
  BlazeMomentsPlayerStyle? playerStyle,
}) {
  if (_shouldBlockPlayLaunch()) return;
  BlazeSDK.playMoments(
          dataSource: dataSource,
          entryContentId: entryContentId,
          playerStyle: playerStyle)
      .then((_) {
    debugPrint('playMoments success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error playing moments: $error');
    debugPrint('Error playing moments: $error');
  }).whenComplete(() => _isPlayLaunching = false);
}

/// Prepare moments
void prepareMoments({
  required BlazeDataSourceType dataSource,
  String? entryContentId,
}) {
  BlazeSDK.prepareMoments(dataSource: dataSource, entryContentId: entryContentId)
      .then((_) {
    debugPrint('prepareMoments success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error prepareMoments: $error');
    debugPrint('Error prepareMoments: $error');
  });
}

/// Append moments to the currently presented moments player
void appendMomentsToPlayer({
  required String sourceId,
  required BlazeDataSourceType dataSource,
  bool shouldOrderContentByReadStatus = false,
}) {
  BlazeSDK.appendMomentsToPlayer(
    sourceId: sourceId,
    dataSource: dataSource,
    shouldOrderContentByReadStatus: shouldOrderContentByReadStatus,
  ).then((_) {
    debugPrint('appendMomentsToPlayer success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error append moments to player: $error');
    debugPrint('Error append moments to player: $error');
  });
}

/// Play videos with data source
void playVideos({
  required BlazeDataSourceType dataSource,
  String? entryContentId,
}) {
  if (_shouldBlockPlayLaunch()) return;
  BlazeSDK.playVideos(
    dataSource: dataSource,
    entryContentId: entryContentId,
    // playbackConfiguration: const BlazeVideosPlaybackConfiguration(
    //   multiAspectRatio: true,
    //   shouldOpenInLandscape: false,
    //   bufferingSpinnerDelayMs: 500,
    // ), // Uncomment this if you want to customize the playback configuration.
  ).then((_) {
    debugPrint('playVideos success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error playing videos: $error');
    debugPrint('Error playing videos: $error');
  }).whenComplete(() => _isPlayLaunching = false);
}

/// Play a single video
void playVideo({required String videoId}) {
  if (_shouldBlockPlayLaunch()) return;
  BlazeSDK.playVideo(
    videoId: videoId,
    // playbackConfiguration: const BlazeVideosPlaybackConfiguration(
    //   multiAspectRatio: true,
    //   shouldOpenInLandscape: true,
    //   bufferingSpinnerDelayMs: 500,
    // ), // Uncomment this if you want to customize the playback configuration.
  ).then((_) {
    debugPrint('playVideo success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error playing video: $error');
  }).whenComplete(() => _isPlayLaunching = false);
}

/// Prepare videos
void prepareVideos({
  required BlazeDataSourceType dataSource,
  String? entryContentId,
}) {
  BlazeSDK.prepareVideos(dataSource: dataSource, entryContentId: entryContentId)
      .then((_) {
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

/// Forces the global mute state for every Blaze player (Stories / Moments /
/// Videos). The SDK does not persist this value, so the host app must
/// re-apply it on each launch.
Future<void> setPlayerSoundState(BlazePlayerSoundState state) {
  return BlazeSDK.setPlayerSoundState(state).then((_) {
    debugPrint("setPlayerSoundState('${state.name}') success");
  }).catchError((error) {
    if (showAlerts) _showAlert('Error setPlayerSoundState: $error');
    debugPrint('Error setPlayerSoundState: $error');
  });
}

/// Read the current SDK-wide mute state.
Future<bool> getIsMuted() async {
  try {
    final result = await BlazeSDK.isMuted();
    debugPrint('isMuted success, result -> $result');
    return result;
  } catch (error) {
    if (showAlerts) _showAlert('Error isMuted: $error');
    debugPrint('Error isMuted: $error');
    return true; // native default is muted
  }
}

/// Show the standalone search screen
void showSearchScreen({BlazeSearchScreenOptions? options}) {
  BlazeSDK.showSearchScreen(options: options).then((_) {
    debugPrint('showSearchScreen success');
  }).catchError((error) {
    if (showAlerts) _showAlert('Error showSearchScreen: $error');
    debugPrint('Error showSearchScreen: $error');
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
  BlazeSDK.handleUniversalLink(link: link).then((_) {
    debugPrint('set universal link success');
  }).catchError((error) {
    if (showAlerts) _showAlert('$error');
    debugPrint('Error set universal link: $error');
  });
}

/// Check if can handle universal link
Future<bool> canHandleUniversalLink(String link) async {
  try {
    final result = await BlazeSDK.canHandleUniversalLink(link: link);
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
  onGAMBannerAdsAdError: (params) {
    debugPrint(
        'BlazeGAMDelegate - BannerAds - onGAMBannerAdsAdError - params: ${params.asJsonString()}');
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
  // playbackModificationHandler: (request) {
  //   return const BlazePlaybackModificationResponse(
  //       modifiedURL: 'https://example.com/modified-url.mp4');
  // },
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
  onTriggerCustomActionButton: (params) {
    debugPrint(
        'EntryPointDelegate - onTriggerCustomActionButton - params: ${params.asJsonString()}');
    if (showAlerts) {
      _showAlert('${params.buttonName} (${params.buttonId})',
          title: 'Custom Action');
    }
  },
  onReadStatusChanged: (params) {
    debugPrint(
        'EntryPointDelegate - onReadStatusChanged - params: ${params.asJsonString()}');
  },
);

/// Casting delegate implementation
final castingDelegate = BlazeCastingDelegate(
  onCastingStateChanged: (params) {
    debugPrint(
        'BlazeCastingDelegate - onCastingStateChanged - params: ${params.asJsonString()}');
  },
);

/// Pip delegate implementation
final pipDelegate = BlazePipDelegate(
  onPiPStateChanged: (params) {
    debugPrint(
        'BlazePipDelegate - onPiPStateChanged - params: ${params.asJsonString()}');
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
    onTriggerCustomActionButton: (params) {
      debugPrint(
          'BlazeWidgetDelegate - widgetId: $widgetId - onTriggerCustomActionButton - params: ${params.asJsonString()}');
      if (showAlerts) {
        _showAlert('${params.buttonName} (${params.buttonId})',
            title: 'Custom Action');
      }
    },
  );
}

/// Create a delegate for the Moments "widget to tabs" fullscreen container.
/// Pass it per-widget via the `momentsContainerTabsDelegate` parameter on
/// `BlazeMomentsRowView` / `BlazeMomentsGridView`.
BlazePlayerContainerTabsDelegate createMomentsContainerTabsDelegate(
    String widgetId) {
  return BlazePlayerContainerTabsDelegate(
    onTabSelected: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onTabSelected - params: ${params.asJsonString()}');
    },
    onDataLoadStarted: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onDataLoadStarted - params: ${params.asJsonString()}');
    },
    onDataLoadComplete: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onDataLoadComplete - params: ${params.asJsonString()}');
    },
    onPlayerDidAppear: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onPlayerDidAppear - params: ${params.asJsonString()}');
    },
    onPlayerDidDismiss: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onPlayerDidDismiss - params: ${params.asJsonString()}');
    },
    onTriggerCTA: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onTriggerCTA - params: ${params.asJsonString()}');
    },
    onTriggerPlayerBodyTextLink: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onTriggerPlayerBodyTextLink - params: ${params.asJsonString()}');
    },
    onPlayerEventTriggered: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onPlayerEventTriggered - params: ${params.asJsonString()}');
    },
    onTriggerCustomActionButton: (params) {
      debugPrint(
          'MomentsContainerTabsDelegate - widgetId: $widgetId - onTriggerCustomActionButton - params: ${params.asJsonString()}');
      if (showAlerts) {
        _showAlert('${params.buttonName} (${params.buttonId})',
            title: 'Custom Action (Tabs)');
      }
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
