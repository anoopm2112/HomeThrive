import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/resources/components/resource_feed_scroll_view.dart';
import 'package:fostershare/ui/views/resources/widgets/no_resources.dart';
import 'package:fostershare/ui/views/resources/resources_view_model.dart';
import 'package:fostershare/ui/components/view_bar/view_bar.dart';
import 'package:stacked/stacked.dart';

class ResourcesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<ResourcesViewModel>.reactive(
      viewModelBuilder: () => locator<ResourcesViewModel>(),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: true,
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            ViewBar(
              title: localization.resources,
            ),
            Expanded(
              child: model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    )
                  : model.hasError
                      ? NoResources(
                          explanationText: localization.errorLoadingResources,
                        )
                      : model.hasResouces
                          ? ResourceFeedScrollView()
                          : NoResources(
                              explanationText: localization.noResources,
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
