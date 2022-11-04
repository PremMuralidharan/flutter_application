import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_application/main.dart';
import 'package:flutter_application/database_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyAppsignup extends StatelessWidget {
  const MyAppsignup({Key? key}) : super(key: key);
  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Signup(),
      ),
    );
  }
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);
 
  @override
  State<Signup> createState() => _SignupState();
}
 
class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController rollno = TextEditingController();
  String? gender;
  TextEditingController mobileno = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _counter = 0;
  // Future getRequest() async {
  //   //replace your restFull API here.
  //   String url = "http://10.20.25.175:3000/helloworld";
  //   final response = await http.get(Uri.parse(url),headers: {"Accept": "application/json"});
  // }
  List<Map<String, dynamic>> myData = [];
  final formKey = GlobalKey<FormState>();

  // bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      myData = data;
      // _isLoading = false;
    });
    print(data);
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "Signed successfully",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  Future<void> addItem() async {
    await DatabaseHelper.createItem(
        nameController.text, passwordController.text, rollno.text, gender, mobileno.text);
    _refreshData();
  }

  // Update an existing data
  Future<void> updateItem(int id) async {
    await DatabaseHelper.updateItem(
        id, nameController.text, passwordController.text);
    _refreshData();
  }

  // Delete an item
  void deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted!'), backgroundColor: Colors.green));
    _refreshData();
  }

  void initState() {
    super.initState();
    _refreshData(); // Loading the data when the app starts
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
                    'Signup',
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
                  controller: passwordController,
                  validator: formValidator,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: rollno,
                  validator: formValidator,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Roll number',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                      Align(child: Text('Gender',style: TextStyle(fontSize: 18)), alignment: Alignment.centerLeft), 
                      RadioListTile(
                          title: const Text("Male"),
                          value: "male", 
                          groupValue: gender, 
                          onChanged: (value){
                            setState(() {
                                gender = value.toString();
                            });
                          },
                      ),

                      RadioListTile(
                          title: const Text("Female"),
                          value: "female", 
                          groupValue: gender, 
                          onChanged: (value){
                            setState(() {
                                gender = value.toString();
                            });
                          },
                      ),

                      RadioListTile(
                            title: const Text("Other"),
                            value: "other", 
                            groupValue: gender, 
                            onChanged: (value){
                              setState(() {
                                  gender = value.toString();
                              });
                            },
                      )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: mobileno,
                  validator: formValidator,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobileno',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  print(nameController);
                  //forgot password screen
                },
                child: const Text('Forgot Password',),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Sign In'),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await addItem();
                        // Clear the text fields
                        setState(() {
                          nameController.text = '';
                          passwordController.text = '';
                          rollno.text = '';
                          gender = '';
                          mobileno.text = '';
                        });
                        showNotification();
                        // Close the bottom sheet
                      } // Save new data
                    },
                  )
              ),
              Row(
                children: <Widget>[
                  const Text('Already have an account?'),
                  TextButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return  MyApp();
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