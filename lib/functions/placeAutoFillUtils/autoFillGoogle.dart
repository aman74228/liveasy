import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

import '/functions/googleAutoCorrectionApi.dart';
import '/models/autoFillMMIModel.dart';
import '../googleAutoCorrectionApi.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_config/flutter_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// String kGoogleApiKey = FlutterConfig.get('mapKey').toString();
String kGoogleApiKey = dotenv.get('mapKey');
String proxyServer = dotenv.get('placeAutoCompleteProxy');

// Future<List<AutoFillMMIModel>> fillCityGoogle(String cityName,Position position) async {
//   print(      Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?'
//       'input=$cityName&location=${position.latitude},${position.longitude}&radius=50000&language=en&components=country:in&key=$kGoogleApiKey')
//   );
//
//   var request = http.Request(
//       'GET',
//       Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?'
//           'input=$cityName&location=${position.latitude},${position.longitude}&radius=50000&language=en&components=country:in&key=$kGoogleApiKey'));
//
//   print("request $request");
//
//   http.StreamedResponse response = await request.send();
//
//   print("resonse $response");
//
//
//
//   List<AutoFillMMIModel> card = [];
//   if (response.statusCode == 200) {
//     // print(await response.stream.bytesToString());
//     var res = await response.stream.bytesToString();
//     var address = json.decode(res);
//     address = address["predictions"];
//     //print(address);
//     for (var json in address) {
//       print("json Description From fillCity ${json["description"]}");
//       List<String> result = json["description"]!.split(",");
//       //print(result);
//       int resultLength = 0;
//       for (var r in result) {
//         resultLength++;
//         r = r.trimLeft();
//         r = r.trimRight();
//         //print(r);
//       }
//       if(resultLength==2)
//         {
//           AutoFillMMIModel locationCardsModal = AutoFillMMIModel(
//               placeName: "${result[0].toString()}",
//               placeCityName: "${result[0].toString()}",
//               // placeStateName: json["placeAddress"]\
//               placeStateName: "${result[0].toString()}");
//           card.add(locationCardsModal);
//         }
//       else if(resultLength==3)
//       {
//         AutoFillMMIModel locationCardsModal = AutoFillMMIModel(
//             placeName: "${result[0].toString()}",
//             placeCityName: "${result[0].toString()}",
//             // placeStateName: json["placeAddress"]\
//             placeStateName: "${result[1].toString()}");
//         card.add(locationCardsModal);
//       }
//       else {
//         AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
//             placeName: "${result[0].toString()}",
//             addresscomponent1: "${result[1].toString()}",
//             placeCityName: "${result[resultLength - 3].toString()}",
//             // placeStateName: json["placeAddress"]\
//             placeStateName: "${result[resultLength - 2].toString()}");
//         card.add(locationCardsModal);
//         print(card[0]);
//       }
//     }
//     return card;
//   } else {
//     List<AutoFillMMIModel> card = [];
//     return card;
//   }
// }

Future<List<AutoFillMMIModel>> fillCityGoogle(String cityName,Position position) async {
  try {
    http.Response response;
    if (kIsWeb) {
      print("Hello");
      response = await http.get(
        Uri.parse(
            '$proxyServer''https://maps.googleapis.com/maps/api/place/autocomplete/json?'
                'input=$cityName&location=${position.latitude},${position
                .longitude}&radius=50000&language=en&components=country:in&key=$kGoogleApiKey'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        },
      );


      print("response: $response");
    }
    else {
      response = await http.get(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
                'input=$cityName&location=${position.latitude},${position
                .longitude}&radius=50000&language=en&components=country:in&key=$kGoogleApiKey'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
      );
    }


    var address = await jsonDecode(response.body);


    List<AutoFillMMIModel> card = [];
    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      // var res = await response.stream.bytesToString();
      // var address = json.decode(response.body);
      address = address["predictions"];
      for (var json in address) {
        List<String> result = json["description"]!.split(",");
        int resultLength = 0;
        for (var r in result) {
          resultLength++;
          r = r.trimLeft();
          r = r.trimRight();
        }

        if (resultLength == 1) {
          //do nothing
          //Example --> India or Delhi --> These type of addresses are not acceptable
        }
        else if (resultLength == 2) {
          if (result[resultLength - 1].toString() == " India" ||
              result[resultLength - 1].toString() == " india" ||
              result[resultLength - 1].toString() == " INDIA") {
            //do nothing
            //Example--> West Bengal, India ...
          }
          else {
            //Example --> Kolkata, WestBengal then placeName : Kolkata, addresscomponent1: "", placeCityName: Kolkata, placeStateName: West Bengal
            AutoFillMMIModel locationCardsModal = AutoFillMMIModel(
                placeName: "${result[0].toString()}",
                placeCityName: "${result[0].toString()}",
                // placeStateName: json["placeAddress"]\
                placeStateName: "${result[1].toString()}");
            card.add(locationCardsModal);
          }
        }
        else if (resultLength == 3) {
          if (result[resultLength - 1].toString() == " India" ||
              result[resultLength - 1].toString() == " india" ||
              result[resultLength - 1].toString() == " INDIA") {
            //Example--> kolkata, West Bengal, India ...
            //placeName: kolkata, addresscomponent1:"", placeCityName: kolkata, placeStateName: West Bengal, India

            AutoFillMMIModel locationCardsModal = AutoFillMMIModel(
                placeName: "${result[0].toString()}",
                placeCityName: "${result[0].toString()}",
                // placeStateName: json["placeAddress"]\
                placeStateName: "${result[1].toString()},${result[2]
                    .toString()}");
            card.add(locationCardsModal);
          }
          else {
            //Example: Jadavpur, Kolkata, West Bengal
            //placeName: Jadavpur, addresscomponent1:"", placeCityName: kolkata, placeStateName: West Bengal
            AutoFillMMIModel locationCardsModal = AutoFillMMIModel(
                placeName: "${result[0].toString()}",
                placeCityName: "${result[1].toString()}",
                // placeStateName: json["placeAddress"]\
                placeStateName: "${result[2].toString()}");
            card.add(locationCardsModal);
          }
        }
        else {
          String addressDetail = "";
          if (resultLength > 4) {
            if (result[resultLength - 1].toString() == " India" ||
                result[resultLength - 1].toString() == " india" ||
                result[resultLength - 1].toString() == " INDIA") {
              for (int i = 1; i < resultLength - 3; i++) {
                addressDetail += result[i].toString();
              }


              AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
                  placeName: "${result[0].toString()}",
                  addresscomponent1: addressDetail == null
                      ? "${result[resultLength - 1].toString()}"
                      : "$addressDetail",
                  placeCityName: "${result[resultLength - 3].toString()}",
                  placeStateName: "${result[resultLength - 2]
                      .toString()},${result[resultLength - 1].toString()}");
              card.add(locationCardsModal);
            }
            else {
              for (int i = 1; i < resultLength - 2; i++) {
                addressDetail += result[i].toString();
              }

              AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
                  placeName: "${result[0].toString()}",
                  addresscomponent1: addressDetail == null
                      ? " " : "$addressDetail",
                  placeCityName: "${result[resultLength - 2].toString()}",
                  placeStateName: "${result[resultLength - 1].toString()}");
              card.add(locationCardsModal);
            }
          }
          else {
            if (result[resultLength - 1].toString() == " India" ||
                result[resultLength - 1].toString() == " india" ||
                result[resultLength - 1].toString() == " INDIA") {
              AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
                  placeName: "${result[0].toString()}",
                  placeCityName: "${result[resultLength - 3].toString()}",
                  placeStateName: "${result[resultLength - 2]
                      .toString()},${result[resultLength - 1].toString()}");
              card.add(locationCardsModal);
            }
            else {
              AutoFillMMIModel locationCardsModal = new AutoFillMMIModel(
                  placeName: "${result[0].toString()}",
                  addresscomponent1: "${result[1].toString()}",
                  placeCityName: "${result[2].toString()}",
                  placeStateName: "${result[3].toString()}");
              card.add(locationCardsModal);
            }
          }
        }
      }
      return card;
    }
    else {
      List<AutoFillMMIModel> card = [];
      return card;
    }
  }
  catch(e){
    print("Here $e");
    List<AutoFillMMIModel> card = [];
    return card;
  }

}


