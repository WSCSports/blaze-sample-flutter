import 'package:flutter/material.dart';
import 'package:blaze_flutter_sdk/blaze_flutter_sdk.dart';
import '../utils/app_follow_entities_manager.dart';
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
  final TextEditingController _addEntityController = TextEditingController();
  final TextEditingController _removeEntityController = TextEditingController();

  bool _showAlerts = true;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    // Reflect the current SDK-wide mute state on mount (native default is
    // muted).
    sdk_utils.getIsMuted().then((muted) {
      if (!mounted) return;
      setState(() => _isMuted = muted);
    });
  }

  Future<void> _togglePlayerSoundState() async {
    await sdk_utils.setPlayerSoundState(
      _isMuted ? BlazePlayerSoundState.unmute : BlazePlayerSoundState.mute,
    );
    // Re-read the state from the SDK so the button label reflects the real
    // value.
    final muted = await sdk_utils.getIsMuted();
    if (!mounted) return;
    setState(() => _isMuted = muted);
  }

  @override
  void dispose() {
    _geoController.dispose();
    _universalLinkController.dispose();
    _externalUserIdController.dispose();
    _addEntityController.dispose();
    _removeEntityController.dispose();
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

  final _forYouWithLabelFilterDataSource = BlazeDataSourceType.recommendations(
    recommendationsType: BlazeRecommendationsType.forYou(
      anyLabelFilter: ['667be28ade367c1ab12b17a7', '667be2a22a660425bcaffdbf'],
    ),
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
          // Fill mode makes the iOS bottom safe-area bleed visible; compare the two.
          _buildActionSection(
            'Play Moments (fill)',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playMoments(
                dataSource: _momentsDataSource,
                playerStyle: const BlazeMomentsPlayerStyle(
                  playerDisplayMode:
                      BlazePlayerDisplayMode.resizeAspectFillCenterCrop,
                ),
              ),
            ),
          ),
          _buildActionSection(
            'Play Moments (fill, iOS bottom safe area)',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playMoments(
                dataSource: _momentsDataSource,
                playerStyle: const BlazeMomentsPlayerStyle(
                  playerDisplayMode:
                      BlazePlayerDisplayMode.resizeAspectFillCenterCrop,
                  ignoresBottomSafeArea: true,
                ),
              ),
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
            'Play Recommendations',
            child: _buildActionButton(
              'Play',
              () => sdk_utils.playMoments(
                dataSource: _forYouWithLabelFilterDataSource,
              ),
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
          _buildActionSection(
            'Show Search Screen',
            child: _buildActionButton(
              'Search',
              () => sdk_utils.showSearchScreen(
                options: BlazeSearchScreenOptions(
                  suggestionsDataSource: BlazeDataSourceType.labels(
                    labels: BlazeWidgetLabel.singleLabel('moments'),
                  ),
                ),
              ),
            ),
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
            'Player Sound (${_isMuted ? 'Muted' : 'Unmuted'})',
            child: _buildActionButton(
              _isMuted ? 'Unmute' : 'Mute',
              _togglePlayerSoundState,
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
          _buildSectionHeader('Follow Entities'),
          _buildActionSection(
            'Add Entity',
            child: _buildInputActionRow(
              controller: _addEntityController,
              hint: 'Entity ID',
              buttonTitle: 'Add',
              onPressed: () {
                final id = _addEntityController.text.trim();
                if (id.isNotEmpty) {
                  AppFollowEntitiesManager().insertFollowedEntities(
                      [BlazeFollowEntity(id: id)]).then((_) {
                    if (!context.mounted) return;
                    _showInfoDialog('Follow Entities', 'Added: $id');
                    _addEntityController.clear();
                  });
                }
              },
            ),
          ),
          _buildActionSection(
            'Remove Entity',
            child: _buildInputActionRow(
              controller: _removeEntityController,
              hint: 'Entity ID',
              buttonTitle: 'Remove',
              onPressed: () {
                final id = _removeEntityController.text.trim();
                if (id.isNotEmpty) {
                  AppFollowEntitiesManager().removeFollowedEntities(
                      [BlazeFollowEntity(id: id)]).then((_) {
                    if (!context.mounted) return;
                    _showInfoDialog('Follow Entities', 'Removed: $id');
                    _removeEntityController.clear();
                  });
                }
              },
            ),
          ),
          _buildActionSection(
            'Get All Entities',
            child: _buildActionButton('Get', () {
              AppFollowEntitiesManager().getFollowedEntities().then((entities) {
                if (!context.mounted) return;
                _showInfoDialog(
                  'Followed Entities',
                  entities.isEmpty
                      ? '(empty)'
                      : entities.map((entity) => entity.id).join(', '),
                );
              });
            }),
          ),
          _buildActionSection(
            'Clear All Entities',
            child: _buildActionButton(
              'Clear',
              () {
                AppFollowEntitiesManager().clearAll().then((_) {
                  if (!context.mounted) return;
                  _showInfoDialog('Follow Entities', 'All entities cleared');
                });
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
    String buttonTitle = 'Set',
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
        _buildActionButton(buttonTitle, onPressed),
      ],
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
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
