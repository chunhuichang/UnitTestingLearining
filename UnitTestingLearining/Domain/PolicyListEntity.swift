//
//  PolicyListEntity.swift
//  UnitTestingLearining
//
//  Created by 00767160 on 2022/4/6.
//

import Foundation

public struct PolicyListEntity{
    public init(policy_no: String, policy_name: String, policy_time: Date) {
        self.policy_no = policy_no
        self.policy_name = policy_name
        self.policy_time = policy_time
    }
    public var policy_no: String
    public var policy_name: String
    public var policy_time: Date
}
