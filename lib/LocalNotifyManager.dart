import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifyManager {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var initSettings;
  int genId = 0;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init() {
    // print("Baru init settings");
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }
  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  initializePlatform() {
    print("initializePlatform start");
    // var initSettingAndroid =
    //     const AndroidInitializationSettings('ic_launcher_background');
    final IOSInitializationSettings initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        // defaultPresentAlert: true,
        // defaultPresentBadge: true,
        // defaultPresentSound: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initSettings = InitializationSettings(iOS: initSettingIOS);
    // await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
    ReceiveNotification notification = ReceiveNotification(
        id: id,
        title: title.toString(),
        body: body.toString(),
        payload: payload.toString());
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (String? payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannel = const AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max, priority: Priority.high, playSound: true);
    // var iosChannel = const IOSNotificationDetails();
    const IOSNotificationDetails iosChannel =
        IOSNotificationDetails(threadIdentifier: "thread2");
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    await flutterLocalNotificationsPlugin
        .show(0, 'Test Title', 'body', platformChannel, payload: 'Net Payload');
  }

  Future<void> repeatNotification() async {
    var androidChannel = const AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max, priority: Priority.high, playSound: true);
    // var iosChannel = const IOSNotificationDetails();
    const IOSNotificationDetails iosChannel =
        IOSNotificationDetails(threadIdentifier: "thread2");
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    await flutterLocalNotificationsPlugin.periodicallyShow(
        0, 'Test Title', 'body', RepeatInterval.everyMinute, platformChannel,
        payload: 'Net Payload');
  }

  Future<void> dailyAtTimeNotification(int _id, int hour, DateTime dt2,
      String id, String title, String description) async {
    // var now = DateTime.now();
    // var diff = dt2.difference(now);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);
    var dt = tz.TZDateTime.now(tz.local);

    var currentDateTime = tz.TZDateTime.from(dt2,
        tz.local); //tz.TZDateTime.utc(dt2.year, dt2.month, dt2.day, dt2.hour, dt2.minute, dt2.second);
    // var dtn = DateTime.now();
    // print("currentDateTime $currentDateTime $dtn");
    var h = dt2.hour;
    var m = dt2.minute;
    var s = dt2.second;

    // currentDateTime = tz.TZDateTime.now(tz.local)
    //     .add(Duration(seconds: (diff.inSeconds * 3600)));
    // if (h > hour) {
    //   var second = (h - hour) * 3600;
    //   second += ((60 - m) * 60);
    //   second += (60 - s);
    //   print("seconds $second");

    //   currentDateTime =
    //       tz.TZDateTime.now(tz.local).add(Duration(seconds: (second * 3600)));
    // } else {
    //   // var dtn2 =
    //   //     DateTime(dt.year, dt.month, dt.day + 1, h, dtn.minute, dtn.second);

    //   var second = (h + 24) - hour;
    //   second += ((60 - m) * 60);
    //   second += (60 - s);

    //   // print("seconds $second");
    //   currentDateTime =
    //       tz.TZDateTime.now(tz.local).add(Duration(seconds: (second * 3600)));
    // }

    // if (dt.hour < hour) {
    //   currentDateTime = tz.TZDateTime.utc(dt.year, dt.month, dt.day, hour);
    // } else {
    //   currentDateTime = tz.TZDateTime.utc(dt.year, dt.month, dt.day + 1, hour);

    // }

    // final String timeZoneName =
    //     await platform.invokeMethod('getTimeZoneName');
    // tz.setLocalLocation(tz.getLocation(timeZoneName));
    // Duration offsetTime = tz.TZDateTime.now(tz.local).timeZoneOffset;

    // var dt3 = tz.TZDateTime.now(tz.local);
    // // var dt3 = DateTime.now();
    // currentDateTime = tz.TZDateTime.utc(
    //     dt3.year, dt3.month, dt3.day, dt3.hour, dt3.minute, dt3.second + 5);

    // currentDateTime = dt.add(const Duration(seconds: 5));
    // currentDateTime = tz.TZDateTime.utc(
    //     dt3.year, dt3.month, dt3.day, dt3.hour, dt3.minute, dt3.second + 3);
    // print("current Date Time ${tz.local} ${currentDateTime}");

    // var androidChannel = const AndroidNotificationDetails(
    //     'CHANNEL_ID', 'CHANNEL_NAME',
    //     icon: "ic_launcher_background",
    //     importance: Importance.max,
    //     priority: Priority.high,
    //     channelShowBadge: true,
    //     playSound: true);
    const IOSNotificationDetails iosChannel = IOSNotificationDetails(
        badgeNumber: 1,
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    // var platformChannel = NotificationDetails(android: androidChannel);
    var platformChannel = const NotificationDetails(iOS: iosChannel);
    // print("here daily ios notification");

    // print("gen Id : $_id");

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     _id + 1000 + 1,
    //     title,
    //     description,
    //     // currentDateTime,
    //     dt.add(const Duration(minutes: 5)),
    //     platformChannel,
    //     payload: id,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.wallClockTime,
    //     androidAllowWhileIdle: true);
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     _id += 1000 + 1,
    //     title,
    //     description,
    //     // currentDateTime,
    //     dt.add(const Duration(seconds: 5 + 1)),
    //     platformChannel,
    //     payload: id,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.wallClockTime,
    //     androidAllowWhileIdle: true);
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     _id += 1000 + 1,
    //     title,
    //     description,
    //     // currentDateTime,
    //     dt.add(const Duration(seconds: 5 + 2)),
    //     platformChannel,
    //     payload: id,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.wallClockTime,
    //     androidAllowWhileIdle: true);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        _id,
        title,
        description,
        currentDateTime,
        // dt.add(const Duration(seconds: 5)),
        platformChannel,
        payload: id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true);
  }

  Future<void> dailyAtTimeNotification2(int _id, int hour, DateTime dt2,
      String id, String title, String description) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);
    var dt = tz.TZDateTime.now(tz.local);
    var currentDateTime = tz.TZDateTime.utc(dt.year, dt.month, dt.day, hour);
    var dtn = DateTime.now();
    print("currentDateTime $currentDateTime $dtn");
    var h = dtn.hour;
    var m = dtn.minute;
    var s = dtn.second;

    if (h > hour) {
      var second = (h - hour) * 3600;
      second -= (m * 60);
      second -= s;

      currentDateTime =
          tz.TZDateTime.now(tz.local).add(Duration(seconds: (second * 3600)));
    } else {
      // var dtn2 =
      //     DateTime(dt.year, dt.month, dt.day + 1, h, dtn.minute, dtn.second);

      var second = (h + 24) - hour;
      second -= (m * 60);
      second -= s;
      currentDateTime =
          tz.TZDateTime.now(tz.local).add(Duration(seconds: (second * 3600)));
    }

    // if (dt.hour < hour) {
    //   currentDateTime = tz.TZDateTime.utc(dt.year, dt.month, dt.day, hour);
    // } else {
    //   currentDateTime = tz.TZDateTime.utc(dt.year, dt.month, dt.day + 1, hour);

    // }

    // final String timeZoneName =
    //     await platform.invokeMethod('getTimeZoneName');
    // tz.setLocalLocation(tz.getLocation(timeZoneName));
    // Duration offsetTime = tz.TZDateTime.now(tz.local).timeZoneOffset;

    // var dt3 = tz.TZDateTime.now(tz.local);
    // // var dt3 = DateTime.now();
    // currentDateTime = tz.TZDateTime.utc(
    //     dt3.year, dt3.month, dt3.day, dt3.hour, dt3.minute, dt3.second + 5);

    // currentDateTime = dt.add(const Duration(seconds: 5));
    // currentDateTime = tz.TZDateTime.utc(
    //     dt3.year, dt3.month, dt3.day, dt3.hour, dt3.minute, dt3.second + 3);
    // print("current Date Time ${tz.local} ${currentDateTime}");

    var androidChannel = const AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max, priority: Priority.high, playSound: true);
    // var iosChannel = const IOSNotificationDetails();
    const IOSNotificationDetails iosChannel =
        IOSNotificationDetails(threadIdentifier: "thread2");
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    print("gen Id : $_id");

    await flutterLocalNotificationsPlugin.zonedSchedule(
        _id + 1000 + 1,
        title,
        description,
        // currentDateTime,
        dt.add(const Duration(minutes: 5)),
        platformChannel,
        payload: id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        _id += 1000 + 1,
        title,
        description,
        // currentDateTime,
        dt.add(const Duration(seconds: 5 + 1)),
        platformChannel,
        payload: id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        _id += 1000 + 1,
        title,
        description,
        // currentDateTime,
        dt.add(const Duration(seconds: 5 + 2)),
        platformChannel,
        payload: id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true);
  }

  Future<void> cancelAllScheduled() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceiveNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
