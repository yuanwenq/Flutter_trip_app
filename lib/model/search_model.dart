class SearchModel {
  String? keyword;
  final List<SearchItem> data;

  SearchModel({required this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;
    List<SearchItem> data =
        dataJson.map((i) => SearchItem.fromJson(i)).toList();
    return SearchModel(data: data);
  }
}

class SearchItem {
  final String? word;
  final String? type;
  final String? price;
  final String? star;
  final String? zonnename;
  final String? districtname;
  final String? url;

  SearchItem(
      {this.word,
      this.type,
      this.price,
      this.star,
      this.zonnename,
      this.districtname,
      required this.url});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      word: json['word'],
      type: json['type'],
      price: json['price'],
      star: json['star'],
      zonnename: json['zonnename'],
      districtname: json['districtname'],
      url: json['url'],
    );
  }
}
