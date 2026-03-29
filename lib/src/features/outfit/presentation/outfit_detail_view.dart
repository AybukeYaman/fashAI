import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/core/utils/platform_utils.dart';
import 'package:fashai/src/features/home/presentation/home_model.dart';
import 'package:flutter/material.dart';

class OutfitDetailPage extends StatelessWidget {
  final OutfitModel outfit;

  const OutfitDetailPage({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    final mockTags = {
      "a": ["Cream Blazer", "White Blouse", "Navy Trousers", "Tan Loafers"],
      "b": [
        "Light Gray Sweater",
        "Dark Jeans",
        "White Sneakers",
        "Crossbody Bag",
      ],
      "c": ["Red Dress", "Heels", "Gold Necklace"],
      "d": ["Beige Turtleneck", "Black Midi Skirt", "Ankle Boots"],
    };
    final tags = mockTags[outfit.id] ?? [];

    final mockSuggestions = {
      "a":
          "This look pairs well with a structured tote bag and minimal gold jewelry. Avoid heavy accessories to keep the professional feel.",
      "b":
          "Try rolling up the sleeves slightly for a more relaxed vibe. A baseball cap would complete the casual weekend look.",
      "c":
          "A silk scarf or delicate pendant necklace would elevate this outfit perfectly for a romantic evening.",
      "d":
          "Layer with a long wool coat for colder days. This outfit transitions seamlessly from home office to a casual outing.",
    };
    final suggestion = mockSuggestions[outfit.id] ?? "";

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: CustomScrollView(
        physics: PlatformUtils.scrollPhysics(context),
        slivers: [
          // Hero image with back button
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: AppColors.beige,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.charcoal,
                  size: TSizes.iconMd,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(TSizes.md),
                  padding: const EdgeInsets.all(TSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.share_outlined,
                    color: AppColors.charcoal,
                    size: TSizes.iconMd,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: TSizes.md),
                  padding: const EdgeInsets.all(TSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: AppColors.charcoal,
                    size: TSizes.iconMd,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(bottom: TSizes.xl),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(TSizes.borderRadiusLg * 2),
                  ),
                  child: Image.network(outfit.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: PlatformUtils.horizontalPadding(context),
                vertical: TSizes.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          outfit.title,
                          style: const TextStyle(
                            color: AppColors.charcoal,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "PT_Serif",
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.md,
                          vertical: TSizes.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightCoral,
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusSm,
                          ),
                        ),
                        child: const Text(
                          "AI Pick",
                          style: TextStyle(
                            color: AppColors.coral,
                            fontSize: TSizes.fontSizeXS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.md),

                  // Reason
                  Text(
                    outfit.reason,
                    style: const TextStyle(
                      color: AppColors.warmGray,
                      fontSize: TSizes.fontSizeMD,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Items section
                  const Text(
                    "Outfit Items",
                    style: TextStyle(
                      color: AppColors.charcoal,
                      fontSize: TSizes.fontSizeLG,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.md),
                  Wrap(
                    spacing: TSizes.sm,
                    runSpacing: TSizes.sm,
                    children: tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.xl,
                              vertical: TSizes.md,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(
                                TSizes.borderRadiusSm,
                              ),
                              border: Border.all(
                                color: AppColors.grey,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: AppColors.charcoal,
                                fontSize: TSizes.fontSizeSM,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // AI Suggestions section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(TSizes.xl),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.coral.withValues(alpha: 0.10),
                          AppColors.coral.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                      border: Border.all(
                        color: AppColors.coral.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(TSizes.sm),
                              decoration: BoxDecoration(
                                color: AppColors.lightCoral,
                                borderRadius: BorderRadius.circular(
                                  TSizes.borderRadiusSm,
                                ),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: AppColors.coral,
                                size: TSizes.iconMd,
                              ),
                            ),
                            const SizedBox(width: TSizes.md),
                            const Text(
                              "AI Styling Tips",
                              style: TextStyle(
                                color: AppColors.charcoal,
                                fontSize: TSizes.fontSizeMD,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.md),
                        Text(
                          suggestion,
                          style: const TextStyle(
                            color: AppColors.warmGray,
                            fontSize: TSizes.fontSizeSM,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Wear this outfit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusMd,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Wear This Outfit",
                        style: TextStyle(
                          fontSize: TSizes.fontSizeMD,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.md),

                  // Save for later button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.coral),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusMd,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Save for Later",
                        style: TextStyle(
                          color: AppColors.coral,
                          fontSize: TSizes.fontSizeMD,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
