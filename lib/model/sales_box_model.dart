import 'package:flutter_trip/model/common_model.dart';

/// 活动入口模型
class SalesBoxModel {
  late final String icon;
  late final String moreUrl;
  late final CommonModel bigCard1;
  late final CommonModel bigCard2;
  late final CommonModel smallCard1;
  late final CommonModel smallCard2;
  late final CommonModel smallCard3;
  late final CommonModel smallCard4;

  SalesBoxModel({
    required this.icon,
    required this.moreUrl,
    required this.bigCard1,
    required this.bigCard2,
    required this.smallCard1,
    required this.smallCard2,
    required this.smallCard3,
    required this.smallCard4,
  });

  factory SalesBoxModel.fromJson(Map<String, dynamic> json) {
    return SalesBoxModel(
      icon: json['icon'],
      moreUrl: json['moreUrl'],
      bigCard1: CommonModel.fromJson(json['bigCard1']),
      bigCard2: CommonModel.fromJson(json['bigCard2']),
      smallCard1: CommonModel.fromJson(json['smallCard1']),
      smallCard2: CommonModel.fromJson(json['smallCard2']),
      smallCard3: CommonModel.fromJson(json['smallCard3']),
      smallCard4: CommonModel.fromJson(json['smallCard4']),
    );
  }
}
