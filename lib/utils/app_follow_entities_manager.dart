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
  List<BlazeFollowEntity> _followedEntities = [];

  BlazeFollowEntitiesManager get _sdkManager => BlazeSDK.followEntitiesManager;

  /// Initialize the follow entities system.
  /// Call after [BlazeSDK.initSDK] completes.
  void start() {
    BlazeSDK.setFollowEntitiesDelegate(_delegate);
    _loadAndApplyStoredEntities();
    debugPrint('[AppFollowEntitiesManager] Started');
  }

  Future<void> setFollowedEntities(List<BlazeFollowEntity> entities) async {
    await _sdkManager.setFollowedEntities(entities);
    _followedEntities = List<BlazeFollowEntity>.from(entities);
    debugPrint('[AppFollowEntitiesManager] setFollowedEntities: $entities');
  }

  Future<void> insertFollowedEntities(List<BlazeFollowEntity> entities) async {
    await _sdkManager.insertFollowedEntities(entities);
    final ids = entities.map((e) => e.id).toSet();
    _followedEntities = [
      ..._followedEntities.where((e) => !ids.contains(e.id)),
      ...entities,
    ];
    debugPrint('[AppFollowEntitiesManager] insertFollowedEntities: $entities');
  }

  Future<void> removeFollowedEntities(List<BlazeFollowEntity> entities) async {
    await _sdkManager.removeFollowedEntities(entities);
    final ids = entities.map((e) => e.id).toSet();
    _followedEntities =
        _followedEntities.where((e) => !ids.contains(e.id)).toList();
    debugPrint('[AppFollowEntitiesManager] removeFollowedEntities: $entities');
  }

  Future<List<BlazeFollowEntity>> getFollowedEntities() async {
    final entities = await _sdkManager.getFollowedEntities();
    debugPrint('[AppFollowEntitiesManager] getFollowedEntities: $entities');
    return entities;
  }

  Future<void> clearAll() async {
    await _sdkManager.setFollowedEntities([]);
    _followedEntities = [];
    debugPrint('[AppFollowEntitiesManager] clearAll');
  }

  // ---- Private ----

  late final BlazeFollowEntitiesDelegate _delegate =
      BlazeFollowEntitiesDelegate(
    onFollowEntityClicked: (params) {
      debugPrint(
          '[AppFollowEntitiesManager] onFollowEntityClicked: ${params.asJsonString()}');

      final entity = params.followEntity;
      final state = params.newFollowingState ? 'FOLLOWED' : 'UNFOLLOWED';
      debugPrint(
          '  → Entity ${entity.id} (${entity.entityType?.name}, ${entity.providerName}) is now $state');

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
      final current = await _sdkManager.getFollowedEntities();
      _followedEntities = current;
      // In production: persist to shared_preferences here.
      debugPrint(
          '[AppFollowEntitiesManager] syncToStorage — snapshot: $current');
    } catch (e) {
      debugPrint('[AppFollowEntitiesManager] syncToStorage error: $e');
    }
  }

  void _loadAndApplyStoredEntities() {
    // In production: read from shared_preferences here.
    final stored = _followedEntities;
    if (stored.isNotEmpty) {
      _sdkManager.setFollowedEntities(stored);
      debugPrint('[AppFollowEntitiesManager] Loaded stored entities: $stored');
    }
  }
}
