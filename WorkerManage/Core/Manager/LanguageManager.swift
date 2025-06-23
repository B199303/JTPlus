//
//  LanguageManager.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import Foundation

public class LanguageManager {
    public static let shared = LanguageManager()

    private static let userDefaultsKey = "current_language"
    public static let fallbackLanguage = "en"

    public var currentLanguage: String {
        didSet {
            storeCurrentLanguage()
        }
    }

    init() {
        currentLanguage = LanguageManager.storedCurrentLanguage ?? LanguageManager.preferredLanguage ?? LanguageManager.fallbackLanguage
    }

    public var currentLanguageDisplayName: String? {
        displayName(language: currentLanguage)
    }

    public func displayName(language: String) -> String? {
        (currentLocale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: language)?.capitalized
    }

    private func storeCurrentLanguage() {
        UserDefaults.standard.set(currentLanguage, forKey: LanguageManager.userDefaultsKey)
    }

    public static func nativeDisplayName(language: String) -> String? {
        let locale = NSLocale(localeIdentifier: language)
        return locale.displayName(forKey: NSLocale.Key.identifier, value: language)?.capitalized
    }

    public static var availableLanguages: [String] {
        Bundle.main.localizations.sorted()
    }

    private static var storedCurrentLanguage: String? {
        UserDefaults.standard.value(forKey: userDefaultsKey) as? String
    }

    private static var preferredLanguage: String? {
//        if let aa = Locale.preferredLanguages.first {
//            if aa.contains("zh") {
//                return "zh-Hant"
//            }
//        }
//        if let code = Bundle.main.preferredLocalizations.first(where: { availableLanguages.contains($0) }) {
//            return code
//        }
    
        return "en"

        return nil
    }

}

extension LanguageManager {

    public var currentLocale: Locale {
        Locale(identifier: currentLanguage)
    }

}

extension LanguageManager {

    public func localize(string: String, bundle: Bundle?) -> String {
        if let languageBundleUrl = bundle?.url(forResource: currentLanguage, withExtension: "lproj"), let languageBundle = Bundle(url: languageBundleUrl) {
            return languageBundle.localizedString(forKey: string, value: nil, table: nil)
        }

        return string
    }

    public func localize(string: String, bundle: Bundle?, arguments: [CVarArg]) -> String {
        String(format: localize(string: string, bundle: bundle), locale: currentLocale, arguments: arguments)
    }

}

extension String {

    var localized: String {
        LanguageManager.shared.localize(string: self, bundle: Bundle.main)
    }

    func localized(_ arguments: CVarArg...) -> String {
        LanguageManager.shared.localize(string: self, bundle: Bundle.main, arguments: arguments)
    }

}
