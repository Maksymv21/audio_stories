import 'dart:io';

class ProfileModel {
  ProfileModel({
    this.uid,
    this.name,
    this.phoneNumber,
    this.imageURL,
    this.avatar,
  });

  final String? uid;
  final String? name;
  final String? phoneNumber;
  final String? imageURL;
  final File? avatar;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'phoneNumber': phoneNumber,
        'imageURL': imageURL,
      };

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      imageURL: json['imageURL'],
    );
  }
}
