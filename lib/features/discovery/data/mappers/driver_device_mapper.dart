import 'package:injectable/injectable.dart';
import '../../../../core/drivers/models/driver_device.dart';
import '../../domain/entities/tv_device.dart';

@injectable
final class DriverDeviceMapper {
  TvDevice mapToTvDevice(DriverDevice driverDevice) {
    return TvDevice(
      id: driverDevice.id,
      name: driverDevice.name,
      ipAddress: driverDevice.ipAddress,
      port: driverDevice.port,
      deviceType: driverDevice.deviceType,
      modelName: driverDevice.modelName,
      manufacturer: driverDevice.manufacturer,
      metadata: driverDevice.metadata,
    );
  }
}
