//
//  StateListView.swift
//  PieDistrictDemo
//
//  Created by Anoop on 20/04/18.
//  Copyright © 2018 Anoop. All rights reserved.
//

import UIKit
import CoreData

class StateListView: UIViewController {
    
    var stateArray = [State]() // Contain all state list for reference
    var filteredState = [State]() //Conatain currently listing state list - Asc/Desc order
   
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var stateListTable: UITableView!
    @IBOutlet weak var tableBottomConstraints :NSLayoutConstraint!
    var searchController: UISearchController!
    
    var isAscendingOrder :Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.regisetrForKeyBoardNotification()
        self.setupView()
        //calling the function that will fetch the json
        getJsonFromUrl();
    }
    
    //Function to setup Basic view setup
    func setupView() {
        
        self.stateListTable.tableFooterView = UIView()

        //Navigation title
        self.navigationItem.title = "State"
        
        //create button on right side of navigation bar
        let rightbutton = UIButton.init(type: .custom)
        rightbutton.setImage(UIImage(named: "descending"), for: UIControlState.normal)
        rightbutton.addTarget(self, action: #selector(sortButtonTapped), for: UIControlEvents.touchUpInside)
        rightbutton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let rightbarButton = UIBarButtonItem(customView: rightbutton)
        self.navigationItem.rightBarButtonItem = rightbarButton
        
        //Create button on left side of navigation bar
        let leftButton = UIButton.init(type: .custom)
        leftButton.setImage(UIImage(named: "edit"), for: UIControlState.normal)
        leftButton.addTarget(self, action: #selector(autoComplete), for: UIControlEvents.touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let leftBarbutton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarbutton
        
        //Search Bar controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        stateListTable.tableHeaderView = searchController.searchBar
        
    }
    
    @objc func autoComplete(sender:UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let autoCompleteview = storyBoard.instantiateViewController(withIdentifier: "AutoCompleteView") as! AutoCompleteView
        self.navigationController?.pushViewController(autoCompleteview, animated: true)
    }
    
    
    
    @objc func sortButtonTapped(sender: UIButton) {
        if isAscendingOrder {
            isAscendingOrder = false
            UIView.transition(with: sender as UIView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                sender.setImage(UIImage(named: "ascending"), for: UIControlState.normal)
            }, completion: nil)

            
        }else{
            isAscendingOrder = true
            UIView.transition(with: sender as UIView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                sender.setImage(UIImage(named: "descending"), for: UIControlState.normal)
            }, completion: nil)
        }
        
        self.loadTable()
    }
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        
        NetworkInterface.getListOfState(managedObjectContext: managedObjectContext, completionHandler: { (itemsArray, totalCount , error) in
            
            if let error = error as NSError? {
                print(error.localizedDescription)
                AlertController.showAlertToUser( messageTitle: "Error", message: error.localizedDescription, controller: self)
            }
            
            self.loadTable()
           
        })
    }
    
    func loadTable() {
        self.stateArray = StateListHandler.getAllStateList(isAscending: isAscendingOrder, managedObjectContext: self.managedObjectContext)
        self.filteredState = self.stateArray
        DispatchQueue.main.async {
            self.stateListTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK : - KEYBOARD NOTIFICATION
    func regisetrForKeyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        //Remove all registerd notification from Viewcontroller
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.tableBottomConstraints.constant = -keyboardSize.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.tableBottomConstraints.constant = 0
    }
    
}

//MARK: - TABLE VIEW
extension StateListView : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredState.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
     
        let identifier = "StateListCell"
        var cell: StateListCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? StateListCell
        if cell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? StateListCell
        }
        
        let state = self.filteredState[indexPath.row]
        let nameString = String(format: "%@(%@)", state.name!, state.abbr!)
        cell.nameLbl?.text = nameString
        cell.capitalLbl?.text = state.capital
        cell.cityLbl.text = state.largest_city
        cell.areaLbl.text = state.area
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
}

//MARK: - SEARCH BAR
extension StateListView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            self.filteredState = self.stateArray
        } else {
            // Filter the results
            self.filteredState = self.stateArray.filter { ($0.name?.lowercased().contains(searchController.searchBar.text!.lowercased()))! }
        }
        
        self.stateListTable.reloadData()
    }
}





