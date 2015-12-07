//
//  MainViewController.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 12/5/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var loaded = false
    private var quoteArray = [Quote]()
    private var refreshControl = UIRefreshControl()

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
        view.addSubview(tableView)
        self.tableView = tableView
        
        let nibName = UINib(nibName: "QuoteCellTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        refreshControl.addTarget(self, action: "fetchQuotes", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)

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
}

//MARK: - TableView DataSource 

extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! QuoteCellTableViewCell
        let quote = quoteArray[indexPath.row]
        cell.quoteTextLabel.text = quote.quoteString
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = AddQuoteView(frame: CGRectMake(0, 0, tableView.frame.size.width, 60))
        
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
}

//MARK: - TableView Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

