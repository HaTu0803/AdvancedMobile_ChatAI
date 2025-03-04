import 'package:flutter/material.dart';

class UpgradePlansScreen extends StatelessWidget {
  const UpgradePlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Plans'),
        centerTitle: true,
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
            Text(
              'Select the plan that works best for you',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                'Basic AI responses',
                '50 messages per day',
                'Standard response time',
                'Text-only interactions',
              ],
              isCurrentPlan: true,
              buttonText: 'Current Plan',
            ),
            
            const SizedBox(height: 16),
            
            // Plus Plan
            _buildPlanCard(
              context,
              title: 'Plus',
              price: '\$9.99',
              period: 'per month',
              features: [
                'Advanced AI responses',
                'Unlimited messages',
                'Faster response time',
                'Image and voice interactions',
                'Custom AI bots',
              ],
              isPrimary: true,
              buttonText: 'Upgrade Now',
            ),
            
            const SizedBox(height: 16),
            
            // Premium Plan
            _buildPlanCard(
              context,
              title: 'Premium',
              price: '\$19.99',
              period: 'per month',
              features: [
                'Priority AI responses',
                'Unlimited messages',
                'Fastest response time',
                'All interaction types',
                'Unlimited custom AI bots',
                'API access',
                'Priority support',
              ],
              buttonText: 'Upgrade Now',
            ),
            const SizedBox(height: 32),

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
    bool isPrimary = false,
    bool isCurrentPlan = false,
    required String buttonText,
  }) {
    return Card(
      elevation: isPrimary ? 4 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isPrimary
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: isPrimary ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isPrimary
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (isPrimary)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Most Popular',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
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
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    period,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                  Text(feature),
                ],
              ),
            )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: isCurrentPlan
                  ? OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        disabledForegroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Text(buttonText),
                    )
                  : FilledButton(
                      onPressed: () {
                        // Handle upgrade
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isPrimary
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      child: Text(buttonText),
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  
  TableRow _buildTableRow(
    BuildContext context, {
    required List<String> cells,
    bool isHeader = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader
            ? Theme.of(context).colorScheme.surfaceVariant
            : null,
      ),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            cell,
            style: isHeader
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
            textAlign: cells.indexOf(cell) == 0
                ? TextAlign.left
                : TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}

