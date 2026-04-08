/// Weather data sources
///
/// Free public weather APIs per FR-018:
/// - OpenWeatherMap: 1000 calls/day limit, global coverage
/// - weather.gov: Unlimited, US-only coverage
enum WeatherSource {
  openWeatherMap('openweathermap', 'OpenWeatherMap'),
  weatherGov('weathergov', 'Weather.gov (US only)');

  const WeatherSource(this.id, this.displayName);

  final String id;
  final String displayName;

  static WeatherSource fromId(String id) {
    return WeatherSource.values.firstWhere(
      (source) => source.id == id,
      orElse: () => WeatherSource.openWeatherMap,
    );
  }
}
