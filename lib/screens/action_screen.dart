import 'package:flutter/material.dart';
import 'package:blaze_flutter_sdk/blaze_flutter_sdk.dart';
import '../utils/sdk_utils.dart' as sdk_utils;

class ActionScreen extends StatefulWidget {
  const ActionScreen({super.key});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _geoController = TextEditingController();
  final TextEditingController _universalLinkController =
      TextEditingController();
  final TextEditingController _externalUserIdController =
      TextEditingController();

  bool _showAlerts = true;

  @override
  void dispose() {
    _geoController.dispose();
    _universalLinkController.dispose();
    _externalUserIdController.dispose();
    super.dispose();
  }

  // Sample data sources for testing
  final _storiesDataSource = BlazeDataSourceType.labels(
    labels: BlazeWidgetLabel.singleLabel('live-stories'),
  );

  final _momentsDataSource = BlazeDataSourceType.labels(
    labels: BlazeWidgetLabel.singleLabel('moments'),
  );

  final _videosDataSource = BlazeDataSourceType.labels(
    labels: BlazeWidgetLabel.singleLabel('videos'),
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildSectionHeader('Player'),
          _buildActionSection(
            'Play Story',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playStory(storyId: '<STORY_ID>'),
            ),
          ),
          _buildActionSection(
            'Play Stories',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playStories(dataSource: _storiesDataSource),
            ),
          ),
          _buildActionSection(
            'Prepare Stories',
            child: _buildActionButton(
              'Prepare',
              () => sdk_utils.prepareStories(dataSource: _storiesDataSource),
            ),
          ),
          _buildActionSection(
            'Play Moment',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playMoment(momentId: '<MOMENT_ID>'),
            ),
          ),
          _buildActionSection(
            'Play Moments',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playMoments(dataSource: _momentsDataSource),
            ),
          ),
          _buildActionSection(
            'Prepare Moments',
            child: _buildActionButton(
              'Prepare',
              () => sdk_utils.prepareMoments(dataSource: _momentsDataSource),
            ),
          ),
          _buildActionSection(
            'Play Video',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playVideo(videoId: '<VIDEO_ID>'),
            ),
          ),
          _buildActionSection(
            'Play Videos',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playVideos(dataSource: _videosDataSource),
            ),
          ),
          _buildActionSection(
            'Prepare Videos',
            child: _buildActionButton(
              'Prepare',
              () => sdk_utils.prepareVideos(dataSource: _videosDataSource),
            ),
          ),
          _buildActionSection(
            'Play Story Page',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playStory(
                storyId: '<STORY_ID>',
                pageId: '<PAGE_ID>',
              ),
            ),
          ),
          _buildActionSection(
            'Dismiss Player',
            child:
                _buildActionButton('Dismiss', () => sdk_utils.dismissPlayer()),
          ),
          _buildSectionHeader('Actions'),
          _buildActionSection(
            'Set Do Not Track',
            child: _buildActionButton(
              'Set',
              () => sdk_utils.setDoNotTrack(),
            ),
          ),
          _buildActionSection(
            'Set External User Id',
            child: _buildInputActionRow(
              controller: _externalUserIdController,
              hint: 'ID',
              onPressed: () => sdk_utils.setExternalUserId(
                _externalUserIdController.text.isEmpty
                    ? null
                    : _externalUserIdController.text,
              ),
            ),
          ),
          _buildActionSection(
            'Set Universal Link',
            child: _buildInputActionRow(
              controller: _universalLinkController,
              hint: 'Link',
              onPressed: () {
                final link = _universalLinkController.text;
                if (link.isNotEmpty) {
                  sdk_utils.handleUniversalLink(link);
                }
              },
            ),
          ),
          _buildActionSection(
            'Update Geo Location',
            child: _buildInputActionRow(
              controller: _geoController,
              hint: 'Location',
              onPressed: () {
                final geo = _geoController.text;
                if (geo.isNotEmpty) {
                  sdk_utils.updateGeoRestriction(geo);
                }
              },
            ),
          ),
          _buildToggleSection(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildActionSection(String title, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 17),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, VoidCallback onPressed) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3498DB),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
        ),
        onPressed: onPressed,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInputActionRow({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 36,
          margin: const EdgeInsets.only(right: 6),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        _buildActionButton('Set', onPressed),
      ],
    );
  }

  Widget _buildToggleSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Show Errors Alerts:',
            style: TextStyle(fontSize: 17),
          ),
          Switch(
            value: _showAlerts,
            onChanged: (value) {
              setState(() {
                _showAlerts = value;
              });
              sdk_utils.setShowAlerts(value);
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
