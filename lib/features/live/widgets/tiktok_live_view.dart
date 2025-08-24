import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TikTokLiveView extends StatefulWidget {
  final String username; // ชื่อแอคเคานต์ TikTok เช่น 'natgeo'
  const TikTokLiveView({super.key, required this.username});

  @override
  State<TikTokLiveView> createState() => _TikTokLiveViewState();
}

class _TikTokLiveViewState extends State<TikTokLiveView> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final url = Uri.parse('https://www.tiktok.com/@${widget.username}/live');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => _loading = false),
      ))
      ..loadRequest(url);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
