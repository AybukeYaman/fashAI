import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/constants/text_strings.dart';
import 'package:fashai/src/core/routes/app_routes.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/core/utils/platform_utils.dart';
import 'package:fashai/src/features/auth/providers/auth_providers.dart';
import 'package:fashai/src/features/profile/data/profile_data.dart';
import 'package:fashai/src/features/profile/presentation/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileModel profile = ProfileData.myProfile;

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: PlatformUtils.scrollPhysics(context),
          padding: EdgeInsets.symmetric(
            horizontal: PlatformUtils.horizontalPadding(context),
            vertical: TSizes.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: TSizes.spaceBtwSections),

              // Avatar
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.sageGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    profile.initial,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PT_Serif",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Name
              Text(
                profile.fullName,
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "PT_Serif",
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Subtitle + location
              Text(
                "${profile.subtitle} • ${profile.location}",
                style: const TextStyle(
                  color: AppColors.warmGray,
                  fontSize: TSizes.fontSizeSM,
                ),
              ),
              const SizedBox(height: TSizes.md),

              // Pro Member badge
              if (profile.isPro)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.xl,
                    vertical: TSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.proMemberBg,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("⭐", style: TextStyle(fontSize: 14)),
                      const SizedBox(width: TSizes.sm),
                      Text(
                        Ttexts.proMember,
                        style: const TextStyle(
                          color: AppColors.proMemberText,
                          fontSize: TSizes.fontSizeSM,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Stats row
              Row(
                children: [
                  _buildStatCard(
                    value: "${profile.itemCount}",
                    label: Ttexts.items,
                  ),
                  const SizedBox(width: TSizes.md),
                  _buildStatCard(
                    value: "${profile.outfitCount}",
                    label: Ttexts.outfits,
                  ),
                  const SizedBox(width: TSizes.md),
                  _buildStatCard(
                    value: "${profile.minSaved}",
                    label: Ttexts.minSaved,
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Settings rows
              _buildSettingsRow(
                context,
                icon: "🎨",
                title: Ttexts.stylePreferences,
                subtitle: Ttexts.stylePreferencesSubtitle,
                onTap: () => context.push(AppRoutes.stylePreferences),
              ),
              const SizedBox(height: TSizes.md),
              _buildSettingsRow(
                context,
                icon: "🌸",
                title: Ttexts.cycleSettings,
                subtitle: Ttexts.cycleSettingsSubtitle,
                onTap: () => context.push(AppRoutes.cycleSettings),
              ),
              const SizedBox(height: TSizes.md),
              _buildSettingsRow(
                context,
                icon: "⚙️",
                title: Ttexts.appSettings,
                subtitle: Ttexts.appSettingsSubtitle,
                onTap: () => context.push(AppRoutes.appSettings),
              ),
              const SizedBox(height: TSizes.md),
              _buildSettingsRow(
                context,
                icon: "X",
                title: 'Sign Out',
                subtitle: 'End this session',
                onTap: () async {
                  await ref.read(authServiceProvider).signOut();
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
              ),

              const SizedBox(height: TSizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TSizes.xl,
          horizontal: TSizes.md,
        ),
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
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.coral,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.warmGray,
                fontSize: TSizes.fontSizeXS,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightCoral,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: TSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.charcoal,
                      fontSize: TSizes.fontSizeSM,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.warmGray,
                      fontSize: TSizes.fontSizeXS,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.warmGray,
              size: TSizes.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}
