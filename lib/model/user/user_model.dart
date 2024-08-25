class UserModel {
  String? userId,
      email,
      role,
      dialCode,
      fullName,
      phone,
      profileImg,
      signupMethod,
      token;

  int? overSpeedCount;
  DateTime? dob, joinedOn, driveStartTime;
  bool? locOn, onBoardComp, isOnline, bluetoothOn, notifOn, isDriving;
  Map<String, dynamic>? currentLoc; // Add GeoPoint field
  DrivingModel? drivingModel;
  List<AppUsageModel>? appUsage;
  List<String>? emergencyContacts, circlesJoined, circlesAdmin;

  // Constructor
  UserModel({
    this.userId,
    this.overSpeedCount,
    this.email,
    this.role,
    this.dialCode,
    this.fullName,
    this.phone,
    this.profileImg,
    this.signupMethod,
    this.token,
    this.dob,
    this.joinedOn,
    this.locOn,
    this.isOnline,
    this.onBoardComp,
    this.bluetoothOn,
    this.notifOn,
    this.isDriving,
    this.currentLoc, // Include GeoPoint in constructor
    this.drivingModel,
    this.emergencyContacts,
    this.driveStartTime,
    this.circlesJoined,
    this.circlesAdmin,
  });

  // Factory method to create a UserModel instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json.containsKey('userId') ? json['userId'] : null,
      email: json.containsKey('email') ? json['email'] : null,
      role: json.containsKey('role') ? json['role'] : null,
      dialCode: json.containsKey('dialCode') ? json['dialCode'] : null,
      fullName: json.containsKey('fullName') ? json['fullName'] : null,
      phone: json.containsKey('phone') ? json['phone'] : null,
      isOnline: json.containsKey('isOnline') ? json['isOnline'] : null,
      profileImg: json.containsKey('profileImg') ? json['profileImg'] : null,
      signupMethod:
          json.containsKey('signupMethod') ? json['signupMethod'] : null,
      token: json.containsKey('token') ? json['token'] : null,
      dob: json.containsKey('dob') ? json['dob'].toDate() : null,
      joinedOn: json.containsKey('joinedOn') ? json['joinedOn'].toDate() : null,
      locOn: json.containsKey('locOn') ? json['locOn'] : null,
      bluetoothOn: json.containsKey('bluetoothOn') ? json['bluetoothOn'] : null,
      notifOn: json.containsKey('notifOn') ? json['notifOn'] : null,
      isDriving: json.containsKey('isDriving') ? json['isDriving'] : null,
      overSpeedCount:
          json.containsKey('overSpeedCount') ? json['overSpeedCount'] : 0,
      onBoardComp: json.containsKey('onBoardComp') ? json['onBoardComp'] : null,
      currentLoc: json.containsKey('currentLoc') ? json['currentLoc'] : null,
      drivingModel: json.containsKey('drivingModel')
          ? DrivingModel.fromMap(json['drivingModel'])
          : null,
      emergencyContacts: json.containsKey('emergencyContacts')
          ? List<String>.from(json['emergencyContacts'])
          : [],
      driveStartTime: json.containsKey('driveStartTime')
          ? json['driveStartTime'].toDate()
          : null,
      circlesJoined: json.containsKey('circlesJoined')
          ? List<String>.from(json['circlesJoined'])
          : [],
      circlesAdmin: json.containsKey('circlesAdmin')
          ? List<String>.from(json['circlesAdmin'])
          : [],
    );
  }

  // Method to convert UserModel instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userId != null) data['userId'] = userId;
    if (email != null) data['email'] = email;
    if (role != null) data['role'] = role;
    if (dialCode != null) data['dialCode'] = dialCode;
    if (fullName != null) data['fullName'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (profileImg != null) data['profileImg'] = profileImg;
    if (signupMethod != null) data['signupMethod'] = signupMethod;
    if (token != null) data['token'] = token;
    if (dob != null) data['dob'] = dob!;
    if (joinedOn != null) data['joinedOn'] = joinedOn!;
    if (isOnline != null) data['isOnline'] = isOnline;
    if (notifOn != null) data['notifOn'] = notifOn;
    if (bluetoothOn != null) data['bluetoothOn'] = bluetoothOn;
    if (locOn != null) data['locOn'] = locOn;
    if (isDriving != null) data['isDriving'] = isDriving;
    if (overSpeedCount != null) data['overSpeedCount'] = overSpeedCount;
    if (onBoardComp != null) data['onBoardComp'] = onBoardComp;
    if (currentLoc != null) {
      data['currentLoc'] = currentLoc;
    }
    if (drivingModel != null) data['drivingModel'] = drivingModel?.toMap();

    if (appUsage != null) data['appUsage'] = appUsage?.map((u) => u.toMap());

    if (circlesJoined != null) data['circlesJoined'] = circlesJoined;
    if (circlesAdmin != null) data['circlesAdmin'] = circlesAdmin;

    if (emergencyContacts != null) {
      data['emergencyContacts'] = emergencyContacts;
    }
    if (driveStartTime != null) data['driveStartTime'] = driveStartTime!;
    return data;
  }
}

class DrivingModel {
  int? overSpeedCount;
  String? totalSpeed;
  DateTime? drivingSince;
  DateTime? drivingTill;
  Map<String, dynamic>? startLoc, destinationLoc;

  DrivingModel(
      {this.overSpeedCount,
      this.totalSpeed,
      this.drivingSince,
      this.drivingTill,
      this.startLoc,
      this.destinationLoc});

  // Convert a DrivingModel into a Map
  Map<String, dynamic> toMap() {
    return {
      if (overSpeedCount != null) 'overSpeedCount': overSpeedCount,
      if (totalSpeed != null) 'totalSpeed': totalSpeed,
      if (drivingSince != null) 'drivingSince': drivingSince,
      if (drivingTill != null) 'drivingTill': drivingTill,
      if (startLoc != null) 'startLoc': startLoc,
      if (destinationLoc != null) 'destinationLoc': destinationLoc,
    };
  }

  // Create a DrivingModel from a Map
  factory DrivingModel.fromMap(Map<String, dynamic> map) {
    return DrivingModel(
      overSpeedCount:
          map.containsKey('overSpeedCount') ? map['overSpeedCount'] : 0,
      totalSpeed: map.containsKey('totalSpeed') ? map['totalSpeed'] : '',
      drivingSince: map.containsKey('drivingSince')
          ? map['drivingSince'].toDate()
          : DateTime.now(),
      drivingTill: map.containsKey('drivingTill')
          ? map['drivingTill'].toDate()
          : DateTime.now(),
      startLoc: map.containsKey('startLoc')
          ? Map<String, dynamic>.from(map['startLoc'])
          : null,
      destinationLoc: map.containsKey('destinationLoc')
          ? Map<String, dynamic>.from(map['destinationLoc'])
          : null,
    );
  }
}

class AppUsageModel {
  String? title, duration;

  AppUsageModel({this.title, this.duration});

  AppUsageModel.fromMap(Map<String, dynamic> map) {
    title = map.containsKey('title') ? map['title'] ?? '' : '';
    duration = map.containsKey('duration') ? map['duration'] ?? '' : '';
  }

  Map<String, dynamic> toMap() {
    return {
      if (title != null) 'title': title,
      if (duration != null) 'duration': duration,
    };
  }
}
