import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_application/signin.dart';
import 'package:flutter_application/database_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application/widgets/details_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_application/models/details.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/reducer.dart';
import 'package:redux/redux.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class details extends StatefulWidget {
//   const details({super.key});
//   // var logindetails;
//   @override
//   State<details> createState() => _detailsState();
// }

// class _detailsState extends State<details> {
//   // final Store<AppState> _store = Store<AppState>(
//   //   updateDetailsReducer,
//   //   initialState: AppState(details: [
//   //     Details(1, "rem", "", ""),
//   //   ],)
//   // );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Details page'),
//         ),
//         body: Container(
//           child: StoreConnector<AppState, List<Details>>(
//             converter: (store) => store.state.details,
//             builder: (context, List<Details> stateDetails)=> Column(
//               children: [
//               ...stateDetails
//                 .map((detail) => DetailsWidget(
//                   details: detail,
//                   )).toList(),
//               ]
//             ),
//           ),
//         ),
//     );
//   }
// }

class App extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<App> {

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),);

  // Future<void> addItem() async {
  //   await DatabaseHelper.createItem(
  //       nameController.text, passwordController.text, rollno.text, gender, mobileno.text);
  //   _refreshData();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("Webview")),
          body: SafeArea(
              child: Column(children: <Widget>[
                Expanded(
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(
                        data: """
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    </head>
    <body>
        <h1>Webview Form</h1>
        <p id="prem"></p>
        <label>Name:</label><br><br>
        <input
          type="text"
          id="name"
        />
        <br><br>
        <label>Password:</label><br><br>
        <input
          type="password"
          id="passwrds"
        />
        <br><br>
        <label>Rollno:</label><br><br>
        <input
          type="text"
          id="rollno"
        />
        <p>Please select your gender:</p>
          <input type="radio" id="Male" name="gender" value="Male">
          <label for="Male">Male</label><br>
          <input type="radio" id="Female" name="gender" value="Female">
          <label for="Female">Female</label><br>
        <br><br>
        <label>Mobileno:</label><br><br>
        <input
          type="number"
          id="mobno"
        />
        <br><br>
        <input type="button" onclick="flutterFunction()" value="Submit form">
        <script>
            window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                window.flutter_inappwebview.callHandler('handlerFoo')
                  .then(function(result) {
                    // print to the console the data coming
                    // from the Flutter side.
                    console.log(JSON.stringify(result));
                    document.getElementById('prem').innerHTML=JSON.stringify(result)

                    window.flutter_inappwebview
                      .callHandler('handlerFooWithArgs', 1, true, ['bar', 100], {foo: 'baz'}, result);
                });
            });
        </script>
    </body>
</html>
                      """
                    ),
                    initialOptions: options,
                    onWebViewCreated: (controller) {
                      controller.addJavaScriptHandler(handlerName: 'handlerFoo', callback: (args)  async{
                        // return data to the JavaScript side!
                        List<dynamic> login = await DatabaseHelper.getItem("jim", "jim");
                        return {
                          'Name': login[0]['title'], 
                          'Gender': login[0]['gender'],
                          'Mobileno': login[0]['mobileno']                          
                        };
                      });

                      controller.addJavaScriptHandler(handlerName: 'handlerFooWithArgs', callback: (args) async{
                        print(args);
                        await DatabaseHelper.createItem(args[0], args[3], args[4], args[2],args[1]);
                        // print(await DatabaseHelper.getItem("roy", "roy"));
                        // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                      });
                    },
                    onLoadStop: (controller, url) {
                      controller.injectJavascriptFileFromAsset(assetFilePath: 'assets/jsfile.js');               
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                      // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                    },
                  ),
                ),
              ]))),
    );
  }
}