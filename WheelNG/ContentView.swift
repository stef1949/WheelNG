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
    
    //Settings Variables
    @State private var isDarkMode = true
    @State private var isHorizonLockEnabled = true
        
    //RPM Variables
    @State private var rpm = 5
    private let minValue = 0.0
    private let maxValue = 11.0
    
    //Speed Variables
    @State private var minSpeed = 0.0
    @State private var maxSpeed = 170.0
    @State private var currentSpeed = 50.0
    
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
                .padding([.top, .leading, .trailing])
                
                Image(systemName: "")
                
                           
                    HStack {
                        
                        // Brake Pedal Icon
                        brakepedalView()
                        
                        Spacer()
                        
                        // Gauge Cluster
                        ZStack {
                            // Speed Gauge
                            Gauge(value: currentSpeed, in: 0...200) {
                                Image(systemName: "gauge.medium")
                                    .font(.system(size: 50.0))
                            } currentValueLabel: {
                                Text("\(currentSpeed.formatted(.number))")
                                
                            }
                            .gaugeStyle(SpeedometerGaugeStyle())
                            .rotationEffect(.degrees(-90 - motionManager.angle), anchor: .center) // Apply rotation based on tilt
                            
                            Spacer()
                            
                            //Boost Gauge
                            VStack {
                                Gauge(value: motionManager.angle, in: -90...90) {
                                    Text("Speed")
                                } currentValueLabel: {
                                    Text(Int(currentSpeed), format: .number)
                                    
                                } minimumValueLabel: {
                                    Text("\(Int(minSpeed))")
                                    
                                        .foregroundColor(.green)
                                } maximumValueLabel: {
                                    Text("\(Int(maxSpeed))")
                                    
                                }
                                .gaugeStyle(.accessoryCircular)
                                
                                Text("PSI")
                                    .offset(CGSize(width: 0, height: -12))
                            }
                            .offset(CGSize(width: -140.0, height: -110.0))
                            
                            //Temperature Gauge
                            VStack {
                                Gauge(value: engineTemp, in: 0...150) {
                                    Label("Temperature (°F)", systemImage: "thermometer.and.liquid.waves")
                                    
                                } currentValueLabel: {
                                    Image(systemName: "thermometer.and.liquid.waves")
                                    
                                } minimumValueLabel: {
                                    Text("\(Int(0))")
                                    
                                        .foregroundColor(.green)
                                } maximumValueLabel: {
                                    Text("\(Int(150))")
                                    
                                }
                                .gaugeStyle(.accessoryCircularCapacity)
                                
                                Label("", systemImage: "thermometer.and.liquid.waves")
                                    .labelStyle(/*@START_MENU_TOKEN@*/DefaultLabelStyle()/*@END_MENU_TOKEN@*/)
                            }
                            .offset(CGSize(width: 140.0, height: -110.0))
                               
                            //Gear
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
                    Button(action: connectAction) {
                        Label("Connect", systemImage: "wifi")
                    }
                    Toggle(isOn: $isDarkMode) {
                        Label("Light/Dark Mode", systemImage: "moon.circle")
                    }
                    
                    Toggle(isOn: $isHorizonLockEnabled) {
                        Label("Horizon Lock", systemImage: "lock.rotation")
                    }
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 24))
                        .padding()
                        .symbolRenderingMode(.multicolor)
                }
            }
            .offset(CGSize(width: 350.0, height: -80.0))
        }
    }
}

struct SpeedometerGaugeStyle: GaugeStyle {
    private var heatGradient = LinearGradient(gradient: Gradient(colors: [.blue, .purple, .pink, .red]), startPoint: .trailing, endPoint: .leading)
    // Track Orientation
        @State private var isLandscape = true
    func makeBody(configuration: Configuration) -> some View {
        ZStack {

            Circle()
                .foregroundColor(Color(.systemGray6))
                //.foregroundStyle(.ultraThinMaterial)

            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(heatGradient, style: StrokeStyle(lineWidth: 40.0, lineCap: .round))
                .rotationEffect(.degrees(135))
                .clipShape(Circle())
            

            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 34], dashPhase: 0.0))
                .rotationEffect(.degrees(135))

            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 150, weight: .bold, design: .rounded))
                    .foregroundStyle(.gray)
                Text("MPH")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundStyle(.gray)
            }

        }
        .frame(width: 280, height: 280)
        .padding(.bottom, -11.0)
    }

}

#Preview {
    ContentView()
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
        }
    }
}
