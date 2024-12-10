import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/gen/assets.gen.dart';

class LeetCodeLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        final authbloc = context.read<AuthBloc>();
        AutoRouter.of(context).push(const LeetcodeWebRoute()).then(
          (leetcodeCookie) {
            if (leetcodeCookie is Map<String, dynamic>) {
              authbloc.add(
                AuthLoginWithLeetcode(
                  credentials: leetcodeCookie,
                ),
              );
            }
          },
        );
      },
      icon: SvgPicture.asset(
        Assets.icons.leetcode,
        height: 20,
      ),
      iconAlignment: IconAlignment.end,
      label: Text(
        'Continue with',
        style: Theme.of(context)
            .textTheme
            .bodyLarge, // Use theme style for button text
      ),
    );
  }
}
