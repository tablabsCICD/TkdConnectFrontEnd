class LanaguageSelect {
  String? langName;
  bool? isSelect;
  String? langCode;

  LanaguageSelect({this.langName, this.isSelect,this.langCode});


  List<LanaguageSelect> getLang(){
    List<LanaguageSelect>langList=[];
    langList.add(LanaguageSelect(langName: "English",isSelect: false,langCode: "en"));
    langList.add(LanaguageSelect(langName: "हिंदी",isSelect: false,langCode: "hi"));
    langList.add(LanaguageSelect(langName: "मराठी",isSelect: false,langCode: "mr"));
    langList.add(LanaguageSelect(langName: "ಕನ್ನಡ",isSelect: false,langCode: "kn_IN"));
     langList.add(LanaguageSelect(langName: "தமிழ்",isSelect: false,langCode: "ta"));
     langList.add(LanaguageSelect(langName: "ગુજરાતી",isSelect: false,langCode: "gu"));
     langList.add(LanaguageSelect(langName: "తెలుగు",isSelect: false,langCode: "te"));
    return langList;
  }
}