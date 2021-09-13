//
//  ParentListViewController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-06-09.
//

/*
 Abstract:
 ParentVC for all view controllers that require asynchronous data fetch, such as image fetching or pdf file fetching, for table view controllers.
 The table view cell has to be subclassed.
 The data store, which houses the entirety of the large size or remote data that need to be fetched, need to be subclassed to suit the type of data that are to be fetched
 ParentVC for view controllers like MainDetailVC, ProfileListVC and ListVC.
 MainDetailVC fetches data according to the category passed on from MainVC.
 ListVC fetches data according to the segmented switch.
 */

import UIKit
import FirebaseFirestore

protocol DataStoreDelegate: AnyObject {
    associatedtype T
    func setDataStore(postArr: [T])
}

class ParentListViewController<T>: UIViewController, TableViewConfigurable, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching, TableViewRefreshDelegate {
    var dataStore: ImageDataStore<T>!
    var loadingQueue = OperationQueue()
    var loadingOperations = [IndexPath : DataLoadOperation]()
    let refreshControl = UIRefreshControl()
    var alert: Alerts!
    var postArr = [T]() {
        didSet {
            setDataStore(postArr: postArr)
        }
    }
    var tableView: UITableView!
    var userId: String! {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
    }
    var firstListener: ListenerRegistration!
    var nextListener: ListenerRegistration!
    var lastSnapshot: QueryDocumentSnapshot!
    let PAGINATION_LIMIT: Int = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        detachListeners()
    }
    
    func setDataStore(postArr: [T]) {
        dataStore = ImageDataStore(posts: postArr)
    }
    
    func detachListeners() {
        if isMovingToParent {
            if firstListener != nil {
                firstListener.remove()
            }
            
            if nextListener != nil {
                nextListener.remove()
            }
        }
    }
    
    // MARK: - configureUI
    func configureUI() {
        view.backgroundColor = .white
        alert = Alerts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParentTableCell<T>.identifier) as? ParentTableCell<T> else {
            fatalError("Sorry, could not load cell")
        }
        cell.selectionStyle = .none
        let post = postArr[indexPath.row]
        cell.updateAppearanceFor(.pending(post))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ParentTableCell<T> else { return }
                
        // How should the operation update the cell once the data has been loaded?
        let updateCellClosure: (UIImage?) -> () = { [weak self] (image) in
            print("updateCellClosure")
            cell.updateAppearanceFor(.fetched(image))
            guard let self = self else { return }
            self.loadingOperations.removeValue(forKey: indexPath)
        }
        
        // Try to find an existing data loader
        if let dataLoader = loadingOperations[indexPath] {
            // Has the data already been loaded?
            if let image = dataLoader.image {
                cell.updateAppearanceFor(.fetched(image))
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                // No data loaded yet, so add the completion closure to update the cell once the data arrives
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            // Need to create a data loaded for this index path
            if let dataLoader = dataStore.loadImage(at: indexPath.row) {
                // Provide the completion closure, and kick off the loading operation
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    // 1. The entire data is loaded to the data store
    // 2. For every cell, prefetch the Operation that pertains to indexPath.row
    // 3. Add the operation to the loading queue (addOperation)
    // 4. Add the opertaion to the loadingOperation dictionary
    // 5. If the data has been loaded already, delete it form the loadingOperations queue
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // If there's a data loader for this index path we don't need it any more. Cancel and dispose
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    // MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    // MARK:- TableView Prefetching DataSource
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] { return }
            if let dataLoader = dataStore.loadImage(at: indexPath.row) {
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
    
    // MARK: - didRefreshTableView
    @objc func didRefreshTableView(index: Int = 0) {}
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 10.0
        if y > (h + reload_distance) {
            guard self.postArr.count > 0 else { return }
            executeAfterDragging()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    func executeAfterDragging() {}
}
