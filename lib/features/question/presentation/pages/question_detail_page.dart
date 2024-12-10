import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/community_solutions/community_solutions_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/official_solution_available/official_solution_available_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_hints/question_hints_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_solution/question_solution_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_tags/question_tags_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/similar_question/similar_question_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_community_solution.dart';
import 'package:codersgym/features/question/presentation/widgets/question_description.dart';
import 'package:codersgym/features/question/presentation/widgets/question_editorial.dart';
import 'package:codersgym/features/question/presentation/widgets/question_info_tile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/question_content/question_content_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_difficulty_text.dart';
import 'package:codersgym/injection.dart';
import 'package:collection/collection.dart';

@RoutePage()
class QuestionDetailPage extends HookWidget implements AutoRouteWrapper {
  final Question question;
  const QuestionDetailPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final questionOfficialSolutionAvailablityCubit =
        context.read<OfficialSolutionAvailableCubit>();
    useEffect(() {
      questionOfficialSolutionAvailablityCubit
          .checkOfficialSolutionAvailable(question);
      return null;
    }, []);
    var tabsItems = [
      TabBarItem(
        id: 'question_description',
        icon: Icons.description_outlined,
        child: QuestionDescription(
          question: question,
        ),
      ),
      TabBarItem(
        id: 'question_community_solution',
        icon: Icons.science_outlined,
        child: QuestionCommunitySolution(
          question: question,
        ),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(question.title ?? 'Question Detail'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: BlocBuilder<QuestionContentCubit, QuestionContentState>(
            builder: (context, state) {
              final currentQuestion = state.mayBeWhen(
                orElse: () => question,
                onLoaded: (questionWithDetail) => questionWithDetail,
              );
              if (currentQuestion.codeSnippets == null) {
                return SizedBox.shrink();
              }
              return FloatingActionButton(
                onPressed: () {
                  AutoRouter.of(context).push(
                    CodeEditorRoute(
                      question: currentQuestion,
                    ),
                  );
                },
                child: Icon(Icons.code),
                tooltip: 'Open Code Editor',
              );
            },
          ),
        ),
        body: BlocConsumer<OfficialSolutionAvailableCubit,
            OfficialSolutionAvailableState>(
          listener: (context, state) {
            state.when(
              onInitial: () {},
              onLoading: () {},
              onLoaded: (isAvailable) {
                if (isAvailable) {
                  tabsItems = List.from(tabsItems)
                    ..insert(
                      1,
                      TabBarItem(
                        id: 'question_editorial',
                        icon: Icons.menu_book_rounded,
                        child: QuestionEditorial(
                          question: question,
                        ),
                      ),
                    );
                }
              },
              onError: (_) {},
            );
          },
          builder: (context, state) {
            return QuestionDetailPageBody(
              // Reinitalize page body if tabs items are changed
              key: ValueKey("QuestionDetailPageBody${tabsItems.length}"),
              question: question,
              tabItems: tabsItems,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt.get<QuestionContentCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<QuestionSolutionCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<QuestionTagsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<SimilarQuestionCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<QuestionHintsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<OfficialSolutionAvailableCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<CommunitySolutionsBloc>(),
        ),
      ],
      child: this,
    );
  }
}

class QuestionDetailPageBody extends HookWidget {
  const QuestionDetailPageBody({
    super.key,
    required this.question,
    required this.tabItems,
  });
  final Question question;
  final List<TabBarItem> tabItems;

  @override
  Widget build(BuildContext context) {
    final questionContentCubit = context.read<QuestionContentCubit>();
    final currentTab = useState<TabBarItem>(tabItems.first);
    final tabController = useTabController(initialLength: tabItems.length);
    final unselectedColor = Theme.of(context).dividerColor;
    final selectedColor = Theme.of(context).primaryColor;
    final questionTopicCubit = context.read<QuestionTagsCubit>();
    final questionHintsCubit = context.read<QuestionHintsCubit>();

    useEffect(
      () {
        questionContentCubit.getQuestionContent(question);
        questionTopicCubit.getQuestionTags(question);
        questionHintsCubit.getQuestionHints(question);
        tabController.animation?.addListener(
          () {
            final tabIndex = tabController.animation?.value.round();
            if (tabIndex != null && tabItems[tabIndex] != currentTab.value) {
              currentTab.value = tabItems[tabIndex];
            }
          },
        );
        return null;
      },
      [],
    );
    return BottomBar(
      icon: (width, height) => Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: null,
          icon: Icon(
            Icons.arrow_upward_rounded,
            color: unselectedColor,
            size: width,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(500),
      duration: const Duration(seconds: 1),
      barDecoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withOpacity(0.3),
            spreadRadius: 10,
            blurRadius: 20,
            offset: Offset(-4, 4), // changes position of shadow
          ),
        ],
      ),
      curve: Curves.decelerate,
      showIcon: true,
      width: MediaQuery.of(context).size.width * 0.8,
      barColor: Theme.of(context).canvasColor,
      start: 2,
      end: 0,
      offset: 10,
      barAlignment: Alignment.bottomCenter,
      iconHeight: 35,
      iconWidth: 35,
      reverse: false,
      hideOnScroll: true,
      scrollOpposite: false,
      onBottomBarHidden: () {},
      onBottomBarShown: () {},
      child: TabBar(
        indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
        controller: tabController,
        dividerColor: Colors.transparent,
        splashBorderRadius: BorderRadius.circular(100),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 4,
          ),
          insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
        ),
        tabs: tabItems
            .map(
              (e) => SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  e.icon,
                  color:
                      currentTab.value == e ? selectedColor : unselectedColor,
                )),
              ),
            )
            .toList(),
      ),
      body: (context, controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: InheritedDataProvider(
              data: controller,
              child: Builder(builder: (context) {
                return tabItems[tabController.index].child;
              }),
            ),
          ),
        );
      },
    );
  }
}

class TabBarItem extends Equatable {
  final IconData icon;
  final String id;
  final Widget child;

  TabBarItem({
    required this.id,
    required this.icon,
    required this.child,
  });

  @override
  List<Object?> get props => [id];
}
