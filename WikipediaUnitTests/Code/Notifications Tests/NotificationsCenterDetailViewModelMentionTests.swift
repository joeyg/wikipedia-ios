
import XCTest
@testable import Wikipedia

class NotificationsCenterDetailViewModelMentionTests: NotificationsCenterViewModelTests {

    override var dataFileName: String {
        get {
            return "notifications-wikipedia-mentions"
        }
    }
    
    func testMentionOnUserTalk() throws {
        
        let notification = try fetchManagedObject(identifier: "1")
        
        guard let project = RemoteNotificationsProject(apiIdentifier: notification.wiki!, languageLinkController: languageLinkController) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        let commonViewModel = NotificationsCenterCommonViewModel(configuration: configuration, notification: notification, project: project)
        let detailViewModel = NotificationsCenterDetailViewModel(commonViewModel: commonViewModel)
        
        XCTAssertEqual(detailViewModel.headerImageName, "notifications-type-mention", "Invalid headerImageName")
        XCTAssertEqual(detailViewModel.headerTitle, "From Fred The Bird", "Invalid headerTitle")
        XCTAssertEqual(detailViewModel.headerSubtitle, "On English Wikipedia", "Invalid headerSubtitle")
        XCTAssertEqual(detailViewModel.headerDate, "7/16/21", "Invalid headerDate")
        XCTAssertEqual(detailViewModel.contentTitle, "Section Title", "Invalid contentTitle")
        XCTAssertEqual(detailViewModel.contentBody, "Reply text mention in talk page User:Jack The Cat", "Invalid contentBody")
    }
    
    func testMentionInUserTalkEditSummary() throws {
        
        let notification = try fetchManagedObject(identifier: "2")
        
        guard let project = RemoteNotificationsProject(apiIdentifier: notification.wiki!, languageLinkController: languageLinkController) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        let commonViewModel = NotificationsCenterCommonViewModel(configuration: configuration, notification: notification, project: project)
        let detailViewModel = NotificationsCenterDetailViewModel(commonViewModel: commonViewModel)
        
        XCTAssertEqual(detailViewModel.headerImageName, "notifications-type-mention", "Invalid headerImageName")
        XCTAssertEqual(detailViewModel.headerTitle, "From Fred The Bird", "Invalid headerTitle")
        XCTAssertEqual(detailViewModel.headerSubtitle, "On English Wikipedia", "Invalid headerSubtitle")
        XCTAssertEqual(detailViewModel.headerDate, "7/16/21", "Invalid headerDate")
        XCTAssertEqual(detailViewModel.contentTitle, "Mention in edit summary", "Invalid contentTitle")
        XCTAssertEqual(detailViewModel.contentBody, "Edit Summary Text: User:Jack The Cat", "Invalid contentBody")
    }
    
    func testMentionInArticleTalk() throws {
        
        let notification = try fetchManagedObject(identifier: "3")
        
        guard let project = RemoteNotificationsProject(apiIdentifier: notification.wiki!, languageLinkController: languageLinkController) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        let commonViewModel = NotificationsCenterCommonViewModel(configuration: configuration, notification: notification, project: project)
        let detailViewModel = NotificationsCenterDetailViewModel(commonViewModel: commonViewModel)
        
        XCTAssertEqual(detailViewModel.headerImageName, "notifications-type-mention", "Invalid headerImageName")
        XCTAssertEqual(detailViewModel.headerTitle, "From Fred The Bird", "Invalid headerTitle")
        XCTAssertEqual(detailViewModel.headerSubtitle, "On Test Wikipedia", "Invalid headerSubtitle")
        XCTAssertEqual(detailViewModel.headerDate, "3/14/22", "Invalid headerDate")
        XCTAssertEqual(detailViewModel.contentTitle, "Section Title", "Invalid contentTitle")
        XCTAssertEqual(detailViewModel.contentBody, "Jack The Cat Reply text mention in talk page.", "Invalid contentBody")
    }
    
    func testMentionInArticleTalkEditSummary() throws {
        
        let notification = try fetchManagedObject(identifier: "4")
        
        guard let project = RemoteNotificationsProject(apiIdentifier: notification.wiki!, languageLinkController: languageLinkController) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        let commonViewModel = NotificationsCenterCommonViewModel(configuration: configuration, notification: notification, project: project)
        let detailViewModel = NotificationsCenterDetailViewModel(commonViewModel: commonViewModel)

        XCTAssertEqual(detailViewModel.headerImageName, "notifications-type-mention", "Invalid headerImageName")
        XCTAssertEqual(detailViewModel.headerTitle, "From Fred The Bird", "Invalid headerTitle")
        XCTAssertEqual(detailViewModel.headerSubtitle, "On Test Wikipedia", "Invalid headerSubtitle")
        XCTAssertEqual(detailViewModel.headerDate, "1/6/22", "Invalid headerDate")
        XCTAssertEqual(detailViewModel.contentTitle, "Mention in edit summary", "Invalid contentTitle")
        XCTAssertEqual(detailViewModel.contentBody, "Edit Summary Text User:Jack The Cat", "Invalid contentBody")
    }
    
    func testMentionFailureAnonymous() throws {
        
        let notification = try fetchManagedObject(identifier: "5")
        
        guard let project = RemoteNotificationsProject(apiIdentifier: notification.wiki!, languageLinkController: languageLinkController) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        let commonViewModel = NotificationsCenterCommonViewModel(configuration: configuration, notification: notification, project: project)
        let detailViewModel = NotificationsCenterDetailViewModel(commonViewModel: commonViewModel)

        XCTAssertEqual(detailViewModel.headerImageName, "notifications-type-mention", "Invalid headerImageName")
        XCTAssertEqual(detailViewModel.headerTitle, "Mentions", "Invalid headerTitle")
        XCTAssertEqual(detailViewModel.headerSubtitle, "On English Wikipedia", "Invalid headerSubtitle")
        XCTAssertEqual(detailViewModel.headerDate, "7/16/21", "Invalid headerDate")
        XCTAssertEqual(detailViewModel.contentTitle, "Failed mention", "Invalid contentTitle")
        XCTAssertEqual(detailViewModel.contentBody, "Your mention of 47.188.91.144 was not sent because the user is anonymous.", "Invalid contentBody")
    }
    
    func testMentionFailureNotFound() throws {
        
        let notification = try fetchManagedObject(identifier: "6")
        
        guard let project = RemoteNotificationsProject(apiIdentifier: notification.wiki!, languageLinkController: languageLinkController) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        let commonViewModel = NotificationsCenterCommonViewModel(configuration: configuration, notification: notification, project: project)
        let detailViewModel = NotificationsCenterDetailViewModel(commonViewModel: commonViewModel)
        
        XCTAssertEqual(detailViewModel.headerImageName, "notifications-type-mention", "Invalid headerImageName")
        XCTAssertEqual(detailViewModel.headerTitle, "Mentions", "Invalid headerTitle")
        XCTAssertEqual(detailViewModel.headerSubtitle, "On Test Wikipedia", "Invalid headerSubtitle")
        XCTAssertEqual(detailViewModel.headerDate, "1/6/22", "Invalid headerDate")
        XCTAssertEqual(detailViewModel.contentTitle, "Failed mention", "Invalid contentTitle")
        XCTAssertEqual(detailViewModel.contentBody, "Your mention of Fredirufjdjd was not sent because the user was not found.", "Invalid contentBody")
    }
    
    func testMentionSuccess() throws {
        
        let notification = try fetchManagedObject(identifier: "7")
        
        guard let project = RemoteNotificationsProject(apiIdentifier: notification.wiki!, languageLinkController: languageLinkController) else {
            throw TestError.failureConvertingManagedObjectToViewModel
        }
        
        let commonViewModel = NotificationsCenterCommonViewModel(configuration: configuration, notification: notification, project: project)
        let detailViewModel = NotificationsCenterDetailViewModel(commonViewModel: commonViewModel)
        
        XCTAssertEqual(detailViewModel.headerImageName, "notifications-type-mention", "Invalid headerImageName")
        XCTAssertEqual(detailViewModel.headerTitle, "Mentions", "Invalid headerTitle")
        XCTAssertEqual(detailViewModel.headerSubtitle, "On English Wikipedia", "Invalid headerSubtitle")
        XCTAssertEqual(detailViewModel.headerDate, "7/16/21", "Invalid headerDate")
        XCTAssertEqual(detailViewModel.contentTitle, "Successful mention", "Invalid contentTitle")
        XCTAssertEqual(detailViewModel.contentBody, "Your mention of Jack The Cat was sent.", "Invalid contentBody")
    }
}
