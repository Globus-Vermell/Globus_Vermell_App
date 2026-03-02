import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onInfo;

  const SectionHeader({
    super.key,
    required this.title,
    this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFE41E26),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.black54,
          ),
        ),
        if (onInfo != null) ...[
          const Spacer(),
          InkWell(
            onTap: onInfo,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ],
    );
  }
}