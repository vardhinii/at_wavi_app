import 'dart:ffi';
import 'dart:typed_data';

import 'package:at_common_flutter/at_common_flutter.dart';
import 'package:at_wavi_app/common_components/public_private_bottomsheet.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/image_picker.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';

class AddCustomField extends StatefulWidget {
  ValueChanged<BasicData> onSave;
  final bool isEdit;
  BasicData? basicData;
  AddCustomField({required this.onSave, this.isEdit = false, this.basicData});

  @override
  _AddCustomFieldState createState() => _AddCustomFieldState();
}

class _AddCustomFieldState extends State<AddCustomField> {
  BasicData basicData =
      BasicData(isPrivate: false, type: CustomContentType.Text.name);
  bool isImageSelected = false;

  @override
  void initState() {
    if (widget.isEdit && widget.basicData != null) {
      basicData = widget.basicData!;

      if (widget.basicData!.type != CustomContentType.Image.name) {
        basicData.valueDescription = basicData.value;
        basicData.value = null;
      }

      if (widget.basicData!.type == CustomContentType.Image.name) {
        isImageSelected = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                            'Add custom content',
                            style: TextStyles.boldText(Colors.black, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Title',
                          style: TextStyles.lightText(
                              ColorConstants.black.withOpacity(0.5),
                              size: 16),
                        ),
                      ),
                      TextFormField(
                        autovalidateMode: basicData.accountName != ''
                            ? AutovalidateMode.disabled
                            : AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Please provide value';
                          }
                          return null;
                        },
                        initialValue: basicData.accountName,
                        onChanged: (String value) {
                          basicData.accountName = value;
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
                      Divider(thickness: 1, height: 1),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Body',
                          style: TextStyles.lightText(
                              ColorConstants.black.withOpacity(0.5),
                              size: 16),
                        ),
                      ),
                      TextFormField(
                        autovalidateMode: basicData.valueDescription != ''
                            ? AutovalidateMode.disabled
                            : AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Please provide value';
                          }
                          return null;
                        },
                        initialValue: basicData.valueDescription,
                        onChanged: (String value) {
                          basicData.valueDescription = value;
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
                      Divider(thickness: 1, height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Add Media'),
                            GestureDetector(
                              onTap: _selectImage,
                              child: Row(
                                children: [
                                  Text(
                                    'Add',
                                    style: TextStyles.lightText(
                                        ColorConstants.black),
                                  ),
                                  SizedBox(width: 7),
                                  Icon(
                                    Icons.add,
                                    // size: 20,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(thickness: 1, height: 1),
                      SizedBox(height: 10),
                      isImageSelected
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Media'),
                                  SizedBox(height: 10),
                                  Stack(
                                    children: [
                                      Image.memory(basicData.value!),
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: InkWell(
                                          onTap: () {
                                            basicData.value = null;
                                            isImageSelected = false;
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: ColorConstants.black,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Icon(Icons.highlight_remove,
                                                size: 30, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: _selectImage,
                                    child: Text('Change Image',
                                        style: TextStyle(
                                          color: ColorConstants.orange,
                                          fontSize: 18.toFont,
                                        )),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 10),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text('View'),
                            SizedBox(height: 5),
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
                              child: Row(
                                children: [
                                  Icon(Icons.public),
                                  SizedBox(width: 5),
                                  Text('Public'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                width: double.infinity,
                height: 60,
                buttonText: 'Save',
                fontColor: ColorConstants.white,
                borderRadius: 0,
                onPressed: _onSave,
              )
            ],
          ),
        ),
      ),
    );
  }

  _selectImage() async {
    basicData.value = await ImagePicker().pickImage();
    if (basicData.value != null) {
      isImageSelected = true;
      // when image is selected , we are converting custom content's type image.
      // and the text entered will go to value description
      basicData.type = CustomContentType.Image.name;
      setState(() {});
    }
  }

  _onSave() {
    if (isImageSelected) {
      basicData.type = CustomContentType.Image.name;
    } else {
      basicData.value = basicData.valueDescription;
      basicData.valueDescription = null;
    }
    Navigator.of(context).pop();
    widget.onSave(basicData);
  }
}