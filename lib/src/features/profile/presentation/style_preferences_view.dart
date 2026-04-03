import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/constants/text_strings.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class StylePreferencesPage extends StatelessWidget {
  const StylePreferencesPage({super.key});

  static const List<String> categories = [
    "Minimalist",
    "Romantic",
    "Classic",
    "Edgy",
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
      appBar: AppBar(
        backgroundColor: AppColors.lightCoral,
        toolbarHeight: 120,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.charcoal),
        ),

        title: Column(
          children: [
            Text(
              Ttexts.sytlePre_AppBar,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "PT_Serif",
                color: AppColors.charcoal,
                fontWeight: FontWeight.bold,
              ),
            ),
            Visibility(
              visible: true,
              child: Text(
                "Help us understand your aesthetic",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.warmGray),
              ),
            ),
          ],
        ),
      ),

      body: CustomScrollView(
        slivers: [
          //-----------------STYLE----------------------------
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Card(
                  color: AppColors.lightCoral,
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
            ),
          ),

          //-----------------FAVORİTE COLORS----------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Favorite Colors",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: AppColors.warmGray),
              ),
            ),
          ),

          //-------CİRCLED COLORS---
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // farklı kolon sayısı
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8, // farklı oran
              ),
            ),
          ),

          /*  //-----------------BODY TYPE----------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  "Body Type",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,

                    fontFamily: "PT_Serif",
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index){

                return Container()
              }),
            ),
          ), */

          //--------------BODY TYPE CONTAİNER----
          /*  SliverToBoxAdapter(
            child: Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    child: Card(child: Text("data")),
                  );
                },
              ),
            ),
          ), */
        ],
      ),
    );
  }
}
