import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'detail_screen.dart';
import 'gridstyle_logic.dart';
import 'new_model.dart';
import 'new_service.dart';
import 'theme_logic.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showUpIcon = false;

  final ScrollController _scroller = ScrollController();
  final TextEditingController _textCtrl = TextEditingController();
  final NewService _service = NewService();

  Future<List<NewModel>>? _futureData;

  @override
  void initState() {
    super.initState();

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
    _textCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _textCtrl.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _futureData = _service.searchNews(query);
      });
    }
  }

  String _formatDate(String rawDate) {
    if (rawDate.length > 10) return rawDate.substring(0, 10);
    return rawDate;
  }

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;
    bool gridStyle = context.watch<GridstyleLogic>().gridStyle;

    return Scaffold(
      backgroundColor: dark ? const Color(0xff0F0F0F) : const Color(0xffF8F9FB),

      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildPillSearch(dark),
      ),

      floatingActionButton: _showUpIcon
          ? FloatingActionButton.small(
              onPressed: () {
                _scroller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,

      body: _buildBody(gridStyle, dark),
    );
  }

  // 🔵 PILL SEARCH BAR (MODERN)
  Widget _buildPillSearch(bool dark) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: dark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(30), // 👈 pill shape
        border: Border.all(
          color: dark ? Colors.white12 : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _textCtrl,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: dark ? Colors.white : Colors.black,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: "Search news...",
          hintStyle: TextStyle(
            color: dark ? Colors.white38 : Colors.grey.shade500,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: dark ? Colors.white38 : Colors.grey,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onSubmitted: (_) => _onSearch(),
      ),
    );
  }

  Widget _buildBody(bool gridStyle, bool dark) {
    if (_futureData == null) {
      return Center(
        child: Text(
          "Type something to search news",
          style: TextStyle(color: dark ? Colors.white38 : Colors.grey),
        ),
      );
    }

    return FutureBuilder<List<NewModel>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _loadingGrid(gridStyle, dark);
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Search error"));
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(child: Text("No results found"));
        }

        return GridView.builder(
          controller: _scroller,
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridStyle ? 2 : 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: gridStyle ? 0.82 : 1.25,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(item)),
                );
              },
              child: Container(
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
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: item.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorWidget: (_, __, ___) => const Icon(Icons.image),
                        ),
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
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(item.creationAt),
                            style: TextStyle(
                              fontSize: 11,
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

  Widget _loadingGrid(bool gridStyle, bool dark) {
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
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: dark ? Colors.white10 : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}
