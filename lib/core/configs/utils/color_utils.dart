import 'dart:ui';
import 'dart:math' as math;

extension ColorUtils on Color {
  int toInt() {
    final alpha = (a * 255).toInt();
    final red = (r * 255).toInt();
    final green = (g * 255).toInt();
    final blue = (b * 255).toInt();
    // Combine the components into a single int using bit shifting
    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }

  String toHex() {
    return '#${value.toRadixString(16).substring(2)}';
  }

  String toHsl() {
    // Convert RGB to 0-1 range
    final r = this.r;
    final g = this.g;
    final b = this.b;

    final max = math.max(math.max(r, g), b);
    final min = math.min(math.min(r, g), b);
    final delta = max - min;

    // Calculate hue
    double h = 0;
    if (delta == 0) {
      h = 0;
    } else if (max == r) {
      h = ((g - b) / delta) % 6;
    } else if (max == g) {
      h = (b - r) / delta + 2;
    } else {
      h = (r - g) / delta + 4;
    }
    h = (h * 60).roundToDouble();
    if (h < 0) h += 360;

    // Calculate lightness
    final l = (max + min) / 2;

    // Calculate saturation
    double s = 0;
    if (delta != 0) {
      s = delta / (1 - (2 * l - 1).abs());
    }

    // Convert to percentages
    s = (s * 100).roundToDouble();
    final lPercent = (l * 100).roundToDouble();

    return 'hsl(${h.round()}, ${s.round()}%, ${lPercent.round()}%)';
  }

  String toHsla() {
    final hsl = toHsl();
    // Remove the closing parenthesis and add alpha
    return hsl.substring(0, hsl.length - 1) + ', ${a.toStringAsFixed(2)})';
  }
}
