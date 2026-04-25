import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/constants/text_strings.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/core/utils/platform_utils.dart';
import 'package:fashai/src/features/profile/presentation/cycle/data/cycle_data.dart';
import 'package:fashai/src/features/profile/presentation/cycle/presentation/cycle_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CycleSettingsPage extends StatefulWidget {
  const CycleSettingsPage({super.key});

  @override
  State<CycleSettingsPage> createState() => _CycleSettingsPageState();
}

class _CycleSettingsPageState extends State<CycleSettingsPage> {
  bool _isCycleAwareOn = false;
  final CycleModel _cycleData = CycleData.myCycleData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        backgroundColor: AppColors.beige,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.charcoal),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Ttexts.cycleAwareMode,
              style: TextStyle(
                color: AppColors.charcoal,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "PT_Serif",
              ),
            ),
            Text(
              Ttexts.comfortFocused,
              style: TextStyle(color: AppColors.warmGray, fontSize: 13),
            ),
          ],
        ),
        toolbarHeight: TSizes.appBarHeight + TSizes.xxl,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: TSizes.xl),
            child: Switch(
              value: _isCycleAwareOn,
              onChanged: (val) => setState(() => _isCycleAwareOn = val),
            ),
          ),
        ],
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isCycleAwareOn ? 1.0 : 0.3,
        child: SingleChildScrollView(
          physics: PlatformUtils.scrollPhysics(context),
          padding: EdgeInsets.symmetric(
            horizontal: PlatformUtils.horizontalPadding(context),
            vertical: TSizes.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCycleRing(),
              const SizedBox(height: TSizes.spaceBtwSections),

              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Text("🌸", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: TSizes.sm),
                    Text(
                      Ttexts.todaysComfortPicks,
                      style: const TextStyle(
                        color: AppColors.charcoal,
                        fontSize: TSizes.fontSizeLG,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.md),

              ..._cycleData.comfortPicks.map((pick) => _buildPickCard(pick)),

              const SizedBox(height: TSizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCycleRing() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: TSizes.imageCarouselHeight,
            height: TSizes.imageCarouselHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 2,
                    centerSpaceRadius: TSizes.iconXl * 2 + TSizes.sm,
                    sections: [
                      PieChartSectionData(
                        value: 5,
                        color: AppColors.coral,
                        radius: 18,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 9,
                        color: AppColors.sageGreen,
                        radius: 18,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 5,
                        color: AppColors.lightCoral,
                        radius: 18,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 9,
                        color: AppColors.dustyRose,
                        radius: 18,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${Ttexts.dayPrefix} ${_cycleData.currentDay}",
                      style: const TextStyle(
                        color: AppColors.charcoal,
                        fontSize: TSizes.fontSizeLG + TSizes.md,
                        fontWeight: FontWeight.bold,
                        fontFamily: "PT_Serif",
                      ),
                    ),
                    Text(
                      _cycleData.currentPhase.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.warmGray,
                        fontSize: TSizes.fontSizeXS,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Ttexts.menstrual, AppColors.coral),
              const SizedBox(width: TSizes.xl),
              _buildLegendItem(Ttexts.follicular, AppColors.sageGreen),
              const SizedBox(width: TSizes.xl),
              _buildLegendItem(Ttexts.luteal, AppColors.dustyRose),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: TSizes.sm * 2 + TSizes.xs,
          height: TSizes.sm * 2 + TSizes.xs,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: TSizes.sm),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.warmGray,
            fontSize: TSizes.fontSizeXS,
          ),
        ),
      ],
    );
  }

  Widget _buildPickCard(ComfortPickModel pick) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.md),
      padding: const EdgeInsets.all(TSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lightCoral,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            ),
            child: Center(
              child: Text(
                pick.icon,
                style: const TextStyle(fontSize: TSizes.iconLg - TSizes.xs),
              ),
            ),
          ),
          const SizedBox(width: TSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pick.title,
                  style: const TextStyle(
                    color: AppColors.charcoal,
                    fontSize: TSizes.fontSizeSM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TSizes.xs),
                Text(
                  pick.subtitle,
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
