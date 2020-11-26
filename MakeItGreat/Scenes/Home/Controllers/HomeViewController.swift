//
//  HomeViewController.swift
//  MakeItGreat
//


import UIKit

class HomeViewController: UIViewController {
    
    //var viewModel: HomeViewModel
    var viewModel: MockHomeViewModel
    weak var homeCoordinator: HomeCoordinator?
    let contentView = HomeView()
    
    init(viewModel: MockHomeViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    func setupTableView() {
        contentView.tasksTableView.delegate = self
        contentView.tasksTableView.dataSource = self
    }
    

    
    private func returnFromEditingModeAction(_ state: Bool?) {
        let tableView = contentView.tasksTableView
        
        guard let cell = tableView.cellForRow(at: viewModel.getLastCellIndexPath()) as? TaskCell else { return }
        
        let isGhostCell = state ?? false
        
        if isGhostCell {
            viewModel.addNewTask(description: cell.taskTextField.text ?? "")
            tableView.insertRows(at: [viewModel.getLastCellIndexPath()], with: .automatic)
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
        
        guard !(viewModel.isGhostCell(at: indexPath.row)) else { return nil }
        
        let infoAction = UIContextualAction(style: .normal, title: "Info") { (action, view, completionHandler) in
            
            view.backgroundColor = .infoActionBackground
            
            //open bottomsheet through coordinator
            print("go to bottomsheet")
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            view.backgroundColor = .deleteActionBackground
            
            //delete task from core data through viewModel
            
            self.viewModel.deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
}


// MARK: TableView DataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier) as? TaskCell else {
            return TaskCell()
        }
        cell.returnFromEditingModeAction = returnFromEditingModeAction
        cell.taskDelegate = self
        if viewModel.isGhostCell(at: indexPath.row){
            cell.isGhostCell = true
            cell.configureAsGhostCell()
        } else {
            cell.taskInfo = viewModel.getTaskInfo(at: indexPath.row)
            cell.configureAsNormalTaskCell()
        }
        
        return cell
    }
}

extension HomeViewController: TaskCheckboxDelegate {
    
    func didChangeStateCheckbox(id: UUID?) {
        guard let id = id else { return }
        viewModel.toggleTaskById(id: id)
    }
}
