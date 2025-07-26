import 'package:flutter/material.dart';

class SonaLogoSmall extends StatelessWidget {
  final double size;
  final Color? color;

  const SonaLogoSmall({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? const Color(0xFFFFB3C6),
            color ?? const Color(0xFFFF6B9D),
            color ?? const Color(0xFFE766AC),
          ],
        ),
      ),
      child: Center(
        child: Text(
          'S',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
        ),
      ),
    );
  }
}

class SonaLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const SonaLogo({
    super.key,
    this.size = 40,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 로고 아이콘
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.25),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFB3C6),
                Color(0xFFFF6B9D),
                Color(0xFFE766AC),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.6,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.3),
          Text(
            'SONA',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: textColor ?? Theme.of(context).textTheme.headlineSmall?.color,
            ),
          ),
        ],
      ],
    );
  }
}

class SonaLogoLarge extends StatelessWidget {
  final double size;

  const SonaLogoLarge({
    super.key,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.25),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFB3C6),
                Color(0xFFFF6B9D),
                Color(0xFFE766AC),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.6,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'SONA',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}