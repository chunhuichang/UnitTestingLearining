//
//  PolicyListViewModel.swift
//  UnitTestingLearining
//
//  Created by 00767160 on 2022/4/6.
//

import Foundation

//input
public protocol PolicyListViewInput {
    
    //refresh
    var loadItemsFeedsTrigger: Box<Void>{get}
    // FIXME: for test
    var dispatchGroupTrigger: Box<Void>{get}
}
// Output
public protocol PolicyListViewOutput {
    var dataItems: Box<[PolicyListCellViewModel]>{get}
    var alertMsg: Box<(String, String)> { get }
    
}
/// Manager
public protocol PolicyListViewManager {
    /// Input
    var input: PolicyListViewInput { get }
    /// Output
    var output: PolicyListViewOutput { get }
}

public class PolicyListViewModel:PolicyListViewManager, PolicyListViewInput, PolicyListViewOutput{
    
    deinit{
//        print("PolicyListViewModel deinit")
    }
    
    public var loadItemsFeedsTrigger: Box<Void> = Box(nil)
    // FIXME: for test
    public var dispatchGroupTrigger: Box<Void> = Box(nil)
    
    public var dataItems: Box<[PolicyListCellViewModel]> = Box([])
    public var alertMsg: Box<(String, String)> = Box(("", ""))
    
    
    public var input: PolicyListViewInput{
        return self
    }
    
    public var output: PolicyListViewOutput{
        return self
    }
        
    
    private var dependency: PolicyListUseCase
    
    public init(dependency: PolicyListUseCase){
        self.dependency = dependency
        
        self.initializeActions()
    }
    
}

extension PolicyListViewModel{
    private func initializeActions(){
        loadItemsFeedsTrigger.binding(trigger: false) { [weak self] newValue, oldValue in
            guard let self = self else { return }
            self.dependency.retrievePolicyListData { result in
                switch result{
                case .success(let entity):
                    self.dataItems.value = [PolicyListCellViewModel(policy_name: entity.policy_name)]
                case.failure(let error):
                    self.alertMsg.value = ("警告", error.localizedDescription)
                }
            }
        }
        
        // FIXME: for test
        dispatchGroupTrigger.binding(trigger: false) { [weak self] newValue, oldValue in
            guard let self = self else { return }
            
            let dispatchGroup = DispatchGroup()
            for i in 1...3 {
                dispatchGroup.enter()
                Thread.sleep(forTimeInterval: TimeInterval(i))
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.alertMsg.value = ("dispatchGroupTrigger", "")
            }
        }
    }
}
