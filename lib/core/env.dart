class Env {
  static const apiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000');
  static const wsUrl  = String.fromEnvironment('WS_URL',   defaultValue: 'ws://localhost:3000/ws');

  // ตั้ง username ของ TikTok สำหรับเดโม (แก้ชื่อจริงได้)
  static const tiktokUser = String.fromEnvironment('TIKTOK_USER', defaultValue: '@twinsgril.64');
}
