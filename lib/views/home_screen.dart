import 'package:bluetooth/controllers/scan_controller.dart';
import 'package:bluetooth/views/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../widgets/scan_result_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = Get.put(ScanController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.isBluetoothOn();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Devices'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
            onPressed: () {
              Get.to(() => HistoryScreen());
            },
            child: const Text('History'),
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: _controller.flutterBlue.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => _controller.flutterBlue.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              child: const Icon(Icons.search),
              onPressed: () => _controller.isBluetoothOn(),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<ScanResult>>(
              stream: _controller.flutterBlue.scanResults,
              initialData: const [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map(
                      (r) => ScanResultTile(result: r, onTap: () {}),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
