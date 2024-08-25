import 'dart:async';

import 'package:get/get.dart';

class GeneralController extends GetxController {
  static GeneralController instance = Get.find<GeneralController>();
  RxInt secondsRemaining = 60.obs;
  Timer? _timer;
  RxBool isTimerCompleted = false.obs;
  RxBool isLoading = false.obs;
  RxString phoneNumberDialCode = ''.obs;

  void startTimer() {
    secondsRemaining.value = 60;
    isTimerCompleted.value = false;
    const thirtySeconds = const Duration(seconds: 1);
    secondsRemaining.value = 60;
    isTimerCompleted.value = false;
    _timer = Timer.periodic(
      thirtySeconds,
      (Timer timer) {
        if (secondsRemaining.value < 1) {
          timer.cancel();
          isTimerCompleted.value = true;
        } else {
          secondsRemaining.value -= 1;
        }
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
