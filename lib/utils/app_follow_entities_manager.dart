import 'dart:async';

import 'package:blaze_flutter_sdk/blaze_flutter_sdk.dart';
import 'package:flutter/foundation.dart';

import 'sdk_utils.dart' show PrettyPrint;

const _syncDebounce = Duration(milliseconds: 500);

/// App-level manager for follow entities.
///
/// Wraps the [BlazeSDK] follow entities API and demonstrates the recommended
/// sync pattern: instead of persisting on every follow/unfollow action, we
/// debounce and always read the latest SDK runtime snapshot. This avoids race
/// conditions when the user rapidly follows/unfollows while the player is open.
///
/// For a production app, replace the in-memory store with `shared_preferences`
/// or your own remote/local persistence layer.
class AppFollowEntitiesManager {
  AppFollowEntitiesManager._();

  static final AppFollowEntitiesManager _instance =
      AppFollowEntitiesManager._();

  factory AppFollowEntitiesManager() => _instance;

  Timer? _syncTimer;
  List<String> _followedEntityIds = [];

  /// Initialize the follow entities system.
  /// Call after [BlazeSDK.initSDK] completes.
  void start() {
    BlazeSDK.setFollowEntitiesDelegate(_delegate);
    _loadAndApplyStoredEntities();
    debugPrint('[AppFollowEntitiesManager] Started');
  }

  Future<void> setFollowedEntities(List<String> entityIds) async {
    await BlazeSDK.setFollowedEntities(entityIds);
    _followedEntityIds = List<String>.from(entityIds);
    debugPrint('[AppFollowEntitiesManager] setFollowedEntities: $entityIds');
  }

  Future<void> insertFollowedEntities(List<String> entityIds) async {
    await BlazeSDK.insertFollowedEntities(entityIds);
    _followedEntityIds = {..._followedEntityIds, ...entityIds}.toList();
    debugPrint('[AppFollowEntitiesManager] insertFollowedEntities: $entityIds');
  }

  Future<void> removeFollowedEntities(List<String> entityIds) async {
    await BlazeSDK.removeFollowedEntities(entityIds);
    _followedEntityIds =
        _followedEntityIds.where((id) => !entityIds.contains(id)).toList();
    debugPrint('[AppFollowEntitiesManager] removeFollowedEntities: $entityIds');
  }

  Future<List<String>> getFollowedEntities() async {
    final ids = await BlazeSDK.getFollowedEntities();
    debugPrint('[AppFollowEntitiesManager] getFollowedEntities: $ids');
    return ids;
  }

  Future<void> clearAll() async {
    await BlazeSDK.setFollowedEntities([]);
    _followedEntityIds = [];
    debugPrint('[AppFollowEntitiesManager] clearAll');
  }

  // ---- Private ----

  late final BlazeFollowEntitiesDelegate _delegate =
      BlazeFollowEntitiesDelegate(
    onFollowEntityClicked: (params) {
      debugPrint(
          '[AppFollowEntitiesManager] onFollowEntityClicked: ${params.asJsonString()}');

      if (params.newFollowingState) {
        debugPrint('  → Entity ${params.followEntity.id} is now FOLLOWED');
      } else {
        debugPrint('  → Entity ${params.followEntity.id} is now UNFOLLOWED');
      }

      _scheduleSyncToStorage();
    },
  );

  /// Debounced sync: waits for rapid follow/unfollow actions to settle, then
  /// reads the latest snapshot from the SDK and persists it.
  void _scheduleSyncToStorage() {
    _syncTimer?.cancel();
    _syncTimer = Timer(_syncDebounce, _syncToStorage);
  }

  Future<void> _syncToStorage() async {
    try {
      final currentIds = await BlazeSDK.getFollowedEntities();
      _followedEntityIds = currentIds;
      // In production: persist to shared_preferences here.
      debugPrint(
          '[AppFollowEntitiesManager] syncToStorage — snapshot: $currentIds');
    } catch (e) {
      debugPrint('[AppFollowEntitiesManager] syncToStorage error: $e');
    }
  }

  void _loadAndApplyStoredEntities() {
    // In production: read from shared_preferences here.
    final stored = _followedEntityIds;
    if (stored.isNotEmpty) {
      BlazeSDK.setFollowedEntities(stored);
      debugPrint('[AppFollowEntitiesManager] Loaded stored entities: $stored');
    }
  }
}
