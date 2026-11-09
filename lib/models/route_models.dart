enum UserRole {
  kepalaGudang('Kepala Gudang'),
  driver('Driver'),
  admin('Admin SPK');

  final String label;
  const UserRole(this.label);

  static UserRole fromString(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.contains('driver') || normalized.contains('kurir')) {
      return UserRole.driver;
    }
    if (normalized.contains('admin') || normalized.contains('spk')) {
      return UserRole.admin;
    }
    return UserRole.kepalaGudang;
  }
}

class UserAccount {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final UserRole role;
  final String avatarAsset;

  const UserAccount({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.role,
    this.avatarAsset = 'assets/images/Profile.jpg',
  });

  String get roleLabel => role.label;
  String get occupation => role.label;

  UserAccount copyWith({
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    UserRole? role,
    String? avatarAsset,
  }) {
    return UserAccount(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      avatarAsset: avatarAsset ?? this.avatarAsset,
    );
  }
}

enum RequestStatus {
  pending,
  approved,
  rejected,
}

class MarketRequest {
  final String id;
  final String product;
  final int quantityPacks;
  final String destination;
  final String agentName;
  final String orderDate;
  final RequestStatus status;
  final double latitude;
  final double longitude;
  final double distanceKm;

  const MarketRequest({
    required this.id,
    required this.product,
    required this.quantityPacks,
    required this.destination,
    required this.agentName,
    required this.orderDate,
    this.status = RequestStatus.pending,
    this.latitude = -7.0051,
    this.longitude = 113.8626,
    this.distanceKm = 2.5,
  });

  MarketRequest copyWith({
    RequestStatus? status,
  }) {
    return MarketRequest(
      id: id,
      product: product,
      quantityPacks: quantityPacks,
      destination: destination,
      agentName: agentName,
      orderDate: orderDate,
      status: status ?? this.status,
      latitude: latitude,
      longitude: longitude,
      distanceKm: distanceKm,
    );
  }
}

enum DeliveryStatus {
  onProgress('On Progress...'),
  success('Success');

  final String label;
  const DeliveryStatus(this.label);
}

class DeliveryOrder {
  final String id;
  final String product;
  final String driverName;
  final String orderDate;
  final String expectedDate;
  final int quantityPacks;
  final String destination;
  final String agentName;
  final DeliveryStatus status;
  final double distanceKm;
  final double latitude;
  final double longitude;

  const DeliveryOrder({
    required this.id,
    required this.product,
    required this.driverName,
    required this.orderDate,
    required this.expectedDate,
    required this.quantityPacks,
    required this.destination,
    required this.agentName,
    required this.status,
    this.distanceKm = 2.5,
    this.latitude = -7.0051,
    this.longitude = 113.8626,
  });

  DeliveryOrder copyWith({
    DeliveryStatus? status,
    String? driverName,
  }) {
    return DeliveryOrder(
      id: id,
      product: product,
      driverName: driverName ?? this.driverName,
      orderDate: orderDate,
      expectedDate: expectedDate,
      quantityPacks: quantityPacks,
      destination: destination,
      agentName: agentName,
      status: status ?? this.status,
      distanceKm: distanceKm,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

class SpkAlternative {
  final String id;
  final String storeName;
  final String destination;
  final double distanceKm;
  final int itemCount;
  final double estimatedCostRp;
  final double travelTimeMinutes;
  final double latitude;
  final double longitude;
  final double sawScore;

  const SpkAlternative({
    required this.id,
    required this.storeName,
    required this.destination,
    required this.distanceKm,
    required this.itemCount,
    required this.estimatedCostRp,
    required this.travelTimeMinutes,
    this.latitude = -7.0051,
    this.longitude = 113.8626,
    this.sawScore = 0.0,
  });

  SpkAlternative copyWith({
    String? storeName,
    String? destination,
    double? distanceKm,
    int? itemCount,
    double? estimatedCostRp,
    double? travelTimeMinutes,
    double? latitude,
    double? longitude,
    double? sawScore,
  }) {
    return SpkAlternative(
      id: id,
      storeName: storeName ?? this.storeName,
      destination: destination ?? this.destination,
      distanceKm: distanceKm ?? this.distanceKm,
      itemCount: itemCount ?? this.itemCount,
      estimatedCostRp: estimatedCostRp ?? this.estimatedCostRp,
      travelTimeMinutes: travelTimeMinutes ?? this.travelTimeMinutes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      sawScore: sawScore ?? this.sawScore,
    );
  }
}
