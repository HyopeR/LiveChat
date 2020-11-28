import 'dart:io';
import 'package:flutter/material.dart';
import 'package:live_chat/components/common/zoomable_widget.dart';

class FilePreview extends StatefulWidget {

  final int currentPage;
  final VoidCallback onPageChange;
  final List<File> itemList;

  const FilePreview({
    Key key,
    this.currentPage,
    this.onPageChange,
    this.itemList
  }) : super(key: key);


  @override
  FilePreviewState createState() => FilePreviewState();
}

class FilePreviewState extends State<FilePreview> {
  PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    if(widget.currentPage != null)
      currentPage = widget.currentPage;

    pageController = PageController(initialPage: currentPage, keepPage: true, viewportFraction: 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // void addItem(File file) {
  //   setState(() {
  //     itemList.add(file);
  //   });
  // }
  //
  // void deleteItem(int index) {
  //   setState(() {
  //     itemList.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.amber
      ),
      child: Material(
        color: Colors.black,
        elevation: 0,
        child: PageView.builder(
          /// Yatay olarak kayma işlemi
          scrollDirection: Axis.horizontal,
          controller: pageController,


          /// Ufak hareketlerle sayfa değişsinmi yoksa sürüklendiği kadarıyla dursunmu?
          pageSnapping: true,

          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });

            widget.onPageChange();
          },

          itemCount: widget.itemList.length,
          itemBuilder: (context, index) {
            return createItem(index);
          },
        ),
      ),
    );
  }


  createItem(int index) {
    return ZoomableWidget(
      panEnabled: true,
      minScale: 1,
      maxScale: 4,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: FileImage(widget.itemList[index]),
              // image: NetworkImage(attachFiles[0]),
              fit: BoxFit.contain,
            )
        ),
      ),
    );
  }
}