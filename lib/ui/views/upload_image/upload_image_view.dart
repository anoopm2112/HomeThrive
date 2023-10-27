import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/upload_image/upload_image_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:stacked/stacked.dart';

class UploadImageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UploadImageView();
}

class _UploadImageView extends State<UploadImageView> {
  UploadImageViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<UploadImageViewModel>.reactive(
      viewModelBuilder: () => UploadImageViewModel(),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              localization.uploadImage,
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
                  : _gallery()),
          persistentFooterButtons: [
            TextButton(
              onPressed: model.onOpenGallery,
              child: Icon(Icons.image, color: theme.buttonColor),
            ),
            TextButton(
              onPressed: model.onOpenCamera,
              child: Icon(Icons.camera_alt, color: theme.buttonColor),
            ),
          ],
        );
      },
    );
  }

  Widget _gallery() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return CreationAwareWidget(
          onWidgetCreated: () => model.onTileCreated(index),
          child: index >= model.familyImages.length
              ? Container(
                  margin: EdgeInsets.all(2),
                  color: Theme.of(context).canvasColor,
                )
              : Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(model.familyImages[index].url),
                      ),
                      color: Theme.of(context).shadowColor),
                ),
        );
      },
      itemCount: model.familyImages.length,
    );
  }
}
