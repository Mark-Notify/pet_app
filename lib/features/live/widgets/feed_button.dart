import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/animal.dart';
import '../../../state/providers.dart';
import '../../../state/wallet_notifier.dart';
import 'package:intl/intl.dart';

class FeedButton extends ConsumerWidget {
  final Animal animal;
  const FeedButton({super.key, required this.animal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedRepo = ref.watch(feedRepoProvider);
    final wallet = ref.watch(walletBalanceProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.fastfood),
        label: Text('ให้อาหาร (${animal.perFeedTokens} โทเคน)'),
        onPressed: wallet >= animal.perFeedTokens ? () async {
          // Reserve (ลดทันทีใน UI เพื่อความรู้สึกเร็ว)
          ref.read(walletBalanceProvider.notifier).spend(animal.perFeedTokens);

          final ok = await feedRepo.feed(animalId: animal.id, tokens: animal.perFeedTokens);

          if (ok) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('สำเร็จ! ${DateFormat.Hms().format(DateTime.now())} • ${animal.name} ได้อาหารแล้ว'))
              );
            }
          } else {
            // Refund on failure
            ref.read(walletBalanceProvider.notifier).refund(animal.perFeedTokens);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ล้มเหลว • มีปัญหาที่อุปกรณ์/โควตาเต็ม (mock)')),
              );
            }
          }
        } : null,
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
      ),
    );
  }
}
