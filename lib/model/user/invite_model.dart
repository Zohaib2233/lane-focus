class InviteModel {
  String? inviteId;
  String? circleId;
  String? ownerId;
  String? inviteCode;
  String? inviteLink;

  InviteModel(
      {this.inviteId,
      this.circleId,
      this.ownerId,
      this.inviteCode,
      this.inviteLink});

  // Convert an InviteModel into a Map
  Map<String, dynamic> toMap() {
    return {
      if (inviteId != null) 'inviteId': inviteId,
      if (circleId != null) 'circleId': circleId,
      if (ownerId != null) 'ownerId': ownerId,
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (inviteLink != null) 'inviteLink': inviteLink,
    };
  }

  // Create an InviteModel from a Map
  factory InviteModel.fromMap(Map<String, dynamic> map) {
    return InviteModel(
      inviteId: map.containsKey('inviteId') ? map['inviteId'] : '',
      circleId: map.containsKey('circleId') ? map['circleId'] : '',
      ownerId: map.containsKey('ownerId') ? map['ownerId'] : '',
      inviteCode: map.containsKey('inviteCode') ? map['inviteCode'] : '',
      inviteLink: map.containsKey('inviteLink') ? map['inviteLink'] : '',
    );
  }
}
