import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:translator/pages/import/import_page.dart';

import '../pages/home/language_page.dart';

appRoutes() => [
      GetPage(
        name: '/language',
        page: () => const LanguagePage(),
      ),GetPage(
        name: '/',
        page: () => const ImportPage(),
      ),
    ];
