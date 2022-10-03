class CommonModel {
  late final String? icon;
  late final String? title;
  late final String url;
  late final String? statusBarColor;
  late final bool? hideAppBar;

  CommonModel(
      {this.icon,
      this.title,
      required this.url,
      this.statusBarColor,
      this.hideAppBar});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      icon: json['icon'],
      title: json['title'],
      url: json['url'],
      statusBarColor: json['statusBarColor'],
      hideAppBar: json['hideAppBar'],
    );
  }
}
