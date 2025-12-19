import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/config.dart';
import '../../repositories/configs/config_repository.dart';
import '../dio/dio_provider.dart';

final configProvider =
    StateNotifierProvider<NewsProConfigNotifier, AsyncValue<NewsProConfig>>(
        (ref) {
  final dio = ref.read(dioProvider);
  final repo = ConfigRepository(dio: dio);

  return NewsProConfigNotifier(repo);
});

class NewsProConfigNotifier extends StateNotifier<AsyncValue<NewsProConfig>> {
  NewsProConfigNotifier(
    this.repo,
  ) : super(const AsyncValue.loading());

  final ConfigRepository repo;

  Future<void> init() async {
    final data = await repo.getNewsProConfig();
    if (data == null) {
      const errorMessage = 'No configuration found';
      state = AsyncError(errorMessage, StackTrace.fromString(errorMessage));
    } else {
      if (data.isAdOn) {}
      state = AsyncData(data);
      return;
    }
  }

  Future<NewsProConfig?> getConfig() async {
    if (state.value != null) return state.value!;

    final data = await repo.getNewsProConfig();
    if (data == null) {
      const errorMessage = 'No configuration found';
      state = AsyncError(errorMessage, StackTrace.fromString(errorMessage));
      return null;
    }
    return data;
  }
}
