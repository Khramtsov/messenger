// Copyright © 2022-2023 IT ENGINEERING MANAGEMENT INC,
//                       <https://github.com/team113>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/model/user.dart';
import '/l10n/l10n.dart';
import '/ui/widget/modal_popup.dart';
import '/ui/widget/outlined_rounded_button.dart';
import '/ui/widget/text_field.dart';
import 'controller.dart';

/// View for adding and confirming an [UserPhone].
///
/// Intended to be displayed with the [show] method.
class AddPhoneView extends StatelessWidget {
  const AddPhoneView({super.key, this.phone});

  /// Initial [UserPhone] to confirm.
  final UserPhone? phone;

  /// Displays a [AddPhoneView] wrapped in a [ModalPopup].
  static Future<T?> show<T>(BuildContext context, {UserPhone? phone}) {
    return ModalPopup.show(context: context, child: AddPhoneView(phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? thin =
        Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black);

    return GetBuilder(
      init: AddPhoneController(
        Get.find(),
        initial: phone,
        pop: Navigator.of(context).pop,
      ),
      builder: (AddPhoneController c) {
        return Obx(() {
          final Widget child;

          switch (c.stage.value) {
            case AddPhoneFlowStage.code:
              child = ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Obx(() {
                      return Text(
                        c.resent.value
                            ? 'label_add_phone_confirmation_sent_again'.l10n
                            : 'label_add_phone_confirmation_sent'.l10n,
                        style: thin?.copyWith(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 25),
                  ReactiveTextField(
                    key: const Key('ConfirmationCode'),
                    state: c.phoneCode,
                    label: 'label_confirmation_code'.l10n,
                  ),
                  const SizedBox(height: 25),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedRoundedButton(
                            key: const Key('Resend'),
                            maxWidth: double.infinity,
                            title: Text(
                              c.resendPhoneTimeout.value == 0
                                  ? 'label_resend'.l10n
                                  : 'label_resend_timeout'.l10nfmt(
                                      {'timeout': c.resendPhoneTimeout.value},
                                    ),
                              style: thin?.copyWith(
                                color: c.resendPhoneTimeout.value == 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            onPressed: c.resendPhoneTimeout.value == 0
                                ? c.resendPhone
                                : null,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedRoundedButton(
                            key: const Key('Proceed'),
                            maxWidth: double.infinity,
                            title: Text(
                              'btn_proceed'.l10n,
                              style: thin?.copyWith(
                                color: c.phoneCode.isEmpty.value
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            onPressed: c.phoneCode.isEmpty.value
                                ? null
                                : c.phoneCode.submit,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              );
              break;

            default:
              child = ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'label_add_phone_description'.l10n,
                      style: thin?.copyWith(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ReactiveTextField(
                    key: const Key('Phone'),
                    state: c.phone,
                    label: 'label_phone_number'.l10n,
                    // TODO: Improve hint to account user's region.
                    hint: '+34 123 123 53 53',
                  ),
                  const SizedBox(height: 25),
                  Obx(() {
                    return OutlinedRoundedButton(
                      key: const Key('Proceed'),
                      maxWidth: double.infinity,
                      title: Text(
                        'btn_proceed'.l10n,
                        style: thin?.copyWith(
                          color: c.phone.isEmpty.value
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      onPressed: c.phone.isEmpty.value ? null : c.phone.submit,
                      color: Theme.of(context).colorScheme.secondary,
                    );
                  }),
                ],
              );
              break;
          }

          return AnimatedSizeAndFade(
            fadeDuration: const Duration(milliseconds: 250),
            sizeDuration: const Duration(milliseconds: 250),
            child: Column(
              key: Key('${c.stage.value}'),
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                ModalPopupHeader(
                  header: Center(
                    child: Text(
                      'label_add_phone'.l10n,
                      style: thin?.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Flexible(
                  child: Padding(
                    padding: ModalPopup.padding(context),
                    child: child,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
      },
    );
  }
}