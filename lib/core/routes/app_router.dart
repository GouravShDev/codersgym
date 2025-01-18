import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/core/routes/observer/analytic_router_observer.dart';
import 'package:flutter/material.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  AutoRouterDelegate delegate({
    String? navRestorationScopeId,
    WidgetBuilder? placeholder,
    NavigatorObserversBuilder navigatorObservers =
        AutoRouterDelegate.defaultNavigatorObserversBuilder,
    DeepLinkBuilder? deepLinkBuilder,
    bool rebuildStackOnDeepLink = false,
    Listenable? reevaluateListenable,
  }) {
    return super.delegate(
        navRestorationScopeId: navRestorationScopeId,
        placeholder: placeholder,
        navigatorObservers: () {
          return [
            AnalyticsRouteObserver(),
          ];
        },
        deepLinkBuilder: deepLinkBuilder,
        rebuildStackOnDeepLink: rebuildStackOnDeepLink,
        reevaluateListenable: reevaluateListenable);
  }

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthShell.page, children: [
          AutoRoute(page: LoginRoute.page),
          AutoRoute(page: LeetcodeWebRoute.page),
        ]),
        AutoRoute(page: DashboardShell.page, children: [
          AutoRoute(
            page: DashboardRoute.page,
            children: [
              AutoRoute(page: HomeRoute.page, initial: true),
              AutoRoute(page: ExploreRoute.page),
              AutoRoute(page: MyProfileRoute.page),
              AutoRoute(page: SettingShell.page, children: [
                AutoRoute(page: SettingRoute.page),
                AutoRoute(page: NotificationRoute.page),
              ]),
            ],
          ),
          AutoRoute(page: CodingExperienceRoute.page),
          AutoRoute(page: QuestionDetailRoute.page),
          AutoRoute(page: CodeEditorRoute.page),
          AutoRoute(page: CommunityPostRoute.page),
          AutoRoute(page: ProblemSheetListRoute.page),
          AutoRoute(page: ProblemSheetDetailRoute.page),
          AutoRoute(page: ContestRoute.page),
          AutoRoute(page: MyListRoute.page),
          AutoRoute(page: DiscussRoute.page),
          AutoRoute(page: ArticleDetailRoute.page),
        ]),
      ];
}
