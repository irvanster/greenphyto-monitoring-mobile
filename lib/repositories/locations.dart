import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'config.dart';
import 'package:http/http.dart' as http;
import '../schemas/locations.dart';

class LocationsRepository {
  Future<List<Location>> getData() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}monitor-locations'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (kDebugMode) print(response.body);
        final List<dynamic> locationsData = responseData['data'];

        final List<Location> locations =
            locationsData.map((json) => Location.fromJson(json)).toList();

        return locations;
      } else {
        if (kDebugMode) {
          print('Failed to fetch data. Status Code: $response');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception while fetching data: $e');
      }
      return [];
    }
  }

  Future<Map<String, dynamic>> getDetail(String locationId) async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}monitor-locations/$locationId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final Map<String, dynamic> data = responseData['data'];

          return data;
        } else {
          if (kDebugMode) {
            print('Failed to fetch data. Message: ${responseData['message']}');
          }
          return {};
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch data. Status Code: ${response.statusCode}');
        }
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception while fetching location detail: $e');
      }
      return {};
    }
  }
}
