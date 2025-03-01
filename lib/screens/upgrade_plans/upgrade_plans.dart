import 'package:flutter/material.dart';

class UpgradePlansScreen extends StatelessWidget {
  const UpgradePlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Plans'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select the plan that works best for you',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            
            // Free Plan
            _buildPlanCard(
              context,
              title: 'Free',
              price: '\$0',
              period: 'forever',
              features: [
                'Up to 20 messages per day',
                'Basic AI capabilities',
                'Standard response time',
                'Text-only responses',
              ],
              isCurrentPlan: true,
              buttonText: 'Current Plan',
              buttonColor: Colors.grey,
            ),
            const SizedBox(height: 16),
            
            // Plus Plan
            _buildPlanCard(
              context,
              title: 'Plus',
              price: '\$9.99',
              period: 'per month',
              features: [
                'Up to 100 messages per day',
                'Advanced AI capabilities',
                'Faster response time',
                'Text and basic image generation',
                'Priority support',
              ],
              isRecommended: true,
              buttonText: 'Upgrade to Plus',
              buttonColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            
            // Premium Plan
            _buildPlanCard(
              context,
              title: 'Premium',
              price: '\$19.99',
              period: 'per month',
              features: [
                'Unlimited messages',
                'Most advanced AI capabilities',
                'Fastest response time',
                'Text, image, and audio generation',
                '24/7 priority support',
                'Custom AI training',
              ],
              buttonText: 'Upgrade to Premium',
              buttonColor: Colors.amber[800]!,
            ),
            
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'All plans include a 7-day free trial.\nCancel anytime.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    required List<String> features,
    bool isRecommended = false,
    bool isCurrentPlan = false,
    required String buttonText,
    required Color buttonColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRecommended
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withOpacity(0.2),
              width: isRecommended ? 2 : 1,
            ),
            boxShadow: isRecommended
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      period,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(feature),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrentPlan ? null : () {
                    // Upgrade plan functionality
                    if (!isCurrentPlan) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Upgrade to $title Plan'),
                          content: Text('Are you sure you want to upgrade to the $title plan?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Upgraded to $title plan!')),
                                );
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentPlan ? Colors.grey : buttonColor, // Grey if it's the current plan
                    foregroundColor: Colors.white, // White text
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: Colors.grey, // Ensure it's grey when disabled
                    disabledForegroundColor: Colors.white, // White text when disabled
                  ),
                  child: Text(buttonText),
                ),
              ),

            ],
          ),
        ),
        if (isRecommended)
          Positioned(
            top: -12,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Recommended',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

