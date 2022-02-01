class ProfileModel {
  final String? uid;
  final String? name;
  final String? phoneNumber;
  final String? imageURL;

  ProfileModel({this.uid, this.name, this.phoneNumber, this.imageURL});

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'name' : name,
    'phoneNumber' : phoneNumber,
    'imageURL'  : imageURL,
  };

  factory ProfileModel.fromJson (Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      imageURL: json['imageURL'],
    );
  }
}
