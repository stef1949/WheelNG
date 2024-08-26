//
//  HapticManager.swift
//  WheelNG
//
//  Created by Stephan Ritchie on 23/08/2024.
//

import UIKit

struct HapticFeedback {
    static func impactOccurred() {
        #if targetEnvironment(simulator)
        // No haptic feedback on simulator
        print("Haptic feedback is not supported on the simulator.")
        #else
        // Provide haptic feedback on real device
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
}
