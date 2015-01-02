//
//  LemonadeMix.swift
//  LemonadeStand
//
//  Created by Ansgar Gerlicher on 02.01.15.
//  Copyright (c) 2015 Ansgar Gerlicher. All rights reserved.
//

import Foundation

struct LemonadeMix {
    var lemons: Double = 0
    var icecubes: Double = 0
    
    
    func calculateLemonIceRatio() -> Double {
        var ratio = 1.0
        if icecubes > 0 {
            ratio = lemons / icecubes
        }
        else {
            println("can't mix lemonade without ice - division by zero not allowed")
        }
        
        return ratio
    }
}