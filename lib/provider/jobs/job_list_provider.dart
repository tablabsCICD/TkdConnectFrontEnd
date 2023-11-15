import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/job_list.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';

class JobListProvider extends BaseProvider{

  int selectedPage=0;

  ScrollController scrollController=ScrollController();
  List<JobData>listJobs=[];
  JobListProvider():super("Ideal"){
   getAllJobs();
   pagenation();
  }

  getAllJobs()async{
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.BASE_URL+'postJob?page=$selectedPage');
    if(apiResponse.status==200){
      JobList jobList=JobList.fromJson(apiResponse.response);
      if(selectedPage==0){
        listJobs.clear();
      }
      listJobs.addAll(jobList.content!);
      selectedPage++;
      notifyListeners();

    }else{

    }


  }

  pagenation(){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getAllJobs();

      }
    });
  }

}