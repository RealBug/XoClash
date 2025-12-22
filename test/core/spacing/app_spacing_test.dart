import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/spacing/app_spacing.dart';

void main() {
  group('AppSpacing', () {
    group('spacing getters', () {
      test('should provide consistent spacing hierarchy', () {
        expect(AppSpacing.xxs, lessThan(AppSpacing.xs));
        expect(AppSpacing.xs, lessThan(AppSpacing.sm));
        expect(AppSpacing.sm, lessThan(AppSpacing.md));
        expect(AppSpacing.md, lessThan(AppSpacing.lg));
        expect(AppSpacing.lg, lessThan(AppSpacing.xl));
        expect(AppSpacing.xl, lessThan(AppSpacing.xxl));
        expect(AppSpacing.xxl, lessThan(AppSpacing.xxxl));
      });

      test('should provide positive spacing values', () {
        expect(AppSpacing.xxs, greaterThan(0));
        expect(AppSpacing.xs, greaterThan(0));
        expect(AppSpacing.sm, greaterThan(0));
        expect(AppSpacing.md, greaterThan(0));
        expect(AppSpacing.lg, greaterThan(0));
        expect(AppSpacing.xl, greaterThan(0));
        expect(AppSpacing.xxl, greaterThan(0));
        expect(AppSpacing.xxxl, greaterThan(0));
      });

      test('should map to UIConstants values correctly', () {
        expect(AppSpacing.xxs, UIConstants.spacingXSmall * 0.5);
        expect(AppSpacing.xs, UIConstants.spacingXSmall);
        expect(AppSpacing.sm, UIConstants.spacingSmall);
        expect(AppSpacing.md, UIConstants.spacingMedium);
        expect(AppSpacing.lg, UIConstants.spacingLarge);
        expect(AppSpacing.xl, UIConstants.spacingXLarge);
        expect(AppSpacing.xxl, UIConstants.spacingXXLarge);
        expect(AppSpacing.xxxl, UIConstants.spacingHuge);
      });
    });

    group('paddingAll', () {
      test('should create EdgeInsets with all sides equal', () {
        final EdgeInsets padding = AppSpacing.paddingAll(16);
        expect(padding, const EdgeInsets.all(16));
      });

      test('should work with zero value', () {
        final EdgeInsets padding = AppSpacing.paddingAll(0);
        expect(padding, EdgeInsets.zero);
      });
    });

    group('paddingSymmetric', () {
      test('should create symmetric padding with both horizontal and vertical', () {
        final EdgeInsets padding = AppSpacing.paddingSymmetric(horizontal: 16, vertical: 8);
        expect(padding, const EdgeInsets.symmetric(horizontal: 16, vertical: 8));
      });

      test('should use zero for null horizontal', () {
        final EdgeInsets padding = AppSpacing.paddingSymmetric(vertical: 8);
        expect(padding, const EdgeInsets.symmetric(vertical: 8));
      });

      test('should use zero for null vertical', () {
        final EdgeInsets padding = AppSpacing.paddingSymmetric(horizontal: 16);
        expect(padding, const EdgeInsets.symmetric(horizontal: 16));
      });

      test('should use zero for both when null', () {
        final EdgeInsets padding = AppSpacing.paddingSymmetric();
        expect(padding, EdgeInsets.zero);
      });
    });

    group('paddingOnly', () {
      test('should create padding with all sides specified', () {
        final EdgeInsets padding = AppSpacing.paddingOnly(
          top: 8,
          bottom: 16,
          left: 12,
          right: 20,
        );
        expect(
          padding,
          const EdgeInsets.only(top: 8, bottom: 16, left: 12, right: 20),
        );
      });

      test('should use zero for unspecified sides', () {
        final EdgeInsets padding = AppSpacing.paddingOnly(top: 8);
        expect(padding, const EdgeInsets.only(top: 8));
      });

      test('should work with bottom only', () {
        final EdgeInsets padding = AppSpacing.paddingOnly(bottom: 16);
        expect(padding, const EdgeInsets.only(bottom: 16));
      });

      test('should work with left only', () {
        final EdgeInsets padding = AppSpacing.paddingOnly(left: 12);
        expect(padding, const EdgeInsets.only(left: 12));
      });

      test('should work with right only', () {
        final EdgeInsets padding = AppSpacing.paddingOnly(right: 20);
        expect(padding, const EdgeInsets.only(right: 20));
      });

      test('should use zero for all when all null', () {
        final EdgeInsets padding = AppSpacing.paddingOnly();
        expect(padding, EdgeInsets.zero);
      });
    });
  });
}
