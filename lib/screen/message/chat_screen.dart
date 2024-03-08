import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/color.dart';
import '../../constant/firestore_constant.dart';
import '../../model/chat_message.dart';
import '../../provider/message/chat_provider.dart';
import '../../widgets/card/base_widgets.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.arguments});

  final ChatPageArguments arguments;

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late final String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late final ChatProvider chatProvider = context.read<ChatProvider>();
 // late final AuthProviders authProvider = context.read<AuthProviders>();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
    onTimeCall();
  }

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() async{
    User user =await LocalSharePreferences().getLoginData();

    currentUserId = user.content!.first.mobileNumber!.toString();
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    try{
      chatProvider.updateDataFirestore(
        FirestoreConstants.pathUserCollection,
        currentUserId,
        {FirestoreConstants.chattingWith: peerId},
      );
    }catch (e){

    }

  }
  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(content, type, groupChatId, currentUserId, widget.arguments.peerId);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
     //ToastMessage.show(msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        // Right (my message)
        return Row(
          children: <Widget>[
            messageChat.type == TypeMessage.text
            // Text
                ? Container(
              child: Text(
                messageChat.content,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              width: 200,
              decoration: BoxDecoration(color:Color(0xFF001E49), borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
            )
                : messageChat.type == TypeMessage.image
            // Image
                ? Container(
              child: OutlinedButton(
                child: Material(
                  child: Image.network(
                    messageChat.content,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          color:  Color(0xFF001E49),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.themeColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return Material(
                        child: Image.asset(
                          'images/img_not_available.jpeg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                      );
                    },
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  clipBehavior: Clip.hardEdge,
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => FullPhotoPage(
                  //       url: messageChat.content,
                  //     ),
                  //   ),
                  // );
                },
                style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
              ),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
            )
            // Sticker
                : Container(
              child: Image.asset(
                'images/${messageChat.content}.gif',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                    child: Image.network(
                      widget.arguments.peerAvatar,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.themeColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 35,
                          color: ColorConstants.greyColor,
                        );
                      },
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    clipBehavior: Clip.hardEdge,
                  )
                      : Container(width: 35),
                  messageChat.type == TypeMessage.text
                      ? Container(
                    child: Text(
                      messageChat.content,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8999999761581421),
                        fontSize: 12.sp,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    width: 200,
                    decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.20000000298023224), borderRadius: BorderRadius.circular(8)),
                    margin: EdgeInsets.only(left: 10),
                  )
                      : messageChat.type == TypeMessage.image
                      ? Container(
                    child: TextButton(
                      child: Material(
                        child: Image.network(
                          messageChat.content,
                          loadingBuilder:
                              (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                color: ColorConstants.greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              width: 200,
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.themeColor,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) => Material(
                            child: Image.asset(
                              'images/img_not_available.jpeg',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => FullPhotoPage(url: messageChat.content),
                        //   ),
                        // );
                      },
                      style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
                    ),
                    margin: EdgeInsets.only(left: 10),
                  )
                      : Container(
                    child: Image.asset(
                      'images/${messageChat.content}.gif',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
                  ),
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                child: Text(
                  DateFormat('dd MMM kk:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageChat.timestamp))),
                  style: TextStyle(color: ColorConstants.greyColor, fontSize: 12, fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
              )
                  : SizedBox.shrink()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get(FirestoreConstants.idFrom) == currentUserId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get(FirestoreConstants.idFrom) != currentUserId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateDataFirestore(
        FirestoreConstants.pathUserCollection,
        currentUserId,
        {FirestoreConstants.chattingWith: null},
      );
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

backgroundColor: Colors.white,
        elevation: 0,
      leadingWidth: 0,
        title:Row(
          children: [
            SizedBox(width: 12,),
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios,color: Colors.black,)),
            SizedBox(width:4),
            BaseWidget().getImage(widget.arguments.peerAvatar, height: 31.h, width: 32.w),
            SizedBox(width:4),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  this.widget.arguments.peerNickname,
                  style: TextStyle(color: Colors.black,fontFamily: AppConstant.FONTFAMILY,fontSize: 12.sp,fontWeight: FontWeight.w600,),
                ),
                SizedBox(height: 1,),
              ],
            )
          ],
        ),

        centerTitle: false,
      ),
      body: SafeArea(
        child: WillPopScope(
          child: Stack(
            children: <Widget>[


              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),

                  // Sticker
                  isShowSticker ? buildSticker() : SizedBox.shrink(),

                  // Input content
                  buildInput(),
                ],
              ),

              // Loading
              buildLoading()
            ],
          ),
          onWillPop: onBackPress,
        ),
      ),
    );
  }

  Widget buildSticker() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi1', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi1.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi2', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi2.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi3', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi3.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi4', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi4.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi5', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi5.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi6', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi6.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi7', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi7.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi8', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi8.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi9', TypeMessage.sticker),
                  child: Image.asset(
                    'images/mimi9.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: ColorConstants.greyColor2, width: 0.5)), color: Colors.white),
        padding: EdgeInsets.all(5),
        height: 180,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? CircularProgressIndicator(): SizedBox.shrink(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          // Material(
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 1),
          //     child: IconButton(
          //       icon: Icon(Icons.attach_file),
          //       onPressed: (){
          //         getImage();
          //       },
          //       color: ColorConstants.primaryColor,
          //     ),
          //   ),
          //   color: Colors.white,
          // ),
          // Material(
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 1),
          //     child: IconButton(
          //       icon: Icon(Icons.face),
          //       onPressed: (){},
          //       color: ColorConstants.primaryColor,
          //     ),
          //   ),
          //   color: Colors.white,
          // ),
          SizedBox(width: 20,),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, TypeMessage.text);
                },
                style: TextStyle(color: ColorConstants.primaryColor, fontSize: 15),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: ColorConstants.greyColor),

                ),

                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, TypeMessage.text),
                color: ColorConstants.primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: ColorConstants.greyColor2, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
        stream: chatProvider.getChatStream(groupChatId, _limit),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data!.docs;
            if (listMessage.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) => buildItem(index, snapshot.data?.docs[index]),
                itemCount: snapshot.data?.docs.length,
                reverse: true,
                controller: listScrollController,
              );
            } else {
              return Center(child: Text("No message here yet..."));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstants.themeColor,
              ),
            );
          }
        },
      )
          : Center(
        child: CircularProgressIndicator(
          color: ColorConstants.themeColor,
        ),
      ),
    );
  }

  onTimeCall(){
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        // Here you can write your code for open new view
      });
    });
  }


  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery).catchError((err) {
      //Fluttertoast.showToast(msg: err.toString());
      return null;
    });
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }


  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, TypeMessage.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
     // Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

}





class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments({required this.peerId, required this.peerAvatar, required this.peerNickname});
}