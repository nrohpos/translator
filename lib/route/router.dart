import 'package:get/get_navigation/src/routes/get_route.dart';

import '../pages/home/language_page.dart';

appRoutes() => [
      GetPage(
        name: '/',
        page: () => const LanguagePage(),
      ),
    ];
