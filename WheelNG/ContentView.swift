//
//  ContentView.swift
//  WheelNG
//
//  Created by Stephan Ritchie on 23/08/2024.
//

import SwiftUI
import CoreMotion
import CoreHaptics

struct ContentView: View {
    
    @StateObject private var motionManager = MotionManager()
    
    //Haptics
    /// @State private var engine: CHHapticEngine?
    func connectAction() {
        // Your connect action goes here
        print("Connect tapped")
    }
    
    //View Variables
    @State private var isDarkMode = true
    @State private var isHorizonLockEnabled = true
    @State private var isInfoPopoverPresented: Bool = false
    
        
    //RPM Variables
    @State private var rpm = 5.0
    @State private var minValue = 0.0
    @State private var maxValue = 11.0
    
    //Boost Variables
    @State private var minPressure = 0.0
    @State private var maxPressure = 17.0
    @State private var currentPressure = 4.3
    
    //Speed Variables
    @State private var minSpeed = 0.0
    @State private var maxSpeed = 230.0
    @State private var currentSpeed = 57.6
    
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    
    //Engine Temperature Variables
    @State private var engineTemp = 110.0
    
    
    //Gear Change
    @State private var gear = ""
    
    //Pedal States
    //@State private var isBrakePressed = false
    //@State private var isAcceleratorPressed = false
    
    //Long Press Gesture
    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress = false
    
    // Speed Units
    @State var selectedUnit = 1 // 1 for MPH, 2 for KM/H
    
    
    
    // Track Orientation
    
    
    //Long press gesture
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 0.2)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 1.0)
                
            }
            .onEnded { finished in
                self.completedLongPress = finished
            }
    }
    
    var body: some View {
        ZStack {
            // Radial Gradient Background
            RadialGradient(gradient: Gradient(colors: [.gray, .black]),
                           center: .center,
                           startRadius: 50,
                           endRadius: 500)
            .ignoresSafeArea(.all) // Ensures the gradient covers the entire screen
            .opacity(0.5)

                //RPM Line
            VStack {
                
                Gauge(value: Double((rpm)), in: minValue...maxValue) {
                    Label("RPM(x1000)", systemImage: "tachometer")
                } currentValueLabel: {
                    Text(Int(rpm), format: .number)
                } minimumValueLabel: {
                    Text("\(Int(minValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxValue))")
                }
                .foregroundColor(.gray)
                .tint(gradient)
                .padding([.top, .leading, .trailing], 25.0)
                
                Image(systemName: "")
                
                           
                    HStack {
                        
                        // Brake Pedal Icon
                        brakepedalView()
                        
                        Spacer()
                        
                        // Gauge Cluster
                        ZStack {
                            // Speed Gauge
                            Gauge(value: currentSpeed, in: minSpeed...maxSpeed) {
                                Image(systemName: "gauge.medium")
                                    .font(.system(size: 50.0))
                                
                            } currentValueLabel: {
                                Text("\(currentSpeed.formatted(.number))")
                            }
                            .gaugeStyle(SpeedometerGaugeStyle(selectedUnit: selectedUnit))
                            .rotationEffect(.degrees(-90 - motionManager.angle), anchor: .center) // Apply rotation based on tilt
                            
                            .padding(.bottom, 25.0)
                            
                            //Boost Gauge
                            let boostGradient = Gradient(colors: [.clear, .yellow, .orange])
                            
                            VStack {
                                Gauge(value: currentPressure, in: minPressure...maxPressure) {
                                    Text("Speed")
                                } currentValueLabel: {
                                    Text(Int(currentPressure), format: .number)
                                    
                                } minimumValueLabel: {
                                    Text("\(Int(minPressure))")
                                    
                                        .foregroundColor(.green)
                                } maximumValueLabel: {
                                    Text("\(Int(maxPressure))")
                                    
                                }
                                .gaugeStyle(.accessoryCircular)
                                .tint(boostGradient)
                                
                            }
                            .offset(CGSize(width: -130.0, height: 100.0))
                            
                            //Temperature Gauge
                            let tempGradient = Gradient(colors: [.blue, .red])
                            
                            VStack {
                                Gauge(value: engineTemp, in: 0...150) {
                                    Label("Temperature (°F)", systemImage: "thermometer.and.liquid.waves")
                                        
                                } currentValueLabel: {
                                    Image(systemName: "thermometer.and.liquid.waves")
                                    
                                } minimumValueLabel: {
                                    Text("C")
                                        .foregroundColor(.blue)
                                    
                                } maximumValueLabel: {
                                    Text("H")
                                        .foregroundColor(.red)
                                }
                                .gaugeStyle(.accessoryCircular)
                                .tint(tempGradient)
      
                            }
                            .offset(CGSize(width: 140.0, height: 100.0))
                               
                            //Gear Selector
                            Image(systemName: "1.square.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50.0, height: 50)
                                .offset(CGSize(width: -150.0, height: 100.0))
                            
                        }
                        
                        Spacer()
                        
                        // Accelerator Pedal Icon
                        accelpedalView()
                    }
                }
            
            ZStack (alignment: .topTrailing) {
             
                // Settings Cog Button with Menu
                Menu {
                    // Connect Dropdown Menu
                           Menu {
                               Button("IP Address") {
                                   // Action for IP Address
                                   print("Wi-Fi connect tapped")
                               }
                               Button("Port") {
                                   // Action for Port selection
                                   print("Port tapped")
                               }
                               Button("Protocol") {
                                   // Action for UDP/TCP switch
                                   print("Protocol tapped")
                               }
                           } label: {
                               Label("Connect", systemImage: "wifi")
                           }
                    
                    Toggle(isOn: $isDarkMode) {
                        Label("Light/Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    
                    Toggle(isOn: $isHorizonLockEnabled) {
                        Label("Horizon Lock", systemImage: "lock.rotation")
                    }
                    
                    Picker(selection: $selectedUnit, label: Text("Units")) {
                        Image(systemName: "mph").tag(1)
                        Image(systemName: "kph").tag(2)
                    }
                    .pickerStyle(.automatic) // Optional: Change the picker style
                    
                } label: {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .symbolRenderingMode(.palette)
                }
            }
            .offset(CGSize(width: 350.0, height: -80.0))
            .menuActionDismissBehavior(.disabled)
            
            //Info page
            Button(action: {
                self.isInfoPopoverPresented = true
            }, label: {
                Image(systemName: "info.square")
                    .imageScale(.large)
                    .symbolRenderingMode(.hierarchical)
                
            })
            .popover(isPresented: $isInfoPopoverPresented) {
                      infoView()
                    .presentationCompactAdaptation(.sheet)
                    .frame(maxWidth: 400)
                    .background(.ultraThinMaterial)
                
                   }
            .offset(CGSize(width: -350.0, height: -80.0))
        }
    }
}

struct SpeedometerGaugeStyle: GaugeStyle {
    var selectedUnit: Int // Pass as a regular property, not a binding
    
    private var heatGradient = LinearGradient(gradient: Gradient(colors: [.teal, .blue, .purple]), startPoint: .trailing, endPoint: .leading)
    
    // Public initializer to accept selectedUnit
        init(selectedUnit: Int) {
            self.selectedUnit = selectedUnit
        }
    
    // Track Orientation
        @State private var isLandscape = true
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color(.systemGray4))
                //.foregroundStyle(.ultraThinMaterial)
            
            //Stroke colour
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(heatGradient, style: StrokeStyle(lineWidth: 15.0, lineCap: .round))
                .rotationEffect(.degrees(135))
                .scaleEffect(CGSize(width: 0.85, height: 0.85))
             
            //Background stroke colour
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(heatGradient, style: StrokeStyle(lineWidth: 15.0, lineCap: .round))
                .rotationEffect(.degrees(135))
                .scaleEffect(CGSize(width: 0.85, height: 0.85))
                .opacity(0.2)
                
            //Dashes
         //   Circle()
        // .trim(from: 0, to: 0.75)
        // .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 34], dashPhase: 0.0))
        //   .rotationEffect(.degrees(135))
        //   .scaleEffect(CGSize(width: 0.95, height: 0.95))

                //Current speed
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                // Display selected unit
                
                    Image(systemName: "mph")
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .foregroundStyle(selectedUnit == 1 ? Color.gray : Color.black)
                    
                    
                    Image(systemName: "kph")
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .foregroundStyle(selectedUnit == 1 ? Color.black : Color.gray)
                }
        }
        .frame(width: 280, height: 280)
        .padding(.bottom, -11.0)
    }
}

struct brakepedalView: View {
    //Pedal States
    @State private var isBrakePressed = false
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: isBrakePressed ? "pedal.brake.fill": "pedal.brake")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
                .imageScale(.large)
                .symbolRenderingMode(.hierarchical)
                .fontWeight(.thin)
                .scaleEffect(isBrakePressed ? 0.8 : 1.0) // Scale down to 90% when pressed
                .animation(
                    .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0),
                    value: isBrakePressed
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            // When the gesture is recognized (pressed), set isPressed to true
                            isBrakePressed = true
                            /// HapticFeedback.impactOccurred()
                            
                        }
                        .onEnded { _ in
                            // When the gesture ends (released), set isPressed to false
                            isBrakePressed = false
                            /// HapticFeedback.impactOccurred()
                        }
                )
            Text ("Brake")
                .foregroundStyle(.gray)
        }
    }
}

struct accelpedalView: View {
    @State private var isAcceleratorPressed = false
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(systemName: isAcceleratorPressed ? "pedal.accelerator.fill" : "pedal.accelerator")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
                .imageScale(.large)
                .symbolRenderingMode(.hierarchical)
                .fontWeight(.thin)
                .scaleEffect(isAcceleratorPressed ? 0.8 : 1.0) // Scale down to 90% when pressed
                .animation(
                    .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0),
                    value: isAcceleratorPressed
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isAcceleratorPressed {
                                // When the gesture is recognized (pressed), set isPressed to true
                                isAcceleratorPressed = true
                                /// HapticFeedback.impactOccurred()
                                
                            }
                        }
                        .onEnded { _ in
                            if isAcceleratorPressed {
                                // When the gesture ends (released), set isPressed to false
                                isAcceleratorPressed = false
                                /// HapticFeedback.impactOccurred()
                            }
                        }
                )
            Text ("Accelerator")
                .foregroundStyle(.gray)
        }
    }
}

struct infoView: View {
    var body: some View {
        ScrollView {
            VStack {
                
                //App Name
                Text("About WheelNG")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                //BeamNG Logo
                AsyncImage(url: URL(string: "https://wiki.beamng.com/images/thumb/d/d0/BeamNG.drive-logo-2016.svg/744px-BeamNG.drive-logo-2016.svg.png")!, scale: 3) { image in
                    image.resizable()
                    image.aspectRatio(contentMode: .fit)
                    
                } placeholder: {
                    Color.orange
                }
                .frame(width: 50, height: 100)
                
                Text("This is app is a remote control for BeamNG Drive. Allowing users to use their phones as remote controls for BeamNG, using the ")
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                
                //Verison Info
                Text("Version 1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                
                // Developer Information
                VStack(alignment: .leading, spacing: 8) {
                    Text("Developed by Stephan Ritchie")
                        .font(.headline)
                    
                    Text("This app is designed to provide a comprehensive and interactive experience for driving simulation enthusiasts. It features customizable speedometers, RPM gauges, and advanced settings to enhance your virtual driving experience.")
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                
                // Links Section
                           VStack(alignment: .leading, spacing: 8) {
                               Text("Follow Us")
                                   .font(.headline)
                               
                               Link("Github", destination: URL(string: "https://github.com/stef1949/WheelNG")!)
                               
                               Link("Follow on Twitter", destination: URL(string: "https://x.com/richies3d?s=21")!)
                               
                               Link("Like on Facebook", destination: URL(string: "https://www.facebook.com/richies3d")!)
                           }
                           .padding(.vertical)
                           
                           Spacer()
                
            }
            .padding()
            .navigationTitle("About")
        }
        
    }
}

#Preview {
    ContentView()
}
