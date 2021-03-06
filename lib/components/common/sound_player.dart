import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/services/operation_service.dart';

// ignore: must_be_immutable
class SoundPlayer extends StatefulWidget {
  String soundUrl;
  String soundType;
  double soundDuration;
  String imageUrl;

  SoundPlayer.voice(
      {Key key,
      this.soundUrl,
      this.soundType = 'Voice',
      this.soundDuration,
      this.imageUrl})
      : super(key: key);

  SoundPlayer.song(
      {Key key,
      this.soundUrl,
      this.soundType = 'Song',
      this.soundDuration,
      this.imageUrl = 'https://img.webme.com/pic/c/creative-blog/song.png'})
      : super(key: key);

  @override
  _SoundPlayerState createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();

  double currentDuration = 0;
  bool currentState = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        currentDuration = event.inSeconds.toDouble();
      });
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        currentDuration = 0;
        currentState = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerRow(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ImageWidget(
          image: NetworkImage(widget.imageUrl),
          imageWidth: 55,
          imageHeight: 55,
          backgroundShape: BoxShape.circle,
          backgroundColor: Colors.grey.withOpacity(0.3),
        ),
        Expanded(
          child: Stack(
            children: [
              Slider(
                activeColor: Colors.black,
                inactiveColor: Colors.black26,
                value: currentDuration,
                onChanged: (value) {
                  setState(() {
                    currentDuration = value;
                  });
                },
                divisions: widget.soundDuration.toInt(),
                max: widget.soundDuration,
                min: 0.0,
              ),
              Positioned(
                  right: 25,
                  bottom: 0,
                  child: Text(currentState ? calculateTimer(currentDuration.toInt()) : calculateTimer(widget.soundDuration.toInt()))
              )
            ],
          ),
        ),
        Container(
            child: IconButton(
              splashRadius: 18,
              icon: Icon(!currentState ? Icons.play_arrow : Icons.pause),
              iconSize: 36,
              onPressed: () => !currentState ? play() : pause(),
           )
        )
      ],
    );
  }

  void play() async {
    // await audioPlayer.release();
    audioPlayer.play(widget.soundUrl, isLocal: false, position: Duration(seconds: currentDuration.toInt()));
    setState(() {
      currentState = true;
    });
  }

  void pause() async {
    audioPlayer.pause();
    setState(() {
      currentState = false;
    });
  }

// void resume() async{
//   await audioPlayer.resume();
// }
//
// void stop() async{
//   await audioPlayer.stop();
// }
//
// void release() async{
//   await audioPlayer.release();
// }
}
