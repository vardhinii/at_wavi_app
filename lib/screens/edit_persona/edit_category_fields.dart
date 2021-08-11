import 'dart:typed_data';

import 'package:at_wavi_app/common_components/add_custom_content_button.dart';
import 'package:at_wavi_app/common_components/public_private_bottomsheet.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/at_key_constants.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditCategoryFields extends StatefulWidget {
  final AtCategory category;
  final String filedHeading;
  EditCategoryFields({required this.category, required this.filedHeading});

  @override
  _EditCategoryFieldsState createState() => _EditCategoryFieldsState();
}

class _EditCategoryFieldsState extends State<EditCategoryFields> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.white,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 5),
                          Text(
                            widget.filedHeading,
                            style: TextStyles.boldText(Colors.black, size: 16),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showPublicPrivateBottomSheet(
                            onPublicClicked: () {},
                            onPrivateClicked: () {},
                            height: 160);
                      },
                      child: GestureDetector(
                        onTap: () {
                          // print('basic data: ${}');
                        },
                        child: Icon(
                            isAllFieldsPrivate() ? Icons.lock : Icons.public),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 35),
              Form(
                key: _formKey,
                child: Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getAllInputFields(),
                  ),
                )),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AddCustomContentButton(
                  text: 'Add custom content',
                  onTap: () {
                    SetupRoutes.push(context, Routes.ADD_CUSTOM_FIELD,
                        arguments: {
                          'onSave': (BasicData data) {
                            List<BasicData>? customFields = UserPreview()
                                .user()!
                                .customFields[widget.category.name];
                            if (customFields != null) {
                              setState(() {
                                customFields.add(data);
                                UserPreview()
                                        .user()!
                                        .customFields[widget.category.name] =
                                    customFields;
                              });
                            }
                          },
                          'isEdit': false
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getAllInputFields() {
    return [...getDefinedInputFields(), ...getCustomInputFields()];
  }

  List<Widget> getDefinedInputFields() {
    var definedFieldsWidgets = <Widget>[];
    var userMap = User.toJson(UserPreview().user());
    List<String> fields = FieldNames().getFieldList(widget.category);

    for (var field in userMap.entries) {
      if (field.key != null &&
          fields.contains(field.key) &&
          field.value != null &&
          field.value.value != null) {
        var widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                field.key,
                style: TextStyles.lightText(
                    ColorConstants.black.withOpacity(0.5),
                    size: 16),
              ),
            ),
            inputField(field.value),
            Divider(thickness: 1, height: 1),
            SizedBox(height: 20)
          ],
        );

        definedFieldsWidgets.add(widget);
      }
    }
    return definedFieldsWidgets;
  }

  List<Widget> getCustomInputFields() {
    var customFieldsWidgets = <Widget>[];
    List<BasicData>? customFields =
        UserPreview().user()!.customFields[widget.category.name];

    if (customFields != null) {
      for (var basicData in customFields) {
        if (basicData.accountName != null && basicData.value != null) {
          var widget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: checkForCustomContentType(basicData),
              ),
            ],
          );
          customFieldsWidgets.add(widget);
        }
      }
    }
    return customFieldsWidgets;
  }

  Widget checkForCustomContentType(BasicData basicData) {
    if (basicData.type == CustomContentType.Text.name ||
        basicData.type == CustomContentType.Number.name ||
        basicData.type == CustomContentType.Link.name ||
        basicData.type == CustomContentType.Youtube.name) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              basicData.accountName!,
              style: TextStyles.lightText(ColorConstants.black.withOpacity(0.5),
                  size: 16),
            ),
          ),
          inputField(basicData),
          Divider(thickness: 1, height: 1),
          SizedBox(height: 20)
        ],
      );

      // to show image content
    } else if (basicData.type == CustomContentType.Image.name) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  basicData.accountName!,
                  style: TextStyles.lightText(
                      ColorConstants.black.withOpacity(0.5),
                      size: 16),
                ),
              ),
              InkWell(
                onTap: () {
                  SetupRoutes.push(context, Routes.ADD_CUSTOM_FIELD,
                      arguments: {
                        'onSave': (BasicData data) {
                          List<BasicData>? customFields = UserPreview()
                              .user()!
                              .customFields[widget.category.name];
                          var index = customFields!.indexOf(basicData);
                          setState(() {
                            customFields[index] = data;
                          });
                        },
                        'basicData': basicData,
                        'isEdit': true
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.edit),
                ),
              )
            ],
          ),
          imageField(basicData),
          Divider(thickness: 1, height: 1),
          SizedBox(height: 20)
        ],
      );
    }
    return SizedBox();
  }

  Widget inputField(BasicData basicData, {bool isCustomField = false}) {
    return Slidable(
      key: UniqueKey(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '',
          // color: ColorConstants.red,
          iconWidget: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Edit',
            ),
          ),
          onTap: () {
            SetupRoutes.push(context, Routes.ADD_CUSTOM_FIELD, arguments: {
              'onSave': (BasicData data) {
                List<BasicData>? customFields =
                    UserPreview().user()!.customFields[widget.category.name];
                var index = customFields!.indexOf(basicData);
                setState(() {
                  customFields[index] = data;
                });
              },
              'basicData': basicData,
              'isEdit': true
            });
          },
        ),
        IconSlideAction(
          caption: '',
          color: ColorConstants.red,
          iconWidget: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onTap: () {
            if (!isCustomField) {
              removeDefinedField(basicData);
            }
            List<BasicData>? customFields =
                UserPreview().user()!.customFields[widget.category.name];
            var index = customFields!.indexOf(basicData);
            customFields[index] = BasicData(
                accountName:
                    customFields[index].accountName! + AtText.IS_DELETED,
                isPrivate: customFields[index].isPrivate);
            setState(() {});
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                autovalidateMode: basicData.value != ''
                    ? AutovalidateMode.disabled
                    : AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value == '') {
                    return 'Please provide value';
                  }
                  return null;
                },
                initialValue: basicData.value,
                onChanged: (String value) {
                  basicData.value = value;
                  _formKey.currentState!.validate();
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    errorStyle: TextStyle(fontSize: 15),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            GestureDetector(
              onTap: () {
                showPublicPrivateBottomSheet(
                    onPublicClicked: () {
                      setState(() {
                        basicData.isPrivate = false;
                      });
                    },
                    onPrivateClicked: () {
                      setState(() {
                        basicData.isPrivate = true;
                      });
                    },
                    height: 160);
              },
              child: Icon(basicData.isPrivate ? Icons.lock : Icons.public),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageField(BasicData basicData) {
    var intList = basicData.value!.cast<int>();
    Uint8List customImage = Uint8List.fromList(intList);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          basicData.valueDescription != null
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(basicData.valueDescription!))
              : SizedBox(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 200,
            child: Image.memory(
              customImage,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  bool isAllFieldsPrivate() {
    List<BasicData>? customFields =
        UserPreview().user()!.customFields[widget.category.name];

    if (customFields != null) {
      for (var basicData in customFields) {
        if (basicData.accountName != null &&
            basicData.value != null &&
            !basicData.isPrivate) {
          return false;
        }
      }
    }
    return true;
  }

  removeDefinedField(BasicData basicData) {
    if (basicData.accountName == FieldsEnum.IMAGE.name) {
      UserPreview().user()!.image = new BasicData();
    } else if (basicData.accountName == FieldsEnum.LASTNAME.name) {
      UserPreview().user()!.lastname = new BasicData();
    } else if (basicData.accountName == FieldsEnum.FIRSTNAME.name) {
      UserPreview().user()!.firstname = new BasicData();
    } else if (basicData.accountName == FieldsEnum.PHONE.name) {
      UserPreview().user()!.phone = new BasicData();
    } else if (basicData.accountName == FieldsEnum.EMAIL.name) {
      UserPreview().user()!.email = new BasicData();
    } else if (basicData.accountName == FieldsEnum.ABOUT.name) {
      UserPreview().user()!.about = new BasicData();
    } else if (basicData.accountName == FieldsEnum.LOCATION.name) {
      UserPreview().user()!.location = new BasicData();
    } else if (basicData.accountName == FieldsEnum.LOCATIONNICKNAME.name) {
      UserPreview().user()!.locationNickName = new BasicData();
    } else if (basicData.accountName == FieldsEnum.PRONOUN.name) {
      UserPreview().user()!.pronoun = new BasicData();
    } else if (basicData.accountName == FieldsEnum.TWITTER.name) {
      UserPreview().user()!.twitter = new BasicData();
    } else if (basicData.accountName == FieldsEnum.FACEBOOK.name) {
      UserPreview().user()!.facebook = new BasicData();
    } else if (basicData.accountName == FieldsEnum.LINKEDIN.name) {
      UserPreview().user()!.linkedin = new BasicData();
    } else if (basicData.accountName == FieldsEnum.INSTAGRAM.name) {
      UserPreview().user()!.instagram = new BasicData();
    } else if (basicData.accountName == FieldsEnum.YOUTUBE.name) {
      UserPreview().user()!.youtube = new BasicData();
    } else if (basicData.accountName == FieldsEnum.TUMBLR.name) {
      UserPreview().user()!.tumbler = new BasicData();
    } else if (basicData.accountName == FieldsEnum.MEDIUM.name) {
      UserPreview().user()!.medium = new BasicData();
    } else if (basicData.accountName == FieldsEnum.PS4.name) {
      UserPreview().user()!.ps4 = new BasicData();
    } else if (basicData.accountName == FieldsEnum.XBOX.name) {
      UserPreview().user()!.xbox = new BasicData();
    } else if (basicData.accountName == FieldsEnum.STEAM.name) {
      UserPreview().user()!.steam = new BasicData();
    } else if (basicData.accountName == FieldsEnum.DISCORD.name) {
      UserPreview().user()!.discord = new BasicData();
    }
  }
}
