//
//  Setupable.swift
//  Navigation
//
//  Created by pumbaaflag on 24.02.2023.
//

import Foundation

protocol ViewModelProtocol {}

protocol Setupable { // MODEL
    func setup(with viewModel: ViewModelProtocol)
}
