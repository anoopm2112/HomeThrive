import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/resource/resource.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/views/local_resources/local_resources_view_model.dart';
import 'package:fostershare/ui/widgets/cards/detail_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class LocalResourcesView extends StatelessWidget {
  final List<Resource> resources;

  const LocalResourcesView({
    Key key,
    @required this.resources,
  })  : assert(resources != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<LocalResourcesViewModel>.nonReactive(
      viewModelBuilder: () => LocalResourcesViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          // TODO make into widget
          iconTheme: IconThemeData(
            color: Color(0xFF95A1AC),
          ),
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            localization.localResources,
            style: GoogleFonts.montserrat(
              color: Color(0xFF95A1AC),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: resources.length,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          itemBuilder: (context, index) {
            final Resource resource = resources[index];
            return DetailCard(
              onTap: () => model.onResourceTap(
                resource.url,
              ),
              imageUrl: resource.image.toString(),
              title: resource.title,
              summary: resource.summary,
              actionText: localization.visitNow,
              alternateImageUrl: resource.alternateImageUrl.toString(),
            );
          },
        ),
      ),
    );
  }
}
