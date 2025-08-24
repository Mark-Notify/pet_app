import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/stream_session.dart';
import 'providers.dart'; // << สำคัญ

final streamSessionProvider = FutureProvider.family<StreamSession, String>((ref, animalId) async {
  final repo = ref.watch(streamRepoProvider);
  return repo.getSession(animalId);
});
