library fast_i18n;

import 'package:devicelocale/devicelocale.dart';
import 'package:fast_i18n/utils.dart';

class FastI18n {
  /// returns the locale string used by the device
  /// it always matches one of the supported locales
  /// fallback to '' (default locale)
  static Future<String> findDeviceLocale(List<String> supported,
      [String baseLocale = '']) async {
    String deviceLocale = (await Devicelocale.currentAsLocale).toLanguageTag();

    return selectLocale(deviceLocale, supported, baseLocale);
  }

  /// returns the candidate (or part of it) if it is supported
  /// fallback to '' (default locale)
  static String selectLocale(String candidate, List<String> supported,
      [String baseLocale = '']) {
    // normalize
    candidate = Utils.normalize(candidate);

    // 1st try: match exactly
    String selected = supported.firstWhere((element) => element == candidate,
        orElse: () => null);
    if (selected != null) return selected;

    // 2nd try: match the first or the second part
    List<String> deviceLocaleParts = candidate.split('-');
    selected = supported.firstWhere(
        (element) =>
            element == deviceLocaleParts.first ||
            element == deviceLocaleParts.last,
        orElse: () => null);
    if (selected != null) return selected;

    // fallback: default locale
    return baseLocale;
  }
}
