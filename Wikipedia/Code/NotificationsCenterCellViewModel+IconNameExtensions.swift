
import Foundation

extension NotificationsCenterCellViewModel {
        
    var projectIconName: NotificationsCenterIconName? {
        return commonViewModel.project.projectIconName
    }
        
    var footerIconType: NotificationsCenterIconType? {
        switch commonViewModel.notification.type {
        case .loginFailKnownDevice,
             .loginFailUnknownDevice,
             .loginSuccessUnknownDevice:
            return NotificationsCenterIconType.lock
        case .unknownSystemAlert,
             .unknownSystemNotice,
             .unknownAlert,
             .unknownNotice,
             .unknown:
            return NotificationsCenterIconType.link
        default:
            break
        }
        
        guard let namespace = PageNamespace(rawValue: Int(commonViewModel.notification.titleNamespaceKey)),
              commonViewModel.notification.titleNamespace != nil else {
            return nil
        }
        
        switch namespace {
        case .talk,
             .userTalk,
             .user:
            return NotificationsCenterIconType.personFill
        case .main:
            return NotificationsCenterIconType.documentFill
        case .file:
            return NotificationsCenterIconType.photo
        default:
            return nil
        }
    }
}
