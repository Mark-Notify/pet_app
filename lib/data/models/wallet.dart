class Wallet {
  final int balance; // token
  Wallet({required this.balance});
  Wallet copyWith({int? balance}) => Wallet(balance: balance ?? this.balance);
  factory Wallet.fromJson(Map<String, dynamic> j) => Wallet(balance: j['balance'] ?? 0);
  Map<String, dynamic> toJson() => {'balance': balance};
}
