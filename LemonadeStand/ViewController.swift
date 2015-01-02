//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Ansgar Gerlicher on 01.01.15.
//  Copyright (c) 2015 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentMoneyLabel: UILabel!
    @IBOutlet weak var currentLemonsLabel: UILabel!
    @IBOutlet weak var currentIceCubesLabel: UILabel!
    @IBOutlet weak var purchasedLemonsLabel: UILabel!
    @IBOutlet weak var purchasedIceCubesLabel: UILabel!
    @IBOutlet weak var mixedLemonsLabel: UILabel!
    @IBOutlet weak var mixedIceCubesLabel: UILabel!
    
    @IBOutlet weak var lemonPurchaseStepper: UIStepper!
    @IBOutlet weak var iceCubesPurchaseStepper: UIStepper!
    
    @IBOutlet weak var lemonMixStepper: UIStepper!
    @IBOutlet weak var iceCubeMixStepper: UIStepper!
    
    var warehouse: Warehouse = Warehouse()
    var lemonadeMix: LemonadeMix = LemonadeMix()
    var purchaseLemons: Double = 0
    var purchaseIceCubes: Double = 0
    var currentBudget: Double = 10
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lemonPurchaseStepper.value = 0.0
        lemonPurchaseStepper.maximumValue = warehouse.money / 2
        
        iceCubesPurchaseStepper.value = 0.0
        iceCubesPurchaseStepper.maximumValue = warehouse.money
        purchaseLemons = 0
        currentBudget = warehouse.money
        
        updateLemonadeStandView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func purchaseLemonsStepperValueChanged(sender: UIStepper) {
       // a lemon costs 2 Dollar so check if there is enough money left to purchase the lemon ammount
    

        if warehouse.money - sender.value * 2 - purchaseIceCubes >= 0 {
            purchaseLemons = sender.value;
            currentBudget = warehouse.money - purchaseIceCubes - purchaseLemons * 2
            
        }
        else {
            
            lemonPurchaseStepper.maximumValue = purchaseLemons
            lemonPurchaseStepper.value = purchaseLemons
            println("can't buy anymore lemons, run out of budget")
        }
       
        println("lemons purchase: \(purchaseLemons) and LemonStepper value: \(sender.value) / IceCubes purchase: \(purchaseIceCubes)")

       updateStepper()
        updateLemonadeStandView()
    }

    @IBAction func purchaseIceCubesStepperValueChanged(sender: UIStepper) {
        // a icecube costs 1 Dollar so check if there is enough money left to purchase the lemon ammount
 
        
        if warehouse.money - purchaseLemons * 2 - sender.value >= 0 {
           purchaseIceCubes = sender.value
           currentBudget = warehouse.money - purchaseIceCubes - purchaseLemons * 2
            
        }
        else {
            iceCubesPurchaseStepper.maximumValue = purchaseIceCubes
            iceCubesPurchaseStepper.value = purchaseIceCubes
            println("can't buy anymore lemons, run out of budget")
        }
        
        println("lemons purchase: \(purchaseLemons) and icecubestepper value: \(sender.value) / IceCubes purchase: \(purchaseIceCubes)")

       updateStepper()

     
        updateLemonadeStandView()
    }
    @IBAction func mixedLemonsStepperValueChanged(sender: UIStepper) {
        
        updateStepper()
        lemonadeMix.lemons = sender.value
        
        updateLemonadeStandView()

        
    }
    @IBAction func mixedIceCubesValueChanged(sender: UIStepper) {
        
        updateStepper()
        lemonadeMix.icecubes = sender.value
        
        updateLemonadeStandView()
        
    }
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
        // calculate warehouse values and lemonade mix
        warehouse.money = currentBudget
        warehouse.lemons += purchaseLemons
        warehouse.iceCubes += purchaseIceCubes
        
        if warehouse.money == 0 && (warehouse.lemons == 0 || warehouse.iceCubes == 0) {
            println("Game over")
            showAlertToUser(header: "Game Over", message: "You are broke")
            resetValuesForNewGame()
            updateStepper()
            updateLemonadeStandView()
            return
            
        }
        
        println("New day starts!")
        println("You have the following in your warehouse:")
        println("Budget left: \(warehouse.money)")
        println("lemons: \(warehouse.lemons)")
        println("ice cubes: \(warehouse.iceCubes)\n")
        if lemonadeMix.icecubes == 0 {
            println("Can't sell lemonade without ice")
            showAlertToUser(header: "Error", message: "Can't sell lemonade without ice")
            return
        }
        if lemonadeMix.lemons == 0 {
            println("Can't sell lemonade without lemon")
            showAlertToUser(header: "Error", message: "Can't sell lemonade without lemon")
            return
        }
        
      
        
        let ratio = lemonadeMix.calculateLemonIceRatio()
        
      
        
        println("lemonade ration Lemon / Ice Cubes is:\(ratio)")
        
        println("Mixing the lemonade now ...")
        
        warehouse.lemons -= lemonadeMix.lemons
        warehouse.iceCubes -= lemonadeMix.icecubes
        
        println("Selling the lemonade...")
        let favoursAcididLemonade = 0...0.4
        let favoursEqualPartsLemonade = 0.4...0.6
        let favoursDilutedLemonade = 0.6...1.0
        
        
        // calculate weather
        var weatherConditions: Int = 0
        let weatherType = Int(arc4random_uniform(UInt32(3)))
        switch weatherType {
        case 0:
            weatherConditions = -3
            weatherImage.image = UIImage(named: "Cold")
            weatherImage.hidden = false
        
        case 1:  weatherConditions = 0
        weatherImage.image = UIImage(named: "Mild")
        weatherImage.hidden = false
        case 2:  weatherConditions = +4
        weatherImage.image = UIImage(named: "Warm")
        weatherImage.hidden = false
        default:  weatherConditions = 0
        }
        
        
        let customers = Int(arc4random_uniform(UInt32(10))) + weatherConditions
        
        var income = 0;
        
        for var index = 0; index <= customers; index++ {
            
            // generate favour for customer
            
            let favourRatio = arc4random_uniform(UInt32(10))
            let fr = 1.0 / (Double(favourRatio)+1)
            println("Customer \(index) has favourRatio \(fr)")
            
            
            if ratio > 1 && fr < 0.4 {
                //favours acidic lemonade
                println("Customer \(index) favours acidic lemonade. Paid!")
                income++
            }
            else if ratio == 1 && fr > 0.4 && fr < 0.6 {
                //favours equal part lemonade
                println("Customer \(index) favours equal parts lemonade. Paid!")
                income++
            }
            else if ratio < 1 && fr > 0.6 && fr <= 1.0 {
                // favours diluted lemonade
                println("Customer \(index) favours dilutes lemonade. Paid!")
                income++
            }
            
            
            
        }
        warehouse.money += Double(income)
        
        println("owned: \(income) today")
        showAlertToUser(header: "Income Today:", message: "You have made \(income) today")
        
        resetValuesForNewDay()
        updateStepper()
        updateLemonadeStandView()
        
        if warehouse.money == 0 && (warehouse.lemons == 0 || warehouse.iceCubes == 0) {
            println("Game over")
            showAlertToUser(header: "Game Over", message: "You are broke")
            resetValuesForNewGame()
            updateStepper()
            updateLemonadeStandView()
            return
            
        }

    }
    
    func updateLemonadeStandView() {
        
        currentLemonsLabel.text = "\(warehouse.lemons) Lemons"
        currentIceCubesLabel.text = "\(warehouse.iceCubes) Ice Cubes"
        purchasedLemonsLabel.text = "\(purchaseLemons)"
        purchasedIceCubesLabel.text = "\(purchaseIceCubes)"
        currentMoneyLabel.text = "\(currentBudget)"
        
        mixedLemonsLabel.text = "\(lemonadeMix.lemons)"
        mixedIceCubesLabel.text = "\(lemonadeMix.icecubes)"
        
    }
    
    func resetValuesForNewDay() {
        lemonadeMix.lemons = 0
        lemonadeMix.icecubes = 0
        lemonPurchaseStepper.value = 0.0
        lemonPurchaseStepper.maximumValue = warehouse.money / 2
        
        lemonMixStepper.value = 0
        iceCubeMixStepper.value = 0
        
        iceCubesPurchaseStepper.value = 0.0
        iceCubesPurchaseStepper.maximumValue = warehouse.money
        purchaseLemons = 0
        purchaseIceCubes = 0
        currentBudget = warehouse.money
        
        
    }
    
    func updateStepper() {
        iceCubeMixStepper.maximumValue = purchaseIceCubes + warehouse.iceCubes
        if iceCubeMixStepper.maximumValue < lemonadeMix.icecubes {
            lemonadeMix.icecubes = iceCubeMixStepper.maximumValue
        }
        lemonMixStepper.maximumValue = purchaseLemons + warehouse.lemons

        if lemonMixStepper.maximumValue < lemonadeMix.lemons {
            lemonadeMix.lemons = lemonMixStepper.maximumValue
        }
        iceCubesPurchaseStepper.maximumValue = warehouse.money - purchaseLemons * 2
        lemonPurchaseStepper.maximumValue = round(warehouse.money / 2)
    }
    
    func showAlertToUser(header: String = "Warning", message: String) {
       var alertView = UIAlertView(title: header, message: message, delegate: nil, cancelButtonTitle: "o.k.")
        alertView.show()
    }
    
    
    func resetValuesForNewGame() {
        lemonadeMix.lemons = 0
        lemonadeMix.icecubes = 0
        lemonPurchaseStepper.value = 0.0
        lemonPurchaseStepper.maximumValue = warehouse.money / 2
        
        lemonMixStepper.value = 0
        iceCubeMixStepper.value = 0
        
        iceCubesPurchaseStepper.value = 0.0
        iceCubesPurchaseStepper.maximumValue = warehouse.money
        purchaseLemons = 0
        purchaseIceCubes = 0
        warehouse.money = 10
        warehouse.lemons = 0
        warehouse.iceCubes = 0
        currentBudget = warehouse.money
        
        
    }
}

