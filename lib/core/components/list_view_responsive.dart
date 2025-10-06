import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/article.dart';
import '../utils/responsive.dart';

class ResponsiveListView extends ConsumerWidget {
  const ResponsiveListView({
    super.key,
    required this.data,
    required this.handleScrollWithIndex,
    this.isInSliver = true,
    this.shrinkWrap = false,
    this.isMainPage = false,
    this.isDisabledScroll = false,
    this.padding = EdgeInsets.zero,
  });

  final List<ArticleModel> data;
  final void Function(int) handleScrollWithIndex;
  final bool isInSliver;
  final bool shrinkWrap;
  final bool isMainPage;
  final bool isDisabledScroll;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMobile = Responsive.isMobile(context);

    // Lista limpia de widgets de artículos, sin Ads
    final List<Widget> items = data.map((article) {
      // Aquí puedes reemplazar ListTile por tu widget de post real
      return ListTile(
        title: Text(article.title ?? "Sin título"),
        //subtitle: Text(article.excerpt ?? ""),
      );
    }).toList();

    return Responsive(
      mobile: _MobileListView(
        handleScrollWithIndex: handleScrollWithIndex,
        data: items,
        isInSliver: isInSliver,
        shrinkWrap: shrinkWrap,
        disabledScroll: isDisabledScroll,
        padding: padding,
      ),
      tablet: _TabletListView(
        handleScrollWithIndex: handleScrollWithIndex,
        data: items,
        isInSliver: isInSliver,
        shrinkWrap: shrinkWrap,
        padding: padding,
      ),
      tabletPortrait: _TabletListViewPortrait(
        handleScrollWithIndex: handleScrollWithIndex,
        data: items,
        isInSliver: isInSliver,
        shrinkWrap: shrinkWrap,
        padding: padding,
      ),
    );
  }
}

class _MobileListView extends StatelessWidget {
  const _MobileListView({
    required this.handleScrollWithIndex,
    required this.data,
    this.isInSliver = true,
    this.shrinkWrap = false,
    this.disabledScroll = false,
    this.padding = EdgeInsets.zero,
  });

  final void Function(int) handleScrollWithIndex;
  final List<Widget> data;
  final bool isInSliver;
  final bool shrinkWrap;
  final bool disabledScroll;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (isInSliver) {
      return SliverPadding(
        padding: padding,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              handleScrollWithIndex(index);
              return data[index];
            },
            childCount: data.length,
          ),
        ),
      );
    } else {
      return ListView.builder(
        padding: padding,
        shrinkWrap: shrinkWrap,
        itemBuilder: (context, index) {
          handleScrollWithIndex(index);
          return data[index];
        },
        itemCount: data.length,
        physics: disabledScroll ? const NeverScrollableScrollPhysics() : null,
      );
    }
  }
}

class _TabletListView extends StatelessWidget {
  const _TabletListView({
    required this.handleScrollWithIndex,
    required this.data,
    this.isInSliver = true,
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
  });

  final void Function(int) handleScrollWithIndex;
  final List<Widget> data;
  final bool isInSliver;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (isInSliver) {
      return SliverPadding(
        padding: padding,
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            crossAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              handleScrollWithIndex(index);
              return data[index];
            },
            childCount: data.length,
          ),
        ),
      );
    } else {
      return GridView.builder(
        padding: padding,
        shrinkWrap: shrinkWrap,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          handleScrollWithIndex(index);
          return data[index];
        },
        itemCount: data.length,
      );
    }
  }
}

class _TabletListViewPortrait extends StatelessWidget {
  const _TabletListViewPortrait({
    required this.handleScrollWithIndex,
    required this.data,
    this.isInSliver = true,
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
  });

  final bool isInSliver;
  final bool shrinkWrap;
  final void Function(int) handleScrollWithIndex;
  final List<Widget> data;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (isInSliver) {
      return SliverPadding(
        padding: padding,
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              handleScrollWithIndex(index);
              return data[index];
            },
            childCount: data.length,
          ),
        ),
      );
    } else {
      return GridView.builder(
        padding: padding,
        shrinkWrap: shrinkWrap,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          handleScrollWithIndex(index);
          return data[index];
        },
        itemCount: data.length,
      );
    }
  }
}
