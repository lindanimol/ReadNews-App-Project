import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'detail_screen.dart';
import 'gridstyle_logic.dart';
import 'new_model.dart';
import 'new_service.dart';
import 'theme_logic.dart';
import 'category_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showUpIcon = false;
  final ScrollController _scroller = ScrollController();
  final NewService _service = NewService();
  late Future<List<NewModel>> _futureData;

  final List<String> categories = [
    "technology",
    "sports",
    "politics",
    "business",
    "health",
    "science",
    "entertainment",
  ];

  @override
  void initState() {
    super.initState();
    final selected = context.read<CategoryLogic>().category;
    _futureData = _service.readNews(selected);

    _scroller.addListener(() {
      if (mounted) {
        setState(() {
          _showUpIcon = _scroller.position.pixels > 400;
        });
      }
    });
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  void _loadCategory(String category) {
    context.read<CategoryLogic>().setCategory(category);
    setState(() {
      _futureData = _service.readNews(category);
    });
  }

  String _formatDate(String rawDate) {
    if (rawDate.length > 10) {
      return rawDate.substring(0, 10);
    }
    return rawDate;
  }

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;
    bool gridStyle = context.watch<GridstyleLogic>().gridStyle;
    String selectedCategory = context.watch<CategoryLogic>().category;

    return Scaffold(
      backgroundColor: dark ? const Color(0xff0F0F0F) : const Color(0xffF8F9FB),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50, // Compact height
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Discover",
          style: TextStyle(
            fontSize: 24, // Balanced size
            letterSpacing: -0.5,
            fontWeight: FontWeight.w800,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ),
      floatingActionButton: _showUpIcon
          ? FloatingActionButton.small(
              // Smaller FAB
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                _scroller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              },
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 20,
              ),
            )
          : null,
      body: Column(
        children: [
          _buildCategoryBar(selectedCategory, dark),
          const SizedBox(height: 8),
          Expanded(child: _buildBody(gridStyle)),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(String selectedCategory, bool isDark) {
    return SizedBox(
      height: 38, // Slimmed down from 55
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _loadCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blueAccent
                      : (isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.white),
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Modern rounded corner (not full stadium)
                  border: Border.all(
                    color: isSelected
                        ? Colors.blueAccent
                        : (isDark
                              ? Colors.white12
                              : Colors.grey.withOpacity(0.2)),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white60 : Colors.black54),
                          fontSize: 11, // Smaller, crisp font
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ENHANCED BODY GRID
  Widget _buildBody(bool gridStyle) {
    return FutureBuilder<List<NewModel>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _loadingGrid(gridStyle);
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading news"));
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) return const Center(child: Text("No News Found"));

        return GridView.builder(
          controller: _scroller,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridStyle ? 2 : 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: gridStyle ? 0.82 : 1.25, // Adjusted ratios
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(item)),
                );
              },
              child: Container(
                clipBehavior: Clip
                    .antiAlias, // Ensures content doesn't leak out of rounded corners
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.04),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: item.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade200),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(item.creationAt),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _loadingGrid(bool gridStyle) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridStyle ? 2 : 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
