
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api_client.dart';
import '../data/repos/wallet_repo.dart';
import '../data/repos/feed_repo.dart';
import '../data/repos/stream_repo.dart';

final apiClientProvider   = Provider((_) => ApiClient());
final walletRepoProvider  = Provider<WalletRepo>((ref) => WalletRepo(ref.watch(apiClientProvider)));
final feedRepoProvider    = Provider<FeedRepo>((ref) => FeedRepo(ref.watch(apiClientProvider)));
final streamRepoProvider  = Provider<StreamRepo>((ref) => StreamRepo());
