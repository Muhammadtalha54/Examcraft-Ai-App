import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'media_query_helper.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool hasBackButton;
  final VoidCallback? onBackPressed;

  const ModernAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
    this.hasBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.glowBorder.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Leading
              if (hasBackButton || leading != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.glowBorder.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: leading ??
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: onBackPressed ?? () => Navigator.pop(context),
                        child: Icon(
                          CupertinoIcons.back,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                ),
              
              // Title
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: context.screenWidth * 0.045,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              
              // Actions
              if (actions != null)
                Row(children: actions!)
              else
                SizedBox(width: 40), // Balance the leading
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56 + MediaQuery.of(NavigationService.navigatorKey.currentContext!).padding.top);
}

// Navigation service for accessing context
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}