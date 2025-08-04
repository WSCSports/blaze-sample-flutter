import 'dart:io';

import 'package:blaze_flutter_sdk/blaze_flutter_sdk.dart';
import 'package:blaze_flutter_sdk_example/utils/sdk_utils.dart';
import 'package:flutter/material.dart';

class VideosGridFullScreen extends StatelessWidget {
  const VideosGridFullScreen({
    super.key,
    required this.dataSource,
  });

  final BlazeDataSourceType dataSource;

  @override
  Widget build(BuildContext context) {
    final controller = BlazeWidgetController();

    if (Platform.isAndroid) {
      // On Android if we are reusing same widgetId -> IF we want to fetch most updated content -> we need to reload the widget.
      controller.reloadData();
    }

    const widgetId = "Videos Grid FullScreen";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: BlazeVideosGridView(
                widgetId: "Videos Grid FullScreen",
                controller: controller, // Pass controller instead of key
                dataSource: dataSource,
                presetWidgetLayout: BlazeWidgetLayoutPreset
                    .videos_grid_twoColumnsVerticalRectangles,
                widgetDelegate: createWidgetDelegate(widgetId),
              )),
        ),
      ),
    );
  }
}
