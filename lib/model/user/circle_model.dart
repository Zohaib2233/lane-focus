class CircleModel {
  String? circleId;
  String? name;
  String? imgUrl;
  List<String>? members;
  String? ownerId;
  String? inviteLink; // Added field
  String? inviteCode; // Added field

  CircleModel({this.circleId, this.name, this.imgUrl, this.members, this.ownerId, this.inviteLink, this.inviteCode});

  // Convert a CircleModel into a Map
  Map<String, dynamic> toMap() {
    return {
      if (circleId != null) 'circleId': circleId,
      if (name != null) 'name': name,
      if (imgUrl != null) 'imgUrl': imgUrl,
      if (members != null) 'members': members,
      if (ownerId != null) 'ownerId': ownerId,
      if (inviteLink != null) 'inviteLink': inviteLink, // Added field
      if (inviteCode != null) 'inviteCode': inviteCode, // Added field
    };
  }

  // Create a CircleModel from a Map
  factory CircleModel.fromMap(Map<String, dynamic> map) {
    return CircleModel(
      circleId: map.containsKey('circleId') ? map['circleId'] : '',
      name: map.containsKey('name') ? map['name'] : '',
      imgUrl: map.containsKey('imgUrl') ? map['imgUrl'] : '',
      members: map.containsKey('members') ? List<String>.from(map['members']) : [],
      ownerId: map.containsKey('ownerId') ? map['ownerId'] : '',
      inviteLink: map.containsKey('inviteLink') ? map['inviteLink'] : '', // Added field
      inviteCode: map.containsKey('inviteCode') ? map['inviteCode'] : '', // Added field
    );
  }
}
