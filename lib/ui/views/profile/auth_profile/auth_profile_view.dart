import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/support_service/support_service.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/med_log/med_logs_list_view.dart';
import 'package:fostershare/ui/views/support_services_view/support_services_view.dart';
import 'package:fostershare/ui/views/upload_image/upload_image_view.dart';
import 'package:fostershare/ui/views/profile/auth_profile/auth_profile_view_model.dart';
import 'package:fostershare/ui/views/profile/profile_row.dart';
import 'package:stacked/stacked.dart';

class AuthProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<AuthProfileViewModel>.nonReactive(
      viewModelBuilder: () => AuthProfileViewModel(),
      builder: (context, model, child) => Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.dialogBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFDEE2E7),
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.showFullName) ...[
                    SizedBox(height: 10),
                    Padding(
                      padding: defaultViewPaddingHorizontal,
                      child: AutoSizeText(
                        model.fullName,
                        maxLines: 1,
                        style: theme.textTheme.headline1.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: getResponsiveFontSize(
                            context,
                            fontSize: 20,
                            max: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (model.showEmail) ...[
                    SizedBox(height: 10),
                    Padding(
                      padding: defaultViewPaddingHorizontal,
                      child: AutoSizeText(
                        model.email,
                        maxLines: 1,
                        style: theme.textTheme.bodyText1.copyWith(
                          fontSize: getResponsiveMediumFontSize(context),
                          color: Color(0xFF8ABAD3), // TODO
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: ProfileRow(
                      label: localization.editProfile,
                      onTap: model.onEditProfile,
                    ),
                  ),
                  Expanded(
                    child: ProfileRow(
                      label: localization.changePassword,
                      onTap: model.onChangePassword,
                    ),
                  ),
                  Expanded(
                    child: ProfileRow(
                      label: localization.myChildren,
                      onTap: model.onMyChildren,
                    ),
                  ),
                  Expanded(
                    child: ProfileRow(
                      label: localization.contactUs,
                      onTap: model.onContactUs,
                    ),
                  ),
                  Expanded(
                    child: ProfileRow(
                      label: localization.shareApp,
                      onTap: model.onShareApp,
                    ),
                  ),
                  Expanded(
                    child: ProfileRow(
                      label: localization.uploadImage,
                      onTap: model.onUploadImage,
                    ),
                  ),
                  Expanded(
                    child: ProfileRow(
                      label: localization.supportServices,
                      onTap: model.onSupportService,
                    ),
                  ),
                  // Expanded(
                  //   child: ProfileRow(
                  //     label: "Med Log",
                  //     onTap: model.onMedLog,
                  //   ),
                  // ),
                  /*Expanded(
                    child: ProfileRow(
                      label: "Med Log",
                      onTap: model.onMedLog,
                    ),
                  ),

                  Expanded(
                    child: ProfileRow(
                      label: localization.recreationLog,
                      onTap: model.onRecreationLog,
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              TextButton(
                onPressed: model.onSignOut,
                child: Text(
                  localization.signOut,
                  style: textTheme.button,
                ),
              ),
              SizedBox(height: 12),
              Text("v${model.versionNumber}"),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
