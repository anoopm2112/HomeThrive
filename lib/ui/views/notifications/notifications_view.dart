import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/data/message/message.dart';
import 'package:fostershare/ui/common/date_format_utils.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/notifications/notifications_view_model.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:stacked/stacked.dart';

class NotificationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<NotificationsViewModel>.reactive(
      viewModelBuilder: () => NotificationsViewModel(),
      onModelReady: (model) => model.loadMessages(),
      builder: (context, model, child) => SafeArea(
        child: Column(
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                localization.notifications,
                style: textTheme.headline1.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: getResponsiveLargeFontSize(context),
                ),
              ),
            ),
            if (model.isBusy)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              )
            else if (model.showNoMessages)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.5 / 1,
                      child: Image.asset(
                        PngAssetImages.fileCabinet,
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: defaultViewChildPaddingHorizontal,
                      child: Text(
                        localization.noNotifications,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextButton(
                      onPressed: model.loadMessages,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sync,
                            color: textTheme.button.color,
                          ),
                          SizedBox(width: 8),
                          Text(
                            localization.reload,
                            style: textTheme.button, // TODO
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 16,
                    right: 20,
                    bottom: 12,
                  ),
                  itemCount: model.messages.length,
                  separatorBuilder: (context, _) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final Message message = model.messages[index];
                    return CreationAwareWidget(
                      onWidgetCreated: () => model.onCardCreated(index),
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: message.status == MessageStatus.sent ? 5 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              if (message.status == MessageStatus.sent) ...[
                                Container(
                                  color: Theme.of(context).primaryColor,
                                  width: 5,
                                ),
                              ],
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 14,
                                    top: 12,
                                    bottom: 14,
                                  ),
                                  child: Text("${message.body}"),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 14,
                                  top: 12,
                                  bottom: 14,
                                ),
                                child: Text(
                                  "${formattedSlashedDate(message.createdAt)}",
                                  style: textTheme.bodyText1.copyWith(
                                    fontSize:
                                        getResponsiveSmallFontSize(context),
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
