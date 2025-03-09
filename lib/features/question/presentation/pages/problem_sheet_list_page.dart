import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/question/domain/model/problem_sheet.dart';
import 'package:codersgym/features/question/presentation/blocs/problem_sheets/problem_sheets_cubit.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class ProblemSheetListPage extends HookWidget implements AutoRouteWrapper {
  const ProblemSheetListPage({super.key});

  Widget _buildSheetCard(
    BuildContext context, {
    required ProblemSheet sheet,
    required Color backgroundColor,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      color: backgroundColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          context.router.push(
            ProblemSheetDetailRoute(
              sheetId: sheet.slug,
              sheetName: sheet.name,
              sheetAuthor: sheet.author,
              sheetDescription: sheet.description,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      sheet.name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                sheet.description,
                style: textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'by ${sheet.author}',
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problemSheetCubit = context.read<ProblemSheetsCubit>();
    final theme = Theme.of(context);

    useEffect(() {
      problemSheetCubit.fetchProblemSheets();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("DSA Sheets"),
      ),
      body: BlocBuilder<ProblemSheetsCubit, ProblemSheetsState>(
        builder: (context, state) {
          return state.when(
            onInitial: () => const Center(
              child: CircularProgressIndicator(),
            ),
            onLoading: (cachedData) => const Center(
              child: CircularProgressIndicator(),
            ),
            onLoaded: (sheets) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Popular DSA Problem Collections",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Study and practice using the most effective question collections",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      problemSheetCubit.fetchProblemSheets();
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: sheets.length,
                      itemBuilder: (context, index) {
                        return _buildSheetCard(
                          context,
                          sheet: sheets[index],
                          backgroundColor: index % 2 == 0
                              ? theme.cardColor
                              : theme.colorScheme.surface,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            onError: (exception) => AppErrorWidget(
              onRetry: () {
                problemSheetCubit.fetchProblemSheets();
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<ProblemSheetsCubit>(),
      child: this,
    );
  }
}
