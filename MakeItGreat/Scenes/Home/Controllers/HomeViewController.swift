//
//  HomeViewController.swift
//  MakeItGreat
//


import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel
    weak var homeCoordinator: HomeCoordinator?
    let contentView = HomeView()
    var mockDataSource: [(String, Bool, UUID)] = []
    
    init(viewModel: HomeViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        mockDataSourceFunction()
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
    
    private func mockDataSourceFunction() {
        mockDataSource = [("Oi hahah", false, UUID()), ("Leticia ne?", false, UUID()), ("Sou um meme", false, UUID()), ("PindaMONHA GA-BA", false,UUID())]
    }
    
    private func returnFromEditingModeAction() {
        let tableView = contentView.tasksTableView
        if mockDataSource.count == tableView.numberOfRows(inSection: 0) - 1 {
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: mockDataSource.count, section: 0)) as? TaskCell else { return }
            
            mockDataSource.append((cell.taskLabel.text ?? "", false, UUID()))
            
            
            
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
        
        guard indexPath.row != mockDataSource.count else { return nil }
        
        let infoAction = UIContextualAction(style: .normal, title: "Info") { (action, view, completionHandler) in
            
            view.backgroundColor = .infoActionBackground
            
            //open bottomsheet through coordinator
            print("go to bottomsheet")
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            view.backgroundColor = .deleteActionBackground
            
            //delete task from core data through viewModel
            
            self.mockDataSource.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
}


// MARK: TableView DataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockDataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier) as? TaskCell else {
            return TaskCell()
        }
        cell.returnFromEditingModeAction = returnFromEditingModeAction
        cell.taskDelegate = self
        if indexPath.row == mockDataSource.count {
            cell.configureAsGhostCell()
        } else {
            cell.isChecked = mockDataSource[indexPath.row].1
            cell.configureAsNormalTaskCell()
            cell.id = mockDataSource[indexPath.row].2
            cell.taskLabel.text = mockDataSource[indexPath.row].0
        }
        
        return cell
    }
}

extension HomeViewController: TaskCheckboxDelegate {
    
    func didChangeStateCheckbox(to state: Bool?, id: UUID?) {
        
        let state = state ?? false
        var cell = mockDataSource.filter({
            $0.2 == id
        })
        
        cell[0].1 = state
        print(cell[0])
    }
}
