import 'dart:io';

abstract class StorageBase {

  Future<String> uploadProfilePhoto(String userId, String fileType, File file);
  Future<String> uploadVoiceNote(String groupId, String fileType, File file);
  Future<String> uploadImage(String groupId, String fileType, File file);

}