import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:translator/pages/Home/home_page.dart';
import 'package:translator/pages/language/language_page.dart';

appRoutes() => [
      GetPage(
        name: '/home',
        page: () => const HomePage(),
      ),
      GetPage(
        name: '/',
        page: () => const LanguagePage(),
      ),
    ];
