import 'package:dollarydoo/models/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'json_helpers.dart';

part 'cent_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Cent extends DbModel {
  String displayName;
  String idName;
  String description;

  /// Represents a userId that can moderate the cent
  final Set<String> mods;
  Cent(
      {required this.displayName,
      required this.idName,
      required this.description,
      Set<String>? mods,
      super.id})
      : mods = mods ?? <String>{};

  factory Cent.fromJson(Map<String, dynamic> json) => _$CentFromJson(json);

  Map<String, dynamic> toJson() => _$CentToJson(this);

  Cent fromJson(Map<String, dynamic> json) => Cent.fromJson(json);
}
