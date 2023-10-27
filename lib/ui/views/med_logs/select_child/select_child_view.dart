import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/med_logs/select_child/select_child_view_model.dart';
import 'package:fostershare/ui/widgets/person_row.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:stacked/stacked.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class SelectChildView extends StatelessWidget {
  final Family family;
  final Child initialSelectedChild;
  final List<Child> children;
  final List<MedLog> availableMedLogs;
  final void Function({
    Child child,
    String secondaryAuthorId,
    MedLog medlog,
  }) onChildAndParentSelected;

  SelectChildView({
    Key key,
    @required this.children,
    @required this.family,
    @required this.availableMedLogs,
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
    return ViewModelBuilder<SelectChildViewModel>.reactive(
      viewModelBuilder: () => SelectChildViewModel(
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
              localization.addMedLog,
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
                  ...availableMedLogs.map<Widget>(
                    (medlog) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: SelectableButton<MedLog>(
                        value: medlog,
                        selected: medlog.child.id ==
                            model
                                .fieldValue(
                                  NewLogField.child,
                                )
                                ?.id,
                        onSelected: (medlogs) {
                          model.updateField<Child>(
                            NewLogField.child,
                            value: medlogs.child,
                          );
                          model.updateField<MedLog>(
                            NewLogField.medLog,
                            value: medlogs,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: PersonRow(
                            image:
                                NetworkImage(medlog.child.imageURL.toString()),
                            name:
                                medlog.child.nickName ?? medlog.child.firstName,
                            description: localization.medLog,
                            indexColor: Color(0xFFFFFF00),
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
