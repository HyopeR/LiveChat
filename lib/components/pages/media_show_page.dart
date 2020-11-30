import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/zoomable_widget.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/services/operation_service.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MediaShowPage extends StatefulWidget {
  String currentMessageId;
  MediaShowPage({Key key, this.currentMessageId}) : super(key: key);

  @override
  _MediaShowPageState createState() => _MediaShowPageState();
}

class _MediaShowPageState extends State<MediaShowPage> {
  ChatView _chatView;
  UserView _userView;
  PageController pageController = PageController(initialPage: 0, keepPage: true, viewportFraction: 1);

  List<MessageModel> itemList = List<MessageModel>();
  int currentPage = 0;
  bool showData = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      setState(() {
        itemList = _chatView.messages
            .where((message) => message.messageType == 'Image')
            .toList();
      });

      if(widget.currentMessageId != null) {
        int itemIndex = itemList.indexWhere((message) => message.messageId == widget.currentMessageId);

        if(currentPage != -1) {
          currentPage = itemIndex;
          pageController.jumpToPage(itemIndex);
        }
      }

    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatView = Provider.of<ChatView>(context);
    _userView = Provider.of<UserView>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.3),
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Theme(
              data: ThemeData(
                  primarySwatch: Colors.amber,
                  brightness: Brightness.dark
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
                  },

                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return createItem(index);
                  },
                ),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: showData ? 1 : 0,
                child: Container(
                  height: 56,
                  child: AppbarWidget(
                    textColor: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.5),
                    onLeftSideClick: () {
                      Navigator.pop(context);
                    },
                    appBarType: 'Chat',

                    titleImage: ImageWidget(
                        imageWidth: 50,
                        imageHeight: 50,
                        backgroundShape: BoxShape.circle,
                        image: NetworkImage(_chatView.groupType == 'Private'
                          ? _chatView.interlocutorUser.userProfilePhotoUrl
                          : _chatView.selectedChat.groupImageUrl)
                    ),
                    titleText: _chatView.groupType == 'Private'
                        ? _chatView.interlocutorUser.userName
                        : _chatView.selectedChat.groupName,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createItem(int index) {
    return ZoomableWidget(
      onTap: () {
        setState(() {
          showData = !showData;
        });
      },
      panEnabled: true,
      minScale: 1,
      maxScale: 4,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(itemList[index].attach),
                // image: NetworkImage(attachFiles[0]),
                fit: BoxFit.contain,
              )),
          child: Stack(
            children: [

              Positioned(
                  top: 66,
                  right: 10,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: showData ? 1 : 0,
                    child: ContainerColumn(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _chatView.groupType == 'Private'
                                ? itemList[index].sendBy == _userView.user.userId ? _userView.user.userName : _chatView.interlocutorUser.userName
                                : itemList[index].sendBy == _userView.user.userId ? _userView.user.userName : _chatView.users.firstWhere((user) => user.userId == itemList[index].sendBy).userName,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                              showDateComposedString(itemList[index].date)),
                        ),
                      ],
                    ),
                  ),
                ),

                itemList[index].message != null
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: showData ? 1 : 0,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(10),
                          color: Colors.black.withOpacity(0.5),
                          height: 50,
                          child: Text(itemList[index].message),
                        ),
                      ),
                    )
                  : Container(
                    height: 0,
                  ),
            ],
          )
      ),
    );
  }
}
