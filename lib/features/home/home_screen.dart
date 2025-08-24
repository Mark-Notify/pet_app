import 'package:flutter/material.dart';
import '../../core/env.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // พาเลตหลัก (Coral–Peach)
  static const coral = Color(0xFFFF6F61);  // accent หลัก
  static const peach = Color(0xFFFFE0B2);  // พื้นหลังอ่อน
  static const blush = Color(0xFFFFC8BD);  // ไฮไลต์อ่อน
  static const cream = Color(0xFFFFF6F1);  // พื้นหลังซอฟต์มาก

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cream,
      body: CustomScrollView(
        slivers: [
          _CuteSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBanner(),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Text(
                        'เลือกดูสตรีม',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: cs.onBackground.withOpacity(.9),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _CuteDot(color: coral),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // การ์ด 1: HLS
                  _CuteCard(
                    bgGradient: const LinearGradient(
                      colors: [Colors.white, peach],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderColor: blush.withOpacity(.5),
                    leading: _EmojiCircle(
                      emoji: '🐾',
                      bg: Colors.white,
                      border: blush,
                    ),
                    title: 'ดูผ่านสตรีมของเรา (HLS)',
                    subtitle: 'เล่นด้วย player ในแอป • latency ต่ำ',
                    badgeText: 'LIVE',
                    badgeColor: coral,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/live',
                      arguments: {
                        'source': 'hls',
                        'animalId': 'a1',
                      },
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: cs.onSurface.withOpacity(.6)),
                  ),
                  const SizedBox(height: 12),

                  // การ์ด 2: TikTok
                  _CuteCard(
                    bgGradient: LinearGradient(
                      colors: [Colors.white, blush.withOpacity(.45)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderColor: blush.withOpacity(.6),
                    leading: _EmojiCircle(
                      emoji: '🎥',
                      bg: Colors.white,
                      border: blush,
                    ),
                    title: 'ดูผ่าน TikTok Live',
                    subtitle: 'เปิดใน WebView ของ TikTok • ฟฟฟ',
                    badgeText: 'BETA',
                    badgeColor: coral,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/live',
                      arguments: {
                        'source': 'tiktok',
                        'tiktokUser': Env.tiktokUser,
                        'animalId': 'a1',
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_new, size: 18, color: cs.onSurface.withOpacity(.6)),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios, size: 16, color: cs.onSurface.withOpacity(.6)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ชิปน่ารัก
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _CuteChip(icon: Icons.pets, text: 'สัตว์ฮิต'),
                      _CuteChip(icon: Icons.favorite, text: 'ถูกใจฉัน'),
                      _CuteChip(icon: Icons.timer, text: 'กำลังกินอยู่'),
                      _CuteChip(icon: Icons.star, text: 'อันดับประจำสัปดาห์'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _InfoHint(
                    icon: Icons.info_outline,
                    text: 'ทุกการให้อาหารมีโควตาปลอดภัยตามคำแนะนำของสัตวแพทย์',
                    color: coral,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _CuteWalletButton(
        color: coral,
        onTap: () => Navigator.pushNamed(context, '/wallet'),
      ),
    );
  }
}

/// -------------------------- Cute Widgets --------------------------

class _CuteSliverAppBar extends StatelessWidget {
  const _CuteSliverAppBar();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 88,
      backgroundColor: HomeScreen.cream,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 10),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: HomeScreen.coral.withOpacity(.18), blurRadius: 10)],
              ),
              padding: const EdgeInsets.all(6),
              child: const Text('🐶', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 8),
            Text(
              'CDH • PetFeed',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                letterSpacing: .2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, HomeScreen.peach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HomeScreen.blush.withOpacity(.5)),
        boxShadow: [BoxShadow(color: HomeScreen.coral.withOpacity(.12), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: HomeScreen.blush),
            ),
            padding: const EdgeInsets.all(16),
            child: const Text('🥕', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ให้อาหารสัตว์แบบไลฟ์',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: cs.onSurface)),
                const SizedBox(height: 4),
                Text('กดส่งอาหาร • ส่งของขวัญ • สะสมแต้ม',
                    style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(.7))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: HomeScreen.coral,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Row(
              children: [
                Icon(Icons.bolt, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text('Live Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CuteCard extends StatelessWidget {
  const _CuteCard({
    required this.bgGradient,
    required this.borderColor,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.badgeText,
    this.badgeColor,
  });

  final Gradient bgGradient;
  final Color borderColor;
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? badgeText;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: bgGradient,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor),
          boxShadow: [BoxShadow(color: HomeScreen.coral.withOpacity(.06), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: (badgeColor ?? HomeScreen.coral).withOpacity(.14),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            badgeText!,
                            style: TextStyle(
                              color: badgeColor ?? HomeScreen.coral,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                      ],
                    ]),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withOpacity(.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiCircle extends StatelessWidget {
  const _EmojiCircle({required this.emoji, required this.bg, required this.border});
  final String emoji;
  final Color bg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}

class _CuteDot extends StatelessWidget {
  const _CuteDot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

class _CuteChip extends StatelessWidget {
  const _CuteChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HomeScreen.blush.withOpacity(.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HomeScreen.blush),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.pets, size: 0), // กัน jump layout บางเคส
        Icon(icon, size: 16, color: HomeScreen.coral),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: HomeScreen.coral, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _InfoHint extends StatelessWidget {
  const _InfoHint({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(.28)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87))),
        ],
      ),
    );
  }
}

class _CuteWalletButton extends StatelessWidget {
  const _CuteWalletButton({required this.color, required this.onTap});
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: color.withOpacity(.35), blurRadius: 18, offset: const Offset(0, 8))],
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.account_balance_wallet),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text('Wallet', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
    );
  }
}
