import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

class HiWebView extends StatefulWidget {
  String? url;
  final String? statusBarColor;
  final String? title;
  final bool? hideAppBar;
  final bool backForbid;

  HiWebView(
      {this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false}) {
    if (url != null && url!.contains('ctrip.com')) {
      //fix 携程H5 http://无法打开问题
      url = url!.replaceAll("http://", 'https://');
    }
  }

  @override
  _HiWebViewState createState() => _HiWebViewState();
}

class _HiWebViewState extends State<HiWebView> {
  bool exiting = false;

  @override
  void initState() {
    super.initState();
  }

  _isToMain(String? url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff$statusBarColorStr')), backButtonColor),
          Expanded(
              child: WebView(
                  //防止携程H5页面重定向到打开携程APP ctrip://wireless/xxx的网址
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) {
                    if (_isToMain(request.url)) {
                      print('blocking navigation to $request}');
                      Navigator.pop(context);
                      return NavigationDecision.prevent;
                    }
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  }))
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              // behavior: HitTestBehavior.opaque,
              onTap: () {
                print('pop');
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 30,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
