
import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var des: UILabel!
    
    var delegate: TodoCellDelegate?
    var id : String?
  
    func updateTodo(todo: Todo) {
        id = todo.id
        title.text = todo.name
        des.text = todo.des
        if todo.isCompleted {
            title.textColor = .red
        }else {
            title.textColor = .blue
        }
    }
   
    @IBAction func onComplete(_ sender: UIButton) {
        if let currentId = id {
            delegate?.onTapComplete(self, id: currentId)
        }
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        if let currentId = id {
            delegate?.onTapDelete(self, id: currentId)
        }
    }
}

protocol TodoCellDelegate {
    func onTapComplete(_ cell: TodoCell, id : String)
    
    func onTapDelete(_ cell: TodoCell, id : String)
}
