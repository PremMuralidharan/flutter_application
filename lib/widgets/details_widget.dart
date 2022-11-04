import 'package:flutter/material.dart';
import 'package:flutter_application/details.dart';
import 'package:flutter_application/models/details.dart';

class DetailsWidget extends StatelessWidget {
  final Details details;

  const DetailsWidget({Key? key,required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Name : ',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        details.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Roll no : ',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        details.rollno,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Gender : ',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        details.gender,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Mobilenumber : ',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        details.mobileno,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    return ListView(
      shrinkWrap: true,
      children: [
        titleSection,
        // Text(details.gender),
        // Text(details.id),
      ],
    );
  }
}
