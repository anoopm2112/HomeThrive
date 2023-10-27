import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/profile/invite_cpa/invite_cpa_card_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:stacked/stacked.dart';

class InviteCpaCard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    final emailController = useTextEditingController();
    final emailFocusNode = useFocusNode();

    return ViewModelBuilder<InviteCpaCardModel>.reactive(
      viewModelBuilder: () => InviteCpaCardModel(),
      onModelReady: (model) => model.onModelReady(emailController),
      builder: (context, model, child) => Card(
        child: Padding(
          padding: EdgeInsets.only(
            // TODO card padding ui util
            left: 14,
            top: 12,
            right: 14,
            bottom: 16,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localization.letYourCpaKnowAboutFosterShare,
                  style: textTheme.headline3.copyWith(
                    fontSize: getResponsiveMediumFontSize(context),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                localization.enterCpasEmailDescription,
                style: textTheme.bodyText2.copyWith(
                  fontSize: getResponsiveSmallFontSize(context),
                ),
              ),
              SizedBox(height: 24),
              AppTextField(
                focusNode: emailFocusNode,
                controller: emailController,
                labelText: localization.email,
                onChanged: model.onEmailChanged,
                errorText: model.emailErrorText,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 14),
              RaisedButton(
                color: Color(0xFF8ABAD3),
                disabledColor: Color(0x998ABAD3),
                onPressed: model.sendingInvite
                    ? null
                    : () => model.onSend(
                          () => FocusScope.of(context).unfocus(),
                        ),
                child: model.sendingInvite
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      )
                    : Text(
                        localization.send,
                        style: TextStyle(
                          color: AppColors.white, // TODO
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
