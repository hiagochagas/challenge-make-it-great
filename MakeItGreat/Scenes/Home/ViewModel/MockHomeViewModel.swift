//
//  MockHomeViewModel.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 26/11/20.
//

import Foundation

class MockHomeViewModel {
    private(set) var mockDataSource: [(String, Bool, UUID)] = []
    
    init() {
        mockDataSourceFunction()
    }
    
    func deleteTask(at index: Int) {
        mockDataSource.remove(at: index)
    }
    
    func addNewTask(description: String) {
        mockDataSource.append((description, false, UUID()))
    }
    
    func toggleTaskById(id: UUID) {
        for (index, task) in mockDataSource.enumerated() {
            if task.2 == id {
                changeTaskState(at: index)
            }
        }
    }
    
    func changeTaskState(at index: Int) {
        mockDataSource[index].1.toggle()
    }
    
    func getNumberOfCells() -> Int {
        return mockDataSource.count + 1
    }
    
    func getTaskInfo(at index: Int) -> (String, Bool, UUID){
        return mockDataSource[index]
    }
    
    func getLastCellIndexPath() -> IndexPath {
        return IndexPath(row: mockDataSource.count, section: 0)
    }
    
    func isGhostCell(at index: Int) -> Bool {
        if index == mockDataSource.count {
            return true
        }
        return false
    }
    
    private func mockDataSourceFunction() {
        mockDataSource = [("Teste... 1, 2, 3", false, UUID())]
    }
}
