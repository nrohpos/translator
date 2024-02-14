import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:translator/pages/import/import_page.dart';

import '../pages/home/language_page.dart';

appRoutes() => [
      GetPage(
        name: '/',
        page: () => const LanguagePage(),
      ),GetPage(
        name: '/import',
        page: () => const ImportPage(),
      ),
    ];
