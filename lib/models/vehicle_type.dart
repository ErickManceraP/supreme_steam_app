class VehicleType {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final String icon;

  VehicleType({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.icon,
  });

  static List<VehicleType> getAllTypes() {
    return [
      VehicleType(
        id: 'sedan',
        name: 'Sedan',
        description: 'Standard car wash for sedans',
        basePrice: 50.0,
        icon: '🚗',
      ),
      VehicleType(
        id: 'suv',
        name: 'SUV',
        description: 'Car wash for SUVs and crossovers',
        basePrice: 70.0,
        icon: '🚙',
      ),
      VehicleType(
        id: 'truck',
        name: 'Truck',
        description: 'Car wash for pickup trucks',
        basePrice: 80.0,
        icon: '🛻',
      ),
      VehicleType(
        id: 'van',
        name: 'Van/Minivan',
        description: 'Car wash for vans and minivans',
        basePrice: 75.0,
        icon: '🚐',
      ),
    ];
  }
}
