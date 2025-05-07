import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:Tracio/core/generated/location.pbgrpc.dart';
import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import '../../../service_locator.dart';

abstract class ITrackingGrpcService {
  Future<LocationResponse> sendLocations({
    required int routeId,
    required List<Map<String, dynamic>> locations,
  });

  Future<void> close();
}

class TrackingGrpcService implements ITrackingGrpcService {
  late final LocationServiceClient _client;
  late final ClientChannel _channel;

  TrackingGrpcService._();

  static TrackingGrpcService init() {
    final service = TrackingGrpcService._();
    String token = "";
    Future.delayed(Duration(seconds: 2), () async {
      token = await sl<AuthLocalSource>().getToken();
    });
    service._channel = ClientChannel(
      '103.28.33.123',
      port: 6009,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    service._client = LocationServiceClient(
      service._channel,
      options: CallOptions(
        timeout: const Duration(seconds: 5),
        metadata: {
          'authorization': 'Bearer $token',
        },
      ),
    );

    return service;
  }

  @override
  Future<LocationResponse> sendLocations({
    required int routeId,
    required List<Map<String, dynamic>> locations,
  }) async {
    final request = LocationRequest()..routeId = routeId;

    for (final loc in locations) {
      request.locations.add(Location()
        ..latitude = loc['latitude']
        ..longitude = loc['longitude']
        ..timestamp = Int64(loc['timestamp'])
        ..speed = loc['speed']
        ..distance = loc['distance']
        ..altitude = loc['altitude']);
    }

    try {
      debugPrint('📍 gRPC Success: $request');
      final response = await _client.sendLocations(request);
      debugPrint('📍 gRPC Success: ${response.message}');
      return response;
    } catch (e) {
      debugPrint('❌ gRPC Error: $e');
      return LocationResponse(success: false, message: 'gRPC send failed');
    }
  }

  @override
  Future<void> close() async {
    await _channel.shutdown();
    debugPrint('🛑 gRPC channel closed');
  }
}
