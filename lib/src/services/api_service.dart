import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final dio = Dio();

  Future<String?> fetchLatestVersion() async {
    try {
      final platform = Platform.isAndroid ? 'android' : 'ios';
      final response = await dio.get(
        'https://endoflife.date/api/$platform.json',
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List && data.isNotEmpty) {
          final latestVersion = data.first['cycle'];
          return latestVersion;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching version info: $e');
      return null;
    }
  }
}
