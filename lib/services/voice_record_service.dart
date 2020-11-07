import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';


class VoiceRecordService {

  final LocalFileSystem _localFileSystem = LocalFileSystem();
  Recording _recording;
  bool isRecording = false;
  File voiceFile;
  String currentPath;

  void recordStart() async {

    try {
      if (await AudioRecorder.hasPermissions) {

        await AudioRecorder.start();
        bool stateRecord = await AudioRecorder.isRecording;

        _recording = Recording(duration: Duration(), path: '');
        isRecording = stateRecord;

      } else {
        print('Record Start: AudioRecorder.hasPermissions Error');
      }
    } catch (err) {
      print('recordStart Error: ${err.toString()}');
    }
  }

  Future<String> recordStop() async {
    var recording = await AudioRecorder.stop();

    bool stateRecord = await AudioRecorder.isRecording;
    currentPath = recording.path;
    voiceFile = _localFileSystem.file(currentPath);

    // print("  File length: ${await file.length()}");
    _recording = recording;
    isRecording = stateRecord;

    return currentPath;
  }

  Future<bool> clearStorage() async {
    try{
      await _localFileSystem.file(currentPath).delete();
      currentPath = null;
      voiceFile = null;
      return true;
    }catch(err) {
      print('storageClear Error: ${err.toString()}');
      return false;
    }

  }

}