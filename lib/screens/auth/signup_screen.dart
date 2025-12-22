import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/app_textfield.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/snackbar.dart';
import '../../widgets/common/ios_transition.dart';
import '../../utils/validators.dart';
import '../home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (Validators.required(name, 'Name') != null) {
      AppSnackbar.show(context, 'Please enter your name', isError: true);
      return;
    }

    if (Validators.email(email) != null) {
      AppSnackbar.show(context, 'Please enter a valid email', isError: true);
      return;
    }

    if (Validators.password(password) != null) {
      AppSnackbar.show(context, 'Password must be at least 6 characters', isError: true);
      return;
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signup(name, email, password);
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          IOSPageRoute(child: const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(context, e.toString(), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back, color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/examcraftAI.png',
                  width: context.screenWidth * 0.4,
                  height: context.screenWidth * 0.4,
                ),
                SizedBox(height: 20),
                Text(
                  'Create Account',
                  style: GoogleFonts.lato(
                    fontSize: context.screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: GoogleFonts.lato(
                    fontSize: context.screenWidth * 0.04,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 40),
                AppTextField(
                  hintText: 'Full Name',
                  controller: _nameController,
                  validator: (value) => Validators.required(value, 'Name'),
                ),
                SizedBox(height: 16),
                AppTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                SizedBox(height: 16),
                AppTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: Validators.password,
                ),
                SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return AppButton(
                      text: 'Sign Up',
                      onPressed: _handleSignup,
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.lato(
                        color: AppColors.textSecondary,
                        fontSize: context.screenWidth * 0.035,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Login',
                        style: GoogleFonts.lato(
                          color: AppColors.primary,
                          fontSize: context.screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}