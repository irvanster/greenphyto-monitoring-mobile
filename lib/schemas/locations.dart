class CurrentMonitor {
  final String id;
  final String soilEc;
  final String soilPh;
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
    required this.soilPh,
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
      soilPh: json['soil_ph'] ?? '',
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

//locations history / detail
class LocationDetail {
  final String locationId;
  final String locationName;
  final String locationImage;
  final List<HistoryData> history;

  LocationDetail({
    required this.locationId,
    required this.locationName,
    required this.locationImage,
    required this.history,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> json) {
    return LocationDetail(
      locationId: json['location_id'] ?? '',
      locationName: json['location_name'] ?? '',
      locationImage: json['location_image'] ?? '',
      history: List<HistoryData>.from((json['history'] ?? [])
          .map((historyItem) => HistoryData.fromJson(historyItem))),
    );
  }
}

class HistoryData {
  final String id;
  final String lightIntensity;
  final String waterPh;
  final String waterTss;
  final String waterEc;
  final String waterTds;
  final String soilTemperature;
  final String soilEc;
  final String soilPh;
  final String soilMoisture;
  final String weatherHumidity;
  final String weatherTemperature;
  final String createdAt;

  HistoryData({
    required this.id,
    required this.lightIntensity,
    required this.waterPh,
    required this.waterTss,
    required this.waterEc,
    required this.waterTds,
    required this.soilPh,
    required this.soilTemperature,
    required this.soilEc,
    required this.soilMoisture,
    required this.weatherHumidity,
    required this.weatherTemperature,
    required this.createdAt,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      id: json['id'] ?? '',
      lightIntensity: json['light_intensity'] ?? '',
      waterPh: json['water_ph'] ?? '',
      waterTss: json['water_tss'] ?? '',
      waterEc: json['water_ec'] ?? '',
      waterTds: json['water_tds'] ?? '',
      soilTemperature: json['soil_temperature'] ?? '',
      soilEc: json['soil_ec'] ?? '',
      soilPh: json['soil_ph'] ?? '',
      soilMoisture: json['soil_moisture'] ?? '',
      weatherHumidity: json['weather_humidity'] ?? '',
      weatherTemperature: json['weather_temperature'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
