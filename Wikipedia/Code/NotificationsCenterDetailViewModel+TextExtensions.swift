
import Foundation

extension NotificationsCenterDetailViewModel {
    var headerImageName: String? {
        return commonViewModel.notification.type.imageName
    }
    
    var headerTitle: String? {
        
        //Login types seem to have an exception where they display "Alert" here.
        switch commonViewModel.notification.type {
        case .loginFailKnownDevice,
             .loginFailUnknownDevice,
             .loginSuccessUnknownDevice:
            return CommonStrings.notificationsCenterAlert
        case .successfulMention,
                .failedMention:
            return WMFLocalizedString("notifications-center-type-item-description-mentions", value: "Mentions", comment: "Description of \"mention\" notification types, used on the notification detail view.")
        case .editMilestone,
             .translationMilestone:
            return WMFLocalizedString("notifications-center-type-item-description-milestone", value: "Milestone", comment: "Description of \"milestone\" notification types, used on the notification detail view.")
        case .welcome:
            return WMFLocalizedString("notifications-center-type-item-description-welcome-verbose", value: "Welcome message", comment: "Description of \"welcome\" notification types, used on the notification detail view.")
        default:
            break
        }
        
        if let agentName = commonViewModel.notification.agentName {
            return String.localizedStringWithFormat(CommonStrings.notificationsCenterAgentDescriptionFromFormat, agentName)
        }

        return commonViewModel.title
    }
    
    var headerSubtitle: String? {
        return String.localizedStringWithFormat(CommonStrings.projectDescriptionOnFormat, commonViewModel.project.projectName(shouldReturnCodedFormat: false))
    }
    
    var headerDate: String? {
        return commonViewModel.dateText
    }
    
    var contentTitle: String? {
        return commonViewModel.bodyText != nil ? commonViewModel.verboseTitle : commonViewModel.title
    }
    
    var contentBody: String? {
        return commonViewModel.bodyText ?? commonViewModel.verboseTitle
    }
}
