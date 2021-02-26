//
//  DisposeBag.swift
//  PokeMaster
//
//  Created by captain on 2021/2/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

typealias SpinLock = NSRecursiveLock

public final class CancelBag {
    private let _lock = SpinLock()
    
    private var _cancellables = [AnyCancellable]()
    private var _isCanceled = false
    
    /// 插入
    public func insert(_ cancellable: AnyCancellable) {
        self._insert(cancellable)?.cancel()
    }
    
    private func _insert(_ cancellable: AnyCancellable) -> AnyCancellable? {
        self._lock.lock(); defer { self._lock.unlock() }
        if self._isCanceled {
            return cancellable
        }
        
        self._cancellables.append(cancellable)
        
        return nil
    }
    
    /// 释放
    private func cancel() {
        let oldCancellables = self._cancel()
        
        for cancellable in oldCancellables {
            cancellable.cancel()
        }
    }
    
    private func _cancel() -> [AnyCancellable] {
        self._lock.lock(); defer { self._lock.unlock()}
        
        let cancellables = self._cancellables
        
        self._cancellables.removeAll(keepingCapacity: false)
        self._isCanceled = true
        
        return cancellables
    }
    
    deinit {
        self.cancel()
    }
}

extension AnyCancellable {
    public func cancel(by bag: CancelBag) {
        bag.insert(self)
    }
}
