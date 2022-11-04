import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_application/database_helper.dart';


void main() {
  runApp(webviewandsqlite());
}

class webviewandsqlite extends StatelessWidget {
  webviewandsqlite({super.key});
  WebViewController? _webViewController;

  Future<List> getId(String username, String passwrd) async {
    print(passwrd);
    var logindetails = await DatabaseHelper.getItem(username, passwrd);
    // var logindetails = await DatabaseHelper.getItems();
    print("hello $logindetails");
    if(logindetails.isNotEmpty){
      print("hello $logindetails");
    } 
    return logindetails;
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Successfully deleted!'), backgroundColor: Colors.green));
    // _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) async {
          await webViewController.loadFlutterAsset('assets/index.html');
            // _webViewController = webViewController;
            // String fileContent = await rootBundle.loadString('assets/index.html');
            // _webViewController?.loadUrl(Uri.dataFromString(fileContent, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
        },
        javascriptChannels: <JavascriptChannel>{
            // JavascriptChannel(
            //     name: 'messageHandler',
            //     onMessageReceived: (JavascriptMessage message) async{
            //         var logindetails = await getId("roy","roy");
            //         print("message from the web view=\"${logindetails}\"");
            //         // final script = "document.getElementById('prem').innerText=\"${logindetails}\"";
            //         final script = "document.getElementById('prem').innerText=\"prem\"";
            //         // final script = "document.getElementById('value').innerText=hello";
            //         _webViewController?.runJavascriptReturningResult(script);
            //     },
            // ),
            JavascriptChannel(

              name: 'Print',
              onMessageReceived: (JavascriptMessage message) async {
                // var logindetails = await getId("roy","roy");
                var logindetails = "PRem";
                // _webViewController?.evaluateJavascript("document.getElementById('prem').innerText=\"${logindetails}\"");
                print("message from the web view=\"${logindetails}\"");
                _webViewController?.evaluateJavascript('callFLutter1("From Flutter")');

                // final token = "4555";
                // final script = 'callFlutter1("$logindetails")';
                // _webViewController?.runJavascript(script);
                // print(message.message);

              },
            ),
        },
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished:(String url) async {
          var logindetails = await getId("roy","roy");
          print("message from the web view=\"${logindetails}\"");
          // final script = "document.getElementById('prem').innerText=\"${logindetails}\"";
          // final script = "document.getElementById('prem').innerText=\"prem\"";
          // await _webViewController?.runJavascriptReturningResult(script);
           _webViewController?.runJavascript('callFLutter1("From Flutter")');
        },
    );
  }
}
