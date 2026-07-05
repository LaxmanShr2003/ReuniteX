import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:reunite_x/shared/models/missing_person_model.dart';


const Color kFeedNavy = Color(0xFF1A3A8F);
const Color kFeedBg = Color(0xFFF4F6FB);

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

enum _FeedFilter { nearMe, amberAlerts, recent }

class _FeedScreenState extends State<FeedScreen> {
  List<MissingPersonModel> _people = [];
  bool _loading = true;
  String _query = '';
  _FeedFilter _filter = _FeedFilter.nearMe;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPeople();
  }

  Future<void> _loadPeople() async {
    // Swap this for a real API call once the backend exists — the rest of
    // the screen only depends on `_people` being populated, not on where
    // it came from.
    final raw = await DefaultAssetBundle.of(context)
        .loadString('assets/missing_persons.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = (decoded['missingPersons'] as List)
        .map((e) => MissingPersonModel.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() {
      _people = list;
      _loading = false;
    });
  }

  List<MissingPersonModel> get _visiblePeople {
    var list = _people;

    switch (_filter) {
      case _FeedFilter.amberAlerts:
        list = list.where((p) => p.alertLevel == AlertLevel.amber).toList();
        break;
      case _FeedFilter.recent:
        list = [...list]..sort((a, b) => b.lastSeenDate.compareTo(a.lastSeenDate));
        break;
      case _FeedFilter.nearMe:
        break; // no location data to filter by yet — shows everything
    }

    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      list = list
          .where((p) =>
              p.fullName.toLowerCase().contains(q) ||
              p.lastSeenLocation.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFeedBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            _buildFilterRow(),
            const SizedBox(height: 4),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: kFeedNavy))
                  : _visiblePeople.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: _visiblePeople.length,
                          itemBuilder: (context, i) =>
                              _PersonCard(person: _visiblePeople[i]),
                        ),
            ),
          ],
        ),
      ),
     
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          // const Icon(Icons.search, color: Color(0xFF9CA3AF)),
          const Expanded(
            child: Center(
              child: Text(
                'ReuniteX',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kFeedNavy,
                ),
              ),
            ),
          ),
       //   const Icon(Icons.notifications_none, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: 'Search names, locations...',
          hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kFeedNavy, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _FilterChip(
            label: 'Near Me',
            selected: _filter == _FeedFilter.nearMe,
            onTap: () => setState(() => _filter = _FeedFilter.nearMe),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'AMBER Alerts',
            selected: _filter == _FeedFilter.amberAlerts,
            onTap: () => setState(() => _filter = _FeedFilter.amberAlerts),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Recent',
            selected: _filter == _FeedFilter.recent,
            onTap: () => setState(() => _filter = _FeedFilter.recent),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(Icons.tune, size: 18, color: Color(0xFF374151)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No matching reports.',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
        ),
      ),
    );
  }



  Widget _navItem(IconData icon, String label, int index) {
    final selected = _navIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _navIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: selected ? kFeedNavy : const Color(0xFF9CA3AF)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selected ? kFeedNavy : const Color(0xFF9CA3AF),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating center "Report" button — place this in a Scaffold's
/// `floatingActionButton` slot alongside `_FeedScreenState`'s bottom nav
/// (`floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked`).
class ReportFab extends StatelessWidget {
  final VoidCallback onPressed;
  const ReportFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: kFeedNavy,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

// ─────────────────────────────────────────────
// Filter chip
// ─────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kFeedNavy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? kFeedNavy : const Color(0xFFE5E7EB)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Person card
// ─────────────────────────────────────────────
class _PersonCard extends StatelessWidget {
  final MissingPersonModel person;
  const _PersonCard({required this.person});

  ({Color color, String label, IconData icon}) get _badge {
    switch (person.alertLevel) {
      case AlertLevel.amber:
        return (color: const Color(0xFFB91C1C), label: 'AMBER ALERT', icon: Icons.warning_amber_rounded);
      case AlertLevel.critical:
        return (color: const Color(0xFF111827), label: 'CRITICAL', icon: Icons.report_gmailerrorred);
      case AlertLevel.standard:
        return (color: const Color(0xFF6B7280), label: 'STANDARD', icon: Icons.info_outline);
      case AlertLevel.found:
        return (color: const Color(0xFF16A34A), label: 'FOUND', icon: Icons.check_circle_outline);
    }
  }

  Color get _actionColor {
    switch (person.alertLevel) {
      case AlertLevel.amber:
      case AlertLevel.critical:
        return const Color(0xFFDC2626);
      case AlertLevel.standard:
      case AlertLevel.found:
        return kFeedNavy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = _badge;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  person.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) =>
                      progress == null ? child : Container(color: const Color(0xFFE5E7EB)),
                  errorBuilder: (ctx, err, stack) => Container(
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(Icons.person, size: 48, color: Color(0xFF9CA3AF)),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: badge.color, borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badge.icon, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        badge.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 11, color: Colors.white),
                      const SizedBox(width: 3),
                      Text(
                        person.timeAgoLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.fullName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 6),
                _infoRow('AGE:', '${person.age} years old'),
                const SizedBox(height: 2),
                _infoRow('LAST SEEN:', person.lastSeenLocation, valueColor: kFeedNavy),
                const SizedBox(height: 6),
                _infoRow('DETAILS:', '${person.description}. ${person.clothingDescription}.'),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined, size: 16),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF374151),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                        label: const Text("I've Seen Them"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _actionColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color valueColor = const Color(0xFF374151)}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, height: 1.5),
        children: [
          TextSpan(text: '$label ', style: const TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.w700)),
          TextSpan(text: value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}