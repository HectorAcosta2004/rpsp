import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart'; //

import '../../core/components/internet_wrapper.dart';
import '../../core/routes/app_routes.dart';
import 'components/authors_list_horizontal.dart';
import 'components/parent_categories.dart';
import 'components/search_bar.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return InternetWrapper(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: SearchButton(),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.notification),
                    icon: const Icon(IconlyLight.notification),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const AuthorLists(),
              const ParentCategories(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
