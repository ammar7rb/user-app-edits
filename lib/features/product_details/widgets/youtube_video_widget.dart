import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


class YoutubeVideoWidget extends StatefulWidget {
  final String? url;
  const YoutubeVideoWidget({super.key, required this.url});

  @override
  State<YoutubeVideoWidget> createState() => _YoutubeVideoWidgetState();
}

class _YoutubeVideoWidgetState extends State<YoutubeVideoWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(YoutubeVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url && widget.url != null) {
      _loadVideo(widget.url!);
    }
  }

  void _initializeController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final String url = request.url;
            // Block external jumps (App Store, YouTube App, etc.)
            if (!url.startsWith('http') && !url.startsWith('https')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

    if (widget.url != null && widget.url!.isNotEmpty) {
      _loadVideo(widget.url!);
    }
  }

  void _loadVideo(String rawUrl) {
    final videoId = _extractVideoId(rawUrl);
    if (videoId == null) return;

    // HTML with 100% width/height CSS to fill the WebView completely
    final String htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          html, body { 
            margin: 0; 
            padding: 0; 
            background-color: black; 
            height: 100%; 
            width: 100%; 
            overflow: hidden; 
          }
          iframe { 
            width: 100%; 
            height: 100%; 
            border: none; 
            display: block; 
          }
        </style>
      </head>
      <body>
        <iframe 
          id="player"
          type="text/html" 
          width="100%" 
          height="100%"
          src="https://www.youtube-nocookie.com/embed/$videoId?autoplay=0&rel=0&modestbranding=1&playsinline=1&controls=1"
          frameborder="0" 
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
          referrerpolicy="strict-origin-when-cross-origin" 
          allowfullscreen>
        </iframe>
      </body>
      </html>
    ''';

    // baseUrl ensures Referrer Policy passes
    _controller.loadHtmlString(
      htmlContent,
      baseUrl: 'https://www.google.com/',
    );
  }

  String? _extractVideoId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.first;
      } else if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      } else if (uri.pathSegments.contains('embed')) {
        return uri.pathSegments.last;
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get exact screen width
    double width = MediaQuery.of(context).size.width;

    if (widget.url == null || widget.url!.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      // 2. FIXED: Use standard 16:9 YouTube aspect ratio (width * 0.5625)
      // This ensures the container fits the video exactly with no black bars.
      height: width * 9.0 / 16.0,
      width: width,

      // 3. FIXED: Removed margin/padding so it touches the screen edges
      child: WebViewWidget(controller: _controller),
    );
  }
}
