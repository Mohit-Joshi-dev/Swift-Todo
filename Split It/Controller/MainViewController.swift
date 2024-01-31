//
//  ViewController.swift
//  Split It
//
//  Created by Mohit Joshi on 15/01/24.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bar: UIProgressView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let todoManager = TodoManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "ResuableCell")
        
        todoManager.delegate = self
        todoManager.getTodos()
        
        loader.hidesWhenStopped = true
        loader.startAnimating()
        emptyLabel.isHidden = true
    }
}

extension MainViewController: TodoManagerDelegate{
    
    func didReceiveData(data: [Todo]) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.tableView.reloadData()
            if data.isEmpty {
                self.bar.progress = 0
                self.emptyLabel.isHidden = false
                self.tableView.isHidden = true
            }
            else{
                let completed = data.filter { todo in
                    todo.isCompleted == true
                }
                let progress = Float(completed.count) / Float(data.count)
                self.bar.progress = progress
                self.emptyLabel.isHidden = true
                self.tableView.isHidden = false
            }
            self.loader.stopAnimating()
        }
    }
    
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate, TodoCellDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 82
        let HELVETICA_REGULAR_17 = UIFont(name: "Helvetica", size: 17)!
        let des = todoManager.todos[indexPath.row].des
        let height = des.height(withConstrainedWidth: screenWidth , font: HELVETICA_REGULAR_17)
        return height + 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResuableCell", for: indexPath) as! TodoCell
        cell.delegate = self
        let todo = todoManager.todos[indexPath.row]
        cell.updateTodo(todo: todo)
        return cell
    }
    
    func onTapComplete(_ cell: TodoCell, id : String) {
        todoManager.markCompleted(id: id)
    }
    
    func onTapDelete(_ cell: TodoCell, id: String) {
        todoManager.deleteTodo(id: id)
    }
}

extension UIViewController {
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        navigationItem.backButtonDisplayMode = .minimal
        return super.awakeAfter(using: coder)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }
 
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
 
        return ceil(boundingBox.width)
    }
    
    func strikeThrough() -> NSAttributedString {
            let attributeString =  NSAttributedString(
                string: self,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            return attributeString
        }
}
