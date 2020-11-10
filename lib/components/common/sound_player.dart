import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';

class SoundPlayer extends StatefulWidget {
  String soundUrl;
  String soundType;
  double soundDuration;
  String imageUrl;

  SoundPlayer.voice({
    Key key,
    this.soundUrl,
    this.soundType = 'Voice',
    this.soundDuration,
    this.imageUrl
  }) : super(key: key);

  SoundPlayer.song({
    Key key,
    this.soundUrl,
    this.soundType = 'Song',
    this.soundDuration,
    this.imageUrl = 'https://img.webme.com/pic/c/creative-blog/song.png'
  }) : super(key: key);

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
          imageUrl: widget.imageUrl,
          imageWidth: 75,
          imageHeight: 75,
          backgroundShape: BoxShape.circle,
          backgroundColor: Colors.grey.withOpacity(0.3),
        ),

        Stack(
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
              child: Text(calculateTimer(currentDuration.toInt()))
            )
          ],
        ),

        Container(
          child: !currentState
              ?
                IconButton(
                  splashRadius: 32,
                  icon: Icon(Icons.play_arrow),
                  iconSize: 44,
                  onPressed: () => play(),
                )
              :
                IconButton(
                  splashRadius: 32,
                  icon: Icon(Icons.pause),
                  iconSize: 44,
                  onPressed: () => pause(),
                )
              )
      ],
    );
  }

  void play() async{
    await audioPlayer.release();
    audioPlayer.play(widget.soundUrl, isLocal: false, position: Duration(seconds: currentDuration.toInt()));
    setState(() {
      currentState = true;
    });
  }

  void pause() async{
    audioPlayer.pause();
    setState(() {
      currentState = false;
    });
  }

  String calculateTimer(int time) {
    if (time < 60) {
      String secondStr = (time % 60).toString().padLeft(2, '0');
      return '00 : $secondStr';
    } else {
      int remainingSecond = time % 60;
      String secondStr = (remainingSecond % 60).toString().padLeft(2, '0');

      int minutes = (time / 60).truncate();
      String minutesStr = (minutes % 60).toString().padLeft(2, '0');

      return '$minutesStr : $secondStr';
    }
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
