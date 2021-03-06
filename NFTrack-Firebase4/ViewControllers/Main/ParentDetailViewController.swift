//
//  ParentDetailViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-06-04.
//
/*
 Abstract:
 Parent view controller for ListDetailViewController and HistoryDetailViewControler
 */

import UIKit
import web3swift
import FirebaseFirestore
import BigInt
import Combine
import CryptoKit

class ParentDetailViewController: UIViewController, SharableDelegate, PostEditDelegate {
    // MARK: - Properties
    var alert: Alerts!
    let transactionService = TransactionService()
    var scrollView: UIScrollView!
    var contractAddress: EthereumAddress!
    var post: Post!
    var pvc: PageViewController<SmallSinglePageViewController<String>>!
    var singlePageVC: SmallSinglePageViewController<String>!
    var usernameContainer: UIView!
    var dateLabel: UILabel!
    var profileImageView: UIImageView!
    var displayNameLabel: UILabel!
    var underLineView: UnderlineView!
    var priceTitleLabel: UILabel!
    var priceLabel: UILabelPadding!
    var descTitleLabel: UILabel!
    var descLabel: UILabelPadding!
    var idTitleLabel: UILabel!
    var idLabel: UILabelPadding!
    var listDetailTitleLabel: UILabel!
    var constraints: [NSLayoutConstraint]!
    var fetchedImage: UIImage!
    var userInfo: UserInfo! {
        didSet {
            userInfoDidSet()
        }
    }
    weak var delegate: RefetchDataDelegate?
    var chatButtonItem: UIBarButtonItem!
    var starButtonItem: UIBarButtonItem!
    var postEditButtonItem: UIBarButtonItem!
    var shareButtonItem: UIBarButtonItem!
    var reportButtonItem: UIBarButtonItem!
    var isSaved: Bool! = false {
        didSet {
            configureBuyerNavigationBar()
        }
    }
    var userId: String! {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
    }
    var imageHeightConstraint: NSLayoutConstraint!
    
    // to refresh after update
    weak var tableViewRefreshDelegate: TableViewRefreshDelegate?
    
    // listing detail
    var listingSpecView: SpecDisplayView!
    lazy var listingDetailArr = [
        SmartContractProperty(propertyName: "Delivery Method", propertyDesc: post.deliveryMethod),
        SmartContractProperty(propertyName: "Payment Method", propertyDesc: post.paymentMethod),
        SmartContractProperty(propertyName: "Sale Format", propertyDesc: post.saleFormat)
    ]
    let LIST_DETAIL_HEIGHT: CGFloat = 50
    var storage = Set<AnyCancellable>()
    var optionsBarItem: UIBarButtonItem!
    private var customNavView: BackgroundView6!
    private var colorPatchView = UIView()
    lazy var colorPatchViewHeight: NSLayoutConstraint = colorPatchView.heightAnchor.constraint(equalToConstant: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        /// UsernameBannerConfigurable
        configureNameDisplay(post: post, v: scrollView) { (profileImageView, displayNameLabel) in
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
            profileImageView.addGestureRecognizer(tap)
            displayNameLabel.addGestureRecognizer(tap)
        }
        fetchUserData(id: post.sellerUserId)
        configureImageDisplay(post: post)
        configureUI()
        setConstraints()
        
        guard let saleType = SaleType(rawValue: post.saleType),
              saleType == SaleType.resale else { return }
        configureResale()
    }
    
    // called when fetchUserData fetched data and assigns it to userInfo
    // modular so that children view controllers can override it
    func userInfoDidSet() {
        processProfileImage()
    }
    
    // Called when the TangibleListEditVC or DigitalListEditVC is finished and popped
    func didUpdatePost(title: String, desc: String, imagesString: [String]?) {
        self.title = title
        descLabel.text = desc
        
        if let imagesString = imagesString,
           imagesString.count > 0,
           let firstImageString = imagesString.first {
            pvc.galleries = imagesString
            singlePageVC = SmallSinglePageViewController(gallery: firstImageString, galleries: imagesString)
            imageHeightConstraint.constant = 250
        } else {
            pvc.galleries?.removeAll()
            //            singlePageVC = nil
            imageHeightConstraint.constant = 0
        }
        
        pvc.setViewControllers([singlePageVC], direction: .forward, animated: false, completion: nil)
        
        // in case TangibleListEditVC gets pushed again
        post.title = title
        post.description = desc
        post.files = imagesString
    }
    
    deinit {
        storage.forEach { $0.cancel() }
        storage.removeAll()
    }
}

extension ParentDetailViewController: UsernameBannerConfigurable {
    // MARK: - configureBackground
    func configureBackground() {
        alert = Alerts()
        constraints = [NSLayoutConstraint]()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .white
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        scrollView.fill()
        
        customNavView = BackgroundView6()
        customNavView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(customNavView)
        
        colorPatchView.backgroundColor = UIColor(red: 25/255, green: 69/255, blue: 107/255, alpha: 1)
        colorPatchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPatchView)
    }
    
    // MARK: - configureUI
    @objc func configureUI() {
        priceTitleLabel = createTitleLabel(text: "Price")
        scrollView.addSubview(priceTitleLabel)
        
        priceLabel = createLabel(text: "\(post.price!) ETH")
        scrollView.addSubview(priceLabel)
        
        descTitleLabel = createTitleLabel(text: "Description")
        scrollView.addSubview(descTitleLabel)
        
        descLabel = createLabel(text: post.description)
        descLabel.lineBreakMode = .byClipping
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        descLabel.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        scrollView.addSubview(descLabel)
        
        idTitleLabel = createTitleLabel(text: "Unique Identifier")
        scrollView.addSubview(idTitleLabel)
        
        idLabel = createLabel(text: post.id)
        idLabel.lineBreakMode = .byClipping
        idLabel.numberOfLines = 0
        idLabel.sizeToFit()
        idLabel.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        scrollView.addSubview(idLabel)
        
        listDetailTitleLabel = createTitleLabel(text: "Listing Detail")
        scrollView.addSubview(listDetailTitleLabel)
        
        listingSpecView = SpecDisplayView(listingDetailArr: listingDetailArr)
        listingSpecView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(listingSpecView)
    }
    
    // MARK: - setConstraints
    @objc func setConstraints() {
        guard let pvc = pvc,
              let pv = pvc.view else { return }
        
        if let files = post.files, files.count > 0 {
            imageHeightConstraint = pv.heightAnchor.constraint(equalToConstant: 250)
        } else {
            imageHeightConstraint = pv.heightAnchor.constraint(equalToConstant: 0)
        }
        
        setNameDisplayConstraints(topView: pv)
        setImageDisplayConstraints(v: scrollView)
        
        constraints.append(contentsOf: [
            customNavView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            customNavView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavView.heightAnchor.constraint(equalToConstant: 50),
            
            colorPatchView.topAnchor.constraint(equalTo: view.topAnchor),
            colorPatchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorPatchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorPatchViewHeight,
            
            priceTitleLabel.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 40),
            priceTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            priceTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            priceTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 0),
            priceLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 50),
            
            descTitleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 40),
            descTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            descTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            
            descLabel.topAnchor.constraint(equalTo: descTitleLabel.bottomAnchor, constant: 10),
            descLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            descLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            idTitleLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 40),
            idTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            idTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            
            idLabel.topAnchor.constraint(equalTo: idTitleLabel.bottomAnchor, constant: 10),
            idLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            idLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            idLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            listDetailTitleLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 40),
            listDetailTitleLabel.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            listDetailTitleLabel.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            
            listingSpecView.topAnchor.constraint(equalTo: listDetailTitleLabel.bottomAnchor, constant: 10),
            listingSpecView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            listingSpecView.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            listingSpecView.heightAnchor.constraint(equalToConstant: CGFloat(listingDetailArr.count) * LIST_DETAIL_HEIGHT),
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
      
    func configureImageDisplay(post: Post) {
        pvc = PageViewController<SmallSinglePageViewController<String>>(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil, galleries: post.files)
        if let files = post.files, files.count > 0 {
            singlePageVC = SmallSinglePageViewController(gallery: files[0], galleries: files)
        } else {
            singlePageVC = SmallSinglePageViewController(gallery: nil, galleries: nil)
        }
        
        pvc.setViewControllers([singlePageVC], direction: .forward, animated: false, completion: nil)
        pvc.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(pvc)
        scrollView.addSubview(pvc.view)
        pvc.didMove(toParent: self)

        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.6)
        pageControl.currentPageIndicatorTintColor = .gray
        pageControl.backgroundColor = .clear
    }
    
    func setImageDisplayConstraints<T: UIView>(v: T, topConstant: CGFloat = 20) {
        constraints.append(contentsOf: [
            imageHeightConstraint,
            pvc.view.topAnchor.constraint(equalTo: v.topAnchor, constant: topConstant),
            pvc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            pvc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer!) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
        
        let tag = sender.view?.tag
        switch tag {
            case 1:
                // tapping on the user profile
                let profileDetailVC = ProfileDetailViewController()
                profileDetailVC.userInfo = userInfo
                self.navigationController?.pushViewController(profileDetailVC, animated: true)
            default:
                break
        }
    }
    
    final func fetchSavedPostData() {
        if let savedBy = post.savedBy, savedBy.contains(userId) {
            isSaved = true
        } else {
            isSaved = false
        }
    }
    
    final func configureBuyerNavigationBar() {
        guard let chatImage = UIImage(systemName: "message"),
              let starImage = UIImage(systemName: "star"),
              let starImageFill = UIImage(systemName: "star.fill"),
              let shareImage = UIImage(systemName: "square.and.arrow.up"),
              let reportImage = UIImage(systemName: "flag") else {
            return
        }
        
        if #available(iOS 14.0, *) {
            let barButtonMenu = UIMenu(title: "", children: [
                UIAction(title: NSLocalizedString("Message", comment: ""), image: chatImage, handler: menuHandler),
                UIAction(title: NSLocalizedString("Save", comment: ""), image: isSaved ? starImageFill : starImage, handler: menuHandler),
                UIAction(title: NSLocalizedString("Share", comment: ""), image: shareImage, handler: menuHandler),
                UIAction(title: NSLocalizedString("Report", comment: ""), image: reportImage, handler: menuHandler),
            ])
            
            let image = UIImage(systemName: "line.horizontal.3.decrease")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            optionsBarItem = UIBarButtonItem(title: nil, image: image, primaryAction: nil, menu: barButtonMenu)
            navigationItem.rightBarButtonItem = optionsBarItem
        } else {
            var buttonItemsArr = [UIBarButtonItem]()
            chatButtonItem = UIBarButtonItem(image: chatImage.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(buttonPressed(_:)))
            chatButtonItem.tag = 6
            buttonItemsArr.append(chatButtonItem)
            
            let finalImage = isSaved ? starImageFill : starImage
            starButtonItem = UIBarButtonItem(image: finalImage.withTintColor(isSaved ? .red : .white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(buttonPressed(_:)))
            starButtonItem.tag = 7
            buttonItemsArr.append(starButtonItem)
            
            shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(buttonPressed(_:)))
            shareButtonItem.tag = 12
            buttonItemsArr.append(shareButtonItem)
            
            reportButtonItem = UIBarButtonItem(image: reportImage.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(buttonPressed(_:)))
            reportButtonItem.tag = 13
            buttonItemsArr.append(reportButtonItem)
            
            self.navigationItem.rightBarButtonItems = buttonItemsArr
        }
    }
    
    // needs a corresponding buttonPressed selector in the subclass
    // for example, the tangible items will assign the tag in ListDetailVC and the digital items in AuctionDetailVC
    // the reason for this is because the tangible items can have their title, description, and the media files modified
    // whereas the digital item can only have their title and the description modified
    // the former will be done in TangibleListEditVC and the latter in DigitalListEditVC
    @objc func configureSellerNavigationBar() {
        // The post edit button should only be allowed up until a buyer purchases the item
        // after which the ability of a seller to edit the post ceases
        // For all the other cases, such as transferring or confirming the receipt of the item, there will only be the share button.
        
        var buttonItemsArr = [UIBarButtonItem]()
        shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(buttonPressed(_:)))
        shareButtonItem.tag = 12
        buttonItemsArr.append(shareButtonItem)
        
        self.navigationItem.rightBarButtonItems = buttonItemsArr
    }
    
    @objc func menuHandler(action: UIAction) {
        switch action.title {
            case "Message":
                navToChatVC()
                break
            case "Save":
                savePost()
                break
            case "Share":
                sharePost()
                break
            case "Report":
                navToReport()
                break
            default:
                break
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
            case 6:
                navToChatVC()
                break
            case 7:
                savePost()
                break
            case 12:
                sharePost()
                break
            case 13:
                navToReport()
                break
            default:
                break
        }
    }
    
    private func navToChatVC() {
        Future<String, PostingError> { [weak self] promise in
            self?.getDocId(promise)
        }
        .sink { [weak self] (completion) in
            switch completion {
                case .failure(.generalError(reason: let err)):
                    self?.alert.showDetail("Error", with: err, for: self)
                case .finished:
                    break
                default:
                    self?.alert.showDetail("Error", with: "There was an error generating a chat ID.", for: self)
            }
        } receiveValue: { [weak self] (docId) in
            let chatVC = ChatViewController()
            // the name of the item to be displayed on ChatListVC as well as be used as a search term.
            chatVC.itemName = self?.post.title
            chatVC.userInfo = self?.userInfo
            // docId is the chat's unique ID
            chatVC.docId = docId
            // The unique ID of the posting so that when ChatVC is pushed from ChatListVC, the ChatListVC can push ReportVC
            chatVC.postingId = self?.post.documentId
            self?.navigationController?.pushViewController(chatVC, animated: true)
        }
        .store(in: &storage)
    }
    
    private func getDocId(_ promise: @escaping (Result<String, PostingError>) -> Void) {
        guard let sellerUid = userInfo.uid,
              let buyerUid = userId else {
            promise(.failure(.generalError(reason: "You're currently not logged in. Please log in and try again.")))
            return
        }
        
        let combinedString = sellerUid + buyerUid + post.documentId
        let inputData = Data(combinedString.utf8)
        let hashedId = SHA256.hash(data: inputData)
        let hashString = hashedId.compactMap { String(format: "%02x", $0) }.joined()
        promise(.success(hashString))
    }
    
    private func savePost() {
        // saving the favourite post
        isSaved = !isSaved
        FirebaseService.shared.db.collection("post").document(post.documentId).updateData([
            "savedBy": isSaved ? FieldValue.arrayUnion(["\(userId!)"]) : FieldValue.arrayRemove(["\(userId!)"])
        ]) {(error) in
            if let error = error {
                self.alert.showDetail("Sorry", with: error.localizedDescription, for: self) { [weak self] in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                } completion: {}
            } else {
//                self.delegate?.didFetchData()
            }
        }
    }
    
    private func sharePost() {
        guard let title = title,
              let itemDescription = descLabel?.text else { return }
        
        var objectsToShare: [AnyObject] = [
            "\(title)\n" as AnyObject,
            itemDescription as AnyObject
        ]
        
        showSpinner { [weak self] in
            guard let self = self else { return }
            Just(objectsToShare)
                .setFailureType(to: PostingError.self)
                .flatMap { (data) -> AnyPublisher<Data, PostingError> in
                    if let files = self.post.files, files.count > 0 {
                        return Future<Data, PostingError> { promise in
                            FirebaseService.shared.downloadURL(urlString: files[0], promise: promise)
                        }
                        .eraseToAnyPublisher()
                    } else {
                        return Result.Publisher(Data()).eraseToAnyPublisher()
                    }
                }
                .sink { (completion) in
                    switch completion {
                        case .failure(let error):
                            self.alert.showDetail("Image Share Error", with: error.localizedDescription, for: self)
                        case .finished:
                            break
                    }
                } receiveValue: { (imageData) in
                    if let image = UIImage(data: imageData) {
                        objectsToShare.append(image as AnyObject)
                    }
                    
                    self.hideSpinner {
//                        let shareSheetVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                        self.present(shareSheetVC, animated: true, completion: nil)
//                        
//                        if let pop = shareSheetVC.popoverPresentationController {
//                            pop.sourceView = self.view
//                            pop.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
//                            pop.permittedArrowDirections = []
//                        }
                        self.share(objectsToShare)
                    }
                }
                .store(in: &self.storage)
        }
    }
    
    private func navToReport() {
        let reportVC = ReportViewController()
        reportVC.post = post
        reportVC.userId = userId
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    
    // For resale, certain motifications have to be made i.e. make mintHash untappable
    @objc func configureResale() {
        
    }
}

//extension ParentDetailViewController {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let gallery = (viewController as! ImagePageViewController).gallery, var index = galleries.firstIndex(of: gallery) else { return nil }
//        index -= 1
//        if index < 0 {
//            return nil
//        }
//        
//        return ImagePageViewController(gallery: galleries[index])
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let gallery = (viewController as! ImagePageViewController).gallery, var index = galleries.firstIndex(of: gallery) else { return nil }
//        index += 1
//        if index >= galleries.count {
//            return nil
//        }
//        
//        return ImagePageViewController(gallery: galleries[index])
//    }
//    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return self.galleries.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let page = pageViewController.viewControllers![0] as! ImagePageViewController
//        
//        if let gallery = page.gallery {
//            return self.galleries.firstIndex(of: gallery)!
//        } else {
//            return 0
//        }
//    }
//}

extension ParentDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if -scrollView.contentOffset.y > 0 {
            colorPatchViewHeight.constant = -scrollView.contentOffset.y
        }
    }
}

// 20.8769

let eventABI = """
        [
        {
        "indexed": true,
        "internalType": "address",
        "name": "from",
        "type": "address"
        },
        {
        "indexed": true,
        "internalType": "address",
        "name": "to",
        "type": "address"
        },
        {
        "indexed": true,
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
        }
        ]
        """
