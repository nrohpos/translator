import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:translator/db/database_helper.dart';
import 'package:translator/route/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.shared.openConnectionDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Translator',
      initialRoute: '/',
      getPages: appRoutes(),
    );
  }
}
