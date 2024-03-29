//
//  BrowseMediatingController.swift
//  ComicFans
//
//  Created by Andrew Masters on 11/6/23.
//

import UIKit

protocol BrowseDelegate {
    func browseViewDidLoad(_ vc: BrowseDisplayable)
    func browseCollectionViewCellTapped(dataSet: DataSet, attribution: String?)
    func browseDownloadMoreData(_ vc: BrowseDisplayable, searchText: String?, offset: Int)
}

protocol BrowseDisplayable: UIViewLoading, BrowseCollectionViewDelegate, ProcessingView, ErrorAlert {
    func appendToBrowseCollectionViewData(_ data: [DataSet])
    func updateAttributionText(_ text: String?)
    func collectionViewCellTapped(dataSet: DataSet)
}

protocol BrowseCollectionViewDelegate {
    func collectionViewCellTapped(dataSet: DataSet)
    func collectionViewContinueDownload(offset: Int)
}

final class BrowseMediatingController: UIViewController, PadConstraints {
    
    @IBOutlet private (set) var searchbar: UISearchBar!
    @IBOutlet private (set) var browseContentView: UIStackView!
    @IBOutlet private (set) var attributionLabel: UILabel!
    @IBOutlet private (set) var singleViewButton: UIButton!
    @IBOutlet private (set) var multiViewButton: UIButton!
    @IBOutlet var padConstraints: [NSLayoutConstraint] = []
    
    private var delegate: BrowseDelegate?
    private var screenTitle: String
    private var displayIsSingleView: Bool = true

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
        self.setupSearchBar()
        self.setupCollectionview()
        self.view.backgroundColor = .darkBlue()
        self.navigationItem.title = self.screenTitle
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.singleViewButton.tintColor = .offWhite()
        self.multiViewButton.tintColor = .offWhite()
        self.delegate?.browseViewDidLoad(self)
        self.setPadConstraints(size: self.view.frame.size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupSearchBar() {
        self.searchbar.delegate = self
        self.searchbar.tintColor = .white
        self.searchbar.overrideUserInterfaceStyle = .dark
    }
    
    private func setupCollectionview() {
        let collectionview = BrowseCollectionView(browseDelegate: self)
        collectionview.backgroundColor = .clear
        self.browseContentView.addArrangedSubview(collectionview)
    }
    
    @IBAction func didTouchSingleViewButton(_ sender: UIButton) {
        guard self.displayIsSingleView == false else { return }
        if let collectionview = browseContentView.subviews.first(where: { $0 is BrowseCollectionView }) as? BrowseCollectionView {
            collectionview.setCollectionViewLayout(UICollectionPageLayout.createLayout(), animated: true)
            self.displayIsSingleView.toggle()
        }
    }
    
    @IBAction func didTouchMultiViewButton(_ sender: UIButton) {
        guard self.displayIsSingleView else { return }
        if let collectionview = browseContentView.subviews.first(where: { $0 is BrowseCollectionView }) as? BrowseCollectionView {
            collectionview.setCollectionViewLayout(UICollectionPageLayout.createFlowLayout(), animated: true)
            self.displayIsSingleView.toggle()
        }
    }
    
    func setBrowseCollectionViewData(_ data: [DataSet]) {
        if let collectionview = browseContentView.subviews.first(where: { $0 is BrowseCollectionView }) as? BrowseCollectionView {
            collectionview.browseData = data
            collectionview.reloadData()
        }
    }
}

extension BrowseMediatingController: BrowseDisplayable {
    func appendToBrowseCollectionViewData(_ data: [DataSet]) {
        if let collectionview = browseContentView.subviews.first(where: { $0 is BrowseCollectionView }) as? BrowseCollectionView {
            collectionview.browseData.append(contentsOf: data)
            collectionview.reloadData()
        }
    }
    
    func collectionViewContinueDownload(offset: Int) {
        self.delegate?.browseDownloadMoreData(self, searchText: self.searchbar.text, offset: offset)
    }
    
    func updateAttributionText(_ text: String?) {
        self.attributionLabel.text = text
    }
    
    func collectionViewCellTapped(dataSet: DataSet) {
        self.delegate?.browseCollectionViewCellTapped(dataSet: dataSet, attribution: self.attributionLabel.text)
    }
    
    func beginProcessing() {
        self.beginProcessing(self.view)
    }
    
    func finishProcessing() {
        self.finishProcessing(self.view)
    }
}

extension BrowseMediatingController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        self.setBrowseCollectionViewData([])
        self.delegate?.browseDownloadMoreData(self, searchText: searchText, offset: 0)
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
