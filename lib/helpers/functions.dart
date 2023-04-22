import 'dart:math';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

calculateDistance(ScanResult scanResult) {
  double measuredPower = -59;
  double n = 2;
  var distance = pow(10, ((measuredPower - scanResult.rssi) / (10 * n)));
  String result = distance.toStringAsFixed(2);
  return "Distance: $result m";
}
