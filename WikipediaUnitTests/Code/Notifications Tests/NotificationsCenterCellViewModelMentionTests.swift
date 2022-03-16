
import XCTest
@testable import Wikipedia

class NotificationsCenterCellViewModelMentionTests: NotificationsCenterViewModelTests {

    override var dataFileName: String {
        get {
            return "notifications-wikipedia-mentions"
        }
    }
    
    func testMentionOnUserTalk() throws {
        
        let notification = try fetchManagedObject(identifier: "1")
        guard let cellViewModel = NotificationsCenterCellViewModel(notification: notification, languageLinkController: languageLinkController, isEditing: false, configuration: configuration) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        XCTAssertEqual(cellViewModel.headerText, "Section Title", "Invalid headerText")
        XCTAssertEqual(cellViewModel.subheaderText, "From Fred The Bird", "Invalid subheaderText")
        XCTAssertEqual(cellViewModel.bodyText, "Reply text mention in talk page User:Jack The Cat", "Invalid bodyText")
        XCTAssertEqual(cellViewModel.footerText, "User talk:Fred The Bird", "Invalid footerText")
        XCTAssertEqual(cellViewModel.dateText, "7/16/21", "Invalid dateText")
        XCTAssertEqual(cellViewModel.projectText, "EN", "Invalid projectText")
    }
    
    func testMentionInUserTalkEditSummary() throws {
        
        let notification = try fetchManagedObject(identifier: "2")
        guard let cellViewModel = NotificationsCenterCellViewModel(notification: notification, languageLinkController: languageLinkController, isEditing: false, configuration: configuration) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        XCTAssertEqual(cellViewModel.headerText, "Mention in edit summary", "Invalid headerText")
        XCTAssertEqual(cellViewModel.subheaderText, "From Fred The Bird", "Invalid subheaderText")
        XCTAssertEqual(cellViewModel.bodyText, "Edit Summary Text: User:Jack The Cat", "Invalid bodyText")
        XCTAssertEqual(cellViewModel.footerText, "User talk:Fred The Bird", "Invalid footerText")
        XCTAssertEqual(cellViewModel.dateText, "7/16/21", "Invalid dateText")
        XCTAssertEqual(cellViewModel.projectText, "EN", "Invalid projectText")
    }
    
    func testMentionInArticleTalk() throws {
        
        let notification = try fetchManagedObject(identifier: "3")
        guard let cellViewModel = NotificationsCenterCellViewModel(notification: notification, languageLinkController: languageLinkController, isEditing: false, configuration: configuration) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        XCTAssertEqual(cellViewModel.headerText, "Section Title", "Invalid headerText")
        XCTAssertEqual(cellViewModel.subheaderText, "From Fred The Bird", "Invalid subheaderText")
        XCTAssertEqual(cellViewModel.bodyText, "Jack The Cat Reply text mention in talk page.")
        XCTAssertEqual(cellViewModel.footerText, "Talk:Blue Bird", "Invalid footerText")
        XCTAssertEqual(cellViewModel.dateText, "3/14/22", "Invalid dateText")
        XCTAssertEqual(cellViewModel.projectText, "TEST", "Invalid projectText")
    }
    
    func testMentionInArticleTalkEditSummary() throws {
        
        let notification = try fetchManagedObject(identifier: "4")
        guard let cellViewModel = NotificationsCenterCellViewModel(notification: notification, languageLinkController: languageLinkController, isEditing: false, configuration: configuration) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        XCTAssertEqual(cellViewModel.headerText, "Mention in edit summary", "Invalid headerText")
        XCTAssertEqual(cellViewModel.subheaderText, "From Fred The Bird", "Invalid subheaderText")
        XCTAssertEqual(cellViewModel.bodyText, "Edit Summary Text User:Jack The Cat")
        XCTAssertEqual(cellViewModel.footerText, "Black Cat", "Invalid footerText")
        XCTAssertEqual(cellViewModel.dateText, "1/6/22", "Invalid dateText")
        XCTAssertEqual(cellViewModel.projectText, "TEST", "Invalid projectText")
    }
    
    func testMentionFailureAnonymous() throws {
        
        let notification = try fetchManagedObject(identifier: "5")
        guard let cellViewModel = NotificationsCenterCellViewModel(notification: notification, languageLinkController: languageLinkController, isEditing: false, configuration: configuration) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        XCTAssertEqual(cellViewModel.headerText, "Failed mention")
        XCTAssertEqual(cellViewModel.subheaderText, "Alert from EN-Wikipedia", "Invalid subheaderText")
        XCTAssertEqual(cellViewModel.bodyText, "Your mention of 47.188.91.144 was not sent because the user is anonymous.")
        XCTAssertEqual(cellViewModel.footerText, "User talk:Fred The Bird", "Invalid footerText")
        XCTAssertEqual(cellViewModel.dateText, "7/16/21", "Invalid dateText")
        XCTAssertEqual(cellViewModel.projectText, "EN", "Invalid projectText")
    }
    
    func testMentionFailureNotFound() throws {
        
        let notification = try fetchManagedObject(identifier: "6")
        guard let cellViewModel = NotificationsCenterCellViewModel(notification: notification, languageLinkController: languageLinkController, isEditing: false, configuration: configuration) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        XCTAssertEqual(cellViewModel.headerText, "Failed mention")
        XCTAssertEqual(cellViewModel.subheaderText, "Alert from TEST-Wikipedia", "Invalid subheaderText")
        XCTAssertEqual(cellViewModel.bodyText, "Your mention of Fredirufjdjd was not sent because the user was not found.")
        XCTAssertEqual(cellViewModel.footerText, "User talk:Jack The Cat", "Invalid footerText")
        XCTAssertEqual(cellViewModel.dateText, "1/6/22", "Invalid dateText")
        XCTAssertEqual(cellViewModel.projectText, "TEST", "Invalid projectText")
    }
    
    func testMentionSuccess() throws {
        
        let notification = try fetchManagedObject(identifier: "7")
        guard let cellViewModel = NotificationsCenterCellViewModel(notification: notification, languageLinkController: languageLinkController, isEditing: false, configuration: configuration) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        XCTAssertEqual(cellViewModel.headerText, "Successful mention")
        XCTAssertEqual(cellViewModel.subheaderText, "Alert from EN-Wikipedia", "Invalid subheaderText")
        XCTAssertEqual(cellViewModel.bodyText, "Your mention of Jack The Cat was sent.")
        XCTAssertEqual(cellViewModel.footerText, "User talk:Fred The Bird", "Invalid footerText")
        XCTAssertEqual(cellViewModel.dateText, "7/16/21", "Invalid dateText")
        XCTAssertEqual(cellViewModel.projectText, "EN", "Invalid projectText")
    }

}
