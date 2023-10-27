import 'package:flutter/widgets.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:stacked/stacked.dart';

enum NewLogField { child, parentSelection, medLog }

class SelectChildViewModel extends BaseViewModel
    with FormViewModelMixin<NewLogField> {
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final AppLocalizations localization;

  void Function({
    Child child,
    MedLog medlog,
    String secondaryAuthorId,
  }) _onComplete;

  Family _family;
  Family get family => this._family;

  List<ParentTileItem> get parentItems => [
        ParentTileItem(
          id: this._family.id,
          fullName: this._family.fullName,
          email: this._family.email,
        ),
      ]..addAll(
          this._family.secondaryParents.map<ParentTileItem>(
                (parent) => ParentTileItem(
                  id: parent.id,
                  fullName: parent.fullName,
                  email: parent.email,
                ),
              ),
        );

  bool get hasSecondaryParents => this._family.hasSecondaryParents;

  SelectChildViewModel({
    @required this.localization,
    @required Family family,
    Child initialSelectedChild,
    void Function({
      Child child,
      MedLog medlog,
      String secondaryAuthorId,
    })
        onChildAndParentSelected,
  })  : assert(family != null),
        this._family = family,
        this._onComplete = onChildAndParentSelected {
    this.addAllFormFields(
      {
        NewLogField.child: FormFieldModel<Child>(
          value: initialSelectedChild,
          validator: (child) => child == null ? localization.selectChild : null,
        ),
        NewLogField.medLog: FormFieldModel<MedLog>(
          value: null,
          validator: (log) => null,
        ),
      },
    );
  }

  void onBack() {
    _navigationService.back();
  }

  @override
  void updateField<T>(
    NewLogField key, {
    T value,
    String validationMessage,
    String Function(T value) validator,
  }) {
    super.updateField<T>(
      key,
      value: value,
      validationMessage: validationMessage,
      validator: validator,
    );

    if (key == NewLogField.medLog) {
      this._onComplete?.call(
            child: this.fieldValue(
              NewLogField.child,
            ),
            medlog: this.fieldValue(
              NewLogField.medLog,
            ),
          );
    }

    notifyListeners();
  }
}

class ParentTileItem {
  final String id;
  final String fullName;
  final String email;

  ParentTileItem({
    @required this.id,
    @required this.fullName,
    @required this.email,
  });
}
