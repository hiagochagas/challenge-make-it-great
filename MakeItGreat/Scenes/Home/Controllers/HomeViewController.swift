//
//  HomeViewController.swift
//  MakeItGreat
//


import UIKit

class HomeViewController: UIViewController {
    
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
        let row = indexPath?.row ?? 0
        
        if isGhostCell {
            guard let cell = tableView.cellForRow(at: indexPath ?? IndexPath(row: 0, section: 0)) as? TaskCell else { return }
            if isShowingProjects {
                if viewModel.getRelatedProjectFromGhostCell(at: row) == nil {
                    _ = viewModel.createProject(name: cell.taskTextField.text ?? "")
                    tableView.insertRows(at: [IndexPath(row: row+1, section: 0), IndexPath(row: row+2, section: 0)], with: .automatic)

                } else {
                    guard let relatedProject = viewModel.getRelatedProjectFromGhostCell(at: row) else { return }
                    guard let newTask = viewModel.createTask(name: cell.taskTextField.text ?? "") else { return }
                    viewModel.insertTaskToProject(task: newTask, project: relatedProject)
                    tableView.insertRows(at: [IndexPath(row: row+1, section: 0)], with: .automatic)
                }
            } else {
                viewModel.addNewTask(name: cell.taskTextField.text ?? "", to: currentShowingList)
                tableView.insertRows(at: [IndexPath(row: row+1, section: 0)], with: .automatic)
            }
            tableView.reloadData()
        } else {
            guard let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
            if isShowingProjects {
                if viewModel.arrayOfProjectsIndexes.contains(row) {
                    guard let project = viewModel.getProjectFromIndex(row) else {
                        print("Não foi possível pegar projeto através do index.")
                        return
                    }
                    viewModel.updateProject(project: project, name: cell.taskTextField.text ?? "", status: project.status, movedAt: project.movedAt ?? Date(), finishedAt: project.finishedAt ?? Date())
                } else {
                    guard let task = viewModel.getTaskInfoFromProject(at: row) else {
                        print("Não foi possível pegar subtask através do index")
                        return
                    }
                    viewModel.updateTask(task: task, name: cell.taskTextField.text ?? "", finishedAt: task.finishedAt ?? Date(), lastMovedAt: task.lastMovedAt ?? Date(), priority: task.priority, status: task.status)
                }
                
            } else {
                let taskList = viewModel.getTaskList(list: currentShowingList)
                let task = taskList[indexPath.row]
                viewModel.updateTask(task: task, name: cell.taskTextField.text ?? "", finishedAt: task.finishedAt!, lastMovedAt: task.lastMovedAt!, priority: task.priority, status: task.status)
            }
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

        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        let isGhostCell = cell.isGhostCell ?? false
        if isGhostCell {
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
            print("go to bottomsheet")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingProjects {
            return viewModel.getNumberOfCellsFromProjects()
        } else {
            return viewModel.getNumberOfCells(from: currentShowingList)
        }
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
        
        if isShowingProjects {
            let (isGhostCell, isProjectGhostCell) = viewModel.isGhostCellInProject(at: indexPath.row)
            // se for ghost cell da tela de projetos tem uma logica especifica
            if isGhostCell {
                if isProjectGhostCell {
                    cell.type = .normalTask
                    cell.isGhostCell = true
                } else {
                    cell.type = .subtask
                    cell.isGhostCell = true
                }
            // se for uma celula normal, mas da tela de projetos
            } else {
                let projectIndexes = viewModel.arrayOfProjectsIndexes 
                if projectIndexes.contains(indexPath.row) {
                    cell.type = .project
                    let indexOnList = projectIndexes.firstIndex(of: indexPath.row)
                    let projectViewModel = viewModel.sortedProjects?[indexOnList ?? 0]
                    cell.projectInfo = projectViewModel?.project
                } else {
                    cell.type = .subtask
                    cell.taskInfo = viewModel.getTaskInfoFromProject(at: indexPath.row)
                }
            }
            
        } else {
            if viewModel.isGhostCell(list: currentShowingList, at: indexPath.row) {
                cell.isGhostCell = true
                cell.type = .none
            } else {
                cell.type = .normalTask
                cell.taskInfo = viewModel.getTaskList(list: currentShowingList)[indexPath.row]
            }
        }
        
        cell.configCell()
        cell.indexPath = indexPath

        return cell
    }
}

extension HomeViewController: TaskCheckboxDelegate {
    
    func didChangeStateCheckbox(id: UUID?, indexPath: IndexPath?) {
        guard let id = id, let indexPath = indexPath else { return }
        viewModel.toggleTaskById(id: id)
        _ = viewModel.fetchAllTasks()
        contentView.tasksTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func changeCurrentListView(list: EnumLists, shouldShowProjects: Bool) {
        
        self.currentShowingList = list
        self.isShowingProjects = shouldShowProjects
    }
}
