import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:bx/password_form.dart';
import 'package:bx/register_form.dart';
import 'package:bx/slide_schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
// import 'package:localstorage/localstorage.dart';
import 'package:overlay_support/overlay_support.dart';

import 'LocalNotifyManager.dart';
import 'SecondScreen.dart';
import 'notificationservice.dart';
import 'qitem.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService().initNotification();
  // FirebaseMessaging.instance.subscribeToTopic("all");
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await localNotifyManager.initializePlatform();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'Bruxism',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Bruxism'),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageMode = 0;
  late String? loginStatus;
  bool isSwitched = false;

  void selectPage(int page) {
    setState(() {
      _pageMode = page;
    });
  }

  void showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> signInWithEmailAndPassword2(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    selectPage(3);
  }

  Future<void> startSessions_test(
      bool isActive, DateTime dt, bool repeat) async {
    // LocalStorage storage = LocalStorage('questions');
    // storage.setItem("initial_date_time", DateTime.now().millisecondsSinceEpoch);

    if (loginStatus == "logout") {
      throw Exception('Must be logged in');
    } else {
      if (!repeat) {
        FirebaseFirestore.instance
            .collection("settings")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            // .doc('settings/' + FirebaseAuth.instance.currentUser!.uid)
            .set({
          'data': "",
          'active': isActive,
          'start': dt.toIso8601String(),
          'end': 0,
          'userId': FirebaseAuth.instance.currentUser!.uid,
        });
      }
    }
    print("hour: ${dt.hour} : ${dt.minute} : ${dt.second}");

    if (isActive) {
      int _id = 0;

      var nd9 =
          DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
      nd9 = nd9.add(const Duration(seconds: 3));
      saveSchedule(nd9, 9, _id);
      _id++;
      print("next day: ${nd9.toIso8601String()}");

      var nd12 =
          DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
      nd12 = nd12.add(const Duration(seconds: 5));
      saveSchedule(nd12, 12, _id);
      _id++;
      print("next day: ${nd12.toIso8601String()}");

      var nd15 =
          DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
      nd15 = nd15.add(const Duration(seconds: 10));

      print("next day: ${nd15.toIso8601String()}");
      saveSchedule(nd15, 15, _id);
      _id++;

      var nd18 =
          DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
      nd18 = nd18.add(const Duration(seconds: 15));

      print("next day: ${nd18.toIso8601String()}");
      saveSchedule(nd18, 18, _id);
      _id++;

      var nd21 =
          DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
      nd21 = nd21.add(const Duration(seconds: 15));
      saveSchedule(nd21, 21, _id);
      _id++;
      print("next day: ${nd21.toIso8601String()}");
    } else {
      localNotifyManager.cancelAllScheduled();
      // LocalStorage storage = LocalStorage("questions");
      // storage.clear();
      // storage.dispose();
    }
  }

  Future<void> saveSchedule(DateTime dt, int mode, int _id) async {
    // LocalStorage storage = LocalStorage('questions');
    final QitemList list = QitemList();

    // var list = [];
    var now = DateTime.now();
    var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var inputDate = inputFormat.parse(
        '${dt.day}/${dt.month}/${dt.year} ${mode.toString()}:00'); // <-- dd/MM 24H format

    var genId =
        "${dt.year}-${dt.month}-${dt.day}-${mode.toString()}-${FirebaseAuth.instance.currentUser!.uid}";

    // var qa = storage.getItem("questions");

    _clearStorage() async {
      // await storage.clear();
      setState(() {
        // list.items = storage.getItem('questions') ?? [];
      });
    }

    _saveToStorage() {
      // storage.setItem('questions', list.toJSONEncodable());
    }

    var packOfQuestions = [
      {
        "id": 0,
        "question": "Kondisi gigi geligi anda saat ini",
        "option": [
          "Terpisah",
          "Berkontak ringan",
          "Berkontak erat",
          "Bergemeretak"
        ],
        "form": "radio"
      },
      {
        "id": 1,
        "question": "Kondisi otot wajah/rahang (?) anda saat ini",
        "option": [
          "Rileks",
          "Otot wajah/rahang tegang dan rahang terasa kencang tanpa ada gigi yang berkontak"
        ],
        "form": "radio"
      },
      {
        "id": 2,
        "question": "Apakah anda merasakan nyeri di daerah wajah",
        "option": ["Ya", "Tidak"],
        "form": "radio"
      },
      {
        "id": 3,
        "question": "Bila nyeri, berapa skala nyeri anda?",
        "option": 10,
        "form": "scale"
      }
    ];

    var packOfQuestions2 = [
      {
        "id": 0,
        "question": "Kondisi gigi geligi anda saat ini",
        "option": [
          "Terpisah",
          "Berkontak ringan",
          "Berkontak erat",
          "Bergemeretak"
        ],
        "form": "radio",
        "isOptional": "false"
      },
      {
        "id": 1,
        "question": "Kondisi otot wajah/rahang (?) anda saat ini",
        "option": [
          "Rileks",
          "Otot wajah/rahang tegang dan rahang terasa kencang tanpa ada gigi yang berkontak"
        ],
        "form": "radio",
        "isOptional": "false"
      },
      {
        "id": 2,
        "question": "Apakah anda merasakan nyeri di daerah wajah",
        "option": ["Ya", "Tidak"],
        "form": "radio",
        "isOptional": "false"
      },
      {
        "id": 3,
        "question":
            "Bila nyeri, berapa skala nyeri anda? 0 - tidak nyeri ;  10 - nyeri yang tidak tertahankan",
        "option": 5,
        "form": "scale",
        "isOptional": "false"
      },
      {
        "id": 4,
        "question": "Kondisi anda hari ini",
        "option": [
          "Merasa gugup atau tegang",
          "Sulit mengontrol kawatir",
          "Merasa sedih, depresi",
          "Merasa malas melakukan sesuatu"
        ],
        "form": "check",
        "isOptional": "yes"
      }
    ];
    var rng = Random();
    int rn = rng.nextInt(100);
    var chosenQuestion =
        packOfQuestions2; // rn % 2 == 0 ? packOfQuestions2 : packOfQuestions;
    var context = {
      "mode": mode,
      "ih": dt.hour,
      "im": dt.minute,
      "is": dt.second,
      "init": now.millisecondsSinceEpoch,
      "end": inputDate.millisecondsSinceEpoch,
      "date": dt.toIso8601String(),
      "timestamp": dt.millisecondsSinceEpoch,
      "status": "onSchedule",
      "question": "default question",
      "answer": "default answer",
      "listQuestions": chosenQuestion,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'genId': genId,
      'email': FirebaseAuth.instance.currentUser!.email,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'answerOn': 0
    };

    // Qitem context2 = {
    //   "mode": mode,
    //   "ih": dt.hour,
    //   "im": dt.minute,
    //   "isec": dt.second,
    //   "init": now.millisecondsSinceEpoch,
    //   "end": inputDate.millisecondsSinceEpoch,
    //   "date": dt.toIso8601String(),
    //   "timestamp": dt.millisecondsSinceEpoch,
    //   "status": "onSchedule",
    //   "question": "default question",
    //   "answer": "default answer",
    //   "listQuestions": chosenQuestion,
    //   'userId': FirebaseAuth.instance.currentUser!.uid,
    //   'genId': genId,
    //   'email': FirebaseAuth.instance.currentUser!.email,
    //   'name': FirebaseAuth.instance.currentUser!.displayName,
    //   'answerOn': 0
    // } as Qitem;

    // list.items.add(context2);

    FirebaseFirestore.instance
        .collection("questions")
        .doc(genId)
        // .doc('settings/' + FirebaseAuth.instance.currentUser!.uid)
        .set(context);

    // String? token = await FirebaseMessaging.instance.getAPNSToken();
    // print("token: ${token.toString()}");

///////////*Firebase message *//////////
    // sendPushMessage("Please change", context);
////////////////////////////////////////
    // _saveToStorage();

    await LocalNotifyManager.init().dailyAtTimeNotification(
        _id,
        mode,
        dt,
        jsonEncode(context),
        "Bruxism Notification",
        "Rate your pain, Jam $mode");
  }

  Future<void> startSessions(bool isActive, DateTime dt, bool repeat) async {
    if (loginStatus == "logout") {
      throw Exception('Must be logged in');
    } else {
      if (!repeat) {
        FirebaseFirestore.instance
            .collection("settings")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            // .doc('settings/' + FirebaseAuth.instance.currentUser!.uid)
            .set({
          'data': "",
          'active': isActive,
          'start': dt.toIso8601String(),
          'end': 0,
          'userId': FirebaseAuth.instance.currentUser!.uid,
        });
      }
    }
    print("hour: ${dt.hour} : ${dt.minute} : ${dt.second}");

    if (isActive) {
      int _id = 0;
      // var ndT = DateTime.utc(dt.year, dt.month, dt.day, 14);
      // saveSchedule(ndT, 14, 8888);

      if (dt.hour >= 21) {
        ///set next day for hours

        var nd9 = DateTime(dt.year, dt.month, dt.day + 1, 9, 0, 0);
        saveSchedule(nd9, 9, _id);
        _id++;

        print("next day: ${nd9.toIso8601String()}");
        var nd12 = DateTime(dt.year, dt.month, dt.day + 1, 12, 0, 0);
        saveSchedule(nd12, 12, _id);
        _id++;

        print("next day: ${nd12.toIso8601String()}");
        var nd15 = DateTime(dt.year, dt.month, dt.day + 1, 15, 0, 0);
        print("next day: ${nd15.toIso8601String()}");
        saveSchedule(nd15, 15, _id);
        _id++;

        var nd18 = DateTime(dt.year, dt.month, dt.day + 1, 18, 0, 0);
        print("next day: ${nd18.toIso8601String()}");
        saveSchedule(nd18, 18, _id);
        _id++;

        var nd21 = DateTime(dt.year, dt.month, dt.day + 1, 21, 0, 0);
        saveSchedule(nd21, 21, _id);
        _id++;

        print("next day: ${nd21.toIso8601String()}");
      } else {
        if (dt.hour < 9) {
          var nd9 = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
          saveSchedule(nd9, 9, _id);
          _id++;
          print("next day: ${nd9.toIso8601String()}");

          var nd12 = DateTime(dt.year, dt.month, dt.day, 12, 0, 0);
          saveSchedule(nd12, 12, _id);
          _id++;

          print("next day: ${nd12.toIso8601String()}");

          var nd15 = DateTime(dt.year, dt.month, dt.day, 15, 0, 0);
          saveSchedule(nd15, 15, _id);
          _id++;

          print("next day: ${nd15.toIso8601String()}");

          var nd18 = DateTime(dt.year, dt.month, dt.day, 18, 0, 0);
          saveSchedule(nd18, 18, _id);
          _id++;

          print("next day: ${nd18.toIso8601String()}");

          var nd21 = DateTime(dt.year, dt.month, dt.day, 21, 0, 0);
          saveSchedule(nd21, 21, _id);
          _id++;

          print("next day: ${nd21.toIso8601String()}");
        } else if (dt.hour >= 9 && dt.hour < 12) {
          var nd12 = DateTime(dt.year, dt.month, dt.day, 12, 0, 0);
          saveSchedule(nd12, 12, _id);
          _id++;

          print("next day: ${nd12.toIso8601String()}");

          var nd15 = DateTime(dt.year, dt.month, dt.day, 15, 0, 0);
          saveSchedule(nd15, 15, _id);
          _id++;

          print("next day: ${nd15.toIso8601String()}");

          var nd18 = DateTime(dt.year, dt.month, dt.day, 18, 0, 0);
          saveSchedule(nd18, 18, _id);
          _id++;

          print("next day: ${nd18.toIso8601String()}");

          var nd21 = DateTime(dt.year, dt.month, dt.day, 21, 0, 0);
          saveSchedule(nd21, 21, _id);
          _id++;

          print("next day: ${nd21.toIso8601String()}");

          ///schedule next day
          dt = dt.add(const Duration(days: 1));
          var nd9 = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
          saveSchedule(nd9, 9, _id);
          _id++;

          print("next day: ${nd9.toIso8601String()}");
        } else if (dt.hour >= 12 && dt.hour < 15) {
          var nd15 = DateTime(dt.year, dt.month, dt.day, 15, 0, 0);
          saveSchedule(nd15, 15, _id);
          _id++;

          print("next day: ${nd15.toIso8601String()}");

          var nd18 = DateTime(dt.year, dt.month, dt.day, 18, 0, 0);
          saveSchedule(nd18, 18, _id);
          _id++;

          print("next day: ${nd18.toIso8601String()}");

          var nd21 = DateTime(dt.year, dt.month, dt.day, 21, 0, 0);
          saveSchedule(nd21, 21, _id);
          _id++;

          print("next day: ${nd21.toIso8601String()}");

          ///schedule next day
          dt = dt.add(const Duration(days: 1));
          var nd9 = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
          saveSchedule(nd9, 9, _id);
          _id++;

          print("next day: ${nd9.toIso8601String()}");
          var nd12 = DateTime(dt.year, dt.month, dt.day, 12, 0, 0);
          saveSchedule(nd12, 12, _id);
          _id++;

          print("next day: ${nd12.toIso8601String()}");
        } else if (dt.hour >= 15 && dt.hour < 18) {
          var nd18 = DateTime(dt.year, dt.month, dt.day, 18, 0, 0);
          saveSchedule(nd18, 18, _id);
          _id++;

          print("next day: ${nd18.toIso8601String()}");

          var nd21 = DateTime(dt.year, dt.month, dt.day, 21, 0, 0);
          saveSchedule(nd21, 21, _id);
          _id++;

          print("next day: ${nd21.toIso8601String()}");

          ///schedule next day
          dt = dt.add(const Duration(days: 1));
          var nd9 = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
          saveSchedule(nd9, 9, _id);
          _id++;

          print("next day: ${nd9.toIso8601String()}");
          var nd12 = DateTime(dt.year, dt.month, dt.day, 12, 0, 0);
          saveSchedule(nd12, 12, _id);
          _id++;

          print("next day: ${nd12.toIso8601String()}");
          var nd15 = DateTime(dt.year, dt.month, dt.day, 15, 0, 0);
          saveSchedule(nd15, 15, _id);
          _id++;

          print("next day: ${nd15.toIso8601String()}");
        } else if (dt.hour >= 18 && dt.hour < 21) {
          var nd21 = DateTime(dt.year, dt.month, dt.day, 21, 0, 0);
          saveSchedule(nd21, 21, _id);
          _id++;

          print("next day: ${nd21.toIso8601String()}");

          ///schedule next day
          dt = dt.add(const Duration(days: 1));
          var nd9 = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
          saveSchedule(nd9, 9, _id);
          _id++;

          print("next day: ${nd9.toIso8601String()}");
          var nd12 = DateTime(dt.year, dt.month, dt.day, 12, 0, 0);
          saveSchedule(nd12, 12, _id);
          _id++;

          print("next day: ${nd12.toIso8601String()}");
          var nd15 = DateTime(dt.year, dt.month, dt.day, 15, 0, 0);
          saveSchedule(nd15, 15, _id);
          _id++;

          print("next day: ${nd15.toIso8601String()}");

          var nd18 = DateTime(dt.year, dt.month, dt.day, 18, 0, 0);
          saveSchedule(nd18, 18, _id);
          _id++;

          print("next day: ${nd18.toIso8601String()}");
        }
      }
    } else {
      localNotifyManager.cancelAllScheduled();
      // LocalStorage storage = LocalStorage("questions");
      // storage.clear();
      // storage.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    // signOut();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // print('User is currently signed out!');
        selectPage(3);
        loginStatus = "logout";
      } else {
        selectPage(0);
        loginStatus = "loggedIn";
      }
    });
    // initFB();
    // startSchedule();

    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(ReceivedNotification notification) {
    print('Notification Received: ${notification.id}');
  }

  onNotificationClick(String? payload) {
    print('Payload xxx ::::: $payload');
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return SecondScreen(
            id: payload as String,
            description: "",
            title: "Bruxism",
            selectPage: selectPage);
      },
    ));
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  int i = 0;
  void setSwitch(bool s) {
    setState(() {
      isSwitched = s;

      var now = DateTime.now();
      // var now2 = DateTime.utc(now.year, now.month, now.day, 15);

      // startSessions(isSwitched, now, false);
      // print("WWWWWWW");
      startSessions_test(isSwitched, now, false);
    });
  }

  Future<bool> readSettings() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    var e = await FirebaseFirestore.instance
        .collection('settings')
        .where("userId", isEqualTo: id)
        .get();

    return e.docs.isNotEmpty ? e.docs[0]["active"] as bool : false;
  }

  @override
  Widget build(BuildContext context) {
    switch (_pageMode) {
      case 0:
        return Scaffold(
            persistentFooterButtons: <Widget>[
              IconButton(
                  icon: const Icon(Icons.logout), onPressed: () => signOut()),
            ],
            body: Center(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.asset("assets/images/bg.png").image,
                      fit: BoxFit.cover),
                ),
                child: GlassmorphicContainer(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.9,
                  borderRadius: 0,
                  blur: 7,
                  alignment: Alignment.bottomCenter,
                  border: 0,
                  linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFF75035).withAlpha(55),
                        const Color(0xFFffffff).withAlpha(45),
                      ],
                      stops: const [
                        0.3,
                        1
                      ]),
                  borderGradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        const Color(0xFF4579C5).withAlpha(100),
                        const Color(0xFFffffff).withAlpha(55),
                        const Color(0xFFF75035).withAlpha(10),
                      ],
                      stops: const [
                        0.06,
                        0.95,
                        1
                      ]),
                  child: Column(children: [
                    Expanded(
                        flex: 1,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.3 * 70,
                              left: 40,
                              child: Container(
                                width: 100,
                                height: 100.0,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFBC1642),
                                      Color(0xFFCB5AC6),
                                    ])),
                              ),
                            ),
                            Positioned(
                              bottom: 50,
                              left: 30,
                              child: Container(
                                width: 80,
                                height: 40,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFFDFC47),
                                      Color(0xFF24FE41),
                                    ])),
                              ),
                            ),
                            Column(children: [
                              SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width),
                              GlassmorphicContainer(
                                width: MediaQuery.of(context).size.width * 0.9 -
                                    20,
                                height:
                                    MediaQuery.of(context).size.height * 0.7 -
                                        20,
                                borderRadius: 35,
                                margin: const EdgeInsets.all(10),
                                blur: 10,
                                alignment: Alignment.bottomCenter,
                                border: 2,
                                linearGradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFFFFFFF).withAlpha(0),
                                      const Color(0xFFFFFFFF).withAlpha(0),
                                    ],
                                    stops: const [
                                      0.3,
                                      1,
                                    ]),
                                borderGradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFFFFFFF).withAlpha(01),
                                      const Color(0xFFFFFFFF).withAlpha(100),
                                      const Color(0xFFFFFFFF).withAlpha(01),
                                    ],
                                    stops: const [
                                      0.2,
                                      0.9,
                                      1
                                    ]),
                                child: GridView.count(
                                    primary: false,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3,
                                    crossAxisCount: 1,
                                    children: <Widget>[
                                      GlassContainer(
                                        height: 200,
                                        width: 200,
                                        blur: 4,
                                        color: Colors.white.withOpacity(0.7),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.2),
                                            Colors.blue.withOpacity(0.3),
                                          ],
                                        ),
                                        //--code to remove border
                                        border: const Border.fromBorderSide(
                                            BorderSide.none),
                                        shadowStrength: 5,
                                        shape: BoxShape.circle,
                                        borderRadius: BorderRadius.circular(16),
                                        shadowColor:
                                            Colors.white.withOpacity(0.24),
                                        child: SlideSchedule(
                                            getStatus: () => readSettings(),
                                            setSwitch: setSwitch),
                                      ),

                                      // GlassContainer(
                                      //     height: 200,
                                      //     width: 200,
                                      //     blur: 4,
                                      //     color: Colors.white.withOpacity(0.7),
                                      //     gradient: LinearGradient(
                                      //       begin: Alignment.topLeft,
                                      //       end: Alignment.bottomRight,
                                      //       colors: [
                                      //         Colors.white.withOpacity(0.2),
                                      //         Colors.blue.withOpacity(0.3),
                                      //       ],
                                      //     ),
                                      //     //--code to remove border
                                      //     border: const Border.fromBorderSide(
                                      //         BorderSide.none),
                                      //     shadowStrength: 5,
                                      //     shape: BoxShape.rectangle,
                                      //     borderRadius: BorderRadius.circular(16),
                                      //     shadowColor: Colors.white.withOpacity(0.24),
                                      //     child: TextButton(
                                      //         onPressed:
                                      //             _checkPendingNotificationRequests,
                                      //         child: const Text(
                                      //           "Pending Notification",
                                      //           style: TextStyle(fontSize: 12),
                                      //         ))),

                                      // GlassContainer(
                                      //     height: 200,
                                      //     width: 200,
                                      //     blur: 4,
                                      //     color: Colors.white.withOpacity(0.7),
                                      //     gradient: LinearGradient(
                                      //       begin: Alignment.topLeft,
                                      //       end: Alignment.bottomRight,
                                      //       colors: [
                                      //         Colors.white.withOpacity(0.2),
                                      //         Colors.blue.withOpacity(0.3),
                                      //       ],
                                      //     ),
                                      //     //--code to remove border
                                      //     border: const Border.fromBorderSide(
                                      //         BorderSide.none),
                                      //     shadowStrength: 5,
                                      //     shape: BoxShape.rectangle,
                                      //     borderRadius: BorderRadius.circular(16),
                                      //     shadowColor: Colors.white.withOpacity(0.24),
                                      //     child: TextButton(
                                      //         onPressed:
                                      //             _startForegroundServiceWithBlueBackgroundNotification,
                                      //         child: const Text(
                                      //           "Active Notification",
                                      //           style: TextStyle(fontSize: 12),
                                      //         ))),
                                      const Padding(
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            "Ver. 17\n\nNote:\n\nTurn the slider On will get\nnotification",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'roboto'),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 6,
                                          )),

                                      // const Center(
                                      //   child: Padding(
                                      //       padding: EdgeInsets.only(left: 30),
                                      //       child: Text(
                                      //         "Ver. 17",
                                      //         style: TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 30),
                                      //       )),
                                      // ),

                                      // GlassContainer(
                                      //     height: 200,
                                      //     width: 200,
                                      //     blur: 4,
                                      //     color: Colors.white.withOpacity(0.7),
                                      //     gradient: LinearGradient(
                                      //       begin: Alignment.topLeft,
                                      //       end: Alignment.bottomRight,
                                      //       colors: [
                                      //         Colors.white.withOpacity(0.2),
                                      //         Colors.blue.withOpacity(0.3),
                                      //       ],
                                      //     ),
                                      //     //--code to remove border
                                      //     border: const Border.fromBorderSide(
                                      //         BorderSide.none),
                                      //     shadowStrength: 5,
                                      //     shape: BoxShape.rectangle,
                                      //     borderRadius: BorderRadius.circular(16),
                                      //     shadowColor: Colors.white.withOpacity(0.24),
                                      //     child: Flex(
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceBetween,
                                      //       direction: Axis.horizontal,
                                      //       children: const [
                                      //         // Padding(
                                      //         //   padding: const EdgeInsets.only(
                                      //         //       top: 35.0, left: 20.0),
                                      //         //   child: BackButton(
                                      //         //       color: Colors.white,
                                      //         //       onPressed: () => _selectPage(0)),
                                      //         // ),
                                      //         Center(
                                      //           child: Padding(
                                      //               padding: EdgeInsets.only(left: 30),
                                      //               child: Text(
                                      //                 "version 14",
                                      //                 style: TextStyle(
                                      //                     color: Colors.white),
                                      //               )),
                                      //         ),
                                      //       ],
                                      //     )),

                                      // TextButton(
                                      //     onPressed: () async {
                                      //       // await localNotifyManager.showNotification();
                                      //       // await localNotifyManager.repeatNotification();

                                      //       var now = DateTime.now();
                                      //       var dt = DateTime.now();
                                      //       var mode = 9;
                                      //       var inputFormat =
                                      //           DateFormat('dd/MM/yyyy HH:mm');
                                      //       var inputDate = inputFormat.parse(
                                      //           '${dt.day}/${dt.month}/${dt.year} ${mode.toString()}:00'); // <-- dd/MM 24H format

                                      //       var genId =
                                      //           "${dt.year}-${dt.month}-${dt.day}-${mode.toString()}-${FirebaseAuth.instance.currentUser!.uid}";

                                      //       var packOfQuestions = [
                                      //         {
                                      //           "id": 0,
                                      //           "question":
                                      //               "Kondisi gigi geligi anda saat ini",
                                      //           "option": [
                                      //             "Terpisah",
                                      //             "Berkontak ringan",
                                      //             "Berkontak erat",
                                      //             "Bergemeretak"
                                      //           ],
                                      //           "form": "radio"
                                      //         },
                                      //         {
                                      //           "id": 1,
                                      //           "question":
                                      //               "Kondisi otot wajah/rahang (?) anda saat ini",
                                      //           "option": [
                                      //             "Rileks",
                                      //             "Otot wajah/rahang tegang dan rahang terasa kencang tanpa ada gigi yang berkontak"
                                      //           ],
                                      //           "form": "radio"
                                      //         },
                                      //         {
                                      //           "id": 2,
                                      //           "question":
                                      //               "Apakah anda merasakan nyeri di daerah wajah",
                                      //           "option": ["Ya", "Tidak"],
                                      //           "form": "radio"
                                      //         },
                                      //         {
                                      //           "id": 3,
                                      //           "question":
                                      //               "Bila nyeri, berapa skala nyeri anda?",
                                      //           "option": 5,
                                      //           "form": "scale"
                                      //         }
                                      //       ];

                                      //       var packOfQuestions2 = [
                                      //         {
                                      //           "id": 0,
                                      //           "question":
                                      //               "Kondisi gigi geligi anda saat ini",
                                      //           "option": [
                                      //             "Terpisah",
                                      //             "Berkontak ringan",
                                      //             "Berkontak erat",
                                      //             "Bergemeretak"
                                      //           ],
                                      //           "form": "radio"
                                      //         },
                                      //         {
                                      //           "id": 1,
                                      //           "question":
                                      //               "Kondisi otot wajah/rahang (?) anda saat ini",
                                      //           "option": [
                                      //             "Rileks",
                                      //             "Otot wajah/rahang tegang dan rahang terasa kencang tanpa ada gigi yang berkontak"
                                      //           ],
                                      //           "form": "radio"
                                      //         },
                                      //         {
                                      //           "id": 2,
                                      //           "question":
                                      //               "Apakah anda merasakan nyeri di daerah wajah",
                                      //           "option": ["Ya", "Tidak"],
                                      //           "form": "radio"
                                      //         },
                                      //         {
                                      //           "id": 3,
                                      //           "question": "Kondisi anda hari ini",
                                      //           "option": [
                                      //             "Merasa gugup atau tegang",
                                      //             "Sulit mengontrol kawatir",
                                      //             "Merasa sedih, depresi",
                                      //             "Merasa malas melakukan sesuatu"
                                      //           ],
                                      //           "form": "check"
                                      //         }
                                      //       ];
                                      //       var rng = Random();
                                      //       int rn = rng.nextInt(100);
                                      //       var chosenQuestion = rn % 2 == 0
                                      //           ? packOfQuestions2
                                      //           : packOfQuestions;

                                      //       var contextz = {
                                      //         "mode": mode,
                                      //         "ih": dt.hour,
                                      //         "im": dt.minute,
                                      //         "is": dt.second,
                                      //         "init": now.millisecondsSinceEpoch,
                                      //         "end": inputDate.millisecondsSinceEpoch,
                                      //         "date": dt.toIso8601String(),
                                      //         "timestamp": dt.millisecondsSinceEpoch,
                                      //         "status": "onSchedule",
                                      //         "question": "default question",
                                      //         "answer": "default answer",
                                      //         "listQuestions": chosenQuestion,
                                      //         'userId': FirebaseAuth
                                      //             .instance.currentUser!.uid,
                                      //         'genId': genId,
                                      //         'email': FirebaseAuth
                                      //             .instance.currentUser!.email,
                                      //         'name': FirebaseAuth
                                      //             .instance.currentUser!.displayName
                                      //       };

                                      //       await LocalNotifyManager.init()
                                      //           .dailyAtTimeNotification2(
                                      //               999,
                                      //               21,
                                      //               tz.TZDateTime.now(tz.local).add(
                                      //                   const Duration(seconds: 5)),
                                      //               jsonEncode(contextz),
                                      //               "Bruxism Notification",
                                      //               "Rate your pain 1-10");

                                      //       sendPushMessage("Please change", contextz);
                                      //     },
                                      //     child: const Text("Notification")),

                                      // TextButton(
                                      //     onPressed: () {
                                      //       Navigator.push(context, MaterialPageRoute(
                                      //         builder: (context) {
                                      //           return const ViewAlerts();
                                      //         },
                                      //       ));
                                      //     },
                                      //     child: const Text("View")),
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(25),
                                      //   child: BackdropFilter(
                                      //     filter:
                                      //         ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                      //     child: Container(
                                      //       height: 250,
                                      //       width: 350,
                                      //       decoration: BoxDecoration(
                                      //           borderRadius: BorderRadius.circular(25),
                                      //           color: Colors.black45),
                                      //       child: TextButton(
                                      //           onPressed: () {
                                      //             var storage =
                                      //                 LocalStorage("questions");
                                      //             storage.clear();
                                      //           },
                                      //           child: const Text("CLEAR")),
                                      //     ),
                                      //   ),
                                      // ),

                                      // Container(
                                      //   padding: const EdgeInsets.all(10.0),
                                      //   constraints: const BoxConstraints.expand(),
                                      //   child: FutureBuilder(
                                      //       future: storage.ready,
                                      //       builder: (BuildContext context,
                                      //           AsyncSnapshot snapshot) {
                                      //         if (snapshot.data == null) {
                                      //           return const Center(
                                      //             child: CircularProgressIndicator(),
                                      //           );
                                      //         }
                                      //         if (!initialized) {
                                      //           var items = storage
                                      //               .getItem("initial_date_time");
                                      //           if (items != null) {
                                      //             return Text(DateFormat(
                                      //                     'MM/dd/yyyy hh:mm a')
                                      //                 .format(DateTime
                                      //                     .fromMillisecondsSinceEpoch(
                                      //                         items)));
                                      //           }
                                      //           initialized = true;
                                      //         }
                                      //         return const Text("Wwww");
                                      //       }),
                                      // )
                                    ]),
                              )
                            ]),
                          ],
                        ))
                  ]),
                ),
              ),
            ));

      case 1:
        return Scaffold(
            // appBar: AppBar(
            //   // Here we take the value from the MyHomePage object that was created by
            //   // the App.build method, and use it to set our appbar title.
            //   title: Text(widget.title),
            // ),
            body: Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset("assets/images/bg.png").image,
                  fit: BoxFit.cover),
            ),
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              borderRadius: 0,
              blur: 7,
              alignment: Alignment.bottomCenter,
              border: 0,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFF75035).withAlpha(55),
                    const Color(0xFFffffff).withAlpha(45),
                  ],
                  stops: const [
                    0.3,
                    1
                  ]),
              borderGradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    const Color(0xFF4579C5).withAlpha(100),
                    const Color(0xFFffffff).withAlpha(55),
                    const Color(0xFFF75035).withAlpha(10),
                  ],
                  stops: const [
                    0.06,
                    0.95,
                    1
                  ]),
              child: Column(children: [
                Expanded(
                    child: Stack(
                  children: [
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.3 * 70,
                      left: 40,
                      child: Container(
                        width: 100,
                        height: 100.0,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
                              Color(0xFFBC1642),
                              Color(0xFFCB5AC6),
                            ])),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 30,
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            gradient: LinearGradient(colors: [
                              Color(0xFFFDFC47),
                              Color(0xFF24FE41),
                            ])),
                      ),
                    ),
                    Column(children: [
                      SizedBox(
                          height: 30, width: MediaQuery.of(context).size.width),
                      GlassmorphicContainer(
                        width: MediaQuery.of(context).size.width * 0.9 - 20,
                        height: MediaQuery.of(context).size.height * 0.6 - 20,
                        borderRadius: 35,
                        margin: const EdgeInsets.all(10),
                        blur: 10,
                        alignment: Alignment.bottomCenter,
                        border: 2,
                        linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFFFFFF).withAlpha(0),
                              const Color(0xFFFFFFFF).withAlpha(0),
                            ],
                            stops: const [
                              0.3,
                              1,
                            ]),
                        borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFFFFFF).withAlpha(01),
                              const Color(0xFFFFFFFF).withAlpha(100),
                              const Color(0xFFFFFFFF).withAlpha(01),
                            ],
                            stops: const [
                              0.2,
                              0.9,
                              1
                            ]),
                        child: GridView.count(
                            primary: false,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20),
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: 2,
                            children: <Widget>[
                              GlassContainer(
                                height: 200,
                                width: 200,
                                blur: 4,
                                color: Colors.white.withOpacity(0.7),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.blue.withOpacity(0.3),
                                  ],
                                ),
                                //--code to remove border
                                border: const Border.fromBorderSide(
                                    BorderSide.none),
                                shadowStrength: 5,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                                shadowColor: Colors.white.withOpacity(0.24),
                                child: InkWell(
                                    onTap: (() => selectPage(1)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            selectPage(0);
                                          },
                                          icon: const Icon(Icons.view_agenda,
                                              color: Colors.white, size: 45),
                                        ),
                                        const InkWell(
                                          child: Center(
                                              child: Padding(
                                            padding: EdgeInsets.only(top: 30),
                                            child: Text(
                                              "Your Alert ",
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  color: Colors.white30),
                                            ),
                                          )),
                                        ),
                                      ],
                                    )),
                              ),
                              GlassContainer(
                                height: 200,
                                width: 200,
                                blur: 4,
                                color: Colors.white.withOpacity(0.7),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.blue.withOpacity(0.3),
                                  ],
                                ),
                                //--code to remove border
                                border: const Border.fromBorderSide(
                                    BorderSide.none),
                                shadowStrength: 5,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                                shadowColor: Colors.white.withOpacity(0.24),
                                child: InkWell(
                                    onTap: (() => selectPage(1)),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.wysiwyg,
                                            color: Colors.white,
                                            size: 45,
                                          ),
                                          onPressed: () => signOut(),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        const Text(
                                          "Sign Out",
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.white24),
                                        )
                                      ],
                                    )),
                              ),
                            ]),
                      )
                    ]),
                  ],
                ))
              ]),
            ),
          ),
        ));
      case 3:
        return Scaffold(
            // appBar: AppBar(
            //   title: const Text("Login"),
            // ),
            // resizeToAvoidBottomInset: false,
            body: Center(
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.asset("assets/images/bg.png").image,
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        PasswordForm(
                          email: "",
                          login: (email, password) {
                            signInWithEmailAndPassword2(
                                email,
                                password,
                                (e) => showErrorDialog(
                                    context, 'Failed to sign in', e));
                          },
                          selectPage: selectPage,
                        ),
                      ],
                    ))));

      case 4:
        return GlassContainer(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            blur: 4,
            color: Colors.white.withOpacity(0.7),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.blue.withOpacity(0.3),
              ],
            ),
            //--code to remove border
            border: const Border.fromBorderSide(BorderSide.none),
            shadowStrength: 5,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.white.withOpacity(0.24),
            child: Scaffold(
                body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset("assets/images/bg.png").image,
                    fit: BoxFit.cover),
              ),
              child: RegisterForm(
                email: "",
                cancel: () {
                  cancelRegistration();
                },
                registerAccount: (
                  email,
                  displayName,
                  password,
                ) {
                  registerAccount(
                      email,
                      displayName,
                      password,
                      (e) => showErrorDialog(
                          context, 'Failed to create account', e));
                },
              ),
            )));

      default:
        return Scaffold(
          appBar: AppBar(title: const Text("test 55555")),
          body: const Text("tst"),
        );
    }
  }

  void registerAccount(String email, String displayName, String password,
      Function(dynamic e) param3) {}
}
