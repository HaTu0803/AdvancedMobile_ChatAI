import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasource/authentication_datasource.dart';
import '../data/repository/authentication_repository.dart';

var locator = GetIt.instance;

Future<void> getItInit() async {
  await _initComponents();
  await _initDatasoruces();
  _initRepositories();
}

Future<void> _initComponents() async {
  locator.registerSingleton<http.Client>(
      http.Client()); // Sử dụng http thay cho Dio
  locator.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
}

Future<void> _initDatasoruces() async {
  locator
      .registerFactory<IAuthenticationDatasource>(() => AuthenticationRemote());
}

void _initRepositories() {
  locator.registerFactory<IAuthRepository>(() => AuthenticationRepository());
}
