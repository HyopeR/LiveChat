import 'package:get_it/get_it.dart';
import 'package:live_chat/repositories/chat_repository.dart';
import 'package:live_chat/repositories/user_repository.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:live_chat/services/firebase_storage_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';
import 'package:live_chat/services/voice_record_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FireStoreDbService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => VoiceRecordService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => ChatRepository());
}
