import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/job_list.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';

class JobListProvider extends BaseProvider{

  int selectedPage=0;
  TextEditingController searchQuery = TextEditingController();
  String? selectedFilter; // e.g. "IT", "HR", etc.

  ScrollController scrollController=ScrollController();
  List<JobData>listJobs=[];
  List<JobData> tempJobs=[];
  JobListProvider():super("Ideal"){
   getAllJobs();
   pagenation();
  }

  getAllJobs()async{
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet('${ApiConstant.BASE_URL}postJob/getAllJobsWithSearch?page=$selectedPage&size=10');
    if(apiResponse.status==200){
      JobList jobList=JobList.fromJson(apiResponse.response);
      if(selectedPage==0){
        listJobs.clear();
        tempJobs.clear();
      }
      listJobs.addAll(jobList.content!);
      tempJobs.addAll(listJobs);
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

  Future<void> getBySearchData() async {
    if(searchQuery.text.length>=2){
      String myUrl = ApiConstant.JOB_SEARCH(searchQuery.text);
      ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
      if(apiResponse.status==200){
        JobList jobList=JobList.fromJson(apiResponse.response);
        listJobs.clear();
        listJobs.addAll(jobList.content!);
      }
    }else{
      listJobs.clear();
      listJobs.addAll(tempJobs);
    }
    notifyListeners();
  }

}