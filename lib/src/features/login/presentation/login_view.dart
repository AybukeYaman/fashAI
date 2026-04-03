import 'package:fashai/src/core/constants/image_strings.dart';
import 'package:fashai/src/core/constants/sizes.dart';
import 'package:fashai/src/core/constants/text_strings.dart';
import 'package:fashai/src/core/routes/app_routes.dart';
import 'package:fashai/src/core/themes/app_colors.dart';
import 'package:fashai/src/core/utils/platform_utils.dart';
import 'package:fashai/src/features/login/presentation/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginViewModel _viewModel = LoginViewModel();
  bool _isLogin = true;
  bool _showForgotPassword = false;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: PlatformUtils.scrollPhysics(context),
          padding: EdgeInsets.symmetric(
            horizontal: PlatformUtils.horizontalPadding(context),
            vertical: PlatformUtils.isIOS(context) ? TSizes.xl : TSizes.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: PlatformUtils.topPadding(context) > 20
                    ? TSizes.xxl
                    : TSizes.xl,
              ),

              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.lightCoral,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.coral,
                  size: 36,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Title
              Text(
                Ttexts.loginTitle,
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: "PT_Serif",
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Subtitle
              Text(
                Ttexts.loginSubTitle,
                style: TextStyle(
                  color: AppColors.warmGray,
                  fontSize: TSizes.fontSizeMD,
                  fontFamily: PlatformUtils.bodyFont(context),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Tab toggle with sliding pill
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                ),
                child: Stack(
                  children: [
                    // Sliding pill
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      alignment: _isLogin
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.coral,
                            borderRadius: BorderRadius.circular(
                              TSizes.borderRadiusMd,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Tab labels on top
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _isLogin = true;
                              _showForgotPassword = false;
                            }),
                            child: Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                vertical: TSizes.md,
                              ),
                              child: Text(
                                Ttexts.logIn,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isLogin
                                      ? AppColors.white
                                      : AppColors.warmGray,
                                  fontWeight: FontWeight.w600,
                                  fontSize: TSizes.fontSizeSM,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _isLogin = false;
                              _showForgotPassword = false;
                            }),
                            child: Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                vertical: TSizes.md,
                              ),
                              child: Text(
                                Ttexts.signUp,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !_isLogin
                                      ? AppColors.white
                                      : AppColors.warmGray,
                                  fontWeight: FontWeight.w600,
                                  fontSize: TSizes.fontSizeSM,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Tab content
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                ),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: KeyedSubtree(
                  key: ValueKey(_isLogin),
                  child: _isLogin ? _buildLoginTab() : _buildSignUpTab(),
                ),
              ),

              SizedBox(
                height:
                    TSizes.defaultSpace + PlatformUtils.bottomPadding(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Login Tab ──────────────────────────────────────────────────────────────
  Widget _buildLoginTab() {
    return Form(
      key: _viewModel.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Ttexts.email,
            style: const TextStyle(
              color: AppColors.charcoal,
              fontSize: TSizes.fontSizeSM,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TSizes.sm),
          _buildTextField(
            controller: _viewModel.emailController,
            hint: Ttexts.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Ttexts.emailRequired;
              }
              if (!value.contains('@') || !value.contains('.')) {
                return Ttexts.emailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Text(
            Ttexts.password,
            style: const TextStyle(
              color: AppColors.charcoal,
              fontSize: TSizes.fontSizeSM,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TSizes.sm),
          _buildTextField(
            controller: _viewModel.passwordController,
            hint: Ttexts.enterYourPassword,
            obscure: true,
            suffixIcon: const Icon(
              Iconsax.eye_slash,
              color: AppColors.warmGray,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Ttexts.passwordRequired;
              }
              if (value.length < 6) {
                return Ttexts.passwordTooShort;
              }
              return null;
            },
          ),

          // Forgot password button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  setState(() => _showForgotPassword = !_showForgotPassword),
              child: Text(
                Ttexts.forgetPassword,
                style: const TextStyle(
                  color: AppColors.coral,
                  fontSize: TSizes.fontSizeSM,
                ),
              ),
            ),
          ),

          // Forgot password slide down
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _showForgotPassword
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Form(
              key: _viewModel.forgotFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Ttexts.enterEmailToReset,
                    style: const TextStyle(
                      color: AppColors.warmGray,
                      fontSize: TSizes.fontSizeXS,
                    ),
                  ),
                  const SizedBox(height: TSizes.sm),
                  _buildTextField(
                    controller: _viewModel.forgotPasswordController,
                    hint: Ttexts.enterYourEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Ttexts.emailRequired;
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return Ttexts.emailInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: TSizes.md),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_viewModel.forgotFormKey.currentState!.validate()) {
                          // send reset link logic
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dustyRose,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusMd,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        Ttexts.sendResetLink,
                        style: const TextStyle(
                          fontSize: TSizes.fontSizeSM,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.md),
                ],
              ),
            ),
          ),

          // Log In button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_viewModel.loginFormKey.currentState!.validate()) {
                  Navigator.pushNamed(context, AppRoutes.main);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                ),
                elevation: 0,
              ),
              child: Text(
                Ttexts.logIn,
                style: const TextStyle(
                  fontSize: TSizes.fontSizeMD,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          _buildSocialButtons(),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildTermsText(),
        ],
      ),
    );
  }

  // ── Sign Up Tab ────────────────────────────────────────────────────────────
  Widget _buildSignUpTab() {
    return Form(
      key: _viewModel.signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Ttexts.fullName,
            style: const TextStyle(
              color: AppColors.charcoal,
              fontSize: TSizes.fontSizeSM,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TSizes.sm),
          _buildTextField(
            controller: _viewModel.fullNameController,
            hint: Ttexts.enterYourName,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Ttexts.nameRequired;
              }
              if (value.trim().length < 2) {
                return Ttexts.nameTooShort;
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Text(
            Ttexts.email,
            style: const TextStyle(
              color: AppColors.charcoal,
              fontSize: TSizes.fontSizeSM,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TSizes.sm),
          _buildTextField(
            controller: _viewModel.emailController,
            hint: Ttexts.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Ttexts.emailRequired;
              }
              if (!value.contains('@') || !value.contains('.')) {
                return Ttexts.emailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Text(
            Ttexts.password,
            style: const TextStyle(
              color: AppColors.charcoal,
              fontSize: TSizes.fontSizeSM,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TSizes.sm),
          _buildTextField(
            controller: _viewModel.passwordController,
            hint: Ttexts.enterYourPassword,
            obscure: true,
            suffixIcon: const Icon(
              Iconsax.eye_slash,
              color: AppColors.warmGray,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Ttexts.passwordRequired;
              }
              if (value.length < 6) {
                return Ttexts.passwordTooShort;
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Sign Up button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_viewModel.signUpFormKey.currentState!.validate()) {
                  Navigator.pushNamed(context, AppRoutes.main);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                ),
                elevation: 0,
              ),
              child: Text(
                Ttexts.signUp,
                style: const TextStyle(
                  fontSize: TSizes.fontSizeMD,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          _buildSocialButtons(),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildTermsText(),
        ],
      ),
    );
  }

  // ── Shared Widgets ─────────────────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.warmGray),
        filled: true,
        fillColor: AppColors.white,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        Row(
          children: [
            const Flexible(child: Divider(color: AppColors.grey, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              child: Text(
                Ttexts.orSignInWith,
                style: const TextStyle(
                  color: AppColors.warmGray,
                  fontSize: TSizes.fontSizeXS,
                ),
              ),
            ),
            const Flexible(child: Divider(color: AppColors.grey, thickness: 1)),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.main),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.lg),
                  side: const BorderSide(color: AppColors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  ),
                  backgroundColor: AppColors.white,
                ),
                icon: const Image(
                  width: TSizes.iconMd,
                  height: TSizes.iconMd,
                  image: AssetImage(TImages.google),
                ),
                label: Text(
                  Ttexts.orSignInWithGoogle,
                  style: const TextStyle(
                    color: AppColors.charcoal,
                    fontSize: TSizes.fontSizeSM,
                  ),
                ),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.main),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: TSizes.lg),
                  side: BorderSide(color: AppColors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  ),
                  backgroundColor: AppColors.white,
                ),
                icon: Image(
                  width: TSizes.iconMd,
                  height: TSizes.iconMd,
                  image: AssetImage(TImages.facebook),
                ),
                label: Text(
                  Ttexts.orSignInWithFacebook,
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontSize: TSizes.fontSizeSM,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTermsText() {
    return Text(
      Ttexts.termsAndPrivacy,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.warmGray,
        fontSize: TSizes.fontSizeXS,
        fontFamily: PlatformUtils.bodyFont(context),
      ),
    );
  }
}
