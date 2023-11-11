//
//  BrowseMediatingController.swift
//  ComicFans
//
//  Created by Andrew Masters on 11/6/23.
//

import UIKit

protocol BrowseDelegate {
    func browseViewDidLoad(_ vc: any BrowseDisplayable, offset: Int)
}

protocol BrowseDisplayable: BrowseCollectionViewDelegate {
    func updateBrowseCollectionView(browseArray: [DataSetProtocol])
    func updateAttributionText(_ text: String?)
    func setupCollectionview()
    func setupTableview()
}

protocol BrowseCollectionViewDelegate {
}

final class BrowseMediatingController: UIViewController {
    
    @IBOutlet private (set) var searchbar: UISearchBar!
    @IBOutlet private (set) var browseContentView: UIStackView!
    @IBOutlet private (set) var attributionLabel: UILabel!
    
    private var delegate: BrowseDelegate?
    private var screenTitle: String

    init(delegate: BrowseDelegate?, screenTitle: String) {
        self.delegate = delegate
        self.screenTitle = screenTitle
        super.init(nibName: "BrowseMediatingController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.screenTitle
        self.delegate?.browseViewDidLoad(self, offset: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension BrowseMediatingController: BrowseDisplayable {
    func setupCollectionview() {
        let collectionview = BrowseCollectionView(browseDelegate: self)
        self.browseContentView.addArrangedSubview(collectionview)
    }
    
    func setupTableview() {
        // TODO: setup tableview
    }
    
    func updateBrowseCollectionView(browseArray: [DataSetProtocol]) {
        if let collectionview = browseContentView.subviews.first(where: { $0 is BrowseCollectionView }) as? BrowseCollectionView {
            collectionview.browseData = browseArray
            collectionview.reloadData()
        }
    }
    
    func updateAttributionText(_ text: String?) {
        self.attributionLabel.text = text
    }
}
