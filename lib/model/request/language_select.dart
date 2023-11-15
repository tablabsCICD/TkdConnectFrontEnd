class LanaguageSelect {
  String? langName;
  bool? isSelect;
  String? langCode;

  LanaguageSelect({this.langName, this.isSelect,this.langCode});


  List<LanaguageSelect> getLang(){
    List<LanaguageSelect>langList=[];
    langList.add(LanaguageSelect(langName: "English",isSelect: false,langCode: "en"));
    langList.add(LanaguageSelect(langName: "हिंदी",isSelect: false,langCode: "hi"));
    // langList.add(LanaguageSelect(langName: "मराठी",isSelect: false));
    // langList.add(LanaguageSelect(langName: "ಕನ್ನಡ",isSelect: false));
    // langList.add(LanaguageSelect(langName: "தமிழ்",isSelect: false));
    // langList.add(LanaguageSelect(langName: "ગુજરાતી",isSelect: false));
    // langList.add(LanaguageSelect(langName: "অসমীয়া",isSelect: false));
    return langList;
  }
}