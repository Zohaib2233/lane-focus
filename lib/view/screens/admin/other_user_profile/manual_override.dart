import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_sizes.dart';
import 'package:lanefocus/view/screens/admin/other_user_profile/phone_usage.dart';
import 'package:lanefocus/view/widget/custom_drop_down_widget.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';
import 'package:lanefocus/view/widget/simple_app_bar_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ManualOverrides extends StatelessWidget {
  ManualOverrides({super.key});

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
      appBar: simpleAppBar(title: 'Manual overrides'),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              text: 'Hard Braking',
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
                              text: 'Km/h',
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
              text: 'What is Manual overrides?',
              size: 16,
              weight: FontWeight.w500,
              paddingTop: 20,
              paddingBottom: 8,
            ),
            MyText(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam id condimentum nisi. In leo risus, dignissim ut dignissim eget, venenatis quis orci. Quisque id feugiat dolor, vel varius lacus. Nulla bibendum ex velit, et molestie velit rhoncus a. ',
              size: 12,
              weight: FontWeight.w300,
            ),
          ],
        ),
      ),
    );
  }
}
