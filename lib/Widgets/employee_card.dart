import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shipper_app/Widgets/alertDialog/update_employee_alert_dialog.dart';
import 'package:shipper_app/Widgets/remove_employee_alert_dialog.dart';
import 'package:shipper_app/models/company_users_model.dart';
import 'package:shipper_app/screens/edit_user_screen.dart';
import '../constants/colors.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/radius.dart';
import '../constants/spaces.dart';
import '../models/popup_model_for_employee_card.dart';
import 'package:http/http.dart' as http;

import '../screens/user_status.dart';

//TODO: This card is used to display the employee name/uid and role in the company and also we can edit the role as well as delete the employee from company database
class EmployeeCard extends StatelessWidget {
  String name = "";
  Future<String> getName(String uid) async {
    // final url ='http://13.235.32.114:9090/uid';
    final String uidApiName = dotenv.get("getUid");
    final response = await http.get(Uri.parse("$uidApiName/$uid"));

    if (response.statusCode == 200) {
      // Request successful
      final jsonData = json.decode(response.body);
      return jsonData['name'];
      // name =
      //     jsonData['name']; // Access the 'name' object from the response data
      // print(name);
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}.');
      return '';
    }
  }

  String email = "";
  Future<String> getEmail(String uid) async {
    // final url ='http://13.235.32.114:9090/uid';
    final String uidApiEmail = dotenv.get("getUid");
    final response = await http.get(Uri.parse("$uidApiEmail/$uid"));

    if (response.statusCode == 200) {
      // Request successful
      final jsonData = json.decode(response.body);
      return jsonData['email'];
      // email =
      //     jsonData['email']; // Access the 'name' object from the response data
      // print(email);
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}.');
      return '';
    }
  }

  Future<bool> checkConnectivity() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult != ConnectivityResult.none;
    } on PlatformException catch (e) {
      print(e.toString());
      return false;
    }
  }

  CompanyUsers companyUsersModel;
  EmployeeCard({Key? key, required this.companyUsersModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: space_2),
      child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            getName(companyUsersModel.uid),
            getEmail(companyUsersModel.uid),
            checkConnectivity(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is still loading, show a loading indicator
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If an error occurred while fetching the name, display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // Otherwise, display the employee card with the fetched name
              final name = snapshot.data?[0] as String?;
              final email = snapshot.data?[1] as String?;
              final isOnline = snapshot.data?[2] as bool? ?? false;
              return Card(
                  color: Colors.white,
                  elevation: 3,
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: space_2, left: space_2, right: space_2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$name",
                              style: TextStyle(
                                  fontSize: kIsWeb ? size_8 : size_8,
                                  color: Color(0xFF152968),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'montserrat'),
                            ),
                            PopupMenuButton<PopUpMenuForEmployee>(
                                offset: Offset(0, space_2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(radius_2))),
                                onSelected: (item) => onSelected(context, item),
                                itemBuilder: (context) => [
                                      ...MenuItemsForEmployee.listItem
                                          .map(showEachItemFromList)
                                          .toList(),
                                    ]),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: size_6,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "${email}",
                              style: TextStyle(
                                fontSize: kIsWeb ? size_8 : size_6,
                                color: Color(0xFF152968),
                                fontFamily: 'montserrat',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size_10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                  fontSize: size_6,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              isOnline ? "Online" : "Offline",
                              style: TextStyle(
                                fontSize: size_6,
                                color: isOnline ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size_4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Role",
                              style: TextStyle(
                                  fontSize: size_6,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w700),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(30, 30)),
                              onPressed: () {
                                MenuItemsForEmployee.itemEdit;
                                updateUser(context);
                              },
                              child: Text(
                                "${companyUsersModel.role}",
                                style: TextStyle(
                                    fontSize: kIsWeb ? size_8 : size_6,
                                    color: veryDarkGrey,
                                    fontFamily: 'montserrat'),
                              ),
                            )

                            // Container(
                            //   width: 90,
                            //   height: 25,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //       color: Colors.grey.shade300),
                            //   child: Center(
                            //     child: Text(
                            //       "${companyUsersModel.role}",
                            //       style: TextStyle(
                            //           fontSize: kIsWeb ? size_8 : size_6,
                            //           color: veryDarkGrey,
                            //           fontFamily: 'montserrat'),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ));
            }
          }),
    );
  }

  PopupMenuItem<PopUpMenuForEmployee> showEachItemFromList(
          PopUpMenuForEmployee item) =>
      PopupMenuItem<PopUpMenuForEmployee>(
          value: item,
          child: Row(
            children: [
              Image(
                image: AssetImage(item.iconImage),
                height: size_6 + 1,
                width: size_6 + 1,
              ),
              SizedBox(
                width: space_1 + 2,
              ),
              Text(
                item.itemText,
                style: TextStyle(
                  fontWeight: mediumBoldWeight,
                ),
              ),
            ],
          ));

  void onSelected(BuildContext context, PopUpMenuForEmployee item) {
    switch (item) {
      case MenuItemsForEmployee.itemEdit:
        updateUser(context);
        break;
      case MenuItemsForEmployee.itemRemove:
        removeUser(context);
        break;
    }
  }

  updateUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditUser();
        });
  }

  removeUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RemoveEmployee(employeeUid: companyUsersModel.uid);
        });
  }
}
