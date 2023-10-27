import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/input/medlog_medication_details/create_medication_details_input.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'children_nickname_view_model.dart';

class ChildrenNickNameView extends StatefulWidget {
  final String childId;
  final String nickName;
  ChildrenNickNameView(this.childId, this.nickName);
  @override
  State<StatefulWidget> createState() => _ChildrenNickNameViewState();
}

class _ChildrenNickNameViewState extends State<ChildrenNickNameView> {
  ChildrenNickNameViewModel model;
  TextEditingController medicationNameController;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<ChildrenNickNameViewModel>.reactive(
      viewModelBuilder: () =>
          ChildrenNickNameViewModel(widget.childId, widget.nickName),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              localization.childrenNickName, //TODO: Localization
              style: theme.appBarTheme.titleTextStyle.copyWith(
                fontSize: getResponsiveMediumFontSize(context),
              ),
            ),
          ),
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${localization.nickName} ",
                        style: textTheme.headline3.copyWith(
                          fontSize: getResponsiveSmallFontSize(context),
                        ),
                      ),
                      SizedBox(height: 16),
                      AppTextField(
                        labelText: localization.nickName,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        initialText: model.fieldValue(
                          childFormField.nickName,
                        ),
                        onChanged: (nickName) => model.updateField(
                          childFormField.nickName,
                          value: nickName,
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 130,
                          child: TextButton(
                            onPressed: () => model.saveChildrenNick(),
                            child: Text(
                              localization.submit,
                              style: TextStyle(color: theme.buttonColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
