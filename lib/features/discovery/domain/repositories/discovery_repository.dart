import '../entities/tv_device.dart';

abstract interface class DiscoveryRepository {
  Stream<TvDevice> watchDevices();
  Future<List<TvDevice>> getDevices();
  Future<void> stopDiscovery();
}
