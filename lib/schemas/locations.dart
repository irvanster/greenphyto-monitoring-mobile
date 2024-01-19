class CurrentMonitor {
  final String id;
  final String soilEc;
  final List<String> soilNpk;
  final String waterEc;
  final String waterPh;
  final String waterTds;
  final String createdAt;
  final String soilMoisture;
  final String lightIntensity;
  final String waterTss;
  final String soilTemperature;
  final String weatherHumidity;
  final String weatherTemperature;

  const CurrentMonitor({
    required this.id,
    required this.soilEc,
    required this.soilNpk,
    required this.waterEc,
    required this.waterPh,
    required this.waterTds,
    required this.createdAt,
    required this.soilMoisture,
    required this.lightIntensity,
    required this.waterTss,
    required this.soilTemperature,
    required this.weatherHumidity,
    required this.weatherTemperature,
  });

  factory CurrentMonitor.fromJson(Map<String, dynamic> json) {
    return CurrentMonitor(
      id: json['id'] as String,
      soilEc: json['soil_ec'] as String,
      soilNpk: List<String>.from(json['soil_npk'] as List),
      waterEc: json['water_ec'] as String,
      waterPh: json['water_ph'] as String,
      waterTds: json['water_tds'] as String,
      createdAt: json['created_at'] as String,
      soilMoisture: json['soil_moisture'] as String,
      lightIntensity: json['light_intensity'] as String,
      waterTss: json['water_tss'] as String,
      soilTemperature: json['soil_temperature'] as String,
      weatherHumidity: json['weather_humidity'] as String,
      weatherTemperature: json['weather_temperature'] as String,
    );
  }
}

class Location {
  final String locationId;
  final String locationName;
  final String locationImage;
  final CurrentMonitor currentMonitor;

  const Location({
    required this.locationId,
    required this.locationName,
    required this.locationImage,
    required this.currentMonitor,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['location_id'] as String,
      locationName: json['location_name'] as String,
      locationImage: json['location_image'] as String,
      currentMonitor: CurrentMonitor.fromJson(
          json['current_monitor'] as Map<String, dynamic>),
    );
  }
}
