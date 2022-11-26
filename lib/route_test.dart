import 'package:flutter/material.dart';

class RouteTest extends StatelessWidget {
  final Map<String, dynamic> data;
  const RouteTest({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["rideType"]),
      ),
      body: Center(child: Text(data["rideRequestID"])),
    );
  }
}
