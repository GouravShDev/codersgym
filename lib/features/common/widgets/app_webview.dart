// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AppWebview extends HookWidget {
  const AppWebview({
    super.key,
    this.url,
    this.htmlText,
    this.redirectUrl,
    this.assetFilePath,
    this.floatingActionButton,
    this.appBarTitle,
    this.showBackButton,
    this.loadingTitle,
    this.loadingDescription,
    this.onUrlRedirection,
    this.showAppBar = true,
  })  : assert(
          url == null || htmlText == null || assetFilePath == null,
          'Cannot use url and html text both',
        ),
        assert(
          url != null || htmlText != null || assetFilePath != null,
          'Url or html text is required',
        );
  final String? url;
  final String? htmlText;
  final String? redirectUrl;
  final String? assetFilePath;
  final Widget? floatingActionButton;
  final Widget? appBarTitle;
  final bool? showBackButton;
  final String? loadingTitle;
  final String? loadingDescription;
  final VoidCallback? onUrlRedirection;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final webViewController = useState<InAppWebViewController?>(null);
    final canGoBack = useState<bool>(false);
    final canGoForward = useState<bool>(false);

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: appBarTitle,
              centerTitle: false,
              automaticallyImplyLeading: showBackButton ?? true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: canGoBack.value
                      ? () {
                          webViewController.value?.goBack();
                        }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: canGoForward.value
                      ? () {
                          webViewController.value?.goForward();
                        }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    webViewController.value?.reload();
                  },
                ),
              ],
            )
          : null,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: url != null
                ? URLRequest(url: WebUri.uri(Uri.parse(url!)))
                : null,
            initialData: htmlText != null
                ? InAppWebViewInitialData(data: htmlText!)
                : null,
            shouldInterceptFetchRequest: (controller, ajaxRequest) async {
              final url = ajaxRequest.url;
              if (redirectUrl != null) {
                if (url.toString().startsWith(redirectUrl!)) {
                  onUrlRedirection?.call();
                  return null;
                }
              }
              return null;
            },
            onLoadStop: (controller, url) async {
              // Check if user is trying to login with google
              // We need to send user-agent for google login to work in the
              // webview
              // Initially we can't add that because
              // cloudflare won't work if we do
              if (url
                  .toString()
                  .startsWith('https://accounts.google.com/v3/signin')) {
                controller.setSettings(
                  settings: InAppWebViewSettings(
                      userAgent:
                          "Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36"),
                );
              }
              canGoBack.value = await controller.canGoBack();
              canGoForward.value = await controller.canGoForward();
            },
            onWebViewCreated: (controller) {
              webViewController.value = controller;
              if (assetFilePath != null) {
                controller.loadFile(assetFilePath: assetFilePath!);
              }
            },
          ),
        ],
      ),
    );
  }
}
