import UIKit
import SwiftUI
import WMF

extension Notification.Name {
     static let textfieldDidBeginEditing = Notification.Name("textfieldDidBeginEditing")
     static let textfieldDidEndEditing = Notification.Name("textfieldDidEndEditing")
}

class NavigationBarHiddenUIHostingController<Content: View>: UIHostingController<Content> {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

/// Allows the use of a limited amount of scrolling SwiftUI, embedded within a UIScrollView.
/// This subclasses ViewController so that we can continue to use our custom navigation bar setup
/// TODO: Make generic so any SwiftUI view can use
/// TODO: make keyboard handling opt-in
@objc(WMFScrollingSwiftUIViewController) class ScrollingSwiftUIViewController: ViewController {
    
    lazy var hostingScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var hostingController: UIHostingController<ApplePayContentView> = {
        var contentView = ApplePayContentView()
        let hostingController = NavigationBarHiddenUIHostingController(rootView: contentView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    
    private lazy var doneButton = UIBarButtonItem(title: CommonStrings.doneTitle, style: .done, target: self, action: #selector(tappedDone))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHostingScrollView()
        setupHostingController()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = theme.colors.paperBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(textfieldDidBeginEditing), name: .textfieldDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textfieldDidEndEditing), name: .textfieldDidEndEditing, object: nil)
        
        // TODO: localize, pass in
        self.title = "Donate"
        
        navigationBar.isBarHidingEnabled = false
        
        // SAMPLE CODE DEMONSTRATING A HEADER VIEW
//        if let headerView = TalkPageHeaderView.wmf_viewFromClassNib() {
//
//            let viewModel = TalkPageHeaderView.ViewModel(header: "Header", title: "Title", info: "Info", intro: "Intro")
//
//            headerView.configure(viewModel: viewModel)
//
//            navigationBar.isBarHidingEnabled = false
//            navigationBar.isUnderBarViewHidingEnabled = true
//            navigationBar.allowsUnderbarHitsFallThrough = true
//            useNavigationBarVisibleHeightForScrollViewInsets = true
//            navigationBar.addUnderNavigationBarView(headerView)
//            navigationBar.underBarViewPercentHiddenForShowingTitle = 0.6
//            navigationBar.title = "Donate"
//
//            updateScrollViewInsets()
//        }
    }
    
    @objc func textfieldDidBeginEditing() {
        navigationItem.rightBarButtonItem = doneButton
        navigationBar.updateNavigationItems()
    }
    
    @objc func textfieldDidEndEditing() {
        navigationItem.rightBarButtonItem = nil
        navigationBar.updateNavigationItems()
    }
    
    @objc func tappedDone() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func setupHostingScrollView() {
        
        view.addSubview(hostingScrollView)
        let topConstraint = hostingScrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomConstraint = hostingScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leadingConstraint = hostingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = hostingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        
        // view.wmf_addSubviewWithConstraintsToEdges(hostingScrollView)
        self.scrollView = hostingScrollView
    }
    
    func setupHostingController() {
        addChild(hostingController)
        
        hostingScrollView.wmf_addSubviewWithConstraintsToEdges(hostingController.view)
        let hostingWidth = hostingController.view.widthAnchor.constraint(equalTo: hostingScrollView.widthAnchor)
        
        hostingScrollView.addConstraint(hostingWidth)
        hostingController.didMove(toParent: self)
    }
        
}
