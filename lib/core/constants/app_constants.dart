/// Константы приложения POS System Kazakhstan
class AppConstants {
  AppConstants._();

  // API. Default points at the .NET central on localhost:5080 — matches
  // pos-server's deploy/docker-compose.local.yml host-port mapping. 5080
  // (not 5000) so we don't collide with macOS AirPlay Receiver, which
  // squats on :5000 by default and returns 403 for any HTTP request.
  //
  // Override at build time with:
  //   flutter run --dart-define=POS_API_HOST=https://api.example.kz
  //
  // The `String.fromEnvironment` lookup is compile-time, so each build
  // bakes in one host — no runtime reconfiguration.
  //
  // Production builds MUST use an https:// URL. Enforced at boot via
  // [assertApiHostIsSecure]; cleartext outside of localhost is also blocked
  // at the Android layer (network_security_config.xml).
  static const String defaultApiHost = String.fromEnvironment(
    'POS_API_HOST',
    defaultValue: 'http://localhost:5080',
  );
  static const String apiPrefix = '/api';

  /// True when the compiled-in API host is safe for release builds: an
  /// absolute `https://…` URL. Localhost over HTTP is permitted in debug /
  /// profile builds only.
  static bool get apiHostIsHttps {
    final uri = Uri.tryParse(defaultApiHost);
    if (uri == null) return false;
    return uri.isScheme('https');
  }

  static bool get apiHostIsLocalLoopback {
    final uri = Uri.tryParse(defaultApiHost);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    return host == 'localhost' || host == '127.0.0.1' || host == '10.0.2.2';
  }

  /// Boot-time guard. area74a is standalone-only — we never send JWTs or
  /// PINs to a central API — so a missing/cleartext POS_API_HOST must not
  /// prevent the till from booting (upstream KeregePOS hung TestFlight
  /// builds on this throw). Kept as a no-op so call sites stay.
  static void assertApiHostIsSecure({required bool isReleaseMode}) {
    // no-op: Pharmacy POS does not require a cloud host.
  }

  // Money — Pakistan. INTEGER paisa (Rs. 1 = 100 paisa). Same storage
  // idea as upstream tiyin; identifiers are renamed in this fork.
  static const int paisaPerRupee = 100;
  static const int tiyinPerTenge = paisaPerRupee; // compat alias during rename
  static const String currencySymbol = 'Rs.';
  static const String currencyCode = 'PKR';

  // Tax rates live in Settings. These are fallbacks only (tax OFF → 0).
  static const int vatRateStandard = 0;
  static const int vatRateZero = 0;

  // PIN
  static const int pinLength = 4;

  // Пагинация
  static const int defaultPageSize = 50;
  static const int searchResultsLimit = 20;

  // Производительность
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration apiTimeout = Duration(seconds: 10);
}
