import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/dashboard/presentation/blocs/contest_reminder_cubit.dart';
import 'package:codersgym/features/dashboard/presentation/widgets/upcoming_contest_card.dart';
import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:codersgym/features/question/presentation/blocs/upcoming_contests/upcoming_contests_cubit.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class ContestPage extends HookWidget implements AutoRouteWrapper {
  const ContestPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final upcomingContestCubit = context.read<UpcomingContestsCubit>();
      upcomingContestCubit.getUpcomingContest();

      final contestReminderCubit = context.read<ContestReminderCubit>();
      contestReminderCubit.checkSchedulesContests();
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contests"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Upcoming Contests",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            BlocBuilder<UpcomingContestsCubit,
                ApiState<List<Contest>, Exception>>(
              buildWhen: (previous, current) =>
                  current.isLoaded || (current.isError && !previous.isLoaded),
              builder: (context, state) {
                return state.mayBeWhen(
                  orElse: () => AppWidgetLoading(
                    child: Column(
                      children: List.generate(
                        2,
                        (index) => UpcomingContestCard.empty(),
                      ),
                    ),
                  ),
                  onLoaded: (contests) {
                    // Using column instead of listview because number of
                    // contests will always be two.
                    // Atleast for now its just two elements

                    return BlocListener<ContestReminderCubit,
                        ContestReminderState>(
                      listener: (context, state) {
                        if (state is ContestReminderLoaded) {
                          final error = state.error;
                          if (error != null) {
                            _handleScheduleFailure(context, error);
                          }
                        }
                      },
                      child: Column(
                          children: contests
                              .map(
                                (contest) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: UpcomingContestCard(
                                    contest: contest,
                                  ),
                                ),
                              )
                              .toList()),
                    );
                  },
                  onError: (exception) {
                    return const AppErrorWidget(
                      message: "That was not supposed to happen!!",
                      showRetryButton: false,
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _handleScheduleFailure(BuildContext context, SetReminderError error) {
    switch (error) {
      case SetReminderError.notificationPermissionDenied:
      case SetReminderError.notificationPermissionDeniedPermanently:
        _showSettingsDialog(context);
      case SetReminderError.alarmNotificationPermissionDenied:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please allow alarm permission')),
        );
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enable Notifications"),
        content: const Text(
          "Notifications are disabled. Please enable them in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<UpcomingContestsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<ContestReminderCubit>(),
        ),
      ],
      child: this,
    );
  }
}
