import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/live/live_screen.dart';
import 'features/wallet/wallet_screen.dart';
import 'features/profile/profile_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'PetFeed Live',
      theme: appTheme,
      routes: {
        '/': (_) => const HomeScreen(),
        '/live': (_) => const LiveScreen(),            // args: StreamSession
        '/wallet': (_) => const WalletScreen(),
        '/animal': (_) => const AnimalProfileScreen(), // args: Animal
      },
    );
  }
}
