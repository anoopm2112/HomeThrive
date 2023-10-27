import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/recreation_log/select_child_and_parent/select_child_and_parent_view_model.dart';
import 'package:fostershare/ui/widgets/person_row.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:stacked/stacked.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class SelectChildAndParentView extends StatelessWidget {
  final Family family;
  final Child initialSelectedChild;
  final List<Child> children;
  final void Function({
    Child child,
    String secondaryAuthorId,
  }) onChildAndParentSelected;

  SelectChildAndParentView({
    Key key,
    @required this.children,
    @required this.family,
    this.initialSelectedChild,
    this.onChildAndParentSelected,
  })  : assert(family != null),
        assert(children != null),
        assert(
          initialSelectedChild == null ||
              children.any(
                (child) =>
                    child.id ==
                    initialSelectedChild.id, // TODO function/override ==
              ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<SelectChildAndParentViewModel>.reactive(
      viewModelBuilder: () => SelectChildAndParentViewModel(
        localization: localization,
        family: this.family,
        initialSelectedChild: this.initialSelectedChild,
        onChildAndParentSelected: this.onChildAndParentSelected,
      ),
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 22),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: model.onBack,
              child: Icon(
                Icons.close,
                size: 32,
                color: Color(0xFF95A1AC), // TODO
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              localization.addRecreationLog,
              style: textTheme.headline1.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: getResponsiveLargeFontSize(context),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.selectChildForLog,
                    style: textTheme.bodyText2.copyWith(
                      fontSize: getResponsiveSmallFontSize(context),
                    ),
                  ),
                  SizedBox(height: 10),
                  ...children.map<Widget>(
                    (child) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: SelectableButton<Child>(
                        value: child,
                        selected: child.id ==
                            model
                                .fieldValue(
                                  NewLogField.child,
                                )
                                ?.id,
                        onSelected: (child) => model.updateField<Child>(
                          NewLogField.child,
                          value: child,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: PersonRow(
                            image: NetworkImage(child.imageURL.toString()),
                            name: child.nickName ?? child.firstName,
                            description: localization.recreationLog,
                            indexColor: Color(0xFF7986CB),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
