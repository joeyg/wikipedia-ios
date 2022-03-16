
import Foundation
import WMF

enum NotificationsCenterAction {
    case markAsReadOrUnread(NotificationsCenterActionData)
    case custom(NotificationsCenterActionData)
    case notificationSubscriptionSettings(NotificationsCenterActionData)
}

extension NotificationsCenterAction: Equatable {
    static func == (lhs: NotificationsCenterAction, rhs: NotificationsCenterAction) -> Bool {
        switch lhs {
        case .markAsReadOrUnread(let lhsActionData):
            switch rhs {
            case .markAsReadOrUnread(let rhsActionData):
                return lhsActionData == rhsActionData
            default:
                return false
            }
        case .custom(let lhsActionData):
            switch rhs {
            case .custom(let rhsActionData):
                return lhsActionData == rhsActionData
            default:
                return false
            }
        case .notificationSubscriptionSettings(let lhsActionData):
            switch rhs {
            case .notificationSubscriptionSettings(let rhsActionData):
                return lhsActionData == rhsActionData
            default:
                return false
            }
        }
    }
}

struct NotificationsCenterActionData: Equatable {
    let text: String
    let url: URL?
    let iconType: NotificationsCenterIconType?
}

//MARK: Private Helpers - Individual Swipe Action methods

extension NotificationsCenterCommonViewModel {
    //"Go to [Username]'s user page"
    var userPageAction: NotificationsCenterAction? {
        guard let agentName = notification.agentName,
              let url = customPrefixAgentNameURL(pageNamespace: .user) else {
            return nil
        }

        let format = WMFLocalizedString("notifications-center-go-to-user-page", value: "Go to %1$@'s user page", comment: "Button text in Notifications Center that routes to a web view of the user page of the sender that triggered the notification. %1$@ is replaced with the sender's username.")
        let text = String.localizedStringWithFormat(format, agentName)

        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.person)

        return NotificationsCenterAction.custom(data)
    }
    
    //"Go to user page"
    var userPageSimplifiedAction: NotificationsCenterAction? {
        guard let url = customPrefixAgentNameURL(pageNamespace: .user) else {
            return nil
        }

        let text = WMFLocalizedString("notifications-center-go-to-user-page-simplified", value: "Go to user page", comment: "Button text in Notifications Center that routes to a web view of the user page of the sender that triggered the notification.")

        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.person)

        return NotificationsCenterAction.custom(data)
    }

    //"Go to diff"
    var diffAction: NotificationsCenterAction? {
        guard let url = fullTitleDiffURL else {
            return nil
        }

        let text = WMFLocalizedString("notifications-center-go-to-diff", value: "Go to diff", comment: "Button text in Notifications Center that routes to a diff screen of the revision that triggered the notification.")
        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.diff)
        return NotificationsCenterAction.custom(data)
    }

    /// Outputs various actions based on the notification title payload.
    /// - Parameters:
    ///   - convertToTalkOrMain: Pass true if you want to construct an action based on the talk-equivalent or main-equivalent of the title payload. For example, if the title payload indicates the notification sourced from an article talk page, passing true here will construct the action based on the main namespace, i.e. "Go to Cat" instead of "Go to Talk:Cat".`
    ///   - simplified: Pass true if you want a generic phrasing of the action, i.e., "Go to article" or "Go to talk page" instead of "Go to Cat" or "Go to Talk:Cat" respectively.
    /// - Returns: NotificationsCenterAction struct, for use in view models.
    func titleAction(convertToTalkOrMain: Bool, simplified: Bool) -> NotificationsCenterAction? {
        
        guard let linkData = linkData,
              let normalizedTitle = linkData.title?.normalizedPageTitle,
              let sourceNamespace = linkData.titleNamespace else {
                  return nil
              }
        
        let namespace = convertToTalkOrMain ? (sourceNamespace.converted ?? sourceNamespace) : sourceNamespace
        let yourPhrasing = notification.type == .userTalkPageMessage
        
        let yourTalkPageText: String
        switch project {
        case .wikipedia:
            yourTalkPageText = WMFLocalizedString("notifications-center-go-to-your-talk-page", value: "Go to your talk page", comment: "Button text in Notifications Center that routes to user's talk page.")
        case .wikinews:
            yourTalkPageText = WMFLocalizedString("notifications-center-go-to-your-collaboration-page", value: "Go to your collaboration page", comment: "Button text in Notifications Center that routes to user's collaboration page.")
        default:
            yourTalkPageText = WMFLocalizedString("notifications-center-go-to-your-discussion-page", value: "Go to your discussion page", comment: "Button text in Notifications Center that routes to user's discussion page.")
        }
        
        guard !simplified else {
            
            //Go to your talk page
            //Go to talk page
            //Go to article
            
            if yourPhrasing {
                let text = yourTalkPageText
                return titleAction(text: text, namespace: namespace, normalizedTitle: normalizedTitle)
            } else if namespace == .talk || namespace == .userTalk {
                
                let text: String
                switch project {
                case .wikipedia:
                    text = WMFLocalizedString("notifications-center-go-to-talk-page", value: "Go to talk page", comment: "Button text in Notifications Center that routes to a talk page.")
                case .wikinews:
                    text = WMFLocalizedString("notifications-center-go-to-collaboration-page", value: "Go to collaboration page", comment: "Button text in Notifications Center that routes to a collaboration page.")
                default:
                    text = WMFLocalizedString("notifications-center-go-to-discussion-page", value: "Go to discussion page", comment: "Button text in Notifications Center that routes to a discussion page.")
                }
                
                return titleAction(text: text, namespace: namespace, normalizedTitle: normalizedTitle)
                
            } else {
                
                let text: String?
                switch project {
                case .wikipedia:
                    text = WMFLocalizedString("notifications-center-go-to-article", value: "Go to article", comment: "Button text in Notifications Center that routes to an article.")
                default:
                    text = nil
                }
                
                return titleAction(text: text, namespace: namespace, normalizedTitle: normalizedTitle)
            }
        }
        
        //Go to your talk page
        //Go to [UserTalk: Title]
        //Go to [Talk: Title]
        //Go to [Title]
        
        let text = yourPhrasing ? yourTalkPageText : nil
        return titleAction(text: text, namespace: namespace, normalizedTitle: normalizedTitle)
    }
    
    private func titleAction(text: String?, namespace: PageNamespace, normalizedTitle: String) -> NotificationsCenterAction {
        let prefix = namespace != .main ? "\(namespace.canonicalName):" : ""
        let actionText = text ?? String.localizedStringWithFormat(CommonStrings.notificationsCenterGoToTitleFormat, "\(prefix)\(normalizedTitle)")
        
        let url = customPrefixTitleURL(pageNamespace: namespace)
        let data = NotificationsCenterActionData(text: actionText, url: url, iconType: NotificationsCenterIconType.document)
        return NotificationsCenterAction.custom(data)
    }

    //"Go to [Article where link was made]"
    var pageLinkToAction: NotificationsCenterAction? {
        guard let url = pageLinkToURL,
              let title = url.wmf_title else {
            return nil
        }

        let text = String.localizedStringWithFormat(CommonStrings.notificationsCenterGoToTitleFormat, title)
        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.document)
        return NotificationsCenterAction.custom(data)
    }

    //"Go to Wikidata item"
    var wikidataItemAction: NotificationsCenterAction? {
        guard let url = connectionWithWikidataItemURL else {
            return nil
        }

        let text = WMFLocalizedString("notifications-center-go-to-wikidata-item", value: "Go to Wikidata item", comment: "Button text in Notifications Center that routes to a Wikidata item page.")
        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.wikidata)
        return NotificationsCenterAction.custom(data)
    }

    //Go to specific Special:UserGroupRights#{Type} page
    var specificUserGroupRightsAction: NotificationsCenterAction? {
        guard let url = specificUserGroupRightsURL,
              let type = url.fragment,
              let title = url.wmf_title else {
            return nil
        }

        let text = String.localizedStringWithFormat(CommonStrings.notificationsCenterGoToTitleFormat, "\(title)#\(type)")
        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.document)
        return NotificationsCenterAction.custom(data)
    }

    //"Go to Special:UserGroupRights"
    var userGroupRightsAction: NotificationsCenterAction? {
        guard let url = userGroupRightsURL,
              let title = url.wmf_title else {
            return nil
        }

        let text = String.localizedStringWithFormat(CommonStrings.notificationsCenterGoToTitleFormat, title)
        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.document)
        return NotificationsCenterAction.custom(data)
    }
    
    //"Go to Help:GettingStarted"
    var gettingStartedAction: NotificationsCenterAction? {
        guard let url = gettingStartedURL,
              let title = url.wmf_title else {
            return nil
        }

        let text = String.localizedStringWithFormat(CommonStrings.notificationsCenterGoToTitleFormat, title)
        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.document)
        return NotificationsCenterAction.custom(data)
    }

    //"Login Notifications"
    var loginNotificationsText: String {
        WMFLocalizedString("notifications-center-login-notifications", value: "Login Notifications", comment: "Button text in Notifications Center that routes user to login notifications help page in web view.")
    }
    var loginNotificationsAction: NotificationsCenterAction? {
        guard let url = loginNotificationsHelpURL else {
            return nil
        }

        let data = NotificationsCenterActionData(text: loginNotificationsText, url: url, iconType: NotificationsCenterIconType.document)
        return NotificationsCenterAction.custom(data)
    }
    
    //"Go to Login Notifications"
    var loginNotificationsGoToAction: NotificationsCenterAction? {
        guard let url = loginNotificationsHelpURL else {
            return nil
        }

        let text = String.localizedStringWithFormat(CommonStrings.notificationsCenterGoToTitleFormat, loginNotificationsText)
        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.document)
        return NotificationsCenterAction.custom(data)
    }

    //"Change password"
    var changePasswordAction: NotificationsCenterAction? {

        guard let url = changePasswordURL else {
            return nil
        }

        let text = CommonStrings.notificationsChangePassword

        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.lock)
        return NotificationsCenterAction.custom(data)
    }

    func actionForGenericLink(link: RemoteNotificationLink) -> NotificationsCenterAction? {
        guard let url = link.url,
              let text = link.label else {
            return nil
        }

        let data = NotificationsCenterActionData(text: text, url: url, iconType: NotificationsCenterIconType.link)
        return NotificationsCenterAction.custom(data)
    }
}
