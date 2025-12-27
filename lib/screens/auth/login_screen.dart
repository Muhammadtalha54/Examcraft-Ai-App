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
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

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
      await authProvider.login(email, password);
      
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: context.screenHeight - context.statusBarHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    width: context.screenWidth * 0.4,
                    height: context.screenWidth * 0.4,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.raleway(
                    fontSize: context.screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to continue your learning journey',
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
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                              context,
                              IOSPageRoute(child: const ForgotPasswordScreen()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: context.screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return AppButton(
                            text: 'Login',
                            onPressed: _handleLogin,
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
                      'Don\'t have an account? ',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: context.screenWidth * 0.035,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          IOSPageRoute(child: const SignupScreen()),
                        );
                      },
                      child: Text(
                        'Sign Up',
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
      ),
    );
  }
}