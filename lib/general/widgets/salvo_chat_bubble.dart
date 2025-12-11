import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/general/widgets/ai_badge.dart';

class SalvoChatBubble extends StatefulWidget {
  final VoidCallback? onClose;
  final Function(String)? onOptionSelected;
  final VoidCallback? onMicrophoneTap;

  const SalvoChatBubble({
    super.key,
    this.onClose,
    this.onOptionSelected,
    this.onMicrophoneTap,
  });

  @override
  State<SalvoChatBubble> createState() => _SalvoChatBubbleState();
}

class _SalvoChatBubbleState extends State<SalvoChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _close() {
    _animationController.reverse().then((_) {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 450),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: GVColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: GVColors.blackWithAlpha30,
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: _close,
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(40, 40),
                        shape: const CircleBorder(),
                      ),
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: GVColors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with greeting message
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: GVColors.guidaEvaiOrangeWithAlpha60,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.salvoGreeting,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 15,
                                  color: GVColors.black,
                                  height: 1.2,
                                ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Option buttons
                        _buildOptionButton(
                          AppLocalizations.of(context)!.reviewTopic,
                          'reviewTopic',
                        ),
                        const SizedBox(height: 8),
                        _buildOptionButton(
                          AppLocalizations.of(context)!.quizDoubts,
                          'quizDoubts',
                        ),
                        const SizedBox(height: 8),
                        _buildOptionButton(
                          AppLocalizations.of(context)!.fullSimulation,
                          'fullSimulation',
                        ),

                        const SizedBox(height: 16),

                        // Bottom section with Salvo avatar and microphone
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Microphone icon
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: widget.onMicrophoneTap,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: GVColors.lightGreyButton,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.keyboard_alt_outlined,
                                    color: GVColors.black,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Salvo avatar with AI badge
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 79,
                                  height: 79,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        'assets/images/figma_designs/avatar_default_user.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // AI badge positioned at bottom-right of avatar
                                const Positioned(
                                  right: -2,
                                  bottom: -4,
                                  child: AIBadge(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(String text, String option) {
    return InkWell(
      onTap: () => widget.onOptionSelected?.call(option),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: GVColors.mediumGrey, width: 0.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 14, color: GVColors.black),
        ),
      ),
    );
  }
}
