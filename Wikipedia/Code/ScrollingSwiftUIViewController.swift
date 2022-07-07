import UIKit
import SwiftUI

class NavigationBarHiddenUIHostingController<Content: View>: UIHostingController<Content> {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

/// Allows the use of a limited amount of scrolling SwiftUI, embedded within a UIScrollView.
/// This subclasses ViewController so that we can continue to use our custom navigation bar setup
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHostingScrollView()
        setupHostingController()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.isBarHidingEnabled = true
        
        self.view.backgroundColor = theme.colors.paperBackground
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
