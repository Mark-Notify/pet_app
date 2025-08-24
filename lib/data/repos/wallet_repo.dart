import '../api_client.dart';

class WalletRepo {
  final ApiClient api;
  WalletRepo(this.api);

  Future<int> fetchBalance() => api.getWalletBalance();
  Future<int> buyPack(int amount) => api.purchaseTokens(amount);
}
