import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:starship/model/spacex.dart';

Future<SpaceX> fetchData() async {
  final response =
      await http.get(Uri.https('api.spacexdata.com', 'v4/launches/latest'));

  if (response.statusCode == 200) {
    return SpaceX.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
