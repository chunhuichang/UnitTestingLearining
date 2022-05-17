//
//  Box.swift
//  CathayLifeAT
//
//  Created by i9400516 on 2019/6/17.
//  Copyright © 2019 CathayLife. All rights reserved.
//

public class Box<T> {
    public typealias LinsterType = (_ newValue: T?, _ oldValue: T?) -> Void

    var eventListeners: [LinsterType] = []

    public var value: T? = nil {
        didSet {
            self.execute(newValue: value, oldValue: oldValue)
        }
    }

    init(_ value: T?, listener: [LinsterType]? = nil) {

        self.value = value
        self.eventListeners = listener ?? []
    }

    deinit {
        // CSRPrint.info("CSRSaveBoxing<\(type(of: value))> deinit)")
    }

    // MARK: 單一binding
    public func binding(trigger: Bool = true, _ index: Int? = nil, listener: @escaping LinsterType) {
        self.appendingBinding(trigger: trigger, index: index, listener: listener)
    }

    private func appendingBinding(trigger: Bool = true, index: Int? = nil, listener: @escaping LinsterType) {
        if let index = index, index < self.eventListeners.count {
            self.eventListeners.insert(listener, at: index)
        } else {
            self.eventListeners.append(listener)
        }

        if trigger {
            listener(self.value, self.value)
        }
    }

    func removeAllBinding() {
        self.eventListeners.removeAll()
    }

    private func execute(newValue: T?, oldValue: T?) {
        for listener in self.eventListeners {
            listener(newValue, oldValue)
        }
    }
}
