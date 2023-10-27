import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/med_logs/med_log_details/med_log_complete.dart';
import 'package:fostershare/ui/views/med_logs/med_log_details/med_log_entry.dart';
import 'package:fostershare/ui/views/med_logs/med_log_details/medications_list.dart';
import 'package:fostershare/ui/views/med_logs/med_log_details/signing_view.dart';
import 'package:fostershare/ui/views/med_logs/med_log_questions/create_medication.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/ui/views/med_logs/med_log_summary/med_log_summary_view_model.dart';
import 'package:stacked/stacked.dart';

class MedLogSummaryView extends StatelessWidget {
  final MedLog medLog;
  final void Function(MedLog medLog) onMedLogChanged;

  const MedLogSummaryView({
    Key key,
    this.medLog, // TODO secondary Auth ID
    this.onMedLogChanged, // TODO asserts
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MedLogSummaryViewModel>.reactive(
        //onModelReady: (model) => model.onModelReady(),
        viewModelBuilder: () => MedLogSummaryViewModel(
              localization: AppLocalizations.of(context),
              medLog: this.medLog,
              onComplete: this.onMedLogChanged,
            ),
        builder: (context, model, child) {
          final localization = AppLocalizations.of(context);
          final textTheme = Theme.of(context).textTheme;
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.dialogBackgroundColor,
            persistentFooterButtons: [
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 5,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    if (model.state.index != 0 &&
                        model.state != MedLogInputState.medlogComplete)
                      OutlinedButton(
                        // TODO make into widget
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 2,
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        onPressed: model.onPrevious,
                        child: Text(
                          localization.previous,
                          style: TextStyle(
                            color: Color(0xFF57636C), // TODO
                          ),
                        ),
                      ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    if (model.state == MedLogInputState.viewAllMedication &&
                        !model.isBusy &&
                        model.canSubmit &&
                        !(model.medLog.isSubmitted &&
                            model.medLog.signingStatus != null))
                      MaterialButton(
                        color: theme.accentColor,
                        textColor: theme.buttonColor,
                        visualDensity: VisualDensity.compact,
                        child: Text(localization.submit),
                        onPressed: () async {
                          var result = await showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text(localization.confirm +
                                      " " +
                                      localization.submit),
                                  content: Text(
                                      localization.makeSureAllEntriesSubmitted),
                                  actions: [
                                    MaterialButton(
                                      child: Text(localization.cancel),
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                    ),
                                    MaterialButton(
                                      child: Text(localization.confirm),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  ],
                                );
                              });
                          if (result) {
                            await model.onTapSubmit();
                          }
                        },
                      ),
                    // if (model.state == MedLogInputState.viewAllMedication &&
                    //     !model.isBusy &&
                    //     model.medLog.isSubmitted &&
                    //     !model.medLog.canSign)
                    //   MaterialButton(
                    //     color: theme.accentColor,
                    //     textColor: theme.buttonColor,
                    //     //visualDensity: VisualDensity.compact,
                    //     child: Text(localization.waitForSign),
                    //     onPressed: () => {},
                    //   ),
                    if (model.state == MedLogInputState.viewAllMedication &&
                        !model.isBusy &&
                        model.medLog.isSubmitted &&
                        model.medLog.canSign)
                      MaterialButton(
                        color: theme.accentColor,
                        textColor: theme.buttonColor,
                        //visualDensity: VisualDensity.compact,
                        child: Text(localization.proceedToSign),
                        onPressed: () => model.onTapSign(),
                      ),
                    if (model.state == MedLogInputState.medlogComplete)
                      MaterialButton(
                        color: theme.accentColor,
                        textColor: theme.buttonColor,
                        //visualDensity: VisualDensity.compact,
                        child: Text(localization.close),
                        onPressed: () => model.onBack(),
                      ),
                  ],
                ),
              ),
            ],
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 25,
                    left: 16,
                    right: 16,
                  ),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: model.onBack,
                            child: Icon(
                              Icons.close,
                              size: 32,
                              color: Color(0xFF95A1AC), // TODO
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          children: [
                            // UserAvatar(
                            //   image: NetworkImage(this.child.imageURL.toString()),
                            //   radius: 45,
                            // ),
                            if (model.state != MedLogInputState.signingView)
                              Container(
                                child: Image.asset(
                                  PngAssetImages.montlyMedLog,
                                  width: 90.0,
                                  height: 90.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(height: 5),
                            Text(this.medLog.child.nickName ??
                                this.medLog.child.firstName),
                            SizedBox(height: 3),
                            model.state == MedLogInputState.medlogEntry
                                ? Text(localization.monthlyMedLogDetails)
                                : Text(localization.monthlyMedLog)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Divider(
                  height: 0,
                  color: Color(0xFFDEE2E7), // TODO
                  thickness: 1,
                ),
                // model.state == MedLogInputState.signingView
                //     ? Expanded(
                //         child: Column(
                //         children: [_getViewForState(model)],
                //       ))
                //     :
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(
                      left: 16,
                      top: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      // bottom: 16,
                    ),
                    child: Column(
                      children: [
                        _getViewForState(model),
                        SizedBox(height: 28),
                        // if (model.state != MedLogInputState.newMedication)
                        //   AnimatedSmoothIndicator(
                        //     activeIndex: model.activeIndex,
                        //     count: 3,
                        //     effect: WormEffect(
                        //       dotWidth: 20,
                        //       dotHeight: 10,
                        //       radius: 5,
                        //       activeDotColor: Theme.of(context).primaryColor,
                        //       dotColor: Color(0xFFDBE2E7), // TODO
                        //     ),
                        //   ),
                        // SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _getViewForState(MedLogSummaryViewModel model) {
    assert(model != null);

    switch (model.state) {
      case MedLogInputState.medicationDetail:
        return CreateMedication();
      case MedLogInputState.signingView:
        return SigningView();
      case MedLogInputState.medlogEntry:
        return MedLogEntry();
      case MedLogInputState.medlogComplete:
        return MedLogComplete();
      case MedLogInputState.viewAllMedication:
      default:
        return MedicationsList();
    }
  }
}
