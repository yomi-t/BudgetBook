// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum AccountSetting {
    /// 口座の編集
    public static let title = L10n.tr("Localizable", "accountSetting.title", fallback: "口座の編集")
    public enum Alert {
      /// 口座名を入力
      public static let placeholder = L10n.tr("Localizable", "accountSetting.alert.placeholder", fallback: "口座名を入力")
      /// 口座を追加
      public static let title = L10n.tr("Localizable", "accountSetting.alert.title", fallback: "口座を追加")
    }
  }
  public enum Add {
    public enum Balance {
      /// 口座
      public static let accountSection = L10n.tr("Localizable", "add.balance.accountSection", fallback: "口座")
      /// 口座を追加してください
      public static let addAccountPrompt = L10n.tr("Localizable", "add.balance.addAccountPrompt", fallback: "口座を追加してください")
      /// 残高
      public static let amountSection = L10n.tr("Localizable", "add.balance.amountSection", fallback: "残高")
      /// 決算月
      public static let dateSection = L10n.tr("Localizable", "add.balance.dateSection", fallback: "決算月")
      /// 月末
      public static let endOfMonth = L10n.tr("Localizable", "add.balance.endOfMonth", fallback: "月末")
      /// 残高を追加
      public static let title = L10n.tr("Localizable", "add.balance.title", fallback: "残高を追加")
    }
    public enum Income {
      /// 収入元を追加してください
      public static let addSourcePrompt = L10n.tr("Localizable", "add.income.addSourcePrompt", fallback: "収入元を追加してください")
      /// 収入金額
      public static let amountSection = L10n.tr("Localizable", "add.income.amountSection", fallback: "収入金額")
      /// 収入月
      public static let dateSection = L10n.tr("Localizable", "add.income.dateSection", fallback: "収入月")
      /// 収入元
      public static let sourceSection = L10n.tr("Localizable", "add.income.sourceSection", fallback: "収入元")
      /// 収入を追加
      public static let title = L10n.tr("Localizable", "add.income.title", fallback: "収入を追加")
    }
    public enum Tab {
      /// 残高
      public static let balance = L10n.tr("Localizable", "add.tab.balance", fallback: "残高")
      /// 収入
      public static let income = L10n.tr("Localizable", "add.tab.income", fallback: "収入")
    }
  }
  public enum Balance {
    public enum AccountList {
      /// %d年%d月の残高
      public static func title(_ p1: Int, _ p2: Int) -> String {
        return L10n.tr("Localizable", "balance.accountList.title", p1, p2, fallback: "%d年%d月の残高")
      }
    }
    public enum Chart {
      /// 貯金額
      public static let savingsLabel = L10n.tr("Localizable", "balance.chart.savingsLabel", fallback: "貯金額")
    }
    public enum List {
      /// これまでの残高記録
      public static let title = L10n.tr("Localizable", "balance.list.title", fallback: "これまでの残高記録")
    }
  }
  public enum Common {
    /// 追加
    public static let add = L10n.tr("Localizable", "common.add", fallback: "追加")
    /// 金額を入力
    public static let amountPlaceholder = L10n.tr("Localizable", "common.amountPlaceholder", fallback: "金額を入力")
    /// %d円
    public static func amountWithCurrency(_ p1: Int) -> String {
      return L10n.tr("Localizable", "common.amountWithCurrency", p1, fallback: "%d円")
    }
    /// キャンセル
    public static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "キャンセル")
    /// 決定
    public static let confirm = L10n.tr("Localizable", "common.confirm", fallback: "決定")
    /// 円
    public static let currency = L10n.tr("Localizable", "common.currency", fallback: "円")
    /// 完了
    public static let done = L10n.tr("Localizable", "common.done", fallback: "完了")
    /// 月
    public static let month = L10n.tr("Localizable", "common.month", fallback: "月")
    /// 選択
    public static let select = L10n.tr("Localizable", "common.select", fallback: "選択")
    /// 設定
    public static let `set` = L10n.tr("Localizable", "common.set", fallback: "設定")
    /// 万円
    public static let tensOfThousandsYen = L10n.tr("Localizable", "common.tensOfThousandsYen", fallback: "万円")
    /// 年
    public static let year = L10n.tr("Localizable", "common.year", fallback: "年")
    /// %d年%d月
    public static func yearMonth(_ p1: Int, _ p2: Int) -> String {
      return L10n.tr("Localizable", "common.yearMonth", p1, p2, fallback: "%d年%d月")
    }
  }
  public enum Expense {
    public enum List {
      /// これまでの支出
      public static let title = L10n.tr("Localizable", "expense.list.title", fallback: "これまでの支出")
    }
    public enum Year {
      /// 今年一年の支出
      public static let title = L10n.tr("Localizable", "expense.year.title", fallback: "今年一年の支出")
    }
  }
  public enum Goal {
    /// 1ヶ月の目安の収入額
    public static let monthEstimate = L10n.tr("Localizable", "goal.monthEstimate", fallback: "1ヶ月の目安の収入額")
    /// 設定する
    public static let setButton = L10n.tr("Localizable", "goal.setButton", fallback: "設定する")
    /// 目標金額まで
    public static let toGoal = L10n.tr("Localizable", "goal.toGoal", fallback: "目標金額まで")
    /// 1年間の収入目標金額
    public static let yearlyTarget = L10n.tr("Localizable", "goal.yearlyTarget", fallback: "1年間の収入目標金額")
    public enum Alert {
      /// 1年間の収入目標金額を設定します。
      public static let message = L10n.tr("Localizable", "goal.alert.message", fallback: "1年間の収入目標金額を設定します。")
      /// 目標金額を入力してください
      public static let placeholder = L10n.tr("Localizable", "goal.alert.placeholder", fallback: "目標金額を入力してください")
      /// 目標金額の設定
      public static let title = L10n.tr("Localizable", "goal.alert.title", fallback: "目標金額の設定")
    }
  }
  public enum Home {
    /// ホーム
    public static let navigationTitle = L10n.tr("Localizable", "home.navigationTitle", fallback: "ホーム")
  }
  public enum Income {
    public enum List {
      /// これまでの収入
      public static let title = L10n.tr("Localizable", "income.list.title", fallback: "これまでの収入")
    }
    public enum SourceList {
      /// %d年%d月の収入
      public static func title(_ p1: Int, _ p2: Int) -> String {
        return L10n.tr("Localizable", "income.sourceList.title", p1, p2, fallback: "%d年%d月の収入")
      }
    }
    public enum Year {
      /// 今年一年の収入
      public static let title = L10n.tr("Localizable", "income.year.title", fallback: "今年一年の収入")
    }
  }
  public enum Latest {
    /// 先月の残金
    public static let balance = L10n.tr("Localizable", "latest.balance", fallback: "先月の残金")
    /// 先月の支出
    public static let expense = L10n.tr("Localizable", "latest.expense", fallback: "先月の支出")
    /// 先月の収入
    public static let income = L10n.tr("Localizable", "latest.income", fallback: "先月の収入")
  }
  public enum SourceSetting {
    /// 収入源の編集
    public static let title = L10n.tr("Localizable", "sourceSetting.title", fallback: "収入源の編集")
    public enum Alert {
      /// 収入源を入力
      public static let placeholder = L10n.tr("Localizable", "sourceSetting.alert.placeholder", fallback: "収入源を入力")
      /// 収入源を追加
      public static let title = L10n.tr("Localizable", "sourceSetting.alert.title", fallback: "収入源を追加")
    }
  }
  public enum Tab {
    /// 追加
    public static let add = L10n.tr("Localizable", "tab.add", fallback: "追加")
    /// 資産
    public static let asset = L10n.tr("Localizable", "tab.asset", fallback: "資産")
    /// 支出
    public static let expense = L10n.tr("Localizable", "tab.expense", fallback: "支出")
    /// ホーム
    public static let home = L10n.tr("Localizable", "tab.home", fallback: "ホーム")
    /// 収入
    public static let income = L10n.tr("Localizable", "tab.income", fallback: "収入")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
