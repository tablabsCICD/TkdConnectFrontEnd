import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/search_data.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/group/create_group_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';
import 'package:tkd_connect/widgets/editText.dart';

class EditGroupScreen extends StatefulWidget {
  List<SearchData> memberList;
  EditGroupScreen(this.memberList, {super.key});

  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  bool isEdit=false;
  final TextEditingController _controller = TextEditingController();
  ScrollController horizantalControllet=ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          CreateGroupProvider(true),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      // appBar: AppBarCommon(context, title: "Create Group").appBar(),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50,),
          groupName(),
          const SizedBox(height: 30,),
          particepent(),
          const SizedBox(height: 20,),
          selectUserList(),
        ],
      ),


      bottomNavigationBar: Consumer<CreateGroupProvider>(
        builder: (context, provider, child) => Padding(padding: const EdgeInsets.fromLTRB(20,10,20,20),
          child: Button(width: 327.w, height: 49.h, title: "Update", textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: AppConstant.FONTFAMILY,
            fontWeight: FontWeight.w600,
            height: 0,
          ), onClick: () async {
            User user=await LocalSharePreferences().getLoginData();
            provider.groupNameController.text = _controller.text;
            await provider.callUpdateGroupApi(user.content!.first.id,_controller.text,widget.memberList,context);
          },isEnbale: true),),
      ),
    );

  }

  bool buttonEnable = false;
  groupName() {
    return Consumer<CreateGroupProvider>(
        builder: (context, provider, child) {
          String img=provider.currentGroup!.imageUrl!;
          _controller.text = provider.currentGroup!.groupName!;
          /*setState(() {

          });*/
          //provider.setData();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ClipOval(
                  child: Material(
                    color: Colors.grey, // Button color
                    child: InkWell(
                      splashColor: Colors.grey, // Splash color
                      onTap: () async{
                        await provider.uploadProfileImage(context);
                      },
                      child: BaseWidget().getImageclip(provider.changeImageUrl==''?img:provider.changeImageUrl,
                          height: 40.h, width: 40.w),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,width: 250,
                  child: EditText(controller: _controller, hint: "Enter Group Name", keybordType: TextInputType.text,

                    width: 250,height: 50,))
            ],
          );}
    );
  }

  particepent() {
    return Container(
      height: 40,
      color: Colors.black12,
      child: Center(child: Text("PARTICIPANTS: ${widget.memberList.length} OF 1000",style: TextStyle(fontSize: 14.sp,
        fontFamily: AppConstant.FONTFAMILY,
        fontWeight: FontWeight.w600,))),
    );
  }



  selectUserList(){
    return Expanded(
      child: ListView.builder(
        // controller: _scrollController,
          shrinkWrap: true,
          itemCount: widget.memberList.length,
          itemBuilder: (context, index) {
            return InkWell(onTap: () {}, child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      widget.memberList[index].profilePicture==null?const Icon(
                        Icons.account_circle,
                        size: 30.0,
                      ):BaseWidget().getImageclip(
                        widget.memberList[index].profilePicture.toString(),
                        height: 34,
                        width: 34,
                      ),
                      const SizedBox(width: 10,),
                      Text(
                          "${widget.memberList[index].firstName!} ${widget.memberList[index].lastName!}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                ),
                const Divider()
              ],
            ));
          }),
    );
  }

}