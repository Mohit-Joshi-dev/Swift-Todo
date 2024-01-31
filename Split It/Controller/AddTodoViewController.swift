//
//  ResultViewController.swift
//  Split It
//
//  Created by Mohit Joshi on 16/01/24.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var desTextfield: UITextField!
 
    let todoManager = TodoManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate=self
        desTextfield.delegate=self
    }
    
    @IBAction func onTapNext(_ sender: UIButton) {
        
        if let text = textfield.text {
            if !text.isEmpty {
                let date = Date.now.timeIntervalSince1970
                todoManager.addTodo(todo: Todo( name: text, des: desTextfield.text ?? "", date: date, isCompleted: false
                                              ))
                
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func backButtonTap(
        _ sender: UIButton
    ) {
        self.dismiss(
            animated: true
        )
    }
}

extension AddTodoViewController: UITextFieldDelegate{
    
}
