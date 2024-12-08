import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: SplashRoute.page),
        AutoRoute(page: DashboardRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: QuestionDetailRoute.page),
        AutoRoute(page: LeetcodeWebRoute.page),
        AutoRoute(page: NotificationRoute.page),
        AutoRoute(page: CommunityPostRoute.page),
        AutoRoute(page: CodeEditorRoute.page),
      ];
}
