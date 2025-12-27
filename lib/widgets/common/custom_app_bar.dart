import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              // Leading
              if (showBackButton)
                _buildBackButton(context)
              else if (leading != null)
                leading!
              else
                SizedBox(width: 40),
              
              // Title
              Expanded(
                child: centerTitle
                    ? Center(
                        child: _buildTitle(),
                      )
                    : _buildTitle(),
              ),
              
              // Actions
              if (actions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                )
              else
                SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: AppTextStyles.headingMedium.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}