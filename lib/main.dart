import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:offline_first/src/app.dart';
import 'package:offline_first/src/data/models/box_container_model.dart';
import 'package:offline_first/src/data/models/item_container_model.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await initHive();
  runApp(const StarterApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ItemContainerModelAdapter());
  Hive.registerAdapter(BoxContainerModelAdapter());
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
