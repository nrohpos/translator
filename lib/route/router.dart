import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:translator/pages/Home/home_page.dart';
import 'package:translator/pages/language/language_page.dart';

appRoutes() => [
  GetPage(
    name: '/home',
    page: () => const HomePage(title: "Translate"),
  ),
  GetPage(
    name: '/',
    page: () => const LanguagePage(),
  ),
];