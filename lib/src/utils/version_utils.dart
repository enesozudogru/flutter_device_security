class VersionUtils {
  static bool isVersionAtLeast(String current, String? minimum) {
    final c = _parseVersion(current);
    final m = _parseVersion(minimum);

    final length = c.length > m.length ? c.length : m.length;

    for (var i = 0; i < length; i++) {
      final cv = i < c.length ? c[i] : 0;
      final mv = i < m.length ? m[i] : 0;

      if (cv > mv) return true;
      if (cv < mv) return false;
    }
    return true;
  }

  static List<int> _parseVersion(String? version) {
    if (version == null || version.isEmpty) {
      return [0];
    }
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }
}
