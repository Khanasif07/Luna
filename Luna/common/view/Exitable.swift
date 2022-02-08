//
//  Exitable.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import Foundation
import Combine

protocol Exitable {
    var exiting: PassthroughSubject<Void, Never> { get }
}
