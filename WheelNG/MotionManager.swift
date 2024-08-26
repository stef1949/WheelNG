//
//  MotionManager.swift
//  WheelNG
//
//  Created by Stephan Ritchie on 23/08/2024.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager
    @Published var angle: Double = 0.0
    
    private var previousAngle: Double = 0.0
    private let smoothingFactor = 0.1  // Adjust this value for more or less smoothing
    
    init() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.001
        
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                guard let data = data, error == nil else { return }
                self?.calculateAngle(data: data)
            }
        }
    }
    
    private func calculateAngle(data: CMAccelerometerData) {
        let acceleration = data.acceleration
        let rawAngle = atan2(acceleration.x, -acceleration.y) * 180 / .pi
        
        // Apply smoothing using a low-pass filter
        let smoothedAngle = (rawAngle * smoothingFactor) + (previousAngle * (1.0 - smoothingFactor))
        
        DispatchQueue.main.async {
            self.angle = smoothedAngle
            self.previousAngle = smoothedAngle
        }
    }
}
