import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';

import 'package:who_mobile_project/general/constants/api_error_types.dart';
import 'package:who_mobile_project/general/models/databased_response.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/repository/repo_state.dart';
import 'package:who_mobile_project/general/widgets/restart_widget.dart';

class InfinitePagingList<T> extends StatefulWidget {
  final Future<SuccessState<List<T>, PaginatedMetaData>?> Function(int, int)
  fetchPage;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Widget Function(BuildContext)? noItemsFoundIndicatorBuilder;
  final Widget Function(BuildContext)? firstPageProgressBuilder;
  final PagingController<int, T>? controller;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  const InfinitePagingList({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    this.firstPageProgressBuilder,
    this.controller,
    this.shrinkWrap = false,
    this.noItemsFoundIndicatorBuilder,
    this.physics = const AlwaysScrollableScrollPhysics(
      parent: ClampingScrollPhysics(),
    ),
  });

  @override
  InfinitePagingListState<T> createState() => InfinitePagingListState<T>();
}

class InfinitePagingListState<T> extends State<InfinitePagingList<T>> {
  static const int limit = 10;

  late PagingController<int, T> _pagingController;

  @override
  void initState() {
    _pagingController =
        widget.controller ?? PagingController<int, T>(firstPageKey: 1);

    _pagingController.addPageRequestListener((pageKey) {
      Logger().d("addPageRequestListener has been called");
      _fetchNextPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchNextPage(int pageKey) async {
    int offset = (pageKey - 1) * limit;
    try {
      SuccessState<List<T>, PaginatedMetaData>? pagingResponse = await widget
          .fetchPage(limit, offset);
      if (pagingResponse == null) {
        _pagingController.appendLastPage([]);
      } else if (pagingResponse.metaData!.totalItems <=
          pagingResponse.metaData!.limit + pagingResponse.metaData!.offset) {
        _pagingController.appendLastPage(pagingResponse.data ?? []);
      } else {
        final nextPageKey = (_pagingController.nextPageKey ?? 0) + 1;
        _pagingController.appendPage(pagingResponse.data ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;

      if (error is RepositoryException &&
          error.error == ErrorType.unauthorized) {
        GetIt.instance<StorageManager>().removeUserRelatedInfo();
        Future.delayed(Duration(seconds: 5), () {
          // ignore: use_build_context_synchronously
          RestartWidget.restartApp();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      child: PagedListView<int, T>(
        pagingController: _pagingController,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        padding: EdgeInsets.symmetric(vertical: 0),
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: widget.itemBuilder,
          noItemsFoundIndicatorBuilder:
              widget.noItemsFoundIndicatorBuilder ??
              (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 15,
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.no_item_found,
                        style: AppTextStyles.headingH3,
                      ),
                      SizedBox(height: 15),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.the_list_is_currently_empty,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
          firstPageErrorIndicatorBuilder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.communication_error,
                    style: AppTextStyles.headingH3,
                  ),
                  SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.please_try_again_later,
                    textAlign: TextAlign.center,
                  ),
                  if (_pagingController.error is RepositoryException &&
                      _pagingController.error.error == ErrorType.unauthorized)
                    Text(
                      AppLocalizations.of(context)!.unauthorized_request,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            );
          },
          firstPageProgressIndicatorBuilder: widget.firstPageProgressBuilder,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
