class Service {
  final String id;
  final String name;
  final String description;
  final String price;
  final List<String> features;
  final String icon;
  final String? duration;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
    required this.icon,
    this.duration,
  });

  static List<Service> getAllServices() {
    return [
      Service(
        id: 'basic_wash',
        name: 'Basic Wash',
        description: 'Essential cleaning for your vehicle',
        price: '\$40-\$60',
        duration: '30-45 min',
        icon: '🚿',
        features: [
          'Exterior hand wash',
          'Wheel & tire cleaning',
          'Window cleaning',
          'Quick interior vacuum',
        ],
      ),
      Service(
        id: 'premium_wash',
        name: 'Premium Wash',
        description: 'Complete interior & exterior cleaning',
        price: '\$80-\$120',
        duration: '1-1.5 hours',
        icon: '✨',
        features: [
          'Everything in Basic Wash',
          'Deep interior cleaning',
          'Dashboard & console detail',
          'Door jamb cleaning',
          'Tire shine',
        ],
      ),
      Service(
        id: 'steam_detail',
        name: 'Steam Detail Complete',
        description: 'Professional steam cleaning treatment',
        price: '\$150-\$200',
        duration: '2-3 hours',
        icon: '💎',
        features: [
          'Everything in Premium Wash',
          'Steam cleaning interior',
          'Leather conditioning',
          'Engine bay cleaning',
          'Paint sealant',
          'Headlight restoration',
        ],
      ),
      Service(
        id: 'ceramic_coating',
        name: 'Ceramic Coating',
        description: 'Long-lasting paint protection',
        price: '\$400-\$800',
        duration: '4-6 hours',
        icon: '🛡️',
        features: [
          'Paint decontamination',
          'Clay bar treatment',
          'Paint correction (1-2 steps)',
          'Ceramic coating application',
          '3-5 year protection',
          'Hydrophobic finish',
        ],
      ),
      Service(
        id: 'paint_correction',
        name: 'Paint Correction',
        description: 'Remove swirls, scratches & oxidation',
        price: '\$300-\$600',
        duration: '4-8 hours',
        icon: '🎨',
        features: [
          'Full paint decontamination',
          'Clay bar treatment',
          'Multi-step polishing',
          'Swirl & scratch removal',
          'Paint sealant application',
          'Before/after photos',
        ],
      ),
      Service(
        id: 'interior_detail',
        name: 'Interior Deep Clean',
        description: 'Thorough interior restoration',
        price: '\$120-\$180',
        duration: '2-3 hours',
        icon: '🧼',
        features: [
          'Complete vacuum',
          'Steam cleaning all surfaces',
          'Leather/fabric treatment',
          'Stain removal',
          'Odor elimination',
          'UV protection',
        ],
      ),
    ];
  }

  static Service getServiceById(String id) {
    return getAllServices().firstWhere(
      (service) => service.id == id,
      orElse: () => getAllServices().first,
    );
  }
}
