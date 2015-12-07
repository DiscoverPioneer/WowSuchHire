//
//  AddQuoteView.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 12/6/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

protocol AddQuoteViewDelegate  {
    func addQuoteViewDidBeginEditing(addQuoteView: AddQuoteView)
    func addQuoteViewDidEndEditing(addQuoteView: AddQuoteView)
    func addQuoteViewAddedQuote(quote: Quote)
    func addQuoteViewFailedToAddQuote(quote: Quote)
}

class AddQuoteView: UIView, UITextFieldDelegate {

    var delegate: AddQuoteViewDelegate?
    @IBOutlet weak var textField: BorderTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.cyanColor()
        let textField = BorderTextField(frame: CGRectMake(5,0,frame.width - 50, frame.height - 10))
        textField.delegate = self
        textField.placeholder = "Add your #SquadGoal"
        addSubview(textField)
        self.textField = textField
        
        let addButton = UIButton(frame: CGRectMake(frame.width - 50,0, 50, frame.height))
        addButton.setTitle("Add", forState: .Normal)
        addButton.addTarget(self, action: "addButtonAction:", forControlEvents: .TouchUpInside)
        addSubview(addButton)
        
    }
    
    @IBAction func addButtonAction(sender: AnyObject) {
        if let text = textField.text where !textField.isEmpty() {
            textField.resignFirstResponder()
            NetworkClient().addQuote(text, completion: { (success, quote) -> Void in
                if success {
                    self.delegate?.addQuoteViewAddedQuote(quote)
                    self.textField.text = ""
                } else {
                    self.delegate?.addQuoteViewFailedToAddQuote(quote)
                }
            })
        }
    }
    
    //MARK: - Delegate Functions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.addQuoteViewDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.addQuoteViewDidEndEditing(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
