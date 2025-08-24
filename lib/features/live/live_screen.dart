import 'dart:math';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
// Windows player
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../data/models/animal.dart';
import '../../state/wallet_notifier.dart';
import 'widgets/feed_button.dart';
import 'widgets/tiktok_live_view.dart';

/// ลิงก์วิดีโอเดโม่ (สตรีมปกติ / HLS mode)
// const kDemoVideoUrl = 'https://cdn.pixabay.com/video/2018/03/31/15305-262921865_large.mp4';
const kDemoVideoUrl = 'https://cdn.pixabay.com/video/2024/03/03/202831-919000200_large.mp4';

/// โทนสี (Peach–Coral)
const _coral = Color(0xFFFF6F61);
const _peach = Color(0xFFFFE0B2);
const _cream = Color(0xFFFFF6F1);

/// ------------------------------
/// แชท MOCK
/// ------------------------------
class ChatMessage {
  final String user;
  final String message;
  ChatMessage({required this.user, required this.message});
}

class LiveChatNotifier extends StateNotifier<List<ChatMessage>> {
  LiveChatNotifier()
      : super([
    ChatMessage(user: 'ระบบ', message: 'Live เริ่มแล้ว!'),
    ChatMessage(user: 'Alice', message: 'น่ารักมากกก 🥰'),
    ChatMessage(user: 'Bob', message: 'พร้อมกดให้อาหาร!'),
  ]);

  void send(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    state = [...state, ChatMessage(user: 'คุณ', message: t)];
  }
}

final liveChatProvider =
StateNotifierProvider<LiveChatNotifier, List<ChatMessage>>(
      (ref) => LiveChatNotifier(),
);

final liveChatTextControllerProvider = Provider<TextEditingController>((ref) {
  final c = TextEditingController();
  ref.onDispose(c.dispose);
  return c;
});

/// ------------------------------
/// หัวใจลอย: โครงสร้างข้อมูลภายใน
/// ------------------------------
class _HeartItem {
  _HeartItem({required this.controller, required this.dx});
  final AnimationController controller; // ควบคุมเวลา/การเคลื่อนที่
  final double dx;                       // ตำแหน่ง X สุ่มภายในพื้นที่ปุ่ม
}

/// ------------------------------
/// Live Screen
/// ------------------------------
class LiveScreen extends ConsumerStatefulWidget {
  const LiveScreen({super.key});

  @override
  ConsumerState<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends ConsumerState<LiveScreen>
    with TickerProviderStateMixin {
  // Mobile player
  VideoPlayerController? _vp;

  // Windows player (media_kit)
  Player? _mkPlayer;
  VideoController? _mkController;

  final animal = Animal.mock();

  String source = 'hls'; // 'hls' | 'tiktok'
  String tiktokUser = 'li_meiping';
  int _likes = 128; // เริ่มจาก 128 ให้ตรงกับ UI เดิม (จะเพิ่มขึ้นเรื่อย ๆ)

  // ✅ คุมเลื่อนคอมเมนต์ไปล่างสุดเสมอ
  final ScrollController _chatScrollCtl = ScrollController();
  int _lastChatCount = 0;

  // ✅ หัวใจลอย (เก็บหลายอนิเมชันพร้อมกัน)
  final List<_HeartItem> _hearts = [];
  final _rand = Random();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map) {
      source = (args['source'] as String?) ?? 'hls';
      tiktokUser = (args['tiktokUser'] as String?) ?? tiktokUser;
    } else if (args is String) {
      source = 'hls';
    }

    if (source == 'hls') {
      _initFromUrl(kDemoVideoUrl);
    }
  }

  /// เล่นวิดีโอจาก URL (มือถือ = video_player, Windows = media_kit)
  Future<void> _initFromUrl(String url) async {
    if (Platform.isWindows) {
      _mkPlayer?.dispose();
      _mkPlayer = Player();
      _mkController = VideoController(_mkPlayer!);
      await _mkPlayer!.open(Media(url), play: true);
      if (mounted) setState(() {});
    } else {
      _vp?.dispose();
      final c = VideoPlayerController.networkUrl(Uri.parse(url));
      await c.initialize();
      await c.setLooping(true);
      await c.play();
      if (!mounted) return;
      setState(() => _vp = c);
    }
  }

  @override
  void dispose() {
    _vp?.dispose();
    _mkPlayer?.dispose();
    _chatScrollCtl.dispose();
    // เคลียร์คอนโทรลเลอร์ของหัวใจทั้งหมด
    for (final h in _hearts) {
      h.controller.dispose();
    }
    super.dispose();
  }

  Widget _hlsPlayer() {
    if (Platform.isWindows) {
      if (_mkController == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return Video(key: const ValueKey('player-windows'), controller: _mkController!);
    }
    final ready = _vp != null && _vp!.value.isInitialized;
    if (!ready) return const Center(child: CircularProgressIndicator());
    return VideoPlayer(key: const ValueKey('player-mobile'), _vp!);
  }

  Widget _tiktokPlayer() {
    return TikTokLiveView(
      key: ValueKey('tiktok-$tiktokUser'),
      username: tiktokUser,
    );
  }

  // ---------- Auto-scroll helpers ----------
  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_chatScrollCtl.hasClients) return;
    final max = _chatScrollCtl.position.maxScrollExtent;
    _chatScrollCtl.animateTo(
      max,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  // ----------------------------------------

  // ---------- Heart button logic ----------
  void _onTapHeart() {
    final ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    final dx = (_rand.nextDouble() * 20) - 10;

    final item = _HeartItem(controller: ctrl, dx: dx);
    setState(() {
      _hearts.add(item);
      _likes++;                 // ✅ เพิ่มจำนวนไลก์ทุกครั้งที่กด
    });

    ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _hearts.remove(item);
          });
        }
        ctrl.dispose();
      }
    });

    ctrl.forward();
  }


  List<Widget> _buildHearts() {
    // แสดงซ้อนหัวใจทั้งหมดในพื้นที่ปุ่ม
    return _hearts.map((h) {
      // เคลื่อนขึ้น 0 -> -60, จาง 1 -> 0, scale 1 -> 1.5
      final moveUp = Tween<double>(begin: 0, end: -60).animate(
        CurvedAnimation(parent: h.controller, curve: Curves.easeOut),
      );
      final fade = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: h.controller, curve: Curves.easeIn),
      );
      final scale = Tween<double>(begin: 1, end: 1.5).animate(
        CurvedAnimation(parent: h.controller, curve: Curves.elasticOut),
      );

      return AnimatedBuilder(
        animation: h.controller,
        builder: (context, child) {
          return Positioned(
            bottom: 0,
            left: 18 + h.dx, // กะให้กลางปุ่ม (ปุ่มกว้างราวๆ 36px)
            child: Opacity(
              opacity: fade.value,
              child: Transform.translate(
                offset: Offset(0, moveUp.value),
                child: Transform.scale(
                  scale: scale.value,
                  child: const Icon(Icons.favorite, color: Colors.pink, size: 26),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }
  // ----------------------------------------

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(walletBalanceProvider);
    final chatList = ref.watch(liveChatProvider);
    final chatController = ref.read(liveChatTextControllerProvider);

    // ให้พื้นที่วิดีโอสูง ~45% ของหน้าจอ
    final double playerHeight = MediaQuery.of(context).size.height * 0.45;

    // auto-scroll: ถ้าจำนวนข้อความเปลี่ยน -> เลื่อนไปล่างสุด
    if (chatList.length != _lastChatCount) {
      _lastChatCount = chatList.length;
      _scheduleScrollToBottom();
    }

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _cream,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _peach, width: 2),
                boxShadow: [BoxShadow(color: _coral.withOpacity(.12), blurRadius: 8)],
              ),
              alignment: Alignment.center,
              child: const Text('🐾', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 10),
            Text(source == 'tiktok' ? 'TikTok Live' : 'Pet Live',
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _peach),
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
              tooltip: source == 'tiktok' ? 'สลับไป MP4' : 'สลับไป TikTok',
              icon: Icon(source == 'tiktok' ? Icons.video_file : Icons.live_tv, color: _coral),
              onPressed: () {
                setState(() {
                  source = source == 'tiktok' ? 'hls' : 'tiktok';
                });
                if (source == 'hls') {
                  _initFromUrl(kDemoVideoUrl);
                } else {
                  _vp?.pause();
                  _mkPlayer?.pause();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/wallet'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _coral,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [BoxShadow(color: _coral.withOpacity(.25), blurRadius: 12)],
                  ),
                  child: Text('💰 $balance', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ---------- Player (สูงขึ้น) ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SizedBox(
              height: playerHeight,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      color: Colors.black,
                      child: IndexedStack(
                        index: source == 'tiktok' ? 1 : 0,
                        children: [
                          Align(alignment: Alignment.center, child: _hlsPlayer()),
                          Align(alignment: Alignment.center, child: _tiktokPlayer()),
                        ],
                      ),
                    ),
                  ),
                  Positioned(top: 10, left: 10, child: _LivePill(likes: _likes)),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _InfoPill(icon: Icons.remove_red_eye_outlined, text: '999 view'),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: _NamePill(text: '${animal.name} • ${animal.species}'),
                  ),
                ],
              ),
            ),
          ),

          // ---------- Mini Stats ใต้จอ ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                _MiniStat(icon: Icons.fastfood, label: 'ต่อครั้ง', value: '${animal.perFeedTokens} โทเคน'),
                const SizedBox(width: 10),
                _MiniStat(icon: Icons.favorite, label: 'ล่าสุด', value: 'Alice'),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('เลื่อนลงเพื่อกดปุ่มให้อาหารด้านล่างได้เลย ✨')),
                    );
                  },
                  icon: const Icon(Icons.fastfood),
                  label: const Text('Feed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _coral,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ---------- โซนแชท (auto-scroll bottom) ----------
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: _chatScrollCtl,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    itemCount: chatList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, i) {
                      final c = chatList[i];
                      final isMe = c.user == 'คุณ';
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: _ChatBubble(
                          text: '${c.user}: ${c.message}',
                          isMe: isMe,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatController,
                          decoration: InputDecoration(
                            hintText: 'พิมพ์ข้อความ...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: _peach),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: _coral, width: 2),
                            ),
                          ),
                          onSubmitted: (t) {
                            ref.read(liveChatProvider.notifier).send(t);
                            chatController.clear();
                            _scheduleScrollToBottom();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ปุ่มหัวใจ + เอฟเฟกต์
                      SizedBox(
                        width: 48,
                        height: 60, // มีพื้นที่ให้หัวใจลอยขึ้น
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.pink, size: 28),
                                onPressed: _onTapHeart,
                                tooltip: 'ส่งหัวใจ',
                              ),
                            ),
                            ..._buildHearts(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          final t = chatController.text.trim();
                          if (t.isNotEmpty) {
                            ref.read(liveChatProvider.notifier).send(t);
                            chatController.clear();
                            _scheduleScrollToBottom();
                          }
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _coral,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(color: _coral.withOpacity(.25), blurRadius: 10)],
                          ),
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 6, 12, 12),
        child: FeedButton(animal: animal),
      ),
    );
  }
}

/// ------------------------------
/// Cute UI widgets
/// ------------------------------
class _LivePill extends StatelessWidget {
  const _LivePill({required this.likes});
  final int likes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _coral,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [BoxShadow(color: _coral.withOpacity(.25), blurRadius: 12)],
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            'LIVE  •  $likes Likes',               // ✅ แสดงจำนวนไลก์จริง
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}


class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: _peach),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _coral),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _NamePill extends StatelessWidget {
  const _NamePill({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _peach),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _peach),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _coral),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(.6))),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          )
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.text, required this.isMe});
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? _coral : Colors.white;
    final fg = isMe ? Colors.white : Colors.black87;
    final border = isMe ? Colors.transparent : _peach;

    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: [
          if (isMe) BoxShadow(color: _coral.withOpacity(.25), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Text(text, style: TextStyle(color: fg)),
    );
  }
}
