import 'dart:async';
import 'dart:developer';

import 'package:app_usage/app_usage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/services/firebaseServices/firebase_crud_services.dart';
import 'package:usage_stats/usage_stats.dart';

class PhoneUsageDriverController extends GetxController {
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  Timer? timer;
  List<AppUsageInfo> usage = [];
  Map<String, dynamic> newMap = {};
  RxBool isCheckIn = false.obs;
  RxBool isLoading = false.obs;

  /// USAGE STATS PACKAGE

  // Future<void> getUsageData() async {
  //   log('Executed');
  //   try {
  //     log('Time Duration : ${endDate?.difference(startDate).inSeconds}');
  //     List<UsageInfo> usageStats =
  //         await UsageStats.queryUsageStats(startDate, DateTime.now());
  //     if (usageStats.isEmpty) {
  //       log('Empty List');
  //     } else {
  //       for (var usage in usageStats) {
  //         log(usage.packageName.toString());
  //         log(_formatTimestamp(int.parse(usage.firstTimeStamp.toString())));
  //         log(_formatTimestamp(int.parse(usage.lastTimeStamp.toString())));
  //         log(usage.totalTimeInForeground.toString());
  //       }
  //     }
  //   } on AppUsageException catch (exception) {
  //     log(exception.toString());
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   startDate = DateTime.now();
  // }

  /// APP USAGE INFO PACKAGE

  Future<List<AppUsageInfo>> getUsageData() async {
    log('Executed');
    try {
      log('Time Duration : ${endDate?.difference(startDate).inSeconds}');

      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, DateTime.now());
      startDate = DateTime.now();
      if (infoList.isEmpty) {
        log('Empty List');
        return [];
      } else {
        // for (var info in infoList) {
        //   log(info.toString());
        //   log(info.startDate.toString());
        //   log(info.endDate.toString());
        //   log(info.usage.inSeconds.toString());
        // }
        await addAppUsage(usage, infoList);
        return infoList;
      }
    } on AppUsageException catch (exception) {
      log(exception.toString());
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> startTimer() async {
    await FirebaseCRUDServices.instance.updateDocumentSingleKey(
        collection: usersCollection,
        docId: userModelGlobal.value!.userId!,
        key: 'isDriving',
        value: true);
    await FirebaseCRUDServices.instance.updateDocumentSingleKey(
        collection: usersCollection,
        docId: userModelGlobal.value!.userId!,
        key: 'driveStartTime',
        value: DateTime.now());

    final isAllowed = await UsageStats.checkUsagePermission();
    log(isAllowed.toString());
    if (isAllowed!) {
      usage = await AppUsage().getAppUsage(
          DateTime.now(), DateTime.now().subtract(Duration(hours: 12)));
      log('Timer Started');
      timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
        endDate = DateTime.now();
        usage = await getUsageData();
      });
    } else {
      await UsageStats.grantUsagePermission();
      log('Permission Denied');
    }
  }

  void cancelTimer() async {
    isLoading.value = true;

    await FirebaseCRUDServices.instance.updateDocumentSingleKey(
      collection: usersCollection,
      docId: userModelGlobal.value!.userId!,
      key: 'isDriving',
      value: false,
    );
    await usersCollection
        .doc(userModelGlobal.value?.userId)
        .collection('appUsage')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    });
    isLoading.value = false;
    log('Timer Cancelled');
    if (timer != null) {
      timer?.cancel();
    }
  }

  Future<void> addAppUsage(
      List<AppUsageInfo> previousInfo, List<AppUsageInfo> newInfo) async {
    Map<String, dynamic> usageDifference = {};

    Map<String, AppUsageInfo> previousInfoMap = {
      for (var info in previousInfo) info.packageName: info
    };
    for (var newApp in newInfo) {
      String packageName = newApp.packageName;
      int newDuration = newApp.usage.inSeconds;

      if (previousInfoMap.containsKey(packageName)) {
        int previousDuration = previousInfoMap[packageName]!.usage.inSeconds;
        int durationDifference = newDuration - previousDuration;
        usageDifference[packageName] = durationDifference.toString();
      }
    }
    usageDifference.forEach(
      (key, value) {
        if (newMap.containsKey(key)) {
          newMap[key] = (int.parse(newMap[key]) + int.parse(value)).toString();
        } else {
          newMap[key] = value;
        }
      },
    );
    log('New Map : $newMap');
    if (newMap.isNotEmpty) {
      newMap.forEach(
        (key, value) async {
          if (value != '0') {
            await usersCollection
                .doc(userModelGlobal.value?.userId)
                .collection('appUsage')
                .doc(key)
                .set({'duration': value, 'title': key});
          }
        },
      );
    }
  }
}
