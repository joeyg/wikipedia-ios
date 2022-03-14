
import Foundation
import WMF

extension NotificationsCenterCellViewModel {
    
    var sheetActions: [NotificationsCenterAction] {
        
        var sheetActions: [NotificationsCenterAction] = []
        let markAsReadText = CommonStrings.notificationsCenterMarkAsRead
        let markAsUnreadText = CommonStrings.notificationsCenterMarkAsUnread
        let markAsReadOrUnreadText = isRead ? markAsUnreadText : markAsReadText
        let markAsReadOrUnreadActionData = NotificationsCenterActionData(text: markAsReadOrUnreadText, url: nil, iconType: nil)
        sheetActions.append(.markAsReadOrUnread(markAsReadOrUnreadActionData))
        
        switch notification.type {
        case .userTalkPageMessage:
            sheetActions.append(contentsOf: userTalkPageActions)
        case .mentionInTalkPage:
            sheetActions.append(contentsOf: mentionInTalkPageActions)
        case .mentionInEditSummary:
            sheetActions.append(contentsOf: mentionInEditSummaryActions)
        case .successfulMention,
             .failedMention:
            sheetActions.append(contentsOf: successfulAndFailedMentionActions)
        case .editReverted:
            sheetActions.append(contentsOf: editRevertedActions)
        case .userRightsChange:
            sheetActions.append(contentsOf: userGroupRightsActions)
        case .pageReviewed:
            sheetActions.append(contentsOf: pageReviewedActions)
        case .pageLinked:
            sheetActions.append(contentsOf: pageLinkActions)
        case .connectionWithWikidata:
            sheetActions.append(contentsOf: connectionWithWikidataActions)
        case .emailFromOtherUser:
            sheetActions.append(contentsOf: emailFromOtherUserActions)
        case .thanks:
            sheetActions.append(contentsOf: thanksActions)
        case .translationMilestone,
             .editMilestone,
             .welcome:
            break
        case .loginFailKnownDevice,
             .loginFailUnknownDevice,
             .loginSuccessUnknownDevice:
            sheetActions.append(contentsOf: loginActions)

        case .unknownAlert,
             .unknownSystemAlert:
            sheetActions.append(contentsOf: genericAlertActions)

        case .unknownSystemNotice,
             .unknownNotice,
             .unknown:
            sheetActions.append(contentsOf: genericActions)

        }
        
        let notificationSubscriptionSettingsText = WMFLocalizedString("notifications-center-notifications-settings", value: "Notification settings", comment: "Button text in Notifications Center that automatically routes to the notifications settings screen.")
        let notificationSettingsActionData = NotificationsCenterActionData(text: notificationSubscriptionSettingsText, url: nil, iconType: nil)
        sheetActions.append(.notificationSubscriptionSettings(notificationSettingsActionData))
        
        return sheetActions
    }
}

//MARK: Private Helpers - Aggregate Swipe Action methods

private extension NotificationsCenterCellViewModel {
    var userTalkPageActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let diffAction = commonViewModel.diffAction {
            sheetActions.append(diffAction)
        }

        if let talkPageAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: true) {
            sheetActions.append(talkPageAction)
        }

        return sheetActions
    }

    var mentionInTalkPageActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let diffAction = commonViewModel.diffAction {
            sheetActions.append(diffAction)
        }

        if let titleTalkPageAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: false) {
            sheetActions.append(titleTalkPageAction)
        }

        //TODO: If mention occurs on a User Talk page, this results in duplicate actions here and on the detail view model. Need to check if titleAction == titleTalkPageAction here and not append in this case.
        if let titleAction = commonViewModel.titleAction(convertToTalkOrMain: true, simplified: false) {
            sheetActions.append(titleAction)
        }

        return sheetActions
    }

    var mentionInEditSummaryActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let diffAction = commonViewModel.diffAction {
            sheetActions.append(diffAction)
        }

        if let titleAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: false) {
            sheetActions.append(titleAction)
        }

        return sheetActions
    }
    
    var editRevertedActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let diffAction = commonViewModel.diffAction {
            sheetActions.append(diffAction)
        }

        if let titleTalkPageAction = commonViewModel.titleAction(convertToTalkOrMain: true, simplified: false) {
            sheetActions.append(titleTalkPageAction)
        }

        if let titleAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: false) {
            sheetActions.append(titleAction)
        }

        return sheetActions
    }

    var successfulAndFailedMentionActions: [NotificationsCenterAction] {
        if let titleAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: false) {
            return [titleAction]
        }

        return []
    }

    var userGroupRightsActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let specificUserGroupRightsAction = commonViewModel.specificUserGroupRightsAction {
            sheetActions.append(specificUserGroupRightsAction)
        }

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let userGroupRightsAction = commonViewModel.userGroupRightsAction {
            sheetActions.append(userGroupRightsAction)
        }

        return sheetActions
    }

    var pageReviewedActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let titleAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: false) {
            sheetActions.append(titleAction)
        }

        return sheetActions
    }

    var pageLinkActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        //Article where link was made
        if let pageLinkToAction = commonViewModel.pageLinkToAction {
            sheetActions.append(pageLinkToAction)
        }
        
        //Article you edited
        if let titleAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: false) {
            sheetActions.append(titleAction)
        }

        if let diffAction = commonViewModel.diffAction {
            sheetActions.append(diffAction)
        }

        return sheetActions
    }

    var connectionWithWikidataActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let titleAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: false) {
            sheetActions.append(titleAction)
        }

        if let wikidataItemAction = commonViewModel.wikidataItemAction {
            sheetActions.append(wikidataItemAction)
        }

        return sheetActions
    }

    var emailFromOtherUserActions: [NotificationsCenterAction] {
        if let agentUserPageAction = commonViewModel.userPageAction {
            return [agentUserPageAction]
        }

        return []
    }

    var thanksActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let titleAction = commonViewModel.titleAction(convertToTalkOrMain: false, simplified: false) {
            sheetActions.append(titleAction)
        }

        if let diffAction = commonViewModel.diffAction {
            sheetActions.append(diffAction)
        }

        return sheetActions
    }

    var loginActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let loginHelpAction = commonViewModel.loginNotificationsAction {
            sheetActions.append(loginHelpAction)
        }

        if let changePasswordAction = commonViewModel.changePasswordAction {
            sheetActions.append(changePasswordAction)
        }

        return sheetActions
    }

    var genericAlertActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let secondaryLinks = notification.secondaryLinks {
            let secondaryNotificationsCenterActions = secondaryLinks.compactMap { commonViewModel.actionForGenericLink(link:$0) }
            sheetActions.append(contentsOf: secondaryNotificationsCenterActions)
        }

        if let diffAction = commonViewModel.diffAction {
            sheetActions.append(diffAction)
        }

        if let primaryLink = notification.primaryLink,
           let primaryAction = commonViewModel.actionForGenericLink(link: primaryLink) {
            sheetActions.append(primaryAction)
        }

        return sheetActions
    }

    var genericActions: [NotificationsCenterAction] {
        var sheetActions: [NotificationsCenterAction] = []

        if let agentUserPageAction = commonViewModel.userPageAction {
            sheetActions.append(agentUserPageAction)
        }

        if let diffAction = commonViewModel.diffAction {
            sheetActions.append(diffAction)
        }

        if let primaryLink = notification.primaryLink,
           let primaryAction = commonViewModel.actionForGenericLink(link: primaryLink) {
            sheetActions.append(primaryAction)
        }

        return sheetActions
    }
}
