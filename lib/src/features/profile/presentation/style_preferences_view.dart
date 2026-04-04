import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

//statefull widget allows the object to be stored and reload the page again
class StylePreferencesPage extends StatefulWidget {
  const StylePreferencesPage({super.key});

  @override
  State<StylePreferencesPage> createState() => _StylePreferencesPageState();
}

class _StylePreferencesPageState extends State<StylePreferencesPage> {
  // Seçilenleri tutan değişkenler
  Set<int> selectedCategoryIndices = {};
  Set<int> selectedColorIndices = {};

  static const List<String> categories = [
    "Minimalist",
    "Romantic",
    "Classic",
    "Edgy",
  ];

  static const List<IconData> categoryIcons = [
    Icons.minimize,
    Icons.favorite,
    Icons.diamond,
    Icons.flash_on,
  ];
  static const List<Color> colors = [
    AppColors.charcoal,
    AppColors.dustyRose,
    AppColors.sageGreen,
    AppColors.proMemberBg,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          //-----------------STYLE GRID----------------------------
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final isSelected = selectedCategoryIndices.contains(index);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (selectedCategoryIndices.contains(index)) {
                      selectedCategoryIndices.remove(index);
                    } else {
                      selectedCategoryIndices.add(index);
                    }
                  }),
                  child: Card(
                    // Seçiliyse rengini değiştir veya border ekle
                    color: isSelected ? AppColors.lightCoral : AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.charcoal
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryIcons[index],
                          color: isSelected
                              ? AppColors.charcoal
                              : AppColors.warmGray,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categories[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
            ),
          ),

          //-----------------FAVORITE COLORS TEXT----------------------------
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Favorite Colors",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, color: AppColors.warmGray),
              ),
            ),
          ),

          //-----------------CIRCLED COLORS GRID----------------------------
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final isSelected = selectedColorIndices.contains(index);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (selectedColorIndices.contains(index)) {
                      selectedColorIndices.remove(index);
                    } else {
                      selectedColorIndices.add(index);
                    }
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.charcoal
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    // Seçilince içine bir check iconu koyabilirsin
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }, childCount: colors.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0, // Daire olması için 1.0 daha iyi
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AppBar'ı temizlik adına ayırdım
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.beige,
      toolbarHeight: 120,
      centerTitle: false,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back, color: AppColors.charcoal),
      ),
      title: const Column(
        children: [
          Text(
            "Style Preferences",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal,
              fontFamily: "PT_Serif",
              fontSize: 27,
            ),
          ),
          Text(
            "Help us to understand your aesthetic",
            style: TextStyle(fontSize: 15, color: AppColors.warmGray),
          ),
        ],
      ),
    );
  }
}
