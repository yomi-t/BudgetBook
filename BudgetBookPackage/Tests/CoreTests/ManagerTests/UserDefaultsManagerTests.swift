import Core
import Foundation
import Testing

@Suite(.serialized)
private struct UserDefaultsManagerTests {
    struct SetAndGetTestCase: Sendable {
        let key: UserDefaultsKey
        let value: Int
    }

    @Test(arguments: [
        SetAndGetTestCase(key: .goal, value: 5000000),
        SetAndGetTestCase(key: .goal, value: 3000000),
        SetAndGetTestCase(key: .goal, value: 10000000),
        SetAndGetTestCase(key: .goal, value: 0),
        SetAndGetTestCase(key: .goal, value: 1000),
        SetAndGetTestCase(key: .goal, value: -1000)
    ])
    func testSetAndGet(_ testCase: SetAndGetTestCase) {
        // テスト前にクリア
        UserDefaults.standard.removeObject(forKey: testCase.key.rawValue)

        // 値を設定
        UserDefaultsManager.set(testCase.value, forKey: testCase.key)

        // 値を取得
        let retrievedValue = UserDefaultsManager.get(forKey: testCase.key)

        // 期待値と一致することを確認
        if retrievedValue != testCase.value {
            Issue.record("Expected \(testCase.value) but got \(retrievedValue)")
        }

        // テスト後にクリア
        UserDefaults.standard.removeObject(forKey: testCase.key.rawValue)
    }

    @Test
    func testGetDefaultValue() {
        let key = UserDefaultsKey.goal

        // テスト前にクリア
        UserDefaults.standard.removeObject(forKey: key.rawValue)

        // 値が設定されていない場合は0が返ることを確認
        let defaultValue = UserDefaultsManager.get(forKey: key)

        if defaultValue != 0 {
            Issue.record("Expected default value 0 but got \(defaultValue)")
        }

        // テスト後にクリア
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    @Test
    func testOverwriteValue() {
        let key = UserDefaultsKey.goal

        // テスト前にクリア
        UserDefaults.standard.removeObject(forKey: key.rawValue)

        // 最初の値を設定
        UserDefaultsManager.set(1000000, forKey: key)
        let firstValue = UserDefaultsManager.get(forKey: key)

        if firstValue != 1000000 {
            Issue.record("Expected first value 1000000 but got \(firstValue)")
        }

        // 値を上書き
        UserDefaultsManager.set(2000000, forKey: key)
        let secondValue = UserDefaultsManager.get(forKey: key)

        if secondValue != 2000000 {
            Issue.record("Expected second value 2000000 but got \(secondValue)")
        }

        // テスト後にクリア
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    struct MultipleOperationsTestCase: Sendable {
        let operations: [(value: Int, expectedAfterSet: Int)]
    }

    @Test(arguments: [
        MultipleOperationsTestCase(operations: [
            (value: 100, expectedAfterSet: 100),
            (value: 200, expectedAfterSet: 200),
            (value: 300, expectedAfterSet: 300)
        ]),
        MultipleOperationsTestCase(operations: [
            (value: 5000000, expectedAfterSet: 5000000),
            (value: 0, expectedAfterSet: 0),
            (value: 3000000, expectedAfterSet: 3000000)
        ]),
        MultipleOperationsTestCase(operations: [
            (value: -100, expectedAfterSet: -100),
            (value: 1000, expectedAfterSet: 1000)
        ])
    ])
    func testMultipleOperations(_ testCase: MultipleOperationsTestCase) {
        let key = UserDefaultsKey.goal

        // テスト前にクリア
        UserDefaults.standard.removeObject(forKey: key.rawValue)

        for operation in testCase.operations {
            UserDefaultsManager.set(operation.value, forKey: key)
            let retrievedValue = UserDefaultsManager.get(forKey: key)

            if retrievedValue != operation.expectedAfterSet {
                Issue.record("Expected \(operation.expectedAfterSet) but got \(retrievedValue)")
            }
        }

        // テスト後にクリア
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    @Test
    func testUserDefaultsKeyRawValue() {
        let key = UserDefaultsKey.goal

        // rawValueが期待通りであることを確認
        if key.rawValue != "goal" {
            Issue.record("Expected rawValue 'goal' but got '\(key.rawValue)'")
        }
    }

    struct LargeValueTestCase: Sendable {
        let value: Int
    }

    @Test(arguments: [
        LargeValueTestCase(value: Int.max),
        LargeValueTestCase(value: Int.min),
        LargeValueTestCase(value: 1_000_000_000),
        LargeValueTestCase(value: -1_000_000_000)
    ])
    func testLargeValues(_ testCase: LargeValueTestCase) {
        let key = UserDefaultsKey.goal

        // テスト前にクリア
        UserDefaults.standard.removeObject(forKey: key.rawValue)

        UserDefaultsManager.set(testCase.value, forKey: key)
        let retrievedValue = UserDefaultsManager.get(forKey: key)

        if retrievedValue != testCase.value {
            Issue.record("Expected \(testCase.value) but got \(retrievedValue)")
        }

        // テスト後にクリア
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
