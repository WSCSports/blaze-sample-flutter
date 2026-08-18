import 'package:blaze_flutter_sdk/blaze_flutter_sdk.dart';
import 'package:blaze_flutter_sdk_example/utils/player_style_utils.dart';
import 'package:flutter/material.dart';

import '../screens/moments_grid_full_screen.dart';
import '../screens/stories_grid_full_screen.dart';
import '../screens/videos_grid_full_screen.dart';
import '../utils/sdk_utils.dart';
import '../utils/ui_utils.dart';
import '../widgets/widget_layout_utils.dart';

Widget buildStoryRowWidget(
    {required String title,
    required String widgetId,
    required BuildContext context}) {
  // Create controller instead of GlobalKey
  final controller = BlazeWidgetController();

  final dataSource = BlazeDataSourceType.labels(
      labels: BlazeWidgetLabel.singleLabel("top-stories"));

  return Column(children: <Widget>[
    buildTitleListItems(
        title, context, () => StoriesGridFullScreen(dataSource: dataSource)),
    const SizedBox(
      height: 8.0,
    ),
    SizedBox(
      width: double.infinity,
      height: 32.0,
      child: TextButton(
        onPressed: () {
          controller.reloadData();
        },
        child: const Text('Reload Data'),
      ),
    ),
    const SizedBox(
      height: 8.0,
    ),
    SizedBox(
      height: 160,
      child: BlazeStoriesRowView(
        widgetId: widgetId,
        controller: controller,
        dataSource: dataSource,
        presetWidgetLayout: BlazeWidgetLayoutPreset.stories_row_circles,
        blazeWidgetLayout: widgetLayoutStoriesRow,
        widgetDelegate: createWidgetDelegate(widgetId),
        // playerStyle: testStoryPlayerStyle,
        // playbackConfiguration: const BlazeStoriesPlaybackConfiguration(
        //   bufferingSpinnerDelayMs: 500,
        // ), // Uncomment this if you want to customize the playback configuration.
      ),
    ),
    const SizedBox(
      height: 24.0,
    ),
  ]);
}

Widget buildStoryGridWidget(
    {required String title,
    required String widgetId,
    required BuildContext context}) {
  final controller = BlazeWidgetController();

  final dataSource = BlazeDataSourceType.labels(
          labels: BlazeWidgetLabel.singleLabel("live-stories"))
      as BlazeDataSourceTypeLabels;

  return Column(children: <Widget>[
    buildTitleListItems(
        title, context, () => StoriesGridFullScreen(dataSource: dataSource)),
    const SizedBox(
      height: 8.0,
    ),
    SizedBox(
      height: 32.0,
      child: TextButton(
        onPressed: () {
          controller.reloadData();
        },
        child: const Text('Reload Data'),
      ),
    ),
    const SizedBox(
      height: 8.0,
    ),
    BlazeStoriesGridView(
      widgetId: widgetId,
      controller: controller,
      dataSource: dataSource,
      presetWidgetLayout:
          BlazeWidgetLayoutPreset.stories_grid_twoColumnsVerticalRectangles,
      isEmbeddedInScrollView: true,
      blazeWidgetLayout:
          widgetLayoutStoriesGrid.copyWith(maxDisplayItemsCount: 4),
      // playbackConfiguration: const BlazeStoriesPlaybackConfiguration(
      //   bufferingSpinnerDelayMs: 500,
      // ), // Uncomment this if you want to customize the playback configuration.
      widgetDelegate: createWidgetDelegate(widgetId),
    ),
    const SizedBox(
      height: 24.0,
    ),
  ]);
}

Widget buildMomentRowWidget(
    {required String title,
    required String widgetId,
    required BuildContext context}) {
  final controller = BlazeWidgetController();

  final dataSource = BlazeDataSourceType.labels(
      labels: BlazeWidgetLabel.singleLabel("moments"));

  return Column(children: <Widget>[
    buildTitleListItems(
        title, context, () => MomentsGridFullScreen(dataSource: dataSource)),
    const SizedBox(
      height: 8.0,
    ),
    SizedBox(
      height: 32.0,
      child: TextButton(
        onPressed: () {
          controller.reloadData();
        },
        child: const Text('Reload Data'),
      ),
    ),
    const SizedBox(
      width: double.infinity,
      height: 8.0,
    ),
    SizedBox(
      width: double.infinity,
      height: 400,
      child: BlazeMomentsRowView(
        widgetId: widgetId,
        controller: controller,
        dataSource: dataSource,
        presetWidgetLayout: BlazeWidgetLayoutPreset
            .moments_row_verticalAnimatedThumbnailsRectangles,
        blazeWidgetLayout: widgetLayoutMomentsRow,
        // playbackConfiguration: const BlazeMomentsPlaybackConfiguration(
        //   loopBehavior: BlazeMomentsLoopBehavior.loopAndAdvance(
        //     numberOfPlays: 2,
        //   ),
        // ), // Uncomment this to customize the moments playback configuration.
        widgetDelegate: createWidgetDelegate(widgetId),
      ),
    ),
    const SizedBox(
      width: double.infinity,
      height: 24.0,
    ),
  ]);
}

/// Demonstrates the Moments "widget to tabs" entry point: tapping any
/// thumbnail opens the fullscreen tabs player. The widget thumbnails are
/// driven by the FIRST tab's `dataSource`. The container-wide callbacks (tab
/// selection, CTA, etc.) are delivered through the per-widget
/// `momentsContainerTabsDelegate` parameter, scoped to this widget instance.
Widget buildMomentsTabsRowWidget(
    {required String title,
    required String widgetId,
    required BuildContext context}) {
  final controller = BlazeMomentsWidgetController();

  final tabsConfiguration = BlazeMomentsWidgetTabsConfiguration(
    containerSourceId: 'moments-tabs-demo',
    // tabsStyle: momentsTabsStyle, // Uncomment to customize the tabs strip; omitting it keeps the native default appearance.
    tabs: [
      BlazeMomentsContainerTabItem(
        containerId: 'tab-for-you',
        title: 'For You',
        dataSource: BlazeDataSourceType.labels(
          labels: BlazeWidgetLabel.singleLabel('moments'),
        ),
        // icon: const BlazePlayerTabItemCustomImageStates(
        //   selectedImage: BlazeImage(imageName: 'like'),
        //   unselectedImage: BlazeImage(imageName: 'exit'),
        // ), // Uncomment if these drawables/assets exist.
      ),
      BlazeMomentsContainerTabItem(
        containerId: 'tab-trending',
        title: 'Trending',
        dataSource: BlazeDataSourceType.labels(
          labels: BlazeWidgetLabel.singleLabel('moments'),
        ),
        shouldOrderMomentsByReadStatus: false,
      ),
      BlazeMomentsContainerTabItem(
        containerId: 'tab-latest',
        title: 'Latest',
        dataSource: BlazeDataSourceType.labels(
          labels: BlazeWidgetLabel.singleLabel('moments'),
        ),
        cachePolicyLevel: BlazeCachingLevel.defaultLevel,
      ),
    ],
    // playerStyle: testMomentsPlayerStyle, // Uncomment to customize the player launched from the tabs.
  );

  return Column(children: <Widget>[
    buildTitleListItems(
        title,
        context,
        () => MomentsGridFullScreen(
            dataSource: tabsConfiguration.tabs.first.dataSource)),
    const SizedBox(
      height: 8.0,
    ),
    SizedBox(
      height: 32.0,
      child: TextButton(
        onPressed: () {
          controller.reloadData();
        },
        child: const Text('Reload Data'),
      ),
    ),
    const SizedBox(
      width: double.infinity,
      height: 8.0,
    ),
    SizedBox(
      width: double.infinity,
      height: 400,
      child: BlazeMomentsRowView.tabs(
        widgetId: widgetId,
        controller: controller,
        tabsConfiguration: tabsConfiguration,
        presetWidgetLayout:
            BlazeWidgetLayoutPreset.moments_row_verticalRectangles,
        widgetDelegate: createWidgetDelegate(widgetId),
        momentsContainerTabsDelegate:
            createMomentsContainerTabsDelegate(widgetId),
      ),
    ),
    const SizedBox(
      width: double.infinity,
      height: 24.0,
    ),
  ]);
}

Widget buildMomentGridWidget(
    {required String title,
    required String widgetId,
    required BuildContext context}) {
  final controller = BlazeWidgetController();

  final dataSource = BlazeDataSourceType.labels(
          labels: BlazeWidgetLabel.singleLabel("moments"))
      as BlazeDataSourceTypeLabels;

  return Column(children: <Widget>[
    buildTitleListItems(
        title, context, () => MomentsGridFullScreen(dataSource: dataSource)),
    const SizedBox(
      height: 8.0,
    ),
    SizedBox(
      height: 32.0,
      child: TextButton(
        onPressed: () {
          controller.reloadData();
        },
        child: const Text('Reload Data'),
      ),
    ),
    const SizedBox(
      width: double.infinity,
      height: 8.0,
    ),
    BlazeMomentsGridView(
      widgetId: widgetId,
      controller: controller, // Pass controller instead of key
      dataSource: dataSource,
      presetWidgetLayout:
          BlazeWidgetLayoutPreset.moments_grid_twoColumnsVerticalRectangles,
      isEmbeddedInScrollView: true,
      blazeWidgetLayout:
          widgetLayoutMomentsGrid.copyWith(maxDisplayItemsCount: 4),
      // playbackConfiguration: const BlazeMomentsPlaybackConfiguration(
      //   loopBehavior: BlazeMomentsLoopBehavior.loopAndAdvance(
      //     numberOfPlays: 2,
      //   ),
      //   bufferingSpinnerDelayMs: 500,
      // ), // Uncomment this to customize the moments playback configuration.
      widgetDelegate: createWidgetDelegate(widgetId),
    ),
    const SizedBox(
      width: double.infinity,
      height: 24.0,
    ),
  ]);
}

Widget buildVideoRowWidget({
  required String title,
  required String widgetId,
  required BuildContext context,
}) {
  final controller = BlazeWidgetController();

  final dataSource = BlazeDataSourceType.labels(
    labels: BlazeWidgetLabel.singleLabel("videos"),
  );

  return Column(
    children: <Widget>[
      buildTitleListItems(
        title,
        context,
        () => VideosGridFullScreen(dataSource: dataSource),
      ),
      const SizedBox(height: 8.0),
      SizedBox(
        width: double.infinity,
        height: 32.0,
        child: TextButton(
          onPressed: () {
            controller.reloadData();
          },
          child: const Text('Reload Data'),
        ),
      ),
      const SizedBox(height: 8.0),
      SizedBox(
        width: double.infinity,
        height: 160,
        child: BlazeVideosRowView(
          widgetId: widgetId,
          controller: controller, // Pass controller instead of key
          dataSource: dataSource,
          presetWidgetLayout:
              BlazeWidgetLayoutPreset.videos_row_horizontalRectangles,
          blazeWidgetLayout: widgetLayoutVideosRow,
          // playbackConfiguration: const BlazeVideosPlaybackConfiguration(
          //   multiAspectRatio: true,
          //   shouldOpenInLandscape: true,
          //   bufferingSpinnerDelayMs: 500,
          // ), // Uncomment this to customize the videos playback configuration.
          widgetDelegate: createWidgetDelegate(widgetId),
        ),
      ),
      const SizedBox(width: double.infinity, height: 24.0),
    ],
  );
}

Widget buildVideoGridWidget({
  required String title,
  required String widgetId,
  required BuildContext context,
}) {
  final controller = BlazeWidgetController();

  final dataSource = BlazeDataSourceType.labels(
    labels: BlazeWidgetLabel.singleLabel("videos"),
  ) as BlazeDataSourceTypeLabels;

  return Column(
    children: <Widget>[
      buildTitleListItems(
        title,
        context,
        () => VideosGridFullScreen(dataSource: dataSource),
      ),
      const SizedBox(height: 8.0),
      SizedBox(
        height: 32.0,
        child: TextButton(
          onPressed: () {
            controller.reloadData();
          },
          child: const Text('Reload Data'),
        ),
      ),
      const SizedBox(width: double.infinity, height: 8.0),
      BlazeVideosGridView(
        widgetId: widgetId,
        controller: controller, // Pass controller instead of key
        dataSource: dataSource,
        presetWidgetLayout:
            BlazeWidgetLayoutPreset.videos_grid_twoColumnsVerticalRectangles,
        isEmbeddedInScrollView: true,
        blazeWidgetLayout:
            widgetLayoutVideosGrid.copyWith(maxDisplayItemsCount: 4),
        // playbackConfiguration: const BlazeVideosPlaybackConfiguration(
        //   multiAspectRatio: true,
        //   shouldOpenInLandscape: true,
        //   bufferingSpinnerDelayMs: 500,
        // ), // Uncomment this to customize the videos playback configuration.
        widgetDelegate: createWidgetDelegate(widgetId),
      ),
      const SizedBox(width: double.infinity, height: 24.0),
    ],
  );
}
