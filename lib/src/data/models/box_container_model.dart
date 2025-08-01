// ignore_for_file: public_member_api_docs, sort_constructors_first
//create a class for a container model with name, list of items, name of responsible person
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:offline_first/src/data/models/item_container_model.dart';

part 'box_container_model.g.dart';

@HiveType(typeId: 1)
class BoxContainerModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String responsiblePerson;
  @HiveField(3)
  List<ItemContainerModel> items; // List of item IDs or names
  @HiveField(4)
  DateTime createdAt;
  @HiveField(5)
  DateTime updatedAt;
  @HiveField(6)
  bool isSynced;
  @HiveField(7)
  String? remoteId;
  @HiveField(8)
  bool isDeleted;
  BoxContainerModel({
    required this.id,
    required this.name,
    required this.responsiblePerson,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    this.remoteId,
    required this.isDeleted,
  });

  BoxContainerModel copyWith({
    String? id,
    String? name,
    String? responsiblePerson,
    List<ItemContainerModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    String? remoteId,
    bool? isDeleted,
  }) {
    return BoxContainerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      responsiblePerson: responsiblePerson ?? this.responsiblePerson,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      remoteId: remoteId ?? this.remoteId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'responsiblePerson': responsiblePerson,
      'items': items,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isSynced': isSynced,
      'remoteId': remoteId,
      'isDeleted': isDeleted,
    };
  }

  factory BoxContainerModel.fromMap(Map<String, dynamic> map) {
    return BoxContainerModel(
      id: map['id'] as String,
      name: map['name'] as String,
      responsiblePerson: map['responsiblePerson'] as String,
      items: List<ItemContainerModel>.from(
        (map['items'] as List).map<ItemContainerModel>(
          (x) => ItemContainerModel.fromMap(x as Map<String, dynamic>),
        ),
      ),

      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      isSynced: map['isSynced'] as bool,
      remoteId: map['remoteId'] != null ? map['remoteId'] as String : null,
      isDeleted: map['isDeleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory BoxContainerModel.fromJson(String source) => BoxContainerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BoxContainerModel(id: $id, name: $name, responsiblePerson: $responsiblePerson, items: $items, createdAt: $createdAt, updatedAt: $updatedAt, isSynced: $isSynced, remoteId: $remoteId, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(covariant BoxContainerModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.responsiblePerson == responsiblePerson && listEquals(other.items, items) && other.createdAt == createdAt && other.updatedAt == updatedAt && other.isSynced == isSynced && other.remoteId == remoteId && other.isDeleted == isDeleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ responsiblePerson.hashCode ^ items.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ isSynced.hashCode ^ remoteId.hashCode ^ isDeleted.hashCode;
  }
}
