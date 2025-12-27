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
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.glowBorder.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              CupertinoIcons.back,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              // Logo with modern styling
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/examcraftAI.png',
                  width: context.screenWidth * 0.35,
                  height: context.screenWidth * 0.35,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Create Account',
                style: GoogleFonts.raleway(
                  fontSize: context.screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Join us to start your learning journey',
                style: GoogleFonts.inter(
                  fontSize: context.screenWidth * 0.038,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 40),
              
              // Form container with modern styling
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.glowBorder.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Column(
                  children: [
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
                    SizedBox(height: 24),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return AppButton(
                          text: 'Sign Up',
                          onPressed: _handleSignup,
                          isLoading: authProvider.isLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: context.screenWidth * 0.035,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Login',
                      style: GoogleFonts.inter(
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
    );
  }
}