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
        widgetDelegate: createWidgetDelegate(widgetId),
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
        widgetDelegate: createWidgetDelegate(widgetId),
      ),
      const SizedBox(width: double.infinity, height: 24.0),
    ],
  );
}
