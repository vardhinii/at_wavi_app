import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/dialog_utils.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/textfields/desktop_textfield.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

class DesktopLoginPage extends StatefulWidget {
  const DesktopLoginPage({Key? key}) : super(key: key);

  @override
  _DesktopLoginPageState createState() => _DesktopLoginPageState();
}

class _DesktopLoginPageState extends State<DesktopLoginPage> {
  late TextEditingController atSignTextEditingController;
  var atClientPrefernce;

  @override
  void initState() {
    atSignTextEditingController = TextEditingController(
      text: '',
    );
    //  _checkToOnboard();
    super.initState();
  }

  void _checkToOnboard() async {
    String? currentatSign = await BackendService().getAtSign();
    await BackendService()
        .getAtClientPreference()
        .then((value) => atClientPrefernce = value)
        .catchError((e) => print(e));

    if (currentatSign != null && currentatSign != '') {
      await BackendService()
          .onboard(currentatSign, atClientPreference: atClientPrefernce);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 32),
              child: Image.asset(
                'assets/images/logo_dark.png',
                fit: BoxFit.fitHeight,
                height: 24,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Strings.desktop_all_links_in_one,
                  style: TextStyle(
                    fontSize: 40,
                    color: appTheme.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  Strings.desktop_create_persona,
                  style: TextStyle(
                    fontSize: 14,
                    color: appTheme.secondaryTextColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Strings.desktop_sign,
                  style: TextStyle(
                    fontSize: 18,
                    color: appTheme.primaryTextColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                _buildLoginTextField(appTheme),
                SizedBox(
                  height: 16,
                ),
                DesktopButton(
                  width: 540,
                  backgroundColor: appTheme.primaryColor,
                  title: Strings.desktop_send,
                  onPressed: () async {
                    await showPassCodeDialog(context,
                        atSign: atSignTextEditingController.text);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    BackendService().onboard('');
                  },
                  child: Text(
                    Strings.desktop_get_sign,
                    style: TextStyle(
                      fontSize: 12,
                      color: appTheme.primaryColor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            _buildFooterWidget(appTheme),
          ],
        ),
      ),
    );
  }

  _buildLoginTextField(AppTheme appTheme) {
    return DesktopTextField(
      controller: atSignTextEditingController,
      hint: Strings.desktop_enter_sign,
      backgroundColor: ColorConstants.LIGHT_GREY,
      borderRadius: 5,
      textSize: 14,
      hasUnderlineBorder: false,
      contentPadding: 20,
      onChanged: (text) {},
    );
  }

  _buildFooterWidget(AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.desktop_wavi,
          style: TextStyle(
            fontSize: 14,
            color: appTheme.primaryTextColor,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          Strings.desktop_company_copyrights,
          style: TextStyle(
            fontSize: 11,
            color: appTheme.secondaryTextColor,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}