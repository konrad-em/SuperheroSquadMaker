import Utils

extension Localization {
    enum Root {
        static let squadTitle = localizedName("root.squad.title")
    }

    enum Details {
        static let hire = localizedName("details.hire")
        static let fire = localizedName("details.fire")
        static let lastAppearance = localizedName("details.lastAppearance")
        static let delete = localizedName("details.delete")
        static let cancel = localizedName("details.cancel")
        static var confirm: (String) -> String = { hero in
            String(format: localizedName("details.confirm"), hero)
        }
        static var andOneOtherComic = localizedName("details.andOneOtherComic")
        static var andOtherComics: (Int) -> String = { number in
            String(format: localizedName("details.andOtherComics"), number)
        }
    }
}
