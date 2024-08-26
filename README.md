# WheelNG - Racing Game Dashboard

**WheelNG** is a SwiftUI-based dashboard for a racing game, providing real-time data visualization such as speed, RPM, and pedal states. The app utilizes device motion to rotate the speedometer and offers a sleek, gradient-enhanced user interface.

## Features

- **Real-Time Speedometer**: The speed gauge dynamically rotates based on the device's orientation, reflecting the car's speed in real-time.
- **RPM Indicator**: Displays the current RPM, allowing players to monitor engine performance.
- **Pedal States**: Visual indicators for brake and accelerator pedals, which respond to user gestures.
- **Gear Display**: Shows the current gear, visually updating as the gear changes.
- **Responsive UI**: The app is optimized for landscape mode and includes a smooth radial gradient background.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **CoreMotion**: To handle device motion and provide real-time rotation for the speedometer.
- **CoreHaptics**: (Optional) To provide haptic feedback when interacting with the pedals.

## Setup and Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/wheelng.git
   cd wheelng
