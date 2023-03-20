import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'app_web_view_notifier.dart';
import 'app_web_view_provider.dart';
import 'app_web_view_state.dart';

class AppWebView extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<AppWebViewNotifier, AppWebViewState> _appWebViewProvider;

  AppWebView({super.key, String? initialUrl}) : _appWebViewProvider = appWebViewProvider(initialUrl);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //'http://localhost:58965'
    // if (!kIsWeb) {
    //   if (Platform.isAndroid) {
    //     WebView.platform = AndroidWebView();
    //   }
    // }
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
          _NavigationControls(_appWebViewProvider),
          Expanded(
            child: WebViewWidget(controller: ref.read(_appWebViewProvider.notifier).webViewController),
          ),
        ],
      ),
    );
  }
}

class _NavigationControls extends ConsumerWidget {
  const _NavigationControls(this.provider);

  final AutoDisposeStateNotifierProvider<AppWebViewNotifier, AppWebViewState> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appWebViewState = ref.watch(provider);
    return Column(
      children: [
        Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: appWebViewState.canGoBack ? () async => await ref.watch(provider.notifier).goBack() : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: appWebViewState.canGoForward ? () async => await ref.watch(provider.notifier).goForward() : null,
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => ref.watch(provider.notifier).reload(),
            ),
          ],
        ),
        Text(appWebViewState.currentUrl ?? ""),
      ],
    );
  }
}
