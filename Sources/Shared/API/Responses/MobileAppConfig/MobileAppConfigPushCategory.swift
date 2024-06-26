import Foundation
import ObjectMapper

public struct MobileAppConfigPushCategory: ImmutableMappable, UpdatableModelSource {
    public struct Action: ImmutableMappable {
        public var title: String
        public var identifier: String
        public var authenticationRequired: Bool
        public var behavior: String
        public var activationMode: String
        public var destructive: Bool
        public var textInputButtonTitle: String?
        public var textInputPlaceholder: String?
        public var url: String?
        public var icon: String?

        public init(map: Map) throws {
            self.title = try map.value("title", default: "Missing title")
            // we fall back to 'action' for android-style dynamic actions
            self.identifier = try map.value("identifier", default: map.value("action", default: "missing"))
            self.authenticationRequired = try map.value("authenticationRequired", default: false)
            self.behavior = try map.value("behavior", default: "default")
            self.activationMode = try map.value("activationMode", default: "background")
            self.destructive = try map.value("destructive", default: false)
            self.textInputButtonTitle = try? map.value("textInputButtonTitle")
            self.textInputPlaceholder = try? map.value("textInputPlaceholder")
            self.icon = try? map.value("icon")
            for urlKey in ["url", "uri"] {
                if let value: String = try? map.value(urlKey) {
                    // a url is set, which means this is likely coming from an actionable notification
                    // so assume that it wants activation for it
                    self.url = value
                    self.activationMode = "foreground"
                }
            }

            if identifier.lowercased() == "reply" {
                // matching Android behavior
                self.behavior = "textinput"
            }
        }
    }

    public var name: String
    public var identifier: String
    public var actions: [Action]

    public init(map: Map) throws {
        self.name = try map.value("name")
        self.identifier = try map.value("identifier", default: name)
        self.actions = map.value("actions", default: [])
    }

    public var primaryKey: String { identifier.uppercased() }
}
