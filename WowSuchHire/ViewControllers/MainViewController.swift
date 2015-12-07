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
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    private func fetchQuotes() {
        NetworkClient().fetchAllQuotes { (quotes) -> Void in
            if let quotes = quotes {
                self.quoteArray = quotes
                self.tableView.reloadData()
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

