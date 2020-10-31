import 'package:get_it/get_it.dart';
import 'package:live_chat/repositories/user_repository.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';
import 'package:live_chat/services/navigation_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FireStoreDbService());
  locator.registerLazySingleton(() => UserRepository());
}
