import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../constants/fontSize.dart';
import '../controller/shipperIdController.dart';
import 'add_user_screen.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  @override
  Widget build(BuildContext context) {
    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Liveasy",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF152968),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: size_12,
              child: Center(
                child: Text(
                  "My Account Details",
                  style: TextStyle(
                      fontSize: size_8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF152968)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: size_12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: size_15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: const Color(0xFF000066),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AddUser();
                              });
                        },
                        child: const Text('Edit'),
                      ),
                      SizedBox(
                        width: size_4,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: const Color(0xFF000066),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AddUser();
                              });
                        },
                        child: const Text('Send invite'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: TextFormField(
                            autofocus: false,
                            decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                print('Enter your name');
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: TextFormField(
                            autofocus: false,
                            decoration: InputDecoration(
                                labelText: 'e-mail',
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                print('Enter your name');
                              } else if (!value.contains('@')) {
                                return 'Please enter valid email id';
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: TextFormField(
                            autofocus: false,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                print('Enter password');
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Update',
                                    style: TextStyle(fontSize: 18),
                                  )),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
