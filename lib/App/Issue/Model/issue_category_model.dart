


class IssueCategoryModel {
  String? status;
  String? message;
  List<CategoryData>? data;

  IssueCategoryModel({this.status, this.message, this.data});

  IssueCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  String? id;
  String? issueCategoryName;
  int? hasAsterisk;

  CategoryData({this.id, this.issueCategoryName, this.hasAsterisk});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    issueCategoryName = json['issue_category_name'];
    hasAsterisk = json['has_asterisk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['issue_category_name'] = this.issueCategoryName;
    data['has_asterisk'] = this.hasAsterisk;
    return data;
  }
}