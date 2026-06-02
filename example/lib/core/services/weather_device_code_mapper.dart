/// Maps OpenWeather condition ids to UTE band weather codes.
class WeatherDeviceCodeMapper {
  WeatherDeviceCodeMapper._();

  static const Map<int, int> _openWeatherToBand = <int, int>{
    // Clear / clouds
    800: 100,
    801: 101,
    802: 102,
    803: 103,
    804: 104,
    // Atmosphere
    701: 500,
    741: 501,
    721: 502,
    751: 503,
    731: 504,
    761: 508,
    711: 507,
    781: 212,
    771: 200,
    762: 900,
    // Snow
    600: 400,
    601: 401,
    602: 402,
    611: 404,
    612: 406,
    613: 406,
    615: 405,
    616: 405,
    620: 407,
    621: 407,
    622: 403,
    // Rain
    500: 305,
    501: 306,
    502: 307,
    503: 307,
    504: 308,
    511: 313,
    520: 309,
    521: 310,
    522: 311,
    531: 312,
    // Thunderstorm / drizzle
    200: 901,
    201: 209,
    202: 210,
    210: 302,
    211: 302,
    212: 303,
    221: 211,
    230: 304,
    231: 304,
    232: 213,
    300: 202,
    301: 203,
    302: 205,
    310: 206,
    311: 207,
    312: 208,
    313: 300,
    314: 301,
    321: 204,
  };

  static int map(int openWeatherCode) => _openWeatherToBand[openWeatherCode] ?? 201;
}
