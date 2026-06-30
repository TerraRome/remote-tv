import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../../core/discovery/discovery_service.dart';
import '../../../../core/discovery/models/discovery_result.dart';

abstract interface class DiscoveryDatasource {
  Stream<DiscoveryResult> startDiscovery();
  Future<void> stopDiscovery();
}

@Injectable(as: DiscoveryDatasource)
final class DiscoveryDatasourceImpl implements DiscoveryDatasource {
  final DiscoveryService _discoveryService;

  DiscoveryDatasourceImpl(this._discoveryService);

  @override
  Stream<DiscoveryResult> startDiscovery() {
    return _discoveryService.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _discoveryService.stopDiscovery();
  }
}
