import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:tracio_fe/core/generated/location.pbgrpc.dart';

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

  TrackingGrpcService() {
    _channel = ClientChannel(
      '103.28.33.123',
      port: 6009,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    _client = LocationServiceClient(
      _channel,
      options: CallOptions(
        timeout: Duration(seconds: 5),
        metadata: {
          'authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkRHJtVHU2cnBDaFJJRUFKOTg5SHFnOFFXZjYzIiwianRpIjoiNDg1NjNmMzUtZmJiZC00YWJmLThlYjQtNjA0NmFlNWEwNzg1Iiwicm9sZSI6InVzZXIiLCJ1bmlxdWVfbmFtZSI6Ikzhu5ljIFRy4bqnbiBNaW5oIChTRTE3MTI0NikiLCJlbWFpbCI6InRybWlubG9jQGdtYWlsLmNvbSIsImN1c3RvbV9pZCI6IjIyIiwiYXZhdGFyIjoiaHR0cHM6Ly91c2VyYXZhdGFydHJhY2lvLnMzLmFtYXpvbmF3cy5jb20vN2ZjZDIzZmItNzQyYS00NmFmLTgyNDAtNWFkZmE1NGE0NTJjX2F2YXRhciUyMGZpbmFsLmpwZyIsIm5iZiI6MTc0NDMyMDk2NywiZXhwIjoxODM5MDE1MzY3LCJpYXQiOjE3NDQzMjA5NjcsImlzcyI6IlVzZXIiLCJhdWQiOiJodHRwczovL3VzZXIudHJhY2lvLnNwYWNlIn0.qhrqrAzvyDjDuVgxM382cGBjDOl-NBYnuS-4xt1EsqM',
        },
      ),
    );
  }

  @override
  Future<LocationResponse> sendLocations({
    required int routeId,
    required List<Map<String, dynamic>> locations,
  }) async {
    final request = LocationRequest()..routeId = routeId;

    for (final loc in locations) {
      final location = Location()
        ..latitude = loc['latitude']
        ..longitude = loc['longitude']
        ..timestamp = Int64(loc['timestamp'])
        ..speed = loc['speed']
        ..distance = loc['distance']
        ..altitude = loc['altitude'];
      request.locations.add(location);
    }

    try {
      final response = await _client.sendLocations(request);
      if (kDebugMode) {
        print('📍 gRPC Success: ${response.message}');
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ gRPC Error: $e');
      }
      return LocationResponse(success: false, message: 'gRPC send failed');
    }
  }

  @override
  Future<void> close() async {
    await _channel.shutdown();
    if (kDebugMode) {
      print('🛑 gRPC channel closed');
    }
  }
}
