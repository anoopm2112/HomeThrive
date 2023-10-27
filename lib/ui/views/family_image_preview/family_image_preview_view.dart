import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/family_image_preview/family_image_preview_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:stacked/stacked.dart';

class FamilyImagePreviewView extends StatefulWidget {
  String imagePath;

  FamilyImagePreviewView(this.imagePath);

  @override
  State<StatefulWidget> createState() => _FamilyImagePreviewView();
}

class _FamilyImagePreviewView extends State<FamilyImagePreviewView> {
  FamilyImagePreviewViewModel model;
  AppLocalizations _localization;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _localization = AppLocalizations.of(context);
    return ViewModelBuilder<FamilyImagePreviewViewModel>.reactive(
      viewModelBuilder: () => FamilyImagePreviewViewModel(widget.imagePath),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _localization.uploadImage,
              style: theme.appBarTheme.titleTextStyle.copyWith(
                fontSize: getResponsiveMediumFontSize(context),
              ),
            ),
          ),
          body: SafeArea(
              child: model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    )
                  : _showPreview()),
        );
      },
    );
  }

  Widget _showPreview() {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Image.file(File(model.currentImagePath))),
          SizedBox(height: 10),
          AppTextField(
            labelText: _localization.imageName,
            keyboardType: TextInputType.text,
            initialText: model.fieldValue(
              SubmitImageFormField.imageName,
            ),
            onChanged: (name) => model.updateField<String>(
              SubmitImageFormField.imageName,
              value: name.trim(),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              model.onSubmitImage();
            },
            child: Text(
              _localization.submit,
              style: theme.textTheme.button,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
