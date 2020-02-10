//
//  MutableCollection+Extensions.swift
//  BensinPriser
//
//  Created by Andrian Sergheev on 2020-02-10.
//  Copyright © 2020 Andrian Sergheev. All rights reserved.
//

import Foundation

extension MutableCollection {
	mutating func mutateEach(_ body: (inout Element) throws -> Void) rethrows {
		for index in self.indices {
			try body(&self[index])
		}
	}
}
