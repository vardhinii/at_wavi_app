import 'package:at_wavi_app/desktop/routes/desktop_route_names.dart';
import 'package:at_wavi_app/desktop/routes/desktop_routes.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:showcaseview/showcaseview.dart';

class DesktopNotificationItem extends StatelessWidget {
  Color backgroundColor;
  NotificationItemType type;
  BuildContext mainContext;

  DesktopNotificationItem({
    required this.backgroundColor,
    required this.mainContext,
    this.type = NotificationItemType.Normal,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 4,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(90.0),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: appTheme.borderColor,
                borderRadius: BorderRadius.all(Radius.circular(90)),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@lauren changed her profile picture',
                  style: TextStyle(
                    color: appTheme.primaryTextColor,
                    fontSize: 10,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '15 mins ago',
                  style: TextStyle(
                    color: appTheme.secondaryTextColor,
                    fontSize: 11,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                type != NotificationItemType.Normal
                    ? GestureDetector(
                        onTap: () async {
                          ShowCaseWidget.of(mainContext)!.dismiss();
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          DesktopSetupRoutes.push(
                            context,
                            DesktopRoutes.DESKTOP_PROFILE,
                            arguments: {
                              'index': 1,
                            },
                          );
                        },
                        child: Container(
                          color: appTheme.primaryLighterColor,
                          padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 4,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(90.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: appTheme.borderColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lauren London',
                                      style: TextStyle(
                                        color: appTheme.primaryTextColor,
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '@lauren',
                                      style: TextStyle(
                                        color: appTheme.secondaryTextColor,
                                        fontSize: 11,
                                        fontFamily: 'Inter',
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }
}