//
//  PolicyListUseCaseTests.swift
//  UnitTestingLeariningTests
//
//  Created by Jill Chang on 2022/5/17.
//

import XCTest
import Quick
import Nimble
import UnitTestingLearining

enum SomeError: Swift.Error {
    case bad(String)
    case nomal
}

public class PolicyListUseCaseTests: QuickSpec {
    private class MockPolicyListRepository: PolicyListRepository {
        // 假Repository
        func retrievePolicyListData(with completion: @escaping (Result<PolicyListEntity, Error>) -> Void) {
            guard let result = self.loadDataResult else {
                completion(.failure(SomeError.bad("load data error")))
                return
            }
            completion(result)
        }
        
        var loadDataResult: Result<PolicyListEntity, Error>?
    }
    
    // 建立測試實體
    private func makeSUT(repo: MockPolicyListRepository) -> PolicyListMainUseCase {
        return PolicyListMainUseCase(repository: repo)
    }
    
    public override func spec() {
        describe("保單清單_UseCase") {
            var sut: PolicyListUseCase!
            var repository: MockPolicyListRepository!
            
            // 每次測試前都清空sut
            beforeEach {
                repository = MockPolicyListRepository()
                sut = nil
            }
            
            // method
            context("讀取保單清單") {
                it("成功獲取清單") { // 正向
                    // Arrange ( Given)
                    // 建立預設要回傳的entity
                    let predicateEntity = PolicyListEntity(policy_no: "1234567", policy_name: "test Name", policy_time: Date())
                    // 指定回傳成功
                    repository.loadDataResult = .success(predicateEntity)
                    sut = self.makeSUT(repo: repository)
                    
                    // Action (When)
                    sut.retrievePolicyListData { result in
                        // Assert (Then)
                        switch result {
                        case .success(let entity):
                            expect(entity.policy_no) == predicateEntity.policy_no
                            expect(entity.policy_name) == predicateEntity.policy_name
                            expect(entity.policy_time) == predicateEntity.policy_time
                            
                        case .failure:
                            XCTFail("測試獲取清單失敗")
                        }
                    }
                }
                
                it("獲取清單失敗") {
                    // Arrange ( Given)
                    // 指定回傳失敗
                    let predicateError: Error = SomeError.bad("network bad")
                    repository.loadDataResult = .failure(predicateError)
                    sut = self.makeSUT(repo: repository)
                    
                    // Action (When)
                    sut.retrievePolicyListData { result in
                        // Assert (Then)
                        switch result {
                        case .success:
                            XCTFail("測試獲取清單失敗")
                            
                        case .failure(let error):
                            expect(error).to(matchError(predicateError))
                        }
                    }
                }
            }
        }
    }
}
