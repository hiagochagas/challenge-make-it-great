//
//  HomeViewController.swift
//  MakeItGreat
//


import UIKit

class HomeViewController: UIViewController, ModalHandler {
    
    func modalDismissed() {
        self.dismiss(animated: true, completion: nil)
        contentView.tasksTableView.reloadData()
    }
    
    
    var viewModel: HomeViewModel
    var homeCoordinator: HomeCoordinator?
    
    // Should change with each touch on lists menu cells
    var currentShowingList: EnumLists = .Inbox {
        
        didSet {
            contentView.tasksTableView.reloadData()
        }
    }
    
    // Change when tapping another list
    var isShowingProjects: Bool = false {
        didSet {
            contentView.tasksTableView.reloadData()
        }
    }

    let contentView = HomeView()
    
    init(viewModel: HomeViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverForKeyboard()
        
    }
    
    private func addObserverForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func loadView() {
        
        view = contentView
        contentView.delegate = self
        getUserNotificationAuthorization()
    }
    
    func setupTableView() {
        
        contentView.tasksTableView.delegate = self
        contentView.tasksTableView.dataSource = self
        
        contentView.tasksTableView.layer.cornerRadius = 10
    }
    

    
    private func returnFromEditingModeAction(_ state: Bool?, indexPath: IndexPath?, type: CellType?) {
        let tableView = contentView.tasksTableView
        
        let isGhostCell = state ?? false
        let row = indexPath?.row ?? 0
        
        if isGhostCell {
            guard let cell = tableView.cellForRow(at: indexPath ?? IndexPath(row: 0, section: 0)) as? TaskCell else { return }
                viewModel.addNewTask(name: cell.taskTextField.text ?? "", to: currentShowingList)
                tableView.insertRows(at: [IndexPath(row: row+1, section: 0)], with: .automatic)
            
        } else {
            
            guard let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
            let taskList = viewModel.getTaskList(list: currentShowingList)
            let task = taskList[indexPath.row]
            

            viewModel.updateTask(task: task,
                                 name: cell.taskTextField.text ?? "",
                                 finishedAt: task.finishedAt!,
                                 lastMovedAt: task.lastMovedAt!,
                                 priority: task.priority,
                                 status: task.status)

        }
        
        tableView.reloadData()
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.contentView.tasksTableView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        contentView.tasksTableView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        contentView.tasksTableView.contentInset = contentInset
    }
}

// MARK: TableView Delegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        let isGhostCell = cell.isGhostCell ?? false
        
        if isGhostCell {
            
            cell.configureAsNormalTaskCell()
            cell.taskLabel.isHidden = true
            cell.taskTextField.isHidden = false
            cell.taskTextField.becomeFirstResponder()
            
        } else {
            
            cell.taskLabel.isHidden = true
            cell.taskTextField.isHidden = false
            cell.taskTextField.text = cell.taskLabel.text
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    //swipe actions: information and delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard !(viewModel.isGhostCell(list: currentShowingList, at: indexPath.row)) else { return nil }
        
        let infoAction = UIContextualAction(style: .normal, title: "Info") { (action, view, completionHandler) in
            
            view.backgroundColor = .infoActionBackground
            
            //open bottomsheet through coordinator
//            print("go to bottomsheet")
//            test
            let controller = HomeViewModel()
            let tasks = controller.getTaskList(list: self.currentShowingList)
            let modalViewController = BottomSheetViewController()
            modalViewController.task = tasks[indexPath.row]
            modalViewController.delegate = self
            modalViewController.modalPresentationStyle = .overCurrentContext
            self.present(modalViewController, animated: true, completion: nil)

        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completionHandler) in
            
            view.backgroundColor = .deleteActionBackground
            
            //delete task from core data through viewModel
            viewModel.deleteTask(at: indexPath.row, from: self.currentShowingList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
}


// MARK: TableView DataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCells(from: currentShowingList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TaskCell
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier) as? TaskCell {
            cell = dequeue
        } else {
            cell = TaskCell()
        }
        cell.taskDelegate = self
        cell.returnFromEditingModeAction = returnFromEditingModeAction

        if viewModel.isGhostCell(list: currentShowingList, at: indexPath.row) {
            cell.isGhostCell = true
            cell.type = .none
        } else {
            if isShowingProjects {
                cell.type = .project
            } else {
                cell.type = .normalTask
            }
            cell.taskInfo = viewModel.getTaskList(list: currentShowingList)[indexPath.row]
            if cell.taskInfo?.priority == 1 {
                        cell.setTaskCellPriorityColor(priority: .low)
                    } else if cell.taskInfo?.priority == 2 {
                        cell.setTaskCellPriorityColor(priority: .medium)
                    } else if cell.taskInfo?.priority == 3 {
                        cell.setTaskCellPriorityColor(priority: .high)
                    } else {
                        cell.setTaskCellPriorityColor(priority: .none)
                    }
        }
        
        cell.configCell()
        cell.indexPath = indexPath

        return cell
    }
    
    func deleteRowAt(_ indexPath: IndexPath?, id: UUID?) {
        guard let id = id, let indexPath = indexPath else { return }
        self.contentView.tasksTableView.beginUpdates()
        viewModel.toggleTaskById(id: id)
        contentView.tasksTableView.deleteRows(at: [indexPath], with: .fade)
        self.contentView.tasksTableView.endUpdates()
        contentView.tasksTableView.reloadData()
    }
}

extension HomeViewController: TaskCheckboxDelegate {
    
    func didChangeStateCheckbox(id: UUID?, indexPath: IndexPath?) {
        deleteRowAt(indexPath, id: id)
        homeCoordinator?.reloadCalendarUponCompletingTask()
        homeCoordinator?.reloadBadgesDataUponCompletingTask()
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func changeCurrentListView(list: EnumLists, shouldShowProjects: Bool) {
        
        self.currentShowingList = list
        self.isShowingProjects = shouldShowProjects
    }
}

