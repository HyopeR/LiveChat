// import 'package:flutter/material.dart';
// import 'package:live_chat/components/common/appbar_widget.dart';
// import 'package:live_chat/components/common/container_column.dart';
// import 'package:live_chat/components/common/container_row.dart';
// import 'package:live_chat/components/common/image_widget.dart';
// import 'package:live_chat/models/user_model.dart';
// import 'package:live_chat/views/chat_view.dart';
// import 'package:live_chat/views/user_view.dart';
// import 'package:provider/provider.dart';
//
// class SearchUserPage extends StatefulWidget {
//   @override
//   _SearchUserPageState createState() => _SearchUserPageState();
// }
//
// class _SearchUserPageState extends State<SearchUserPage> {
//   ChatView _chatView;
//   UserView _userView;
//
//   TextEditingController _controller;
//   FocusNode _focusNode;
//
//   List<UserModel> users;
//   String searchedText = '';
//   bool updatedContacts = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//     _focusNode = FocusNode();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     updatedContacts = false;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _chatView = Provider.of<ChatView>(context);
//     _userView = Provider.of<UserView>(context);
//
//     double marginWithoutWidth = MediaQuery.of(context).size.width - 20;
//
//     return Scaffold(
//       appBar: AppbarWidget(
//         titleText: 'Search User',
//         brightness: Brightness.light,
//         onLeftSideClick: () {
//           Navigator.of(context).pop(updatedContacts);
//         },
//       ),
//
//       body: WillPopScope(
//         onWillPop: () async {
//           Navigator.of(context).pop(updatedContacts);
//           return updatedContacts;
//         },
//
//         child: SafeArea(
//           child: ContainerColumn(
//             padding: EdgeInsets.all(10),
//             children: [
//
//               ContainerRow(
//                 children: [
//                   Container(
//                     height: 50,
//                     width: marginWithoutWidth * 0.7,
//                     padding: EdgeInsets.all(10),
//
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         bottomLeft: Radius.circular(10),
//                       ),
//                       color: Colors.grey.shade300.withOpacity(0.8),
//                     ),
//
//                     child: TextField(
//                       focusNode: _focusNode,
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         isDense: true,
//                         contentPadding: EdgeInsets.all(5),
//                         hintText: 'Kullanıcı adı giriniz.'
//                       ),
//                     ),
//                   ),
//
//                   Container(
//                     height: 50,
//                     width: marginWithoutWidth * 0.3,
//                     child: InkWell(
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//
//                       onTap: () async {
//                         setState(() {
//                           searchedText = _controller.text;
//                         });
//
//                         if(_focusNode.hasPrimaryFocus)
//                           _focusNode.unfocus();
//
//                         _controller.clear();
//                       },
//
//                       child: ContainerRow(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(10),
//                             bottomRight: Radius.circular(10),
//                           ),
//                           color: Theme.of(context).primaryColor.withOpacity(0.8),
//                         ),
//
//                         children: [
//                           Text('Ara', style: TextStyle(fontSize: 16),),
//                           Icon(Icons.search),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//
//               SizedBox(height: 10),
//               searchedText.trim().length > 0
//                 ? Container(
//                   padding: EdgeInsets.all(10),
//                   alignment: Alignment.centerLeft,
//                     child: RichText(
//                         text: TextSpan(
//                             style: TextStyle(color: Colors.black),
//                             children: [
//                               TextSpan(text: 'Aranılan kelime: ', style: TextStyle(fontWeight: FontWeight.bold)),
//                               TextSpan(text: searchedText),
//                             ]
//                         ),
//                     )
//                 )
//
//               : Container(),
//
//               Expanded(
//                 child: FutureBuilder<List<UserModel>>(
//                   future: _chatView.searchUsers(searchedText),
//                   builder: (context, futureResult) {
//                     if (futureResult.hasData) {
//                       users = futureResult.data;
//
//                       if (users.length > 0)
//                         return RefreshIndicator(
//                           onRefresh: () => refreshUsers(),
//                           child: ListView.builder(
//                               itemCount: users.length,
//                               itemBuilder: (context, index) => createItem(index)
//                               ),
//                         );
//                       else {
//                         return LayoutBuilder(
//                           builder: (context, constraints) => RefreshIndicator(onRefresh: () => refreshUsers(),
//                               child: SingleChildScrollView(
//                                   physics: AlwaysScrollableScrollPhysics(),
//                                   child: ConstrainedBox(
//                                     constraints: BoxConstraints(
//                                         minHeight: constraints.maxHeight),
//                                     child: ContainerColumn(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         Icon(Icons.people, size: 100),
//                                         Text(
//                                           '$searchedText kullanıcısı bulunamadı.',
//                                           textAlign: TextAlign.center,
//                                         )
//                                       ],
//                                     ),
//                                   ))),
//                         );
//                       }
//                     } else
//                       return Center(child: CircularProgressIndicator());
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   refreshUsers() async {
//     await Future.delayed(Duration(seconds: 2), () {
//       setState(() {});
//     });
//   }
//
//   Widget createItem(int index) {
//
//     UserModel currentUser = users[index];
//
//     if ((currentUser.userId != _userView.user.userId)) {
//       bool myContact = _userView.searchUserInContacts(currentUser.userId);
//
//       return GestureDetector(
//         onTap: () {
//           _chatView.findChatByUserIdList([
//             _userView.user.userId,
//             currentUser.userId
//           ]);
//         },
//         child: ListTile(
//           leading: ImageWidget(
//             image: NetworkImage(currentUser.userProfilePhotoUrl),
//             imageWidth: 75,
//             imageHeight: 75,
//             backgroundShape: BoxShape.circle,
//             backgroundColor:
//             Colors.grey.withOpacity(0.3),
//           ),
//
//           trailing: IconButton(
//             splashRadius: 25,
//             icon: myContact ? Icon(Icons.mobile_friendly) : Icon(Icons.add),
//             onPressed: () async {
//               if(!myContact) {
//                 await _userView.addContact(_userView.user.userId, currentUser.userId);
//                 setState(() {
//                   updatedContacts = true;
//                 });
//               }
//             },
//           ),
//
//           title: Text(currentUser.userName),
//           subtitle: Text(currentUser.userEmail),
//         ),
//       );
//     } else
//       return Container();
//
//   }
// }
