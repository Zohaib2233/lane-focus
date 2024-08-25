import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/view/screens/admin/other_user_profile/phone_usage.dart';
import 'package:lanefocus/view/widget/custom_drop_down_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RestrictedAppUsage extends StatelessWidget {
  RestrictedAppUsage({super.key});

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
      appBar: simpleAppBar(title: 'Restricted Apps Usage'),
      body: ListView(
        padding: AppSizes.DEFAULT,
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MyText(
                            text: 'Mobile Specific Apps Usage',
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: CustomDropDown(
                            hint: 'Weekly Statistics',
                            items: [],
                            onChanged: (v) {},
                            selectedValue: null,
                            marginBottom: 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 220,
                      child: SfCartesianChart(
                        plotAreaBorderColor: Colors.transparent,
                        plotAreaBorderWidth: 0,
                        margin: EdgeInsets.zero,
                        primaryXAxis: CategoryAxis(
                          title: AxisTitle(
                            text: 'Days',
                            textStyle: TextStyle(
                              color: kBlackColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.SPLINE_SANS,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 8,
                            color: kQuaternaryColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFonts.SPLINE_SANS,
                          ),
                          majorGridLines: MajorGridLines(
                            width: 0,
                          ),
                          axisLine: AxisLine(
                            color: kQuaternaryColor,
                            width: 1.0,
                          ),
                          majorTickLines: MajorTickLines(
                            color: Colors.transparent,
                          ),
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 100,
                          interval: 10,
                          title: AxisTitle(
                            text: 'Time (minutes)',
                            textStyle: TextStyle(
                              color: kBlackColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.SPLINE_SANS,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 8,
                            color: kQuaternaryColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFonts.SPLINE_SANS,
                          ),
                          majorGridLines: MajorGridLines(
                            color: kInputBorderColor,
                          ),
                          majorTickLines: MajorTickLines(
                            color: Colors.transparent,
                          ),
                          axisLine: AxisLine(
                            color: Colors.transparent,
                          ),
                        ),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            width: 0.4,
                            spacing: 0.2,
                            color: kBlueColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          MyText(
            text: 'Apps',
            size: 16,
            weight: FontWeight.w500,
            paddingTop: 20,
            paddingBottom: 8,
          ),
          ...List.generate(
            5,
            (index) {
              return _AppTile(
                appIcon: Assets.imagesWhatsappIcon,
                name: 'WhatsApp',
                timing: '2h 30 mint',
                value: 0.5,
              );
            },
          ),
        ],
      ),
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
