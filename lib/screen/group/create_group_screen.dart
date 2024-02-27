import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/generated/l10n.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/dashboard/rating_provider.dart';
import 'package:tkd_connect/provider/group/group_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/rating_star.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/editText.dart';

class CreateGroupScreen extends StatefulWidget {
  GroupProvider provider;
  CreateGroupScreen(this.provider);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  bool isEdit=false;
  TextEditingController _controller = TextEditingController();
  ScrollController horizantalControllet=ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return /*ChangeNotifierProvider(
      create: (BuildContext context) =>
          GroupProvider(widget.userId),
      builder: (context, child) => _buildPage(context),
    );*/_buildPage(context);
  }

  _buildPage(BuildContext context) {
    return Scaffold(
          // appBar: AppBarCommon(context, title: "Create Group").appBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 50,),
              groupName(widget.provider),
              SizedBox(height: 30,),
              particepent(widget.provider),
              SizedBox(height: 20,),
              Padding(padding: EdgeInsets.only(left: 10,right: 10),child: selectUserList(widget.provider),),
            ],
          ),

          bottomNavigationBar: Padding(padding: EdgeInsets.fromLTRB(20,10,20,20),
            child: Button(width: 327.w, height: 49.h, title: S().create, textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: AppConstant.FONTFAMILY,
            fontWeight: FontWeight.w600,
            height: 0,
          ), onClick: () async {
              User user=await LocalSharePreferences().getLoginData();
              await widget.provider.callCreateGroupApi(user.content!.first.id,widget.provider.groupNameController.text,context);
            //  Navigator.pushReplacementNamed(context, AppRoutes.group);
          },isEnbale: buttonEnable),),
        );

  }

  bool buttonEnable = false;
  groupName(GroupProvider provider) {
    String img=provider.imageUrl.replaceAll('"', '');
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
                 setState(() {
                 });
                },
                child: SizedBox(width: 50, height: 50, child:  Image.network(provider.changeImageUrl==''?img:provider.changeImageUrl)),
              ),
            ),
          ),
        ),
        Container(height: 50,width: 250,
            child: EditText(controller: provider.groupNameController, hint: "Enter Group Name", keybordType: TextInputType.text,
          onChange: (val){
              if(val==0) {
                buttonEnable = false;
              }else{
                buttonEnable = true;
              }
              setState(() {
              });
          },
          width: 250,height: 50,))
      ],
    );
  }

  particepent(GroupProvider provider) {
    return Container(
      height: 40,
      color: Colors.black12,
      child: Center(child: Text("PARTICIPANTS: ${provider.selectedUsers.length} OF 1000",style: TextStyle(fontSize: 14.sp,
        fontFamily: AppConstant.FONTFAMILY,
        fontWeight: FontWeight.w600,))),
    );
  }



  selectUserList(GroupProvider provider){
    return ListView.builder(
      // controller: _scrollController,
        shrinkWrap: true,
        itemCount: provider.selectedUsers.length,
        itemBuilder: (context, index) {
          return InkWell(onTap: () {}, child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    provider.selectedUsers[index].profilePicture!.allMatches("null")==0 ? Image.network(provider.selectedUsers[index].profilePicture!,height: 64,width: 64,) : Icon(
                      Icons.account_circle,
                      size: 30.0,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      provider.selectedUsers[index].firstName!+" "+provider.selectedUsers[index].lastName!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w600,
                      ))
                  ],
                ),
              ),
              Divider()
            ],
          ));
        });
  }

}