import 'package:bluetooth/controllers/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../widgets/scan_result_tile_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _controller = Get.put(ScanController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.getScanResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Scan Devices'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (_controller.scans.value[index]["deviceName"].isNotEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _controller.scans.value[index]["deviceName"],
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _controller.scans.value[index]["device_id"],
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    )
                  : Text(
                      _controller.scans.value[index]["device_id"],
                    ),
              Text(
                _controller.scans.value[index]["distance"],
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: _controller.scans.length,
      ),
    );
  }
}
