import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/features/home/presentation/home_view.dart';
import 'package:fashai/src/features/profile/presentation/profile_view.dart';
import 'package:fashai/src/features/styleAI/presentation/style_ai_view.dart';
import 'package:fashai/src/features/wardrobe/presentation/wardrobe_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _cameraActive = false;

  final List<Widget> _pages = const [
    HomePage(),
    WardrobePage(),
    StyleAiPage(),
    ProfilePage(),
  ];

  void _openCamera() async {
    setState(() => _cameraActive = true);

    final ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera);

    setState(() => _cameraActive = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  Widget _buildFloatingNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TSizes.defaultSpace,
        0,
        TSizes.defaultSpace,
        TSizes.defaultSpace,
      ),
      child: Container(
        clipBehavior: Clip.none,
        height: 64,
        padding: const EdgeInsets.all(TSizes.xs),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg * 2),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Sliding coral pill
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: _selectedIndex == 0
                  ? const Alignment(-1.0, 0) // Home — en sol
                  : _selectedIndex == 1
                  ? const Alignment(-0.5, 0) // Wardrobe
                  : _selectedIndex == 2
                  ? const Alignment(0.5, 0) // Style AI
                  : const Alignment(1.0, 0), // Profile — en sağ
              child: FractionallySizedBox(
                widthFactor: 0.2,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.coral,
                    borderRadius: BorderRadius.circular(
                      TSizes.borderRadiusLg * 2,
                    ),
                  ),
                ),
              ),
            ),

            // Nav items + camera
            Row(
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, "Home"),
                _buildNavItem(
                  1,
                  Icons.checkroom_outlined,
                  Icons.checkroom,
                  "Wardrobe",
                ),

                // Camera button
                Expanded(
                  child: GestureDetector(
                    onTap: _openCamera,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -13,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: _cameraActive ? 62 : 58,
                            height: _cameraActive ? 62 : 58,
                            decoration: BoxDecoration(
                              color: _cameraActive
                                  ? AppColors.dustyRose
                                  : AppColors.coral,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.beige,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.coral.withValues(
                                    alpha: _cameraActive ? 0.6 : 0.4,
                                  ),
                                  blurRadius: _cameraActive ? 20 : 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                              size: TSizes.iconLg,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _buildNavItem(
                  2,
                  Icons.auto_awesome_outlined,
                  Icons.auto_awesome,
                  "Style AI",
                ),
                _buildNavItem(3, Icons.person_outline, Icons.person, "Profile"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          color: Colors.transparent,
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? AppColors.white
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                size: TSizes.iconMd,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.white
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
