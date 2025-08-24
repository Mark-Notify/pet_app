class StreamSession {
  final String id;
  final String playbackUrl; // HLS/DASH
  final bool lowLatency;
  final String animalId;

  StreamSession({
    required this.id,
    required this.playbackUrl,
    required this.lowLatency,
    required this.animalId,
  });

  factory StreamSession.mock(String animalId) => StreamSession(
    id: 's1',
    playbackUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8', // ตัวอย่าง HLS
    lowLatency: false,
    animalId: animalId,
  );
}
