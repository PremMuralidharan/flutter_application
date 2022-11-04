import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_application/signin.dart';
import 'package:flutter_application/database_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_application/models/details.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/reducer.dart';
import 'package:flutter_application/redux/actions.dart';
import 'package:redux/redux.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(Nav2App());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
 
  static const String _title = 'Sample App';

  // final Store<AppState> _store = Store<AppState>(
  //   updateDetailsReducer,
  //   initialState: AppState(details: [
  //     Details(1, "rem", "", "","","",""),
  //     Details(2, "ram", "", "","","",""),
  //   ],)
  // );
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: Scaffold(
          appBar: AppBar(title: const Text(_title)),
          body: const MyStatefulWidget(),
        ),
    );
  }
}
 
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
 
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}
 
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _counter = 0;
  final formKey = GlobalKey<FormState>();


  // Future getRequest() async {
  //   //replace your restFull API here.
  //   String url = "http://10.20.25.175:3000/helloworld";
  //   final response = await http.get(Uri.parse(url),headers: {"Accept": "application/json"});
  // }
  
  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "Logedin successfully",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  Future<List> getId(String username, String passwrd) async {
    var logindetails = await DatabaseHelper.getItem(username, passwrd);
    if(logindetails.isNotEmpty){
      StoreProvider.of<AppState>(context).dispatch
      (AddDetailsAction(Details(logindetails[0]['id'], logindetails[0]['title'], logindetails[0]['description'],
      logindetails[0]['rollno'],logindetails[0]['gender'],logindetails[0]['mobileno'],logindetails[0]['createdAt'])));

      showNotification();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return details();
        }),
      ); 
    }  else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Invalid username or password'), backgroundColor: Colors.green));
    }
    return logindetails;
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Successfully deleted!'), backgroundColor: Colors.green));
    // _refreshData();
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Flutterapp',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  validator: formValidator,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  validator: formValidator,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text('Forgot Password',),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var logindetails = await getId(nameController.text,passwordController.text);
                        // print(logindetails[0]);
                        // List<Details> newDetails;
                        // newDetails = 

                        // StoreProvider.of<AppState>(context).dispatch(UpdatedDetailsAction(4, "rem", "prem", "male","",""));
                        // Clear the text fields
                        setState(() {
                          nameController.text = '';
                          passwordController.text = '';
                        });
                        // showNotification();
                        // Close the bottom sheet
                      } // Save new data
                    }
                  )
              ),
              Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MyAppsignup();
                          }),
                        );  
                      //signup screen
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ));
  }
}

class Nav2App extends StatelessWidget {
  final Store<AppState> _store = Store<AppState>(
    updateDetailsReducer,
    initialState: AppState(details: [
      // Details(1, "rem", "", "","","",""),
      // Details(2, "ram", "", "","","",""),
    ],)
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: _store,
      child: MaterialApp(
        routes: {
          '/': (context) => MyApp(),
          '/myapp': (context) => MyAppsignup(),
          '/details': (context) => details(),
        },
      ),
    );
  }
}



// class Signup extends StatefulWidget {
//   const Signup({Key? key}) : super(key: key);
 
//   @override
//   State<Signup> createState() => _SignupState();
// }
 
// class _SignupState extends State<Signup> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   Future getRequest() async {
//     //replace your restFull API here.
//     String url = "http://10.20.25.175:3000/helloworld";
//     final response = await http.get(Uri.parse(url),headers: {"Accept": "application/json"});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(10),
//         child: ListView(
//           children: <Widget>[
//             Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.all(10),
//                 child: const Text(
//                   'Flutterapp',
//                   style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 30),
//                 )),
//             Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.all(10),
//                 child: const Text(
//                   'Login',
//                   style: TextStyle(fontSize: 20),
//                 )),
//             Container(
//               padding: const EdgeInsets.all(10),
//               child: TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'User Name',
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//               child: TextField(
//                 obscureText: true,
//                 controller: passwordController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Password',
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 print(nameController);
//                 //forgot password screen
//               },
//               child: const Text('Forgot Password',),
//             ),
//             Container(
//                 height: 50,
//                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                 child: ElevatedButton(
//                   child: const Text('Login'),
//                   onPressed: () {
                        
//                   },
//                 )
//             ),
//             Row(
//               children: <Widget>[
//                 const Text('Does not have account?'),
//                 TextButton(
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) {
//                           return MyStatefulWidget();
//                         }),
//                       );
//                     //signup screen
//                   },
//                 )
//               ],
//               mainAxisAlignment: MainAxisAlignment.center,
//             ),
//           ],
//         ));
//   }
// }

