import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';


class VoiceRecordService {

  final LocalFileSystem _localFileSystem = LocalFileSystem();
  Recording _recording;
  bool _isRecording = false;
  String _currentPath;

  void recordStart() async {

    try {
      if (await AudioRecorder.hasPermissions) {

        await AudioRecorder.start();
        bool isRecording = await AudioRecorder.isRecording;

        _recording = Recording(duration: Duration(), path: '');
        _isRecording = isRecording;

      } else {
        print('Record Start: AudioRecorder.hasPermissions Error');
      }
    } catch (err) {
      print('recordStart Error: ${err.toString()}');
    }
  }

  Future<File> recordStop() async {
    var recording = await AudioRecorder.stop();

    bool isRecording = await AudioRecorder.isRecording;
    _currentPath = recording.path;

    File file = _localFileSystem.file(_currentPath);

    // print("  File length: ${await file.length()}");
    _recording = recording;
    _isRecording = isRecording;

    return file;
  }

  Future<bool> clearStorage() async {
    try{
      await _localFileSystem.file(_currentPath).delete();
      _currentPath = null;
      return true;
    }catch(err) {
      print('storageClear Error: ${err.toString()}');
      return false;
    }

  }

}