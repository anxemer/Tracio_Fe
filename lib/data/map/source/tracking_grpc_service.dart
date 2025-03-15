import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:tracio_fe/core/generated/location.pbgrpc.dart';

abstract class ITrackingGrpcService {
  Future<LocationResponse> sendLocation({
    required int routeId,
    required double latitude,
    required double longitude,
    double? altitude,
    required int timestamp,
  });

  Future<void> close();
}

class TrackingGrpcService implements ITrackingGrpcService {
  late LocationServiceClient _client;
  late ClientChannel _channel;

  TrackingGrpcService() {
    _channel = ClientChannel(
      '10.0.2.2',
      port: 6009,
      options: ChannelOptions(
        credentials: ChannelCredentials.secure(
          onBadCertificate: (cert, host) => true,
        ),
      ),
    );
    _client = LocationServiceClient(_channel,
        options: CallOptions(timeout: const Duration(seconds: 5)));
  }

  @override
  Future<LocationResponse> sendLocation({
    required int routeId,
    required double latitude,
    required double longitude,
    double? altitude,
    required int timestamp,
  }) async {
    final request = LocationRequest()
      ..routeId = routeId
      ..latitude = latitude
      ..longitude = longitude
      ..altitude = altitude ?? 0.0
      ..timestamp = Int64(timestamp);

    try {
      final response = await _client.sendLocation(request);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error sending location: $e');
      }
      return LocationResponse(success: false, message: 'Failed');
    }
  }

  @override
  Future<void> close() async {
    await _channel.shutdown();
  }
}
