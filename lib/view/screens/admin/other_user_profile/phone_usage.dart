import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/model/user/user_model.dart';
import 'package:lanefocus/view/widget/custom_drop_down_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PhoneUsage extends StatelessWidget {
  PhoneUsage({required this.otherUserId, required this.startTime, super.key});
  final String otherUserId;
  final DateTime startTime;

  final List<ChartData> chartData = [
    ChartData('Mon', 80),
    ChartData('Tue', 60),
    ChartData('Wed', 30),
    ChartData('Thu', 40),
    ChartData('Fri', 50),
    ChartData('Sat', 70),
    ChartData('Sun', 60),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: 'Phone Usage'),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CustomCard(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: [
            //           Row(
            //             children: [
            //               Expanded(
            //                 child: MyText(
            //                   text: 'Phone Usage',
            //                   weight: FontWeight.w500,
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 120,
            //                 child: CustomDropDown(
            //                   hint: 'Weekly Statistics',
            //                   items: [],
            //                   onChanged: (v) {},
            //                   selectedValue: null,
            //                   marginBottom: 0,
            //                 ),
            //               ),
            //             ],
            //           ),
            //           SizedBox(
            //             height: 16,
            //           ),
            //           SizedBox(
            //             height: 220,
            //             child: SfCartesianChart(
            //               plotAreaBorderColor: Colors.transparent,
            //               plotAreaBorderWidth: 0,
            //               margin: EdgeInsets.zero,
            //               primaryXAxis: CategoryAxis(
            //                 title: AxisTitle(
            //                   text: 'Days',
            //                   textStyle: TextStyle(
            //                     color: kBlackColor,
            //                     fontSize: 10,
            //                     fontWeight: FontWeight.w400,
            //                     fontFamily: AppFonts.SPLINE_SANS,
            //                   ),
            //                 ),
            //                 labelStyle: TextStyle(
            //                   fontSize: 8,
            //                   color: kQuaternaryColor,
            //                   fontWeight: FontWeight.w400,
            //                   fontFamily: AppFonts.SPLINE_SANS,
            //                 ),
            //                 majorGridLines: MajorGridLines(
            //                   width: 0,
            //                 ),
            //                 axisLine: AxisLine(
            //                   color: kQuaternaryColor,
            //                   width: 1.0,
            //                 ),
            //                 majorTickLines: MajorTickLines(
            //                   color: Colors.transparent,
            //                 ),
            //               ),
            //               primaryYAxis: NumericAxis(
            //                 minimum: 0,
            //                 maximum: 100,
            //                 interval: 10,
            //                 title: AxisTitle(
            //                   text: 'Time (minutes)',
            //                   textStyle: TextStyle(
            //                     color: kBlackColor,
            //                     fontSize: 10,
            //                     fontWeight: FontWeight.w400,
            //                     fontFamily: AppFonts.SPLINE_SANS,
            //                   ),
            //                 ),
            //                 labelStyle: TextStyle(
            //                   fontSize: 8,
            //                   color: kQuaternaryColor,
            //                   fontWeight: FontWeight.w400,
            //                   fontFamily: AppFonts.SPLINE_SANS,
            //                 ),
            //                 majorGridLines: MajorGridLines(
            //                   color: kInputBorderColor,
            //                 ),
            //                 majorTickLines: MajorTickLines(
            //                   color: Colors.transparent,
            //                 ),
            //                 axisLine: AxisLine(
            //                   color: Colors.transparent,
            //                 ),
            //               ),
            //               series: <CartesianSeries>[
            //                 ColumnSeries<ChartData, String>(
            //                   dataSource: chartData,
            //                   xValueMapper: (ChartData data, _) => data.x,
            //                   yValueMapper: (ChartData data, _) => data.y,
            //                   width: 0.4,
            //                   spacing: 0.2,
            //                   color: kBlueColor,
            //                   borderRadius: BorderRadius.only(
            //                     topLeft: Radius.circular(8),
            //                     topRight: Radius.circular(8),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            MyText(
              text: 'What is Phone Usage?',
              size: 16,
              weight: FontWeight.w500,
              paddingTop: 20,
              paddingBottom: 8,
            ),
            MyText(
              text:
                  'Phone usage involves utilizing mobile devices for calls, texting, browsing, and app usage, while excessive or distracted use may lead to safety hazards and social disconnection.',
              size: 12,
              weight: FontWeight.w300,
            ),
            MyText(
              text: 'Apps used while driving',
              size: 16,
              weight: FontWeight.w500,
              paddingTop: 20,
              paddingBottom: 8,
            ),
            StreamBuilder(
              stream: usersCollection
                  .doc(otherUserId)
                  .collection('appUsage')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: kSecondaryColor,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: MyText(text: 'No Usage'),
                  );
                } else {
                  List<AppUsageModel> usages = [];
                  snapshot.data?.docs.forEach(
                    (data) {
                      usages.add(
                        AppUsageModel.fromMap(data.data()),
                      );
                    },
                  );
                  return usages.length == 0
                      ? Center(
                          child: MyText(text: 'No Usage'),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: usages.length,
                          itemBuilder: (context, index) {
                            log(usages[index].title.toString());

                            final totalDuration =
                                getDurationInSeconds(startTime);
                            log(totalDuration.toString());
                            return _AppTile(
                              appIcon: Assets.imagesAndroidIcon,
                              name: extractAppName(usages[index].title!),
                              timing:
                                  '${usages[index].duration ?? '0'} seconds',
                              value:
                              getPercentage(totalDuration,
                                  double.parse(usages[index].duration!)),
                            );
                          },
                        );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  double getPercentage(double totalDuration, double duration) {
    return duration / totalDuration;
  }

  double getDurationInSeconds(DateTime start) {
    // Calculate the difference between end and start
    Duration difference = DateTime.now().difference(start);

    // Return the duration in seconds
    return difference.inSeconds.toDouble();
  }

  String extractAppName(String packageName) {
    // Split the package name by dots
    List<String> parts = packageName.split('.');

    // Check if the package name has at least two parts
    if (parts.length > 1) {
      // Extract the app name part (assumed to be the second part)
      String appName = parts[1];

      // Capitalize the first letter and return
      return appName[0].toUpperCase() + appName.substring(1);
    }

    // Return an empty string if the package name format is invalid
    return '';
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
  );
  final String x;
  final double y;
}

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withOpacity(0.1),
            blurRadius: 18,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AppTile extends StatelessWidget {
  final String appIcon, name, timing;
  final double value;
  const _AppTile({
    super.key,
    required this.appIcon,
    required this.name,
    required this.timing,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kInputColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: kInputBorderColor,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            color: kPrimaryColor,
            child: Center(
              child: Image.asset(
                appIcon,
                height: 26,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: name,
                  size: 12,
                  lineHeight: 1.2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: 'Timing',
                        size: 10,
                        color: kQuaternaryColor,
                      ),
                    ),
                    MyText(
                      text: timing,
                      size: 10,
                      color: kQuaternaryColor,
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                LinearPercentIndicator(
                  percent: value,
                  padding: EdgeInsets.zero,
                  animationDuration: 1000,
                  lineHeight: 7,
                  animation: true,
                  progressColor: kBlueColor,
                  backgroundColor: kBlueColor.withOpacity(0.4),
                  barRadius: Radius.circular(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
