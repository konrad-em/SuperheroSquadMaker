import Foundation

public enum Localization {
    public static func localizedName(_ key: String) -> String {
        NSLocalizedString(key, bundle: Bundle.main, comment: "")
    }
}
