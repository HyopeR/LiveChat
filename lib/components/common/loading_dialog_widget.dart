import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:live_chat/components/common/container_column.dart';

class LoadingDialogWidget extends StatelessWidget {

  final String operationDetail;
  const LoadingDialogWidget({Key key, this.operationDetail}) : super(key: key);

  Future<bool> show(BuildContext context) async {
    return await showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (context) => this
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      content: ContainerColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(operationDetail),
        ],
      ),
    );
  }

}