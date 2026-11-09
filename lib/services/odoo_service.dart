import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:route_wise/models/route_models.dart';

class OdooService {
  final String baseUrl;
  final String database;
  final http.Client _client;
  String? _sessionId;
  int? _uid;

  OdooService({
    this.baseUrl = const String.fromEnvironment(
      'ODOO_URL',
      defaultValue: 'http://localhost:8069',
    ),
    this.database = const String.fromEnvironment(
      'ODOO_DB',
      defaultValue: 'routewise_erp',
    ),
    http.Client? client,
  }) : _client = client ?? http.Client();

  bool get isAuthenticated => _uid != null;

  Future<bool> authenticate({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/web/session/authenticate');
    final payload = {
      'jsonrpc': '2.0',
      'method': 'call',
      'params': {
        'db': database,
        'login': username,
        'password': password,
      },
      'id': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return false;
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        _sessionId = setCookie.split(';').first;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final result = body['result'] as Map<String, dynamic>?;
      final uid = result?['uid'];
      if (uid is int && uid > 0) {
        _uid = uid;
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<List<MarketRequest>> fetchMarketRequests() async {
    final records = await _callKw(
      model: 'sale.order',
      method: 'search_read',
      args: [
        [
          ['state', 'in', ['draft', 'sent', 'sale']]
        ]
      ],
      kwargs: {
        'fields': [
          'id',
          'name',
          'partner_id',
          'date_order',
          'amount_total',
          'state',
        ],
        'limit': 50,
      },
    );

    if (records is! List) return const [];

    return records.map((raw) {
      final map = raw as Map<String, dynamic>;
      final partner = map['partner_id'];
      final partnerName =
          (partner is List && partner.length > 1) ? partner[1].toString() : '-';
      final state = map['state']?.toString() ?? 'draft';

      return MarketRequest(
        id: 'odoo-so-${map['id']}',
        product: map['name']?.toString() ?? 'Djava Mild',
        quantityPacks: ((map['amount_total'] as num?)?.toInt() ?? 200),
        destination: partnerName,
        agentName: partnerName,
        orderDate: map['date_order']?.toString() ?? '',
        status: state == 'sale'
            ? RequestStatus.approved
            : RequestStatus.pending,
      );
    }).toList();
  }

  Future<List<DeliveryOrder>> fetchDeliveryOrders() async {
    final records = await _callKw(
      model: 'stock.picking',
      method: 'search_read',
      args: [
        [
          ['picking_type_code', '=', 'outgoing']
        ]
      ],
      kwargs: {
        'fields': [
          'id',
          'name',
          'origin',
          'partner_id',
          'scheduled_date',
          'date_done',
          'state',
        ],
        'limit': 50,
      },
    );

    if (records is! List) return const [];

    return records.map((raw) {
      final map = raw as Map<String, dynamic>;
      final partner = map['partner_id'];
      final partnerName =
          (partner is List && partner.length > 1) ? partner[1].toString() : '-';
      final state = map['state']?.toString() ?? 'assigned';

      return DeliveryOrder(
        id: 'odoo-pick-${map['id']}',
        product: map['origin']?.toString() ?? map['name']?.toString() ?? '-',
        driverName: 'Ilham Maulana',
        orderDate: map['scheduled_date']?.toString() ?? '',
        expectedDate:
            map['date_done']?.toString() ?? map['scheduled_date']?.toString() ?? '',
        quantityPacks: 200,
        destination: partnerName,
        agentName: partnerName,
        status: state == 'done'
            ? DeliveryStatus.success
            : DeliveryStatus.onProgress,
      );
    }).toList();
  }

  Future<dynamic> _callKw({
    required String model,
    required String method,
    required List<dynamic> args,
    Map<String, dynamic> kwargs = const {},
  }) async {
    final uri = Uri.parse('$baseUrl/web/dataset/call_kw');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (_sessionId != null) 'Cookie': _sessionId!,
    };

    final payload = {
      'jsonrpc': '2.0',
      'method': 'call',
      'params': {
        'model': model,
        'method': method,
        'args': args,
        'kwargs': kwargs,
      },
      'id': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      final response = await _client
          .post(uri, headers: headers, body: jsonEncode(payload))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded['result'];
    } catch (_) {
      return null;
    }
  }
}
