import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/med_log_details/create_medlog_note_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/cards/generic_card.dart';
import 'package:fostershare/ui/widgets/cards/med_log_card.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/detail_tile.dart';
import 'package:fostershare/ui/widgets/horizontal_buttons_list_view.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CreateMedLogNoteView extends StatefulWidget {
  final String medLogId;
  final String medLogEntryId;
  final String medicationId;

  CreateMedLogNoteView(this.medLogId, {this.medLogEntryId, this.medicationId});

  @override
  State<StatefulWidget> createState() => _CreateMedLogNoteViewState();
}

class _CreateMedLogNoteViewState extends State<CreateMedLogNoteView> {
  TextEditingController medLogNoteController;

  CreateMedLogNoteViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<CreateMedLogNoteViewModel>.reactive(
      viewModelBuilder: () => CreateMedLogNoteViewModel(
        widget.medLogId,
        medLogEntryId: widget.medLogEntryId,
        medicationId: widget.medicationId,
      ),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
        return WillPopScope(
          onWillPop: () async {
            model.back();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                "Notes", //TODO: Localization
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
                : _createNotes(),
          ),
        );
      },
    );
  }

  Widget _createNotes() {
    var theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: Text("Create a new note")),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                    child: AppTextField(
                  labelText: "Note",
                  controller: medLogNoteController,
                  errorText: model.fieldValidationMessage(
                    CreateMedLogNoteInputField.content,
                  ),
                  onChanged: (val) =>
                      model.setValue(CreateMedLogNoteInputField.content, val),
                )),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          await model.createNote();
                          medLogNoteController.clear();
                        } catch (err) {}
                      },
                      color: theme.accentColor,
                      child: Text(
                        "Create",
                        style: TextStyle(color: theme.buttonColor),
                      ),
                    ),
                  ),
                )),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(child: Text("Previous notes")),
                _previousNotesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _previousNotesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) {
          var note = model.notes[i];
          return _noteTile(note.content, note.enteredBy);
        },
        childCount: model.notes.length,
      ),
    );
  }

  Widget _noteTile(String content, String enteredBy) {
    return DetailTile(
      title: null,
      value: content,
      small: true,
      description: enteredBy,
    );
  }

  @override
  void initState() {
    medLogNoteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    medLogNoteController.dispose();
    super.dispose();
  }
}
