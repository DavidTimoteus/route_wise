import 'package:flutter/material.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/spk_calculator.dart';

class AppState extends ChangeNotifier {
  final List<UserAccount> _accounts = [
    const UserAccount(
      id: 'usr-1',
      fullName: 'David Timoteus',
      email: 'david@routewise.id',
      password: 'password123',
      phoneNumber: '081234567890',
      role: UserRole.kepalaGudang,
      avatarAsset: 'assets/images/ProfilAdmin.jpg',
    ),
    const UserAccount(
      id: 'usr-2',
      fullName: 'Ilham Maulana Ahmad',
      email: 'Maulana@gmail.com',
      password: 'password123',
      phoneNumber: '081352673477',
      role: UserRole.driver,
      avatarAsset: 'assets/images/Profile.jpg',
    ),
    const UserAccount(
      id: 'usr-3',
      fullName: 'Moh Iqbal Fatoni',
      email: 'iqbal@routewise.id',
      password: 'password123',
      phoneNumber: '081398765432',
      role: UserRole.admin,
      avatarAsset: 'assets/images/hero.jpg',
    ),
  ];

  UserAccount _currentUser = const UserAccount(
    id: 'usr-1',
    fullName: 'Ilham Maulana Ahmad',
    email: 'Maulana@gmail.com',
    password: 'password123',
    phoneNumber: '081352673477',
    role: UserRole.kepalaGudang,
    avatarAsset: 'assets/images/Profile.jpg',
  );

  final List<MarketRequest> _requests = [
    const MarketRequest(
      id: 'req-1',
      product: 'Djava Mild',
      quantityPacks: 200,
      destination: 'JL Trunojoyo No 212',
      agentName: 'Arudam Djaya Sumenep',
      orderDate: '10/22/2023 13:41:05',
      latitude: -7.0086,
      longitude: 113.8582,
      distanceKm: 2.5,
    ),
    const MarketRequest(
      id: 'req-2',
      product: 'Djava Ocha',
      quantityPacks: 350,
      destination: 'Jl. Diponegoro No. 45',
      agentName: 'Toko Barokah',
      orderDate: '10/23/2023 09:15:00',
      latitude: -7.0145,
      longitude: 113.8654,
      distanceKm: 3.8,
    ),
    const MarketRequest(
      id: 'req-3',
      product: 'Djava Traditional',
      quantityPacks: 150,
      destination: 'Jl. Panglima Sudirman No. 88',
      agentName: 'Toko Sejahtera',
      orderDate: '10/24/2023 11:20:30',
      latitude: -7.0012,
      longitude: 113.8710,
      distanceKm: 4.2,
    ),
  ];

  final List<DeliveryOrder> _deliveries = [
    const DeliveryOrder(
      id: 'del-1',
      product: 'Djava Mild',
      driverName: 'Ilham Maulana',
      orderDate: '10/22/2023 13:41:05',
      expectedDate: '10/22/2023 15:00:00',
      quantityPacks: 200,
      destination: 'JL Trunojoyo No 212',
      agentName: 'Arudam Djaya Sumenep',
      status: DeliveryStatus.success,
      distanceKm: 2.5,
      latitude: -7.0086,
      longitude: 113.8582,
    ),
    const DeliveryOrder(
      id: 'del-2',
      product: 'Djava Ocha',
      driverName: 'Ilham Maulana',
      orderDate: '10/23/2023 09:15:00',
      expectedDate: '10/23/2023 11:30:00',
      quantityPacks: 350,
      destination: 'Jl. Diponegoro No. 45',
      agentName: 'Toko Barokah',
      status: DeliveryStatus.onProgress,
      distanceKm: 3.8,
      latitude: -7.0145,
      longitude: 113.8654,
    ),
    const DeliveryOrder(
      id: 'del-3',
      product: 'Djava Traditional',
      driverName: 'Ilham Maulana',
      orderDate: '10/24/2023 11:20:30',
      expectedDate: '10/24/2023 14:00:00',
      quantityPacks: 150,
      destination: 'Jl. Panglima Sudirman No. 88',
      agentName: 'Toko Sejahtera',
      status: DeliveryStatus.onProgress,
      distanceKm: 4.2,
      latitude: -7.0012,
      longitude: 113.8710,
    ),
  ];

  List<SpkAlternative> _spkAlternatives = SpkCalculator.rankBySaw(const [
    SpkAlternative(
      id: 'spk-1',
      storeName: 'Toko Arudam',
      destination: 'Jl Trunojoyo No 212',
      distanceKm: 2.5,
      itemCount: 912,
      estimatedCostRp: 45000,
      travelTimeMinutes: 12,
      latitude: -7.0086,
      longitude: 113.8582,
    ),
    SpkAlternative(
      id: 'spk-2',
      storeName: 'Toko Barokah',
      destination: 'Jl. Diponegoro No. 45',
      distanceKm: 3.8,
      itemCount: 350,
      estimatedCostRp: 65000,
      travelTimeMinutes: 18,
      latitude: -7.0145,
      longitude: 113.8654,
    ),
    SpkAlternative(
      id: 'spk-3',
      storeName: 'Toko Sejahtera',
      destination: 'Jl. Panglima Sudirman No. 88',
      distanceKm: 4.2,
      itemCount: 520,
      estimatedCostRp: 70000,
      travelTimeMinutes: 22,
      latitude: -7.0012,
      longitude: 113.8710,
    ),
  ]);

  UserAccount get currentUser => _currentUser;
  List<MarketRequest> get requests => List.unmodifiable(_requests);
  List<DeliveryOrder> get deliveries => List.unmodifiable(_deliveries);
  List<SpkAlternative> get spkAlternatives =>
      List.unmodifiable(_spkAlternatives);

  int get pendingRequestCount =>
      _requests.where((r) => r.status == RequestStatus.pending).length;

  int get activeDeliveryCount =>
      _deliveries.where((d) => d.status == DeliveryStatus.onProgress).length;

  bool login({required String email, required String password}) {
    final trimmedEmail = email.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.email.toLowerCase() == trimmedEmail) {
        if (password.isNotEmpty) {
          _currentUser = account;
          notifyListeners();
          return true;
        }
      }
    }
    if (trimmedEmail.isNotEmpty && password.isNotEmpty) {
      _currentUser = UserAccount(
        id: 'usr-${_accounts.length + 1}',
        fullName: trimmedEmail.split('@').first,
        email: email.trim(),
        password: password,
        phoneNumber: '081352673477',
        role: UserRole.fromString(trimmedEmail),
      );
      _accounts.add(_currentUser);
      notifyListeners();
      return true;
    }
    return false;
  }

  UserAccount register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String occupation,
  }) {
    final newUser = UserAccount(
      id: 'usr-${_accounts.length + 1}',
      fullName: fullName.trim().isEmpty ? 'Pengguna RouteWise' : fullName.trim(),
      email: email.trim().isEmpty ? 'user@routewise.id' : email.trim(),
      password: password,
      phoneNumber: phoneNumber.trim().isEmpty ? '-' : phoneNumber.trim(),
      role: UserRole.fromString(occupation),
    );
    _accounts.add(newUser);
    _currentUser = newUser;
    notifyListeners();
    return newUser;
  }

  void updateProfile({
    required String fullName,
    required String email,
    String? password,
    required String phoneNumber,
  }) {
    _currentUser = _currentUser.copyWith(
      fullName: fullName.trim().isEmpty ? _currentUser.fullName : fullName.trim(),
      email: email.trim().isEmpty ? _currentUser.email : email.trim(),
      password: (password != null && password.isNotEmpty)
          ? password
          : _currentUser.password,
      phoneNumber: phoneNumber.trim().isEmpty
          ? _currentUser.phoneNumber
          : phoneNumber.trim(),
    );
    notifyListeners();
  }

  void updateRequestStatus(String requestId, RequestStatus newStatus) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;

    final updated = _requests[index].copyWith(status: newStatus);
    _requests[index] = updated;

    if (newStatus == RequestStatus.approved) {
      final alreadyExists =
          _deliveries.any((d) => d.id == 'del-from-$requestId');
      if (!alreadyExists) {
        _deliveries.insert(
          0,
          DeliveryOrder(
            id: 'del-from-$requestId',
            product: updated.product,
            driverName: _currentUser.fullName,
            orderDate: updated.orderDate,
            expectedDate: updated.orderDate,
            quantityPacks: updated.quantityPacks,
            destination: updated.destination,
            agentName: updated.agentName,
            status: DeliveryStatus.onProgress,
            distanceKm: updated.distanceKm,
            latitude: updated.latitude,
            longitude: updated.longitude,
          ),
        );
      }
    }
    notifyListeners();
  }

  void toggleDeliveryStatus(String deliveryId) {
    final index = _deliveries.indexWhere((d) => d.id == deliveryId);
    if (index == -1) return;

    final current = _deliveries[index];
    final nextStatus = current.status == DeliveryStatus.success
        ? DeliveryStatus.onProgress
        : DeliveryStatus.success;
    _deliveries[index] = current.copyWith(status: nextStatus);
    notifyListeners();
  }

  void upsertSpkAlternative({
    required String storeName,
    required double distanceKm,
    required int itemCount,
    required double estimatedCostRp,
    required double travelTimeMinutes,
    String? destination,
  }) {
    final existingIndex = _spkAlternatives.indexWhere(
      (item) => item.storeName.toLowerCase() == storeName.trim().toLowerCase(),
    );

    if (existingIndex >= 0) {
      final current = _spkAlternatives[existingIndex];
      _spkAlternatives[existingIndex] = current.copyWith(
        distanceKm: distanceKm,
        itemCount: itemCount,
        estimatedCostRp: estimatedCostRp,
        travelTimeMinutes: travelTimeMinutes,
        destination: destination ?? current.destination,
      );
    } else {
      _spkAlternatives.add(
        SpkAlternative(
          id: 'spk-${_spkAlternatives.length + 1}',
          storeName: storeName.trim(),
          destination: destination ?? 'Sumenep, Jawa Timur',
          distanceKm: distanceKm,
          itemCount: itemCount,
          estimatedCostRp: estimatedCostRp,
          travelTimeMinutes: travelTimeMinutes,
          latitude: -7.0051 - (_spkAlternatives.length * 0.004),
          longitude: 113.8626 + (_spkAlternatives.length * 0.004),
        ),
      );
    }
    _spkAlternatives = SpkCalculator.rankBySaw(_spkAlternatives);
    notifyListeners();
  }

  void recalculateSpkRanking() {
    _spkAlternatives = SpkCalculator.rankBySaw(_spkAlternatives);
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateScope>()
        ?.notifier;
  }

  static AppState of(BuildContext context) {
    final state = maybeOf(context);
    if (state != null) {
      return state;
    }
    return _fallbackState;
  }

  static final AppState _fallbackState = AppState();
}
