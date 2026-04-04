import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/core/utils/platform_utils.dart';
import 'package:fashai/src/features/wardrobe/data/wardrobe_data.dart';
import 'package:fashai/src/features/wardrobe/presentation/wardrobe_model.dart';
import 'package:flutter/material.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  String _selectedCategory = "All";
  String _searchQuery = "";

  final List<String> _categories = [
    "All",
    "Tops",
    "Bottoms",
    "Dresses",
    "Outerwear",
  ];

  List<WardrobeItemModel> get _filteredItems {
    return WardrobeData.items.where((item) {
      final matchesCategory =
          _selectedCategory == "All" || item.category == _selectedCategory;
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                PlatformUtils.horizontalPadding(context),
                TSizes.xl,
                PlatformUtils.horizontalPadding(context),
                TSizes.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "My Wardrobe",
                        style: TextStyle(
                          color: AppColors.charcoal,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "PT_Serif",
                        ),
                      ),
                      Text(
                        "${_filteredItems.length} items",
                        style: const TextStyle(
                          color: AppColors.warmGray,
                          fontSize: TSizes.fontSizeSM,
                        ),
                      ),
                    ],
                  ),
                  // Sort button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.md,
                      vertical: TSizes.sm,
                    ),
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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sort,
                          color: AppColors.coral,
                          size: TSizes.iconMd,
                        ),
                        const SizedBox(width: TSizes.sm),
                        const Text(
                          "Sort",
                          style: TextStyle(
                            color: AppColors.charcoal,
                            fontSize: TSizes.fontSizeXS,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: PlatformUtils.horizontalPadding(context),
                vertical: TSizes.sm,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: "Search your closet...",
                    hintStyle: TextStyle(color: AppColors.warmGray),
                    prefixIcon: Icon(Icons.search, color: AppColors.warmGray),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: TSizes.md),
                  ),
                ),
              ),
            ),

            // Category filter
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: PlatformUtils.horizontalPadding(context),
                  vertical: TSizes.sm,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: TSizes.sm),
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.xl,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.coral : AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected ? AppColors.coral : AppColors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.warmGray,
                            fontSize: TSizes.fontSizeXS,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: TSizes.md),

            // Grid
            Expanded(
              child: _filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        "No items found",
                        style: TextStyle(
                          color: AppColors.warmGray,
                          fontSize: TSizes.fontSizeMD,
                        ),
                      ),
                    )
                  : GridView.builder(
                      physics: PlatformUtils.scrollPhysics(context),
                      padding: EdgeInsets.fromLTRB(
                        PlatformUtils.horizontalPadding(context),
                        0,
                        PlatformUtils.horizontalPadding(context),
                        TSizes.defaultSpace + TSizes.xxxl,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: TSizes.md,
                            mainAxisSpacing: TSizes.md,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildWardrobeCard(_filteredItems[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWardrobeCard(WardrobeItemModel item) {
    final color = Color(int.parse(item.color.replaceAll('#', '0xFF')));

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color preview
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(TSizes.cardRadiusLg),
                  ),
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Favorite icon
                Positioned(
                  top: TSizes.sm,
                  right: TSizes.sm,
                  child: Container(
                    padding: const EdgeInsets.all(TSizes.sm),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: item.isFavorite
                          ? AppColors.coral
                          : AppColors.warmGray,
                      size: TSizes.iconMd,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.charcoal,
                    fontSize: TSizes.fontSizeSM,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: TSizes.xs),
                Text(
                  item.brand,
                  style: const TextStyle(
                    color: AppColors.warmGray,
                    fontSize: TSizes.fontSizeXS,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
