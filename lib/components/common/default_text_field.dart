import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  final void Function(String) onChanged;
  const DefaultTextField({Key key, this.onChanged}) : super(key: key);

  @override
  DefaultTextFieldState createState() => DefaultTextFieldState();
}

class DefaultTextFieldState extends State<DefaultTextField> {
  TextEditingController controller;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onChanged: widget.onChanged,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.white),
        hintText: 'Başlık ekleyin...',
        border: InputBorder.none,
        // isDense: true,
      ),
    );
  }
}