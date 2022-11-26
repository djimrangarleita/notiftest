import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notiftest/firebase_options.dart';
import 'package:notiftest/local_notif_service.dart';
import 'package:notiftest/route_test.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LocalNotifService.initializeNotif();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initNotifInfo();
    super.initState();
  }

  initNotifInfo() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      log("From terminated");
      if (message != null) {
        log(message.data["rideRequestID"]);
        log(message.data["rideType"]);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RouteTest(
              data: message.data,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      log("Foreground");
      if (message.notification != null) {
        LocalNotifService.createNotif(message);
        log(message.notification!.title!);
        log(message.data["rideRequestID"]);
        log(message.data["rideType"]);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RouteTest(
              data: message.data,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("Background");
      if (message.notification != null) {
        log(message.notification!.title!);
        log(message.data["rideRequestID"]);
        log(message.data["rideType"]);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RouteTest(
              data: message.data,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notif"),
      ),
    );
  }
}
