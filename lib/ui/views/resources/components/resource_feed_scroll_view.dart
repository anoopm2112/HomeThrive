import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/resource/resource.dart';
import 'package:fostershare/core/models/data/resource_category/resource_category.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/resources/resources_view_model.dart';
import 'package:fostershare/ui/views/resources/widgets/titled_resource_view_section.dart';
import 'package:fostershare/ui/widgets/cards/detail_card.dart';
import 'package:fostershare/ui/widgets/cards/snippet_card.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:stacked/stacked.dart';

class ResourceFeedScrollView extends ViewModelWidget<ResourcesViewModel> {
  @override
  Widget build(
    BuildContext context,
    ResourcesViewModel model,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context);

    return CustomScrollView(
      key: PageStorageKey("ResourceFeedScrollViewKey"),
      physics: BouncingScrollPhysics(
        //TODO
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: model.onRefresh,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              if (model.showPopularTopics) ...[
                SizedBox(height: 10),
                TitledResourceViewSection(
                  title: localization.popularTopics,
                  child: SizedBox(
                    height: screenHeightPercentage(
                      context,
                      percentage: 24,
                    ),
                    child: ListView.separated(
                      key: PageStorageKey("ResourceFeedPopularTopicsKey"),
                      scrollDirection: Axis.horizontal,
                      itemCount: model.popularTopicsCount,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10,
                      ),
                      itemBuilder: (context, index) {
                        final ResourceCategory resourceCategory =
                            model.resourceCategory(index);
                        return SnippetCard(
                          onTap: () => model.onResourceCategoryTap(
                            resourceCategory.id,
                          ),
                          title: resourceCategory.name,
                          subtitle: localization.articleCount(
                            resourceCategory.resourcesCount,
                          ),
                          imageUrl: resourceCategory.image.toString(),
                          alternateImageUrl:
                              resourceCategory.alternateImage.toString(),
                        );
                      },
                    ),
                  ),
                ),
              ],
              if (model.showLocalResources) ...[
                SizedBox(height: 10),
                TitledResourceViewSection(
                  title: localization.localResources,
                  child: DetailCard(
                    onTap: model.onLocalResourcesTap,
                    title: localization.localResources,
                    margin: defaultViewPaddingHorizontal,
                    summary: localization.aCuratedListOfResources,
                    actionText: localization.viewAll,
                    metaDataText: localization.resourceCount(
                      model.localResourcesCount,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (model.showPopularCategory) ...[
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: TitledResourceViewSection(
              title: localization.popularArticles,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 6,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final Resource resource = model.popularArticle(index);
                  return DetailCard(
                    margin: EdgeInsets.only(bottom: 14),
                    onTap: () => model.onResourceTap(
                      resource.url,
                    ),
                    title: resource.title,
                    summary: resource.summary,
                    imageUrl: resource.image.toString(),
                    alternateImageUrl: resource.alternateImageUrl.toString(),
                  );
                },
                childCount: model.popularArticlesCount,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
