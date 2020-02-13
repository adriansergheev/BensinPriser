//
//  TimeLogger.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-02-12.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import Foundation

final class TimeLogger: TextOutputStream {

	private var previous = Date()
	private let formatter = NumberFormatter()

	init() {
		formatter.maximumFractionDigits = 5
		formatter.minimumFractionDigits = 5
	}

	func write(_ string: String) {
		let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return }
		let now = Date()
		print("Thread: \(Thread.current.threadName) | +\(formatter.string(for: now.timeIntervalSince(previous))!)s: \(string)")
		previous = now
	}
}

extension Thread {
    var threadName: String {
        if let currentOperationQueue = OperationQueue.current?.name {
            return "OperationQueue: \(currentOperationQueue)"
        } else if let underlyingDispatchQueue = OperationQueue.current?.underlyingQueue?.label {
            return "DispatchQueue: \(underlyingDispatchQueue)"
        } else {
            let name = __dispatch_queue_get_label(nil)
            return String(cString: name, encoding: .utf8) ?? Thread.current.description
        }
    }
}
