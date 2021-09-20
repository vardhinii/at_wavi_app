import 'package:at_wavi_app/desktop/screens/desktop_profile/desktop_profile_info_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_search_model.dart';

class DesktopSearchPage extends StatefulWidget {
  const DesktopSearchPage({Key? key}) : super(key: key);

  @override
  _DesktopSearchPageState createState() => _DesktopSearchPageState();
}

class _DesktopSearchPageState extends State<DesktopSearchPage> {
  late DesktopSearchModel _model;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopSearchModel(userPreview: userPreview);
        return _model;
      },
      child: Container(
        color: appTheme.backgroundColor,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: TextEditingController(
                text: '',
              ),
              autofocus: true,
              style: TextStyle(
                fontSize: 12,
                color: appTheme.primaryTextColor,
                fontFamily: 'Inter',
              ),
              onChanged: (text) {
                _model.searchUser(text);
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(
                  color: appTheme.secondaryTextColor,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
                filled: true,
                fillColor: appTheme.borderColor,
                hintText: Strings.desktop_search_sign,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    Strings.desktop_prefix_sign,
                    style: TextStyle(
                      fontSize: 12,
                      color: appTheme.primaryTextColor,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              Strings.desktop_recent_search,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                color: appTheme.primaryTextColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Consumer<DesktopSearchModel>(
                builder: (_, model, child) {
                  if (model.users.isEmpty) {
                    return Center(
                      child: Container(
                        child: Text(
                          'Empty',
                          style: TextStyle(
                            color: appTheme.primaryTextColor,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.users.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(90.0),
                                child: Container(
                                  width: 56,
                                  height: 56,
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
                                      'User name 0',
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
                                      '@sign',
                                      style: TextStyle(
                                        color: appTheme.secondaryTextColor,
                                        fontSize: 11,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 28,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
