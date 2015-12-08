//
//  MainViewController.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 12/5/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchResultsUpdating ,UISearchBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var loaded = false
    private var isSearching = false
    private var isSearchingOnline = false
    private var searchArray = [Quote]()
    var quoteArray = [Quote]()
    private var refreshControl = UIRefreshControl()
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "#SquadGoals"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !loaded {
            loaded = true
            setupView()
            fetchQuotes()
        }
    }
    
    private func setupView() {
        let tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        view.addSubview(tableView)
        self.tableView = tableView
        
        let nibName = UINib(nibName: "QuoteCellTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        let nibName2 = UINib(nibName: "QuotePhotoTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName2, forCellReuseIdentifier: "PhotoCell")
        
        refreshControl.addTarget(self, action: "fetchQuotes", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonAction:"), animated: true)
    }
    
    func fetchQuotes() {
        NetworkClient().fetchAllQuotes { (quotes) -> Void in
            if let quotes = quotes {
                self.refreshControl.endRefreshing()
                self.quoteArray = quotes
                self.tableView.reloadData()
            }
        }
    }
    
    func addButtonAction(sender: AnyObject) {
        //Add Photo
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let photoAction = UIAlertAction(title: "Choose an existing photo", style: .Default) {
            alert  in
            self.getImageFromSource(.PhotoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take a photo", style: .Default) {
            alert in
            self.getImageFromSource(.Camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            alert in
        }
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
        optionMenu.addAction(cancelAction)
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func getImageFromSource(source:UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = false
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentViewController(imagePicker, animated: true, completion: nil)
            })
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(false, completion: nil)
        NetworkClient().addImage(image) { (success, quote) -> Void in
            if let quote = quote {
                self.quoteArray.append(quote)
                self.tableView.reloadData()
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //MARK: - SearchBar
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        isSearching = true
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        if searchBar.text?.characters.count != 0 {
            isSearching = true
        } else {
            isSearching = false
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let text = searchBar.text {
            //Perform Search
            searchArray = findQuotesWithText(text)
            tableView.reloadData()
        }
    }
    
    func findQuotesWithText(text: String) -> [Quote] {
        var filteredArray = [Quote]()
        for quote in quoteArray {
            if quote.quoteString?.containsString(text) == true {
                filteredArray.append(quote)
            }
        }
        return filteredArray
    }
}

//MARK: - TableView DataSource 

extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchArray.count + 1
        }
        return quoteArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var quote: Quote!
        
        if isSearching {
            return setQuoteCellForIndexPath(indexPath)
        } else {
            quote = quoteArray[indexPath.row]
        }
        
        if quote.hasPhoto {
            return setQuotePhotoForIndexPath(indexPath)
        } else {
            return setQuoteCellForIndexPath(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = AddQuoteView(frame: CGRectMake(0, 0, tableView.frame.size.width, 60))
        footerView.delegate = self
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !isSearching
    }
    
    private func setQuoteCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! QuoteCellTableViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        if isSearching {
            if indexPath.row == searchArray.count {
                cell.quoteTextLabel.text = isSearchingOnline ? "Search Locally": "Search Database"
                cell.backgroundColor = UIColor.redColor()
            } else {
                let quote = searchArray[indexPath.row]
                cell.quoteTextLabel.text = quote.squadQuote
            }
        } else {
            let quote = quoteArray[indexPath.row]
            cell.quoteTextLabel.text = quote.squadQuote
        }
        return cell
    }
    
    private func setQuotePhotoForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! QuotePhotoTableViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        let quote = quoteArray[indexPath.row]
        cell.quotePhotoView.image = nil
        quote.photo { (photo) -> Void in
            cell.quotePhotoView.image = photo
        }
        return cell
    }
}

//MARK: - TableView Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let searchText = searchController.searchBar.text
            where isSearching && indexPath.row == searchArray.count {
                //Search Local
                if isSearchingOnline {
                    searchArray = findQuotesWithText(searchText)
                    tableView.reloadData()
                    isSearchingOnline = false
                    return
                }
                //Search online
                NetworkClient().searchForQuote(searchText, completion: { (success, quotes) -> Void in
                    if success {
                        self.searchArray = quotes
                        self.tableView.reloadData()
                        self.isSearchingOnline = true
                    }
                })
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let quote = quoteArray[indexPath.row]
            quoteArray.removeAtIndex(indexPath.row)
            NetworkClient().deleteQuote(quote, completion: { (success) -> Void in
                
            })
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}

//MARK: - AddQuoteView Delegate

extension MainViewController: AddQuoteViewDelegate {
    func addQuoteViewDidBeginEditing(addQuoteView: AddQuoteView) {
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let point = CGPointMake(0, addQuoteView.frame.origin.y - navigationBarHeight)
        tableView.setContentOffset(point, animated: true)
    }
    
    func addQuoteViewDidEndEditing(addQuoteView: AddQuoteView) {
        let numberOfSections = tableView.numberOfSections
        let numberOfRows = tableView.numberOfRowsInSection(numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }
    
    func addQuoteViewAddedQuote(quote: Quote) {
        quoteArray.append(quote)
        tableView.reloadData()
    }
    
    func addQuoteViewFailedToAddQuote(quote: Quote) {
        
    }
}

