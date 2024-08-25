import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.headingWeight,
    this.labelText,
  });

  final List<dynamic>? items;
  String? selectedValue, labelText;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  Color? bgColor;
  double? marginBottom, width;
  FontWeight? headingWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          items: items!
              .map(
                (item) => DropdownMenuItem<dynamic>(
                  value: item,
                  child: MyText(
                    text: item,
                    size: 10,
                  ),
                ),
              )
              .toList(),
          value: selectedValue,
          onChanged: onChanged,
          isExpanded: false,
          customButton: Container(
            height: 24,
            padding: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: kGreyColor2,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyText(
                    text: selectedValue ?? hint,
                    size: 10,
                    color: kTertiaryColor,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                Image.asset(
                  Assets.imagesDropDown,
                  height: 6,
                ),
              ],
            ),
          ),
          // buttonStyleData: ButtonStyleData(
          //   height: 24,
          //   overlayColor: MaterialStatePropertyAll(
          //     kSecondaryColor.withOpacity(0.1),
          //   ),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(4),
          //   ),
          // ),
          menuItemStyleData: MenuItemStyleData(
            height: 40,
            overlayColor: MaterialStatePropertyAll(
              kSecondaryColor.withOpacity(0.1),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            elevation: 3,
            maxHeight: 300,
            offset: Offset(0, -5),
            decoration: BoxDecoration(
              border: Border.all(
                color: kBlackColor.withOpacity(0.06),
                width: 0.4,
              ),
              borderRadius: BorderRadius.circular(5),
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
