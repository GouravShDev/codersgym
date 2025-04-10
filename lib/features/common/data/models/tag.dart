import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final String? name;
  final String? id;
  final String? slug;

  const Tag({this.name, this.id, this.slug});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
      id: json['id'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'slug': slug,
    };
  }

  @override
  List<Object?> get props => [id];
}
