//
//  PolicyListViewModelTests.swift
//  UnitTestingLeariningTests
//
//  Created by Jill Chang on 2022/5/17.
//

import XCTest
import Quick
import Nimble
import UnitTestingLearining

class PolicyListViewModelTests: QuickSpec {
    // 假UseCase
    class MockPolicyUseCase: PolicyListUseCase {
        func retrievePolicyListData(with completion: @escaping (Result<PolicyListEntity, Error>) -> Void) {
            guard let result = fetchResult else {
                completion(.failure(SomeError.bad("load data error")))
                return
            }
            self.fetchResults.append(result)
            completion(result)
        }
        
        // 傳入需要驗的結果
        var fetchResult: Result<PolicyListEntity, Error>?
        // 呼叫次數
        var fetchResults: [Result<PolicyListEntity, Error>] = []
    }
    
    private func makeSUT(useCase: MockPolicyUseCase) -> PolicyListViewModel {
        return PolicyListViewModel(dependency: useCase)
    }
    
    public override func spec() {
        describe("保單清單_ViewModel") {
            var sut: PolicyListViewModel!
            var usecase: MockPolicyUseCase!
            
            // 每次測試前都清空sut
            beforeEach {
                usecase = MockPolicyUseCase()
                sut = nil
            }
            
            context("讀取保單清單") {
                it("成功獲取清單") {
                    // Given Arrange
                    // 建立預設要回傳的entity
                    let predicateEntity = PolicyListEntity(policy_no: "987654321", policy_name: "VM", policy_time: Date())
                    // 指定回傳成功
                    usecase.fetchResult = .success(predicateEntity)
                    sut = self.makeSUT(useCase: usecase)
                    
                    // output
                    sut.output.dataItems.binding(trigger: false) { [weak usecase] newValue, _ in
                        // Then Assert
                        // 接收回傳entity與預設entity比對
                        if let entity = newValue {
                            expect(entity.count) == 1
                            expect(usecase?.fetchResults.count) == 1
                            if let item = entity.first {
                                expect(item.policy_name) == predicateEntity.policy_name
                            } else {
                                XCTFail("resultData is empty")
                            }
                        } else {
                            XCTFail("resultData is nil")
                        }
                    }
                    
                    // When Action input
                    sut.input.loadItemsFeedsTrigger.value = ()
                }
                
                it("獲取清單失敗") {
                    // Given Arrange
                    // 指定回傳失敗
                    let predicateError: Error = SomeError.bad("network bad")
                    usecase.fetchResult = .failure(predicateError)
                    sut = self.makeSUT(useCase: usecase)
                    
                    // output
                    sut.output.alertMsg.binding(trigger: false) { [weak usecase] newValue, _ in
                        // Then Assert
                        if let alertMsg = newValue {
                            expect(alertMsg.0) == "警告"
                            expect(alertMsg.1) == predicateError.localizedDescription
                            print(predicateError.localizedDescription)
                            expect(usecase?.fetchResults.count) == 1
                        } else {
                            XCTFail("alertMsg is nil")
                        }
                    }
                    
                    // When Action input
                    sut.input.loadItemsFeedsTrigger.value = ()
                }
                
                it("非同步測試") {
                    // Given Arrange
                    // 指定回傳失敗
                    let predicateError: Error = SomeError.bad("network bad")
                    usecase.fetchResult = .failure(predicateError)
                    sut = self.makeSUT(useCase: usecase)
                    
                    // output
                    sut.output.alertMsg.binding(trigger: false) { newValue, _ in
                        // Then Assert
                        if let alertMsg = newValue {
                            expect(alertMsg.0) == "dispatchGroupTrigger"
                            expect(alertMsg.0).toEventually(equal("dispatchGroupTrigger"))
                        } else {
                            XCTFail("alertMsg is nil")
                        }
                    }
                    
                    // When Action input
                    sut.input.dispatchGroupTrigger.value = ()
                }
            }
        }
    }
}

