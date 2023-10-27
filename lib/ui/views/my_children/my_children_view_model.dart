import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/input/update_child_input/update_child_input.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/dialog_service.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/services/auth_bottom_nav_service.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:stacked/stacked.dart';
import 'children_nickname_view.dart';

class MyChildrenViewModel extends BaseViewModel {
  final _authBottomNavService = locator<AuthBottomNavService>();
  final _authService = locator<AuthService>();
  final _childrenService = locator<ChildrenService>();
  final _dialogService = locator<DialogService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();

  List<Child> _children = <Child>[];
  bool get hasChildren => _children.isNotEmpty;

  Child _selectedChild;
  Child get selectedChild => _selectedChild;

  int get selectedChildIndex => _children.indexOf(_selectedChild);

  List<String> get childrenNames => _children
      .map(
        (child) => child.firstName,
      )
      .toList();

  int get childrenCount => this._children?.length ?? 0;

  Future<String> token() {
    return _authService.getIdToken();
  }

  Future<void> onModelReady() async {
    _loggerService.info(
      "MyChildrenViewModel - onModelReady()",
    );
    this.setBusy(true);

    try {
      _children = await _childrenService.children();

      if (_children.isNotEmpty) {
        // TODO if no children?
        _selectedChild = _children.first;
      }
    } catch (error, stack) {
      this.setError("Error loading children");

      _loggerService.error(
        "MyChildrenViewModel - onModelReady() - Failed getting children",
        error: error,
        stackTrace: stack,
      );
    }

    this.setBusy(false);
  }

  Future<void> onAddChildImage() async {
    final PickedFile file = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (file != null) {
      _dialogService.circularProgressIndicator();

      try {
        final String imageInBase64 = await file.toBase64();

        final Child updatedChild = await _childrenService.updateChild(
          UpdateChildInput(
            id: this._selectedChild.id,
            image: imageInBase64,
          ),
        );

        this._children[this.selectedChildIndex] = updatedChild;
        this._selectedChild = updatedChild;
      } catch (e, s) {
        _loggerService.error(
          "Error uploading image for child",
          error: e,
          stackTrace: s,
        );
      }

      notifyListeners();

      _navigationService.back();
    }
  }

  Child child(int index) {
    assert(index >= 0); // TODO util function maybe a mixin
    assert(index < this.childrenCount);
    _loggerService.info(
      "MyChildrenViewModel - child(index:$index)",
    );

    return this._children[index];
  }

  bool isSelectedChild(int index) {
    assert(index >= 0); // TODO util function maybe a mixin
    assert(index < this.childrenCount);
    _loggerService.info(
      "MyChildrenViewModel - isSelectedChild(index:$index)",
    );

    return _selectedChild.id == this._children[index].id;
  }

  void onChildPressed(int index) {
    assert(index >= 0); // TODO util function maybe a mixin
    assert(index < this.childrenCount);
    _loggerService.info(
      "MyChildrenViewModel - onChildPressed(index:$index)",
    );

    _selectedChild = this._children[index];
    notifyListeners();
  }

  void onViewAll() {
    _loggerService.info(
      "MyChildrenViewModel - onViewAll()",
    );

    _authBottomNavService.changeTap(AuthBottomNavTab.activity.index);
    _navigationService.back();
  }

  void onChildLogTap(ChildLog log) {
    _loggerService.info(
      "MyChildrenViewModel - onChildLogTap()",
    );

    _navigationService.navigateTo(
      Routes.logSummaryView,
      arguments: LogSummaryViewArguments(
        id: log.id,
        date: log.date,
        child: this.selectedChild,
      ),
    );
  }

  onEditNickName() async {
    var childSave = await showModalBottomSheet<Child>(
      context: NavigationService.navigatorKey.currentContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => SizedBox(
        height: screenHeightPercentage(context, percentage: 95),
        child: ChildrenNickNameView(_selectedChild.id, _selectedChild.nickName),
      ),
    );
    if (childSave != null) {
      this._children[this.selectedChildIndex] = childSave;
      this._selectedChild = childSave;
    }
    notifyListeners();
  }
}
