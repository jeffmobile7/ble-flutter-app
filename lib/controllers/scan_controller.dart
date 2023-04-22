import 'dart:convert';
import 'dart:math';

import 'package:bluetooth/helpers/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  final box = GetStorage();
  var isPermissionGranted = false.obs;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  var scans = [].obs;
  var subscription;

  Future isBluetoothOn() async {
    final state = await flutterBlue.state.first;
    isPermissionGranted.value = state == BluetoothState.on;

    if (!isPermissionGranted.value) {
      Get.defaultDialog(
        title: "",
        backgroundColor: const Color(0xff131429),
        content: Column(
          children: const [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: Text(
                "Turn on Bluetooth",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        onCancel: () {
          Get.back();
        },
      );
    } else {
      _scan();
    }
  }

  _scan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      saveScanResults(results);
    });
  }

  void saveScanResults(List<ScanResult> scanResults) {
    List jsonList = box.read('scan_results') ?? [];
    List<Map<String, dynamic>> existingScanResults = [];
    for (String jsonString in jsonList) {
      Map<String, dynamic> map = jsonDecode(jsonString);
      existingScanResults.add(map);
    }
    for (ScanResult scanResult in scanResults) {
      bool found = false;
      for (int i = 0; i < existingScanResults.length; i++) {
        if (existingScanResults[i]['device_id'] == scanResult.device.id.id) {
          found = true;
          existingScanResults[i].addAll({
            'deviceName': scanResult.device.name,
            'rssi': scanResult.rssi,
            'timestamp': DateTime.now().toIso8601String(),
            'distance': calculateDistance(scanResult)
          });
          break;
        }
      }
      if (!found) {
        existingScanResults.add({
          'device_id': scanResult.device.id.id,
          'deviceName': scanResult.device.name,
          'rssi': scanResult.rssi,
          'timestamp': DateTime.now().toIso8601String(),
          'distance': calculateDistance(scanResult)
        });
      }
    }
    List<String> newJsonList =
        existingScanResults.map((map) => jsonEncode(map)).toList();
    box.write('scan_results', newJsonList);
  }

  List<Map<String, dynamic>> getScanResults() {
    List<String> jsonList = box.read('scan_results') ?? [];
    List<Map<String, dynamic>> scanResults = [];
    for (String jsonString in jsonList) {
      Map<String, dynamic> map = jsonDecode(jsonString);
      scanResults.add(map);
    }
    scans.value = scanResults;
    return scanResults;
  }
}
