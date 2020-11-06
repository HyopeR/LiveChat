import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CombineGestureWidget extends StatelessWidget {

  final VoidCallback onLongPressStart;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressEnd;
  final Widget child;

  const CombineGestureWidget({
    Key key,
    this.onLongPressStart,
    this.onLongPress,
    this.onLongPressEnd,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<
            AllowMultipleGestureRecognizer>(
              () => AllowMultipleGestureRecognizer(),
              (AllowMultipleGestureRecognizer instance) {

            instance.onLongPressStart = (value) => onLongPressStart();
            instance.onLongPress = () => onLongPress();
            instance.onLongPressEnd = (value) => onLongPressEnd();

          },
        )
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

// Custom Gesture Recognizer.
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
class AllowMultipleGestureRecognizer extends LongPressGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}