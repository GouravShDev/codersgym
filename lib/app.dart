import 'package:codersgym/core/services/firebase_push_notification_service.dart';
import 'package:codersgym/core/services/local_notification_service.dart';
import 'package:codersgym/core/utils/custom_scroll_physics.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/common/services/recent_question_manager.dart';
import 'package:codersgym/features/settings/presentation/blocs/app_info/app_info_cubit.dart';
import 'package:codersgym/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:codersgym/core/routes/app_router.dart';
import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppInitializer extends HookWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final isInitialized = useState(false);

    useEffect(
      () {
        Future<void> initialize() async {
          await LocalNotificationService().initialize();
          await FirebasePushNotificationService().initialize();
          var path = await getExternalStorageDirectory();
          Hive.init(path?.path);
          await initializeDependencies();
          await getIt.get<RecentQuestionManager>().init();
          isInitialized.value = true;
        }

        initialize();
        return null;
      },
      [],
    );

    if (!isInitialized.value) {
      return WidgetsApp(
        color: leetcodeTheme.scaffoldBackgroundColor,
        builder: (context, _) => Scaffold(
          backgroundColor: leetcodeTheme.scaffoldBackgroundColor,
          body: Center(
            child: Image.asset(
              Assets.images.appIcon.path,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );
    }

    // Once initialized, show the main MaterialApp
    return const App();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt.get<AppRouter>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<AppInfoCubit>()..getAppInfo(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Coders Gym',
        theme: leetcodeTheme,
        debugShowCheckedModeBanner: false,
        darkTheme: leetcodeTheme,
        scrollBehavior: const ScrollBehavior().copyWith(
          overscroll: false,
          physics: const CustomPageViewScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
        ),
        routerConfig: appRouter.config(),
      ),
    );
  }
}
