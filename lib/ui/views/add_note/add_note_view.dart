import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/add_note/add_note_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:stacked/stacked.dart';

class AddNoteView extends StatelessWidget {
  final String childLogId;

  const AddNoteView({
    Key key,
    @required this.childLogId,
  })  : assert(childLogId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<AddNoteViewModel>.reactive(
      viewModelBuilder: () => AddNoteViewModel(
        localization: localization,
        childLogId: childLogId,
      ),
      builder: (context, model, child) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22),
            GestureDetector(
              onTap: model.onClose,
              child: Icon(
                Icons.close,
                size: 32,
                color: Color(0xFF95A1AC), // TODO
              ),
            ),
            SizedBox(height: 12),
            Text(
              localization.addNote,
              style: textTheme.headline1.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: getResponsiveLargeFontSize(context),
              ),
            ),
            SizedBox(height: 24),
            AppTextField(
              autoFocus: true,
              keyboardType: TextInputType.text,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              textCapitalization: TextCapitalization.sentences,
              contentPadding: EdgeInsets.all(16),
              minLines: 4,
              maxLines: null,
              labelText: localization.additionalNotes,
              errorText: model.fieldValidationMessage(
                AddNoteField.notes,
              ),
              onChanged: (notes) => model.updateField(
                AddNoteField.notes,
                value: notes,
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: model.isBusy ? null : model.onSaveNote,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140, 50),
                ),
                child: model.isBusy
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.dialogBackgroundColor,
                        ),
                      )
                    : Text(
                        localization.saveNote,
                        style: textTheme.button,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
