import 'package:flutter/cupertino.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/job_list.dart';
import '../../network/api_helper.dart';
import '../base_provider.dart';

class JobListProvider extends BaseProvider {

  JobListProvider() : super("Ideal") {
    getAllJobs();
    pagination();
  }

  // ================= PAGINATION =================
  int selectedPage = 0;
  ScrollController scrollController = ScrollController();

  // ================= SEARCH & FILTER CONTROLLERS =================
  TextEditingController searchQuery = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  // ================= FILTER VALUES =================
  String? selectedRole;
  String? selectedDepartment;
  String? selectedExperience;
  String? selectedSalary;
  DateTime? selectedDate;

  // ================= DATA =================
  List<JobData> listJobs = [];
  List<JobData> tempJobs = [];

  // ================= API CALL =================
  Future<void> getAllJobs({
    int currentPage = 0,
    String? search,
    String? role,
    String? department,
    String? experience,
    String? salary,
    String? date,
  }) async {

    if (currentPage == 0) selectedPage = 0;

    String url =
        '${ApiConstant.BASE_URL}postJob/getAllJobsWithSearch'
        '?page=$selectedPage'
        '&size=10'
        '&search=${search ?? ""}'
        '&role=${role ?? ""}'
        '&department=${department ?? ""}'
        '&experience=${experience ?? ""}'
        '&salary=${salary ?? ""}'
        '&date=${date ?? ""}';

    ApiResponse apiResponse =
    await ApiHelper().apiWithoutDecodeGet(url);

    if (apiResponse.status == 200) {
      JobList jobList = JobList.fromJson(apiResponse.response);

      if (selectedPage == 0) {
        listJobs.clear();
        tempJobs.clear();
      }

      listJobs.addAll(jobList.content!);
      tempJobs.addAll(listJobs);
      selectedPage++;

      notifyListeners();
    }
  }

  // ================= SEARCH =================
  Future<void> getBySearchData() async {
    if (searchQuery.text.length >= 2) {
      String myUrl = ApiConstant.JOB_SEARCH(searchQuery.text);
      ApiResponse apiResponse =
      await ApiHelper().apiWithoutDecodeGet(myUrl);

      if (apiResponse.status == 200) {
        JobList jobList = JobList.fromJson(apiResponse.response);
        listJobs.clear();
        listJobs.addAll(jobList.content!);
      }
    } else {
      listJobs.clear();
      listJobs.addAll(tempJobs);
    }
    notifyListeners();
  }

  // ================= APPLY FILTER =================
  void applyFilters() {
    getAllJobs(
      currentPage: 0,
      search: searchQuery.text.trim(),
      role: selectedRole,
      department: selectedDepartment,
      experience: selectedExperience,
      salary: selectedSalary,
      date: selectedDate != null
          ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}"
          : null,
    );
  }

  // ================= CLEAR FILTER =================
  void clearFilters() {
    selectedRole = null;
    selectedDepartment = null;
    selectedExperience = null;
    selectedSalary = null;
    selectedDate = null;

    roleController.clear();
    departmentController.clear();

    getAllJobs(currentPage: 0);
  }

  // ================= PAGINATION LISTENER =================
  void pagination() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getAllJobs();
      }
    });
  }
}
