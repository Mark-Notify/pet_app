import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repos/wallet_repo.dart';
import 'providers.dart'; // << สำคัญ

final walletBalanceProvider = StateNotifierProvider<WalletNotifier, int>((ref) {
  final repo = ref.watch(walletRepoProvider);
  return WalletNotifier(repo)..load();
});

class WalletNotifier extends StateNotifier<int> {
  final WalletRepo repo;
  WalletNotifier(this.repo) : super(0);

  Future<void> load() async {
    state = await repo.fetchBalance();
  }

  Future<void> buy(int amount) async {
    final inc = await repo.buyPack(amount);
    state = state + inc;
  }

  void spend(int amount) {
    state = (state - amount).clamp(0, 1 << 31);
  }

  void refund(int amount) {
    state = state + amount;
  }

  // สำหรับ IAP เติมโทเคนหลังซื้อสำเร็จ (mock)
  void refill(int amount) {
    state = state + amount;
  }
}
