import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to Supreme Steam Detail',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We are South Florida\'s premier mobile car detailing service, dedicated to providing exceptional quality and convenience to our customers.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              icon: Icons.cleaning_services,
              title: 'Our Mission',
              description:
                  'To deliver outstanding mobile detailing services using eco-friendly steam technology and premium products, ensuring your vehicle looks its absolute best.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              icon: Icons.star,
              title: 'Why Choose Us',
              description:
                  '• 100% Mobile - We come to you\n• Professional steam cleaning\n• Eco-friendly biodegradable products\n• Experienced and certified technicians\n• Satisfaction guaranteed',
            ),
            const SizedBox(height: 24),
            _buildSection(
              icon: Icons.phone,
              title: 'Contact Us',
              description:
                  'Have questions? We\'re here to help!\n\nEmail: info@supremesteamdetail.co\nPhone: (555) 123-4567\n\nServing: Miami, Fort Lauderdale, West Palm Beach, and surrounding areas',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.purple[200]!,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.eco,
                    size: 48,
                    color: Colors.green[700],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Eco-Friendly Promise',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We use biodegradable products and steam cleaning technology to minimize environmental impact while delivering superior results.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.purple[700],
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
