import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../debug_util.dart';
import 'app_web_view_state.dart';

class AppWebViewNotifier extends StateNotifier<AppWebViewState> {
  late final WebViewController webViewController;

  AppWebViewNotifier({String? initialUrl}) : super(const AppWebViewState()) {
    debugUtil.mark(hashCode.toString());
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("Toaster", onMessageReceived: (JavaScriptMessage message) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(message.message)),
        // );
      })
      ..addJavaScriptChannel("Token", onMessageReceived: (JavaScriptMessage message) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(message.message)),
        // );
        // debugUtil.log('WebView get token ${message.message}');
        // Navigator.pop(context);
      })
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugUtil.log('WebView is loading (progress : $progress%)');
            setProgress(progress);
          },
          onPageStarted: (String url) async {
            debugUtil.log('Page started loading: $url');
            setPageStarted(url);
            afterPageStartedOrFinished(
              currentUrl: await webViewController.currentUrl(),
              canGoBack: await webViewController.canGoBack(),
              canGoForward: await webViewController.canGoForward(),
            );
          },
          onPageFinished: (String url) async {
            debugUtil.log('Page finished loading: $url');
            setPageFinished(url);
            afterPageStartedOrFinished(
              currentUrl: await webViewController.currentUrl(),
              canGoBack: await webViewController.canGoBack(),
              canGoForward: await webViewController.canGoForward(),
            );
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            debugUtil.log('WebView attend to load $request');
            if (request.url.startsWith('emmacanhelp-auth0-redirect')) {
              debugUtil.log('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugUtil.log('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            debugUtil.log('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
        ),
      );
    if (initialUrl != null) {
      loadUrl(initialUrl);
    }
  }

  Future<void> loadUrl(String url) async {
    webViewController.loadRequest(Uri.parse(url));
  }

  Future<void> goBack() async {
    webViewController.goBack();
  }

  Future<void> goForward() async {
    webViewController.goForward();
  }

  Future<void> reload() async {
    webViewController.reload();
  }

  void setProgress(int progress) {
    state = state.copyWith(progress: progress);
  }

  void setPageStarted(String url) {
    state = state.copyWith(pageStarted: url);
  }

  void setPageFinished(String url) {
    state = state.copyWith(pageFinished: url);
  }

  void afterPageStartedOrFinished({required String? currentUrl, required bool canGoBack, required bool canGoForward}) {
    state = state.copyWith(currentUrl: currentUrl, canGoBack: canGoBack, canGoForward: canGoForward);
  }
}
