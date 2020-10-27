import 'package:get_it/get_it.dart';
import 'package:live_chat/repositories/user_repository.dart';
import 'package:live_chat/services/firebase_auth_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
}
