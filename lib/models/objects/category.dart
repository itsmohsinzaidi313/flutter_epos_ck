import 'package:sqflite/sqflite.dart';

class Category {
  final String serverId;
  final String categoryName;
  final String description;
  final String userId;
  final String companyId;
  final String delStatus;

  Category(
      {this.serverId,
      this.categoryName,
      this.description,
      this.userId,
      this.companyId,
      this.delStatus});

  Category.fromMap(Map<String, dynamic> map)
      : serverId = map['id'],
        categoryName = map['category_name'],
        description = map['description'],
        userId = map['user_id'],
        companyId = map['company_id'],
        delStatus = map['del_status'];
}
