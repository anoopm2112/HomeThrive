import 'package:stacked/stacked.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/input/update_child_nickname_input/update_child_nickname_input.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:fostershare/ui/common/validators.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

enum childFormField { nickName }

class ChildrenNickNameViewModel extends BaseViewModel
    with FormViewModelMixin<childFormField> {
  final _loggerService = locator<LoggerService>();
  final _toastService = locator<ToastService>();
  final _childrenService = locator<ChildrenService>();
  final _localization = AppLocalizations.current;
  final _navigationService = locator<NavigationService>();

  final String childId;
  final String nickName;
  ChildrenNickNameViewModel(this.childId, this.nickName);

  Future<void> onModelReady() async {
    this.setBusy(true);

    try {
      this.addAllFormFields({
        childFormField.nickName: FormFieldModel<String>(
          value: this.nickName,
          validator: (nickName) => nickName != null && nickName.isNotEmpty
              ? null
              : _localization.nickName, // TODO
        ),
      });
      this.setBusy(false);
    } catch (e, s) {
      this.setBusy(false);
    }
  }

  Future<void> saveChildrenNick() async {
    final bool validForm = this.validateForm();
    notifyListeners();

    if (validForm) {
      this.setBusy(true);

      try {
        var updatedChild = await _childrenService.updateChildNickName(
          UpdateChildNickNameInput(
            id: this.childId,
            nickName: this.fieldValue(
              childFormField.nickName,
            ),
          ),
        );

        this.setBusy(false);
        _navigationService.back<Child>(result: updatedChild);
      } catch (err) {
        _toastService.displayToast("Unable to save");

        this.setBusy(false);
      }
    }
  }

  @override
  void updateField<T>(
    childFormField key, {
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

    notifyListeners();
  }
}
