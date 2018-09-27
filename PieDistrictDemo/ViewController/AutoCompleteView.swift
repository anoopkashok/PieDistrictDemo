//
//  AutoCompleteView.swift
//  PieDistrictDemo
//
//  Created by Anoop on 21/04/18.
//  Copyright © 2018 Anoop. All rights reserved.
//

import UIKit
import CoreData

class AutoCompleteView: UIViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBOutlet weak var autoComplteField: UITextField!
    var autoCompletionPossibilities = [String]()// String array to hold the name of state
    
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoCompletionPossibilities = StateListHandler.getStateNameArray(managedObjectContext: managedObjectContext)
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    func setupView()  {
        //Navigation title
        self.navigationItem.title = "Autocomplete"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AutoCompleteView: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string)
        subString = formatSubstring(subString: subString)
        if subString.count == 0 { // when a user clears the textField
            resetValues()
        } else {
            searchAutocompleteEntriesWIthSubstring(substring: subString)
        }
        return true
    }
    
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized
        return formatted
    }
    
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring)//Holding matching state name
        
        if suggestions.count > 0 {
            //set the textfiled to text as first object from suggesion array, after properly formating color
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions)
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery)
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
            })
        } else {
            //If no match found set textfiled text to user typed text
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                self.autoComplteField.text = substring
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    //This function return an array of string based on user text input
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        for item in autoCompletionPossibilities {
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.autoComplteField.attributedText = colouredString
    }
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.autoComplteField.position(from: self.autoComplteField.beginningOfDocument, offset: userQuery.count) {
            self.autoComplteField.selectedTextRange = self.autoComplteField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = autoComplteField.selectedTextRange
        autoComplteField.offset(from: autoComplteField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        autoComplteField.text = ""
    }
    
}
