import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/resource/resource.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/resource_detail/resource_detail_view_model.dart';
import 'package:stacked/stacked.dart';

class ResourceDetailView extends StatelessWidget {
  final Resource resource;

  const ResourceDetailView({
    Key key,
    @required this.resource,
  })  : assert(resource != null),
        super(key: key); // TODO

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResourceDetailViewModel>.nonReactive(
      viewModelBuilder: () => ResourceDetailViewModel(),
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
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
                          resource.image.toString(),
                          fit: BoxFit.cover,
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
                            Flexible(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  resource.title,
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
                                fontWeight: FontWeight.w400, // TODO character
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
            SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "When my husband and I decided to become foster parents, we knew one thing for certain: It would be a challenge. We knew it’d be hard to love kids and then let them go. We wondered how our children would react to sharing their parents and their home. We expected that there would be a lot of people who wouldn’t understand our decision. But we also believed that opening our home to children who needed love and security would be rewarding and worthwhile. I have to say that, over these past four years, I haven’t once regretted our decision. It has shaped us in ways I never could have imagined. There are still things I wish I had known that would have made things a little easier. If we were sitting down, having a heart-to-heart before you took the leap into fostering children, here’s what I would tell you. Foster parenting can be an isolating experience. Not many people understand what it’s like to welcome new children into your home, to parent alongside a biological parent who is a virtual stranger and to work so closely with Children’s Aid. Most of your friends won’t have experience with parenting through trauma or loving a child who leaves. Most of them won’t understand the very specific stressful situations that can arise as part of being a foster parent (a child leaving your home suddenly, an unexpected court ruling, an injured child). And, because of privacy and confidentiality, you can’t share this with them because these children’s stories are not yours to tell. The only people who truly understand what you’re going through are other foster parents. Finding a support network is invaluable—it will save your life. I know because it saved mine. When you connect with other foster parents, you’ll have people who can answer questions and offer insight into child behaviours or challenges you might be having with a child’s birth parent. You’ll have friends who won’t blink when your toddler throws the most epic tantrum or when you have a baby who won’t stop screaming. They know because they’ve been there—in fact, they’re probably there right now. When you’re starting out, make the effort to attend the training sessions offered by your agency. You’ll learn about things like caring for kids with special needs, court proceedings for foster children and self-care for foster families and—perhaps more importantly—you’ll connect with other foster parents. Attend special events offered by your agency and get to know other families. I met some of my closest foster-parent friends when we connected through respite: One of us was taking the other’s foster children for a short period of time and we exchanged numbers and stayed in touch. You’ll need the support and friendship, so don’t be afraid to seek it out.",
                  style: TextStyle(
                    color: Color(0xFF57636C),
                    fontSize: 22,
                    height: 1.375,
                    fontWeight: FontWeight.w600, // TODO character
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
