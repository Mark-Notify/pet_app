import '../models/stream_session.dart';

class StreamRepo {
  Future<StreamSession> getSession(String animalId) async {
    // เรียก backend จริงภายหลัง
    await Future.delayed(const Duration(milliseconds: 300));
    return StreamSession.mock(animalId);
  }
}
