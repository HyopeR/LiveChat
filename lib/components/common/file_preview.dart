import 'dart:io';
import 'package:flutter/material.dart';

class FilePreview extends StatefulWidget {

  final VoidCallback onPageChange;

  const FilePreview({
    Key key,
    this.onPageChange
  }) : super(key: key);


  @override
  FilePreviewState createState() => FilePreviewState();
}

class FilePreviewState extends State<FilePreview> {
  PageController pageController;
  int currentPage = 0;

  List<File> itemList = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void addItem(File file) {
    setState(() {
      itemList.add(file);
    });
  }

  void deleteItem(int index) {
    setState(() {
      itemList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: PageView.builder(
        /// Yatay olarak kayma işlemi
        scrollDirection: Axis.horizontal,
        controller: pageController,


        /// Ufak hareketlerle sayfa değişsinmi yoksa sürüklendiği kadarıyla dursunmu?
        pageSnapping: false,

        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });

          widget.onPageChange();
        },

        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return createItem(index);
        },
      ),
    );
  }


  createItem(int index) {
    return InteractiveViewer(
      panEnabled: true,
      minScale: 1,
      maxScale: 4,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: FileImage(itemList[index]),
              // image: NetworkImage(attachFiles[0]),
              fit: BoxFit.contain,
            )
        ),
      ),
    );
  }
}




// ListView(
//   scrollDirection: Axis.horizontal,
//   // Sayfaların tam kaydırma eylemini gerçekleştirmesi için gerekli.
//   physics: PageScrollPhysics(),
//   addAutomaticKeepAlives: false,
//   children: [
//
//     InteractiveViewer(
//       panEnabled: true,
//       minScale: 1,
//       maxScale: 4,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//             color: Colors.black,
//             image: DecorationImage(
//               image: NetworkImage('https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg'),
//               // image: NetworkImage(attachFiles[0]),
//               fit: BoxFit.contain,
//             )
//         ),
//       ),
//     ),
//
//     InteractiveViewer(
//       panEnabled: true,
//       minScale: 1,
//       maxScale: 4,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//             color: Colors.black,
//             image: DecorationImage(
//               image: NetworkImage('https://i.pinimg.com/originals/b8/94/2f/b8942f236f51960e99f9781ec827d92e.jpg'),
//               // image: NetworkImage(attachFiles[0]),
//               fit: BoxFit.contain,
//             )
//         ),
//       ),
//     ),
//
//     InteractiveViewer(
//       panEnabled: true,
//       minScale: 1,
//       maxScale: 4,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//             color: Colors.black,
//             image: DecorationImage(
//               image: NetworkImage('https://wallpapercave.com/wp/wp5152418.jpg'),
//               // image: NetworkImage(attachFiles[0]),
//               fit: BoxFit.contain,
//             )
//         ),
//       ),
//     ),
//
//
//   ],
// )
