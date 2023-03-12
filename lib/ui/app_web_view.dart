import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../debug_util.dart';

class AppWebView extends StatelessWidget {
  AppWebView({Key? key}) : super(key: key);
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final _navControlsNotifier = _NavControlsNotifier(false);

  @override
  Widget build(BuildContext context) {
    JavascriptChannel toasterJavascriptChannel(BuildContext context) {
      return JavascriptChannel(
          name: 'Toaster',
          onMessageReceived: (JavascriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          });
    }

    JavascriptChannel tokenJavascriptChannel(BuildContext context) {
      return JavascriptChannel(
          name: 'Token',
          onMessageReceived: (JavascriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
            debugUtil.log('WebView get token ${message.message}');
            Navigator.pop(context);
          });
    }

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        WebView.platform = AndroidWebView();
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Web View"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.close_rounded)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedBuilder(
            animation: _navControlsNotifier,
            builder: (BuildContext context, Widget? child) {
              return _NavigationControls(_controller.future);
            },
          ),
          Expanded(
            child: WebView(
              initialUrl:
                  'http://localhost:58965',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                debugUtil.log('WebView is loading (progress : $progress%)');
                _navControlsNotifier.notify();
              },
              javascriptChannels: <JavascriptChannel>{
                toasterJavascriptChannel(context),
                tokenJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                debugUtil.log('WebView attend to load $request');
                _navControlsNotifier.notify();
                if(request.url.startsWith('emmacanhelp-auth0-redirect')){
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
              onPageStarted: (String url) {
                debugUtil.log('Page started loading: $url');
                _navControlsNotifier.notify();
              },
              onPageFinished: (String url) async {
                debugUtil.log('Page finished loading: $url');
                _navControlsNotifier.notify();
              },
              gestureNavigationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationControls extends StatelessWidget {
  const _NavigationControls(this._webViewControllerFuture, {Key? key})
      : super(key: key);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        if (webViewReady && controller != null) {
          return FutureBuilder<List<dynamic>>(
            future: Future.wait([
              controller.canGoBack(),
              controller.canGoForward(),
              controller.currentUrl(),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              final data = snapshot.data;
              if (data != null) {
                final canGoBack = data[0] as bool;
                final canGoForward = data[1] as bool;
                final url = data[2] as String;
                return Column(
                  children: [
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded),
                          onPressed: canGoBack
                              ? () async => await controller.goBack()
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          onPressed: canGoForward
                              ? () async => await controller.goForward()
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded),
                          onPressed: () => controller.reload(),
                        ),
                      ],
                    ),
                    Text(url),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _NavControlsNotifier extends ValueNotifier<bool> {
  _NavControlsNotifier(super.value);

  Future<void> notify() async {
    value = !value;
  }
}
