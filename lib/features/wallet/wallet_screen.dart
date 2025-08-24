import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/wallet_notifier.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bal = ref.watch(walletBalanceProvider);

    Widget pack(int amount, String bonus, int price) => Card(
      child: ListTile(
        leading: const Icon(Icons.token),
        title: Text('$amount โทเคน'),
        subtitle: Text(bonus),
        trailing: ElevatedButton(
          onPressed: () => ref.read(walletBalanceProvider.notifier).buy(amount),
          child: Text('ซื้อ $price฿'),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              title: const Text('ยอดคงเหลือ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Text('$bal โทเคน', style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(height: 8),
          pack(100,  'เริ่มต้น', 10),
          pack(550,  '+10% โบนัส', 50),
          pack(1200, '+20% โบนัส', 100),
          pack(3000, '+25% โบนัส', 300),
          const SizedBox(height: 8),
          const Text('** หมายเหตุ: หน้านี้เป็น mock ซื้อด้วยเงินจริงให้ต่อ in_app_purchase ภายหลัง'),
        ],
      ),
    );
  }
}
