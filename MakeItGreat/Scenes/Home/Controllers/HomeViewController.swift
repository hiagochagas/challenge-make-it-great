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
    weak var homeCoordinator: HomeCoordinator?
    
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
    
    override func loadView() {
        
        view = contentView
        contentView.delegate = self
    }
    
    func setupTableView() {
        
        contentView.tasksTableView.delegate = self
        contentView.tasksTableView.dataSource = self
        
        contentView.tasksTableView.layer.cornerRadius = 10
    }
    

    
    private func returnFromEditingModeAction(_ state: Bool?, indexPath: IndexPath?) {
        let tableView = contentView.tasksTableView
        
        let isGhostCell = state ?? false
        
        if isGhostCell {
            guard let cell = tableView.cellForRow(at: viewModel.getLastCellIndexPath(list: currentShowingList)) as? TaskCell else { return }
            viewModel.addNewTask(name: cell.taskTextField.text ?? "", to: currentShowingList)
            tableView.insertRows(at: [viewModel.getLastCellIndexPath(list: currentShowingList)], with: .automatic)
            tableView.reloadData()
        } else {
            guard let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
            let taskList = viewModel.getTaskList(list: currentShowingList)
            let task = taskList[indexPath.row]
            viewModel.updateTask(task: task, name: cell.taskTextField.text ?? "", finishedAt: task.finishedAt!, lastMovedAt: task.lastMovedAt!, priority: task.priority, status: task.status)
            tableView.reloadData()
        }
    }
}

// MARK: TableView Delegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0)-1 {
            guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
            cell.configureAsNormalTaskCell()
            cell.taskLabel.isHidden = true
            cell.taskTextField.isHidden = false
            cell.taskTextField.becomeFirstResponder()
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
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            view.backgroundColor = .deleteActionBackground
            
            //delete task from core data through viewModel
            
            self.viewModel.deleteTask(at: indexPath.row, from: self.currentShowingList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
}


// MARK: TableView DataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isShowingProjects {
            return viewModel.sortedProjects?.count ?? 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfCells(from: currentShowingList)
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
        if viewModel.isGhostCell(list: currentShowingList, at: indexPath.row){
            cell.isGhostCell = true
            cell.configureAsGhostCell()
        } else {
            cell.taskInfo = viewModel.getTaskList(list: currentShowingList)[indexPath.row]
            cell.configureAsNormalTaskCell()
        }
        cell.indexPath = indexPath

        return cell
    }
}

extension HomeViewController: TaskCheckboxDelegate {
    
    func didChangeStateCheckbox(id: UUID?) {
        guard let id = id else { return }
        viewModel.toggleTaskById(id: id)
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func changeCurrentListView(list: EnumLists, shouldShowProjects: Bool) {
        
        self.currentShowingList = list
        self.isShowingProjects = shouldShowProjects
    }
}
