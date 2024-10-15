import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/views/HalamanLogin/login_page.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
    ),
  ];
}
