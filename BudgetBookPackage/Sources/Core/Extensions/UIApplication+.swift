import UIKit

public extension UIApplication {
    func endEditing(_ force: Bool) {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
