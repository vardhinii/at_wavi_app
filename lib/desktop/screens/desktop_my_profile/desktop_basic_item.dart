import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/utils.dart';
import 'package:at_wavi_app/desktop/widgets/textfields/desktop_textfield.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DesktopBasicItem extends StatelessWidget {
  BasicData data;
  Function(String) onValueChanged;

  DesktopBasicItem({
    required this.data,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            child: Text(
              getTitle(data.displayingAccountName ?? ''),
              style: TextStyle(
                  fontSize: 12,
                  color: appTheme.secondaryTextColor,
                  fontFamily: 'Inter'),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: DesktopTextField(
              controller: TextEditingController(
                text: data.value,
              ),
              readOnly: true,
              borderRadius: 10,
              hasUnderlineBorder: false,
              onChanged: (text) {
                onValueChanged(text);
              },
            ),
          ),
        ],
      ),
    );
  }
}