import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

/// Preset scenarios available in the interactive playground
enum DemoPreset {
  /// Avatar profile with glowing presence wave
  avatar,

  /// Incoming phone call ringing pulse
  call,

  /// AI / Siri voice assistant breathing wave
  voice,

  /// Radar sonar and beacon scanner
  radar,

  /// Unread notification bell indicator
  notification,

  /// Music / podcast playback pulsing button
  music,
}

/// Interactive Ripple Animation Demo & Playground
class MyHomePage extends StatefulWidget {
  /// Initialize the demo widget
  const MyHomePage({
    required this.title,
    this.onToggleTheme,
    this.isDarkMode = false,
    super.key,
  });

  /// Title of the app
  final String title;

  /// Callback to toggle theme
  final VoidCallback? onToggleTheme;

  /// Whether current theme is dark
  final bool isDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _color = const Color(0xFF8B5CF6);
  double _minRadius = 50;
  double _maxRadius = 130;
  int _ripplesCount = 6;
  int _durationMs = 1800;
  int _delayMs = 150;
  bool _repeat = true;
  bool _ambientGlow = true;
  DemoPreset _preset = DemoPreset.voice;
  int _triggerKey = 0;

  final List<Color> _palette = const <Color>[
    Color(0xFF8B5CF6), // Cosmic Purple
    Color(0xFFFF5722), // Solar Blaze (Deep Orange)
    Color(0xFF6366F1), // Electric Indigo
    Color(0xFF06B6D4), // Neon Cyan
    Color(0xFF10B981), // Emerald Pulse
    Color(0xFFEC4899), // Cyberpunk Pink
    Color(0xFFF59E0B), // Sunburst Amber
    Color(0xFFEF4444), // Crimson Alert
    Color(0xFF0284C7), // Ocean Sky
    Color(0xFF64748B), // Slate Monochrome
  ];

  void _applyPreset(DemoPreset preset) {
    setState(() {
      _preset = preset;
      switch (preset) {
        case DemoPreset.avatar:
          _color = const Color(0xFFFF5722);
          _minRadius = 65;
          _maxRadius = 135;
          _ripplesCount = 5;
          _durationMs = 2200;
          _delayMs = 200;
          _repeat = true;
        case DemoPreset.call:
          _color = const Color(0xFF10B981);
          _minRadius = 45;
          _maxRadius = 115;
          _ripplesCount = 4;
          _durationMs = 1400;
          _delayMs = 100;
          _repeat = true;
        case DemoPreset.voice:
          _color = const Color(0xFF8B5CF6);
          _minRadius = 50;
          _maxRadius = 130;
          _ripplesCount = 6;
          _durationMs = 1800;
          _delayMs = 150;
          _repeat = true;
        case DemoPreset.radar:
          _color = const Color(0xFF06B6D4);
          _minRadius = 30;
          _maxRadius = 145;
          _ripplesCount = 5;
          _durationMs = 2600;
          _delayMs = 250;
          _repeat = true;
        case DemoPreset.notification:
          _color = const Color(0xFFEC4899);
          _minRadius = 36;
          _maxRadius = 90;
          _ripplesCount = 3;
          _durationMs = 1200;
          _delayMs = 0;
          _repeat = true;
        case DemoPreset.music:
          _color = const Color(0xFF8B5CF6);
          _minRadius = 48;
          _maxRadius = 125;
          _ripplesCount = 5;
          _durationMs = 1600;
          _delayMs = 100;
          _repeat = true;
      }
      _triggerKey++;
    });
  }

  void _triggerOnce() {
    setState(() {
      _triggerKey++;
    });
  }

  void _resetDefaults() {
    _applyPreset(DemoPreset.voice);
  }

  Widget _buildPresetChildWidget() {
    switch (_preset) {
      case DemoPreset.avatar:
        return Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            CircleAvatar(
              radius: _minRadius,
              backgroundColor: _color.withValues(alpha: 0.18),
              child: Icon(
                Icons.person_rounded,
                size: _minRadius * 1.15,
                color: _color,
              ),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).cardColor,
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        );

      case DemoPreset.call:
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _triggerOnce,
            borderRadius: BorderRadius.circular(_minRadius),
            child: Container(
              width: _minRadius * 2,
              height: _minRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: <Color>[
                    _color,
                    _color.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: _color.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.phone_in_talk_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        );

      case DemoPreset.voice:
        return Container(
          width: _minRadius * 2,
          height: _minRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: <Color>[
                _color,
                const Color(0xFF8B5CF6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _color.withValues(alpha: 0.45),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.mic_rounded,
            color: Colors.white,
            size: 38,
          ),
        );

      case DemoPreset.radar:
        return Container(
          width: _minRadius * 2,
          height: _minRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _color.withValues(alpha: 0.15),
            border: Border.all(color: _color, width: 2.5),
          ),
          child: Icon(
            Icons.radar_rounded,
            color: _color,
            size: 34,
          ),
        );

      case DemoPreset.notification:
        return Container(
          width: _minRadius * 2,
          height: _minRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _color,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _color.withValues(alpha: 0.4),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_active_rounded,
            color: Colors.white,
            size: 32,
          ),
        );

      case DemoPreset.music:
        return Container(
          width: _minRadius * 2,
          height: _minRadius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                _color,
                _color.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _color.withValues(alpha: 0.4),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Icon(
            Icons.graphic_eq_rounded,
            color: Colors.white,
            size: 36,
          ),
        );
    }
  }

  String _generateDartCode() {
    final String colorString = _getColorCodeName(_color);
    final String childString = _getPresetChildCode();

    return '''RippleAnimation(
  color: $colorString,
  delay: const Duration(milliseconds: $_delayMs),
  repeat: $_repeat,
  minRadius: ${_minRadius.toInt()},
  maxRadius: ${_maxRadius.toInt()},
  ripplesCount: $_ripplesCount,
  duration: const Duration(milliseconds: $_durationMs),
  child: $childString,
)''';
  }

  String _getColorCodeName(Color c) {
    if (c == const Color(0xFFFF5722)) {
      return 'Colors.deepOrange';
    }
    if (c == const Color(0xFF6366F1)) {
      return 'Colors.indigo';
    }
    if (c == const Color(0xFF06B6D4)) {
      return 'Colors.cyan';
    }
    if (c == const Color(0xFF10B981)) {
      return 'Colors.green';
    }
    if (c == const Color(0xFFEC4899)) {
      return 'Colors.pink';
    }
    if (c == const Color(0xFF8B5CF6)) {
      return 'Colors.purple';
    }
    if (c == const Color(0xFFF59E0B)) {
      return 'Colors.amber';
    }
    if (c == const Color(0xFFEF4444)) {
      return 'Colors.red';
    }
    if (c == const Color(0xFF0284C7)) {
      return 'Colors.lightBlue';
    }
    if (c == const Color(0xFF64748B)) {
      return 'Colors.blueGrey';
    }
    return 'Color(0x${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()})';
  }

  String _getPresetChildCode() {
    switch (_preset) {
      case DemoPreset.avatar:
        return '''const CircleAvatar(
    radius: ${_minRadius.toInt()},
    child: Icon(Icons.person, size: ${_minRadius.toInt()}),
  )''';
      case DemoPreset.call:
        return '''Container(
    width: ${_minRadius.toInt() * 2},
    height: ${_minRadius.toInt() * 2},
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.green,
    ),
    child: const Icon(Icons.phone_in_talk, color: Colors.white),
  )''';
      case DemoPreset.voice:
        return '''Container(
    width: ${_minRadius.toInt() * 2},
    height: ${_minRadius.toInt() * 2},
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.indigo,
    ),
    child: const Icon(Icons.mic, color: Colors.white),
  )''';
      case DemoPreset.radar:
        return '''Container(
    width: ${_minRadius.toInt() * 2},
    height: ${_minRadius.toInt() * 2},
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.cyan, width: 2),
    ),
    child: const Icon(Icons.radar, color: Colors.cyan),
  )''';
      case DemoPreset.notification:
        return '''Container(
    width: ${_minRadius.toInt() * 2},
    height: ${_minRadius.toInt() * 2},
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.pink,
    ),
    child: const Icon(Icons.notifications_active, color: Colors.white),
  )''';
      case DemoPreset.music:
        return '''Container(
    width: ${_minRadius.toInt() * 2},
    height: ${_minRadius.toInt() * 2},
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.purple,
    ),
    child: const Icon(Icons.graphic_eq, color: Colors.white),
  )''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.blur_circular_rounded,
                color: _color,
                size: 22,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    'Interactive Playground • v0.1.1',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: isDark ? Colors.white : Colors.black87,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reset', style: TextStyle(fontSize: 13)),
            onPressed: _resetDefaults,
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 20,
            ),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isDesktop = constraints.maxWidth >= 920;
          if (isDesktop) {
            return Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: _buildCanvasArea(isDark),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: _buildControlsArea(cardColor, isDark),
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 420,
                    child: _buildCanvasArea(isDark),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildControlsArea(cardColor, isDark),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCanvasArea(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B132B) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? const Color(0xFF1E2D4A) : const Color(0xFFE2E8F0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Ambient Glow Background Effect
          if (_ambientGlow)
            Positioned.fill(
              child: Center(
                child: Container(
                  width: _maxRadius * 2.2,
                  height: _maxRadius * 2.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: _color.withValues(alpha: isDark ? 0.22 : 0.12),
                        blurRadius: 90,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Preset Chips Top Bar
          Positioned(
            top: 18,
            left: 16,
            right: 16,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildPresetChip('Avatar', DemoPreset.avatar, Icons.person),
                    const SizedBox(width: 8),
                    _buildPresetChip('Call', DemoPreset.call, Icons.phone),
                    const SizedBox(width: 8),
                    _buildPresetChip('Voice', DemoPreset.voice, Icons.mic),
                    const SizedBox(width: 8),
                    _buildPresetChip('Radar', DemoPreset.radar, Icons.radar),
                    const SizedBox(width: 8),
                    _buildPresetChip(
                      'Alert',
                      DemoPreset.notification,
                      Icons.notifications,
                    ),
                    const SizedBox(width: 8),
                    _buildPresetChip(
                      'Music',
                      DemoPreset.music,
                      Icons.graphic_eq,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Center Ripple Animation Stage
          Center(
            child: KeyedSubtree(
              key: ValueKey<String>(
                'stage-$_triggerKey-$_color-$_minRadius-$_maxRadius-$_ripplesCount-$_durationMs-$_delayMs-$_repeat-$_preset',
              ),
              child: RippleAnimation(
                color: _color,
                minRadius: _minRadius,
                maxRadius: _maxRadius,
                ripplesCount: _ripplesCount,
                duration: Duration(milliseconds: _durationMs),
                delay: Duration(milliseconds: _delayMs),
                repeat: _repeat,
                child: _buildPresetChildWidget(),
              ),
            ),
          ),

          // Bottom Metric & Trigger Bar
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF14203D).withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF26385C)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _repeat
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_minRadius.toInt()}px → ${_maxRadius.toInt()}px • ${_ripplesCount}w • ${_durationMs}ms',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    backgroundColor: _color.withValues(alpha: 0.15),
                    foregroundColor: _color,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: Text(
                    _repeat ? 'Pulse' : 'Trigger Once',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: _triggerOnce,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, DemoPreset preset, IconData icon) {
    final bool isSelected = _preset == preset;
    return FilterChip(
      avatar: Icon(
        icon,
        size: 15,
        color: isSelected ? Colors.white : _color,
      ),
      label: Text(label),
      selected: isSelected,
      selectedColor: _color,
      showCheckmark: false,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 12,
      ),
      onSelected: (_) => _applyPreset(preset),
    );
  }

  Widget _buildControlsArea(Color cardColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Color Palette Selector
        _buildSectionHeader(
          title: 'Color Spectrum',
          badgeText: '${_palette.length} Presets',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _palette.map((Color c) {
            final bool isSelected = _color == c;
            return InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => setState(() => _color = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: <BoxShadow>[
                    if (isSelected)
                      BoxShadow(
                        color: c.withValues(alpha: 0.65),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Dimensions & Wave Count
        _buildSectionHeader(title: 'Geometry & Radii'),
        const SizedBox(height: 8),
        _buildSliderCard(
          label: 'Min Radius',
          description: 'Starting inner radius of the ripple waves',
          value: _minRadius,
          min: 20,
          max: 120,
          unit: 'px',
          onChanged: (double v) {
            setState(() {
              _minRadius = v;
              if (_maxRadius < _minRadius + 20) {
                _maxRadius = _minRadius + 20;
              }
            });
          },
        ),
        const SizedBox(height: 12),
        _buildSliderCard(
          label: 'Max Radius',
          description: 'Maximum outer radius before wave fades out',
          value: _maxRadius,
          min: 50,
          max: 220,
          unit: 'px',
          onChanged: (double v) {
            setState(() {
              _maxRadius = v;
              if (_minRadius > _maxRadius - 20) {
                _minRadius = _maxRadius - 20;
              }
            });
          },
        ),
        const SizedBox(height: 12),
        _buildSliderCard(
          label: 'Ripples Count',
          description: 'Simultaneous concentric waves radiating outwards',
          value: _ripplesCount.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          unit: 'waves',
          onChanged: (double v) => setState(() => _ripplesCount = v.toInt()),
        ),

        const SizedBox(height: 24),

        // Timing & Behavior
        _buildSectionHeader(title: 'Timing & Lifecycle'),
        const SizedBox(height: 8),
        _buildSliderCard(
          label: 'Duration',
          description: 'Total duration for one full wave cycle',
          value: _durationMs.toDouble(),
          min: 400,
          max: 4000,
          unit: 'ms',
          onChanged: (double v) => setState(() => _durationMs = v.toInt()),
        ),
        const SizedBox(height: 12),
        _buildSliderCard(
          label: 'Delay',
          description: 'Initial wait time before starting the animation',
          value: _delayMs.toDouble(),
          min: 0,
          max: 1500,
          unit: 'ms',
          onChanged: (double v) => setState(() => _delayMs = v.toInt()),
        ),

        Material(
          color: isDark ? const Color(0xFF141F36) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF243456) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Repeat Animation',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text(
                    _repeat
                        ? 'Continuous looping ripple wave'
                        : 'Executes once on demand',
                    style: const TextStyle(fontSize: 12),
                  ),
                  value: _repeat,
                  activeThumbColor: _color,
                  onChanged: (bool v) => setState(() => _repeat = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Ambient Glow Effect',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Soft atmospheric glow in the background',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _ambientGlow,
                  activeThumbColor: _color,
                  onChanged: (bool v) => setState(() => _ambientGlow = v),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Generated Code Studio
        _buildSectionHeader(
          title: 'Live Flutter Code',
          badgeText: 'Ready to Copy',
        ),
        const SizedBox(height: 8),
        _buildCodeSnippetCard(isDark),

        const SizedBox(height: 24),
        _buildPubAddSnippetCard(isDark),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? badgeText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ),
        if (badgeText != null) ...<Widget>[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: _color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSliderCard({
    required String label,
    required String description,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
    int? divisions,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141F36) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF243456) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${value.toInt()} $unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: _color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _color,
              thumbColor: _color,
              overlayColor: _color.withValues(alpha: 0.14),
              trackHeight: 3.5,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetCard(bool isDark) {
    final String code = _generateDartCode();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF070D1B) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF223150) : const Color(0xFF334155),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'flutter_widget.dart',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xFF38BDF8),
                  ),
                  icon: const Icon(Icons.copy_rounded, size: 15),
                  label: const Text('Copy', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            const Text('Flutter code copied to clipboard!'),
                        backgroundColor: _color,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1E293B)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.55,
                color: Color(0xFFE2E8F0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPubAddSnippetCard(bool isDark) {
    const String command = 'flutter pub add simple_ripple_animation';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF10192C) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF223150) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Expanded(
            child: SelectableText(
              command,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Copy Command',
            icon: const Icon(Icons.copy_rounded, size: 16),
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: command));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Installation command copied!'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
