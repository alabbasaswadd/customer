import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ─── Primitive helper ────────────────────────────────────────────────────────

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

Color _baseColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
}

Color _highlightColor(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);
}

// ─── Home Tab shimmer ─────────────────────────────────────────────────────────

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Greeting header
            const Row(
              children: [
                _ShimmerBox(width: 48, height: 48, borderRadius: 24),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(width: 80, height: 12),
                    SizedBox(height: 8),
                    _ShimmerBox(width: 140, height: 18),
                  ],
                ),
                Spacer(),
                _ShimmerBox(width: 40, height: 40, borderRadius: 20),
              ],
            ),
            const SizedBox(height: 20),
            // Ticker bar
            const _ShimmerBox(width: double.infinity, height: 44, borderRadius: 12),
            const SizedBox(height: 20),
            // Subscription card
            const _ShimmerBox(width: double.infinity, height: 160, borderRadius: 20),
            const SizedBox(height: 24),
            // Wallet section
            const _ShimmerBox(width: 120, height: 18),
            const SizedBox(height: 12),
            _walletRow(),
            const SizedBox(height: 24),
            // Quick actions label
            const _ShimmerBox(width: 100, height: 18),
            const SizedBox(height: 16),
            _quickActionsGrid(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _walletRow() {
    return Row(
      children: List.generate(3, (i) {
        final isLast = i == 2;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: isLast ? 0 : 12),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }),
    );
  }

  Widget _quickActionsGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: List.generate(
        8,
        (_) => const _ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 16,
        ),
      ),
    );
  }
}

// ─── Subscriptions Tab shimmer ────────────────────────────────────────────────

class SubscriptionsShimmer extends StatelessWidget {
  const SubscriptionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (_, __) => _PlanCardShimmer(),
      ),
    );
  }
}

class _PlanCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              _ShimmerBox(width: 130, height: 20),
              SizedBox(width: 10),
              _ShimmerBox(width: 60, height: 20, borderRadius: 12),
            ],
          ),
          SizedBox(height: 8),
          _ShimmerBox(width: 200, height: 13),
          SizedBox(height: 16),
          // Chip row
          Row(
            children: [
              _ShimmerBox(width: 90, height: 30, borderRadius: 12),
              SizedBox(width: 8),
              _ShimmerBox(width: 90, height: 30, borderRadius: 12),
            ],
          ),
          SizedBox(height: 16),
          // Price + button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(width: 100, height: 36),
              _ShimmerBox(width: 100, height: 40, borderRadius: 12),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Connected Devices shimmer ────────────────────────────────────────────────

class ConnectedDevicesShimmer extends StatelessWidget {
  const ConnectedDevicesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor(context),
      highlightColor: _highlightColor(context),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Network info card
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),
            // Stats header
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            // Device items
            ...List.generate(5, (_) => _DeviceItemShimmer()),
          ],
        ),
      ),
    );
  }
}

class _DeviceItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          _ShimmerBox(width: 44, height: 44, borderRadius: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 120, height: 14),
                SizedBox(height: 8),
                _ShimmerBox(width: 80, height: 12),
              ],
            ),
          ),
          _ShimmerBox(width: 60, height: 28, borderRadius: 10),
        ],
      ),
    );
  }
}
