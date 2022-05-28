

class WeatherInfo {
  final String description;
 final String icon;

  WeatherInfo({ required this.description, required this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
   final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(description: description, icon: icon);
  }
}

class TemperatureInfo {
  final double temperature;

  TemperatureInfo({required this.temperature});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    final temperature = json['temp'];
    return TemperatureInfo(temperature: temperature);
  }
}
class feel {
  final double feels_like;

  feel({required this.feels_like});

  factory feel.fromJson(Map<String, dynamic> json) {
    final feels_like = json['feels_like'];
    return feel(feels_like: feels_like);
  }
}
class hum{
  final int humidity;

  hum({required this.humidity});

  factory hum.fromJson(Map<String, dynamic> json) {
    final humidity = json['humidity'];
    return hum(humidity: humidity);
  }
}
// class vis{
//   final int visibility;
//
//   vis({required this.visibility});
//
//   factory vis.fromJson(Map<String, dynamic> json) {
//     final visibility = json['visibility'];
//     return vis(visibility: visibility);
//   }
// }


class WeatherResponse {
  final String cityName;
  final TemperatureInfo tempInfo;
  final WeatherInfo weatherInfo;
  final feel feels_like;
  final hum humidity;
  // final vis visibility;



  WeatherResponse({required this.cityName, required this.tempInfo,required this.weatherInfo,required this.feels_like,required this.humidity,  });//required this.visibility

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final cityName = json['name'];

    final tempInfoJson = json['main'];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    final weatherInfoJson = json['weather'][0];
   final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);
    final feels_likeJson = json['main'];
    final feels_like = feel.fromJson(feels_likeJson);
    final humidityJson= json['main'];
    final humidity=hum.fromJson((humidityJson));
    // final visibilityJson= json['visibility'];
    // final visibility=vis.fromJson((visibilityJson));

   return WeatherResponse(
         cityName: cityName, tempInfo: tempInfo,feels_like: feels_like, weatherInfo: weatherInfo,humidity: humidity,);//visibility: visibility
  }
}