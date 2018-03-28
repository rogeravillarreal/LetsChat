//
//  ChatViewController.swift
//  LetsChat
//
//  Created by Roger Villarreal on 2/7/18.
//  Copyright © 2018 Roger Alexander. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // message array
    var messageArray: [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextField.delegate = self
        
        // Set up Gesture Recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        // Register Cell
        messageTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
    }
    
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! MessageTableViewCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUserName.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUserName.text == Auth.auth().currentUser?.email as! String {
            // messages we send
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120
    }
    
    // Mark: - Gesture Rcognizer
    @objc func tableViewTapped() {
        print("you have tapped out of the text field!")
        messageTextField.endEditing(true)
    }
    
    // MARK: - TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("user is typing...")
        
        UIView.animate(withDuration: 0.25) {
            self.heightConstraint.constant = 345
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Send & Receive Firebase
    @IBAction func sendPressed(_ sender: Any) {
        messageTextField.endEditing(true)
        
        // disable textfield and button so user cant keep pressing send
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        // create FireBase Database
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email  , "MessageBody": messageTextField.text!]
        
        // create a custom random key for our message so they can be saved under thier wone unique identifier.
        // save messages to the databaser under a unique identifier
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil {
                print(error)
            } else {
                print("Message saved successfully")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
    // TODO: - Create retreive method
    func retrieveMessages() {
        // look into the databse
        let messagesDB = Database.database().reference().child("Messages")
        
        // observe to see if there are added messages to database
        messagesDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        // log out the user and send them to the Welcome screen
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print("there is an error!")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
