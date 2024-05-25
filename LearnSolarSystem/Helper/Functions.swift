//
//  Functions.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 20/05/24.
//

import Foundation

struct Functions {
    static func getRandomInclusive(lowerBound: Int, upperbound: Int) -> Int{
        guard lowerBound <= upperbound else {
            fatalError("[ERROR] Lower bound must be less than or equal to upper bound")
        }
        return Int.random(in: lowerBound...upperbound)
    }
}
