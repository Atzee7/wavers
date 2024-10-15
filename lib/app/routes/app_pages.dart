import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/views/HalamanLogin/login_page.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/edit_profile_page.dart';
import 'package:sosmed/app/modules/home/bindings/edit_profile_binding.dart';
part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: '/editProfile',
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
  ];
}
