import 'package:fashai/src/core/routes/app_routes.dart';
import 'package:fashai/src/core/utils/platform_utils.dart';
import 'package:fashai/src/features/home/data/home_data.dart';
import 'package:flutter/material.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/constants/text_strings.dart';
import 'package:fashai/src/features/home/presentation/home_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategoryId = "1";
  final HomeModel myHomeData = HomeData.myHomeData;

  @override
  Widget build(BuildContext context) {
    final filteredOutfits = myHomeData.outfits
        .where((o) => o.categoryId == selectedCategoryId)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: CustomScrollView(
        physics: PlatformUtils.scrollPhysics(context),
        slivers: <Widget>[
          // 1. APP BAR
          SliverAppBar(
            expandedHeight: 240,
            backgroundColor: AppColors.beige,
            elevation: 0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.fromLTRB(
                  TSizes.xl,
                  PlatformUtils.isIOS(context) ? 64 : 48,
                  TSizes.xl,
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Ttexts.greetings,
                              style: const TextStyle(
                                color: AppColors.charcoal,
                                fontSize: TSizes.xxxl,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Ttexts.day,
                              style: const TextStyle(
                                color: AppColors.warmGray,
                                fontSize: TSizes.fontSizeSM,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(TSizes.md),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              TSizes.borderRadiusMd,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.coral,
                            size: TSizes.iconMd,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.md),
                    // Weather Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.xl,
                        vertical: TSizes.lg,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.coral.withValues(alpha: 0.10),
                            AppColors.coral.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          TSizes.borderRadiusLg,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wb_cloudy_outlined,
                              color: AppColors.coral,
                              size: TSizes.iconLg,
                            ),
                          ),
                          const SizedBox(width: TSizes.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${myHomeData.temperature}°C",
                                style: const TextStyle(
                                  color: AppColors.charcoal,
                                  fontSize: TSizes.fontSizeLG,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                myHomeData.weatherStatus,
                                style: const TextStyle(
                                  color: AppColors.warmGray,
                                  fontSize: TSizes.fontSizeXS,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                myHomeData.city,
                                style: const TextStyle(
                                  color: AppColors.charcoal,
                                  fontSize: TSizes.fontSizeSM,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                "H: 21° L: 15°",
                                style: TextStyle(
                                  color: AppColors.warmGray,
                                  fontSize: TSizes.fontSizeXS,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. KATEGORİLER
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    TSizes.xl,
                    TSizes.xl,
                    TSizes.xl,
                    TSizes.md,
                  ),
                  child: Text(
                    "How are you feeling today?",
                    style: TextStyle(
                      color: AppColors.charcoal,
                      fontSize: TSizes.fontSizeSM,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.xl),
                    itemCount: myHomeData.categories.length,
                    itemBuilder: (context, index) {
                      final category = myHomeData.categories[index];
                      final isSelected = selectedCategoryId == category.id;

                      return GestureDetector(
                        onTap: () =>
                            setState(() => selectedCategoryId = category.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: TSizes.md),
                          padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.xl,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.coral
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.coral
                                  : AppColors.grey,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category.title,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.warmGray,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: TSizes.fontSizeSM,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 3. TODAY'S PICKS header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                TSizes.xl,
                TSizes.xxl,
                TSizes.xl,
                TSizes.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Picks",
                    style: TextStyle(
                      fontSize: TSizes.fontSizeLG,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh,
                          color: AppColors.warmGray,
                          size: TSizes.iconMd,
                        ),
                        const SizedBox(width: TSizes.sm),
                        const Text(
                          "Refresh",
                          style: TextStyle(
                            color: AppColors.warmGray,
                            fontSize: TSizes.fontSizeXS,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. KIYAFET LİSTESİ
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.xl),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildOutfitCard(filteredOutfits[index]),
                childCount: filteredOutfits.length,
              ),
            ),
          ),

          // 5. VIEW FULL WARDROBE banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                TSizes.xl,
                TSizes.md,
                TSizes.xl,
                TSizes.xxl,
              ),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.xl,
                    vertical: TSizes.lg,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(TSizes.md),
                        decoration: BoxDecoration(
                          color: AppColors.lightCoral,
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusSm,
                          ),
                        ),
                        child: const Icon(
                          Icons.share_outlined,
                          color: AppColors.coral,
                          size: TSizes.iconMd,
                        ),
                      ),
                      const SizedBox(width: TSizes.md),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "View Full Wardrobe",
                            style: TextStyle(
                              color: AppColors.charcoal,
                              fontWeight: FontWeight.w600,
                              fontSize: TSizes.fontSizeSM,
                            ),
                          ),
                          Text(
                            "84 items",
                            style: TextStyle(
                              color: AppColors.warmGray,
                              fontSize: TSizes.fontSizeXS,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.warmGray,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height:
                  TSizes.defaultSpace + PlatformUtils.bottomPadding(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitCard(OutfitModel outfit) {
    final mockTags = {
      "a": ["Cream Blazer", "White Blouse", "Navy Trousers"],
      "b": ["Light Gray Sweater", "Dark Jeans", "White Sneakers"],
      "c": ["Red Dress", "Heels"],
      "d": ["Beige Turtleneck", "Black Midi Skirt", "Ankle Boots"],
    };
    final tags = mockTags[outfit.id] ?? [];

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.outfitDetail,
        arguments: outfit,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(TSizes.cardRadiusLg),
                  ),
                  child: Image.network(
                    outfit.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.white,
                    child: const Icon(
                      Icons.favorite_border,
                      color: AppColors.charcoal,
                      size: TSizes.iconMd,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        outfit.title,
                        style: const TextStyle(
                          fontSize: TSizes.fontSizeMD,
                          fontWeight: FontWeight.bold,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.warmGray,
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    outfit.reason,
                    style: const TextStyle(
                      color: AppColors.warmGray,
                      fontSize: TSizes.fontSizeSM,
                    ),
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: TSizes.md),
                    Wrap(
                      spacing: TSizes.sm,
                      runSpacing: TSizes.sm,
                      children: [
                        ...tags
                            .take(3)
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TSizes.md,
                                  vertical: TSizes.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.beige,
                                  borderRadius: BorderRadius.circular(
                                    TSizes.borderRadiusSm,
                                  ),
                                  border: Border.all(
                                    color: AppColors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: AppColors.charcoal,
                                    fontSize: TSizes.fontSizeXS,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        if (tags.length > 3)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.md,
                              vertical: TSizes.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.beige,
                              borderRadius: BorderRadius.circular(
                                TSizes.borderRadiusSm,
                              ),
                              border: Border.all(
                                color: AppColors.grey,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "+${tags.length - 3}",
                              style: const TextStyle(
                                color: AppColors.warmGray,
                                fontSize: TSizes.fontSizeXS,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
