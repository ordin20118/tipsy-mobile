
class Liquor {
  int? liquorId;
  String? nameKr;
  String? nameEn;

  int? category1Id;
  int? category2Id;
  int? category3Id;
  int? category4Id;
  String? category1Name;
  String? category2Name;
  String? category3Name;
  String? category4Name;

  String? description;
  String? history;

  int? vintage;
  double? abv;
  int? countryId;

  DateTime? regDate;
  DateTime? updateDate;

  Liquor() {}
  Liquor.set({this.liquorId, this.nameKr, this.nameEn, this.category1Id,
            this.category2Id, this.category3Id, this.category4Id, this.category1Name,
            this.category2Name, this.category3Name, this.category4Name,
            this.vintage, this.abv, this.countryId,
            this.description, this.history, this.regDate, this.updateDate});


  // factory PhotosList.fromJson(List<dynamic> parsedJson) {
  //   List<Photo> photos = new List<Photo>();
  //   ​
  //   return new PhotosList(
  //   photos: photos,
  //   );
  // }

  factory Liquor.fromJson(Map<String, dynamic> json) {
    return Liquor.set(
      liquorId: json['liquor_id'],
      nameKr: json['name_kr'],
      nameEn: json['name_en'],
      category1Id: json['category1_id'],
      category2Id: json['category2_id'],
      category3Id: json['category3_id'],
      category4Id: json['category4_id'],
      category1Name: json['category1_ame'],
      category2Name: json['category2_ame'],
      category3Name: json['category3_ame'],
      category4Name: json['category4_ame'],
      vintage: json['vintage'],
      abv: json['abv'],
      countryId: json['country_id'],
      description: json['description'],
      history: json['history'],
      regDate: json['reg_date'],
      updateDate: json['update_date'],
    );
  }
}

class LiquorList {
  List<Liquor>? liquors;

  LiquorList() {}
  LiquorList.set({
    this.liquors,
  });

  factory LiquorList.fromJson(List<dynamic> parsedJson) {
    List<Liquor> liquors = new List<Liquor>.empty();
    liquors = parsedJson.map((i)=>Liquor.fromJson(i)).toList();
    return new LiquorList.set(
      liquors: liquors,
    );
  }
}