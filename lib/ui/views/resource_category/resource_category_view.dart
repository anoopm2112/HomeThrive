import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/resource/resource.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/resource_category/resource_category_view_model.dart';
import 'package:fostershare/ui/widgets/cards/detail_card.dart';
import 'package:stacked/stacked.dart';

class ResourceCategoryView extends StatelessWidget {
  final String id;

  const ResourceCategoryView({
    Key key,
    @required this.id,
  })  : assert(id != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ViewModelBuilder<ResourceCategoryViewModel>.reactive(
      viewModelBuilder: () => ResourceCategoryViewModel(),
      onModelReady: (model) => model.onModelReady(id), // TODO dynamic
      builder: (context, model, child) => Scaffold(
        body: model.isBusy
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.orange500,
                  ),
                ),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: screenHeightPercentage(context, percentage: 40),
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints.expand(),
                            child: ShaderMask(
                              blendMode: BlendMode.srcOver,
                              shaderCallback: (rect) => LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.clamp,
                                colors: [
                                  Color(0x0016222B),
                                  Color(0xFF121313),
                                ],
                              ).createShader(rect),
                              child: Image.network(
                                model.resourceCategory.image.toString(),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Image.network(
                                      model.resourceCategory.alternateImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                    return Container(color: theme.canvasColor);
                                  });
                                },
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: model.onBack,
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 28,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        model.resourceCategory.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 24,
                                          color: Color(0xFFFFFFFF),
                                          height: 1.083,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "4m Read",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.w400, // TODO character
                                      fontSize: 14,
                                      color: Color(0xFF95A1AC),
                                      height: 1.143,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 14),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        localization.popularArticles,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF57636C),
                          fontWeight: FontWeight.w600, // TODO character?
                          height: 1.143,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 14),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final Resource resource =
                            model.resourceCategory.resources[index]; // TODO
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            top: index != 0 ? 14 : 0,
                            right: 16,
                            bottom: index ==
                                    model.resourceCategory.resources.length - 1
                                ? 14
                                : 0,
                          ),
                          child: DetailCard(
                            // TODO elevation/shadow
                            onTap: () => model.onResourceTap(resource.url),
                            imageUrl: resource.image.toString(),
                            title: resource.title,
                            summary: resource.summary,
                            alternateImageUrl:
                                resource.alternateImageUrl.toString(),
                          ),
                        );
                      },
                      childCount: model.resourceCategory.resources
                          .length, // TODO make getter
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
