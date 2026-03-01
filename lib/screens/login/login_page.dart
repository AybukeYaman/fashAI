import 'package:flutter/material.dart';
import 'package:fashai/t_store/common/styles/spacing_styles.dart';
import 'package:fashai/t_store/utils/constants/text_strings.dart';
import 'package:fashai/t_store/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import "package:fashai/t_store/utils/constants/image_strings.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.star, weight: 300, color: Color(0xFFDB7964)),
                  Text(
                    Ttexts.loginTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    Ttexts.loginSubTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),

              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: TSizes.spaceBtwSections,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Iconsax.direct_right_copy),
                          labelText: Ttexts.email,
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Iconsax.password_check_copy),
                          labelText: Ttexts.password,
                          suffixIcon: Icon(Iconsax.eye_slash),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields / 2),

                      Row(
                        children: [
                          //Remember Me
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(value: true, onChanged: (value) {}),
                              const Text(Ttexts.rememberMe),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          //Forget Password
                          TextButton(
                            onPressed: () {},
                            child: Text(Ttexts.forgetPassword),
                          ),
                        ],
                      ),

                      //Sign in
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(Ttexts.signIn),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text(Ttexts.createAccount),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Diivider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: Color.fromARGB(255, 0, 0, 0),
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text(
                    Ttexts.orSignInWith,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Flexible(
                    child: Divider(
                      color: Color.fromARGB(255, 0, 0, 0),
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFDB7964)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton.icon(
                      label: Text("Google"),
                      onPressed: () {},
                      icon: const Image(
                        width: TSizes.iconMd,
                        height: TSizes.iconMd,
                        image: AssetImage(TImages.google),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFDB7964)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton.icon(
                      label: Text("Facebook"),
                      onPressed: () {},
                      icon: const Image(
                        width: TSizes.iconMd,
                        height: TSizes.iconMd,
                        image: AssetImage(TImages.facebook),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
