//
//  ContentView.swift
//  sleepCalculator
//
//  Created by Lucas Parreira on 11/04/21.
//

import SwiftUI

struct ContentView: View {
       @State private var wakeUp = defaultWakeTime
       @State private var sleepAmount = 8.0
       @State private var coffeeAmount = 1

       @State private var alertTitle = ""
       @State private var alertMessage = ""
       @State private var showingAlert = false

       let model = SleepCalculator()

       static var defaultWakeTime: Date {
           var components = DateComponents()
           components.hour = 7
           components.minute = 0
           return Calendar.current.date(from: components) ?? Date()
       }
    
    var body: some View {
        NavigationView{
                
                Form{
                    Text("When do you want to wake up?").font(.headline)
                    
                    DatePicker("Please enter a time", selection:$wakeUp, displayedComponents:.hourAndMinute).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                
                    VStack(alignment: .leading){
                        Text("Desired amount of sleep").font(.headline)
                        
                        Stepper(value:$sleepAmount, in:1...12,step:0.50){
                            if(sleepAmount < 2){
                                Text("\(sleepAmount, specifier:"%.2f") hour")
                            } else {
                                Text("\(sleepAmount, specifier: "%.2f") hours")
                            }
                        
                        }
                            Text("Daily coffee intake").font(.headline)
                            Stepper(value: $coffeeAmount, in: 1...20){
                                if(coffeeAmount == 1){
                                    Text("1 coup")
                                } else {
                                    Text("\(coffeeAmount) coups")
                                }
                        }
                    }
                
            }.navigationBarTitle("Better Rest App")
            .navigationBarItems(trailing:
                                    Button(action: calculationBedTime){
                                        Text("Calculate")
                                    }
            )
                .alert(isPresented: $showingAlert){
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
                }
        }
    }
    
    func calculationBedTime(){
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
                let hour = (components.hour ?? 0) * 60 * 60
                let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal time to sleep is ..."
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there as a error calculation your bedtime"
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
