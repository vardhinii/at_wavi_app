import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DesktopSettingSwitchWidget extends StatelessWidget {
  final IconData prefixIcon;
  final String title;

  const DesktopSettingSwitchWidget({
    Key? key,
    required this.prefixIcon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 24),
          Icon(
            prefixIcon,
            color: appTheme.primaryTextColor,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: appTheme.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 16),
          Switch(
            value: true,
            onChanged: (value) {},
            activeColor: appTheme.primaryColor,
          ),
          SizedBox(width: 24),
        ],
      ),
    );
  }
}