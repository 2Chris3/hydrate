import SwiftUI

struct ContentView: View {
	@State private var cups: Int = 0
	let goal: Int = 8
	
	var progress: Double {
		min(Double(cups) / Double(goal), 1.0)
	}
	
	var statusMessage: String {
		switch cups {
			case 0: return "Let's get hydrated! 💧"
			case 1...2: return "Good start, keep going!"
			case 3...5: return "You're doing great! 🌊"
			case 6...7: return "Almost there, champ!"
			default: return "Goal reached! Amazing! 🎉"
		}
	}
	
	var waveColor: Color {
		cups >= goal ? Color(red: 0.1, green: 0.7, blue: 0.5) : Color(red: 0.2, green: 0.5, blue: 0.9)
	}
	
	var body: some View {
		ZStack {
				// Background
			LinearGradient(
				colors: [Color(red: 0.05, green: 0.1, blue: 0.25), Color(red: 0.08, green: 0.18, blue: 0.4)],
				startPoint: .top,
				endPoint: .bottom
			)
			.ignoresSafeArea()
			
			VStack(spacing: 36) {
				
					// Title
				VStack(spacing: 4) {
					
					Text("Hydration")
						.font(.system(size: 13, weight: .semibold, design: .rounded))
						.tracking(4)
						.foregroundColor(.white.opacity(0.5))
						.textCase(.uppercase)
					
					Text("Daily Tracker")
						.font(.system(size: 34, weight: .bold, design: .rounded))
						.foregroundColor(.white)
				}
				.padding(.top, 20)
				
					// Water bottle visual
				ZStack(alignment: .bottom) {
						// Bottle outline
					RoundedRectangle(cornerRadius: 40)
						.stroke(Color.white.opacity(0.15), lineWidth: 2)
						.frame(width: 140, height: 220)
					
						// Water fill
					RoundedRectangle(cornerRadius: 40)
						.fill(
							LinearGradient(
								colors: [waveColor.opacity(0.5), waveColor],
								startPoint: .top,
								endPoint: .bottom
							)
						)
						.frame(width: 140, height: max(10, 220 * progress))
						.animation(.spring(response: 0.5, dampingFraction: 0.7), value: cups)
					
						// Bottle cap
					RoundedRectangle(cornerRadius: 8)
						.fill(Color.white.opacity(0.1))
						.frame(width: 60, height: 20)
						.offset(y: -215)
					
						// Cup count inside bottle
					VStack(spacing: 2) {
						Text("\(cups)")
							.font(.system(size: 52, weight: .black, design: .rounded))
							.foregroundColor(.white)
						Text("of \(goal) cups")
							.font(.system(size: 13, weight: .medium, design: .rounded))
							.foregroundColor(.white.opacity(0.7))
					}
				}
				.frame(height: 240)
				
					// Status message
				Text(statusMessage)
					.font(.system(size: 16, weight: .medium, design: .rounded))
					.foregroundColor(.white.opacity(0.8))
					.animation(.easeInOut, value: cups)
				
					// Progress bar
				VStack(spacing: 8) {
					HStack {
						Text("Progress")
							.font(.system(size: 12, weight: .semibold, design: .rounded))
							.foregroundColor(.white.opacity(0.5))
							.textCase(.uppercase)
							.tracking(2)
						Spacer()
						Text("\(Int(progress * 100))%")
							.font(.system(size: 12, weight: .bold, design: .rounded))
							.foregroundColor(waveColor)
					}
					
					GeometryReader { geo in
						ZStack(alignment: .leading) {
							RoundedRectangle(cornerRadius: 6)
								.fill(Color.white.opacity(0.1))
								.frame(height: 8)
							RoundedRectangle(cornerRadius: 6)
								.fill(LinearGradient(colors: [waveColor.opacity(0.7), waveColor], startPoint: .leading, endPoint: .trailing))
								.frame(width: geo.size.width * progress, height: 8)
								.animation(.spring(response: 0.5, dampingFraction: 0.7), value: cups)
						}
					}
					.frame(height: 8)
				}
				.padding(.horizontal, 36)
				
					// Cup dots
				HStack(spacing: 10) {
					ForEach(0..<goal, id: \.self) { i in
						Circle()
							.fill(i < cups ? waveColor : Color.white.opacity(0.15))
							.frame(width: 18, height: 18)
							.scaleEffect(i < cups ? 1.1 : 1.0)
							.animation(.spring(response: 0.3), value: cups)
					}
				}
				
					// Buttons
				HStack(spacing: 16) {
						// Remove button
					Button(action: {
						if cups > 0 { cups -= 1 }
					}) {
						Image(systemName: "minus")
							.font(.system(size: 20, weight: .bold))
							.foregroundColor(cups > 0 ? .white : .white.opacity(0.3))
							.frame(width: 60, height: 60)
							.background(Color.white.opacity(cups > 0 ? 0.15 : 0.05))
							.clipShape(Circle())
					}
					.disabled(cups == 0)
					
						// Add button
					Button(action: {
						if cups < goal { cups += 1 }
					}) {
						HStack(spacing: 8) {
							Image(systemName: "drop.fill")
							Text("Add Cup")
								.font(.system(size: 16, weight: .bold, design: .rounded))
						}
						.foregroundColor(.white)
						.padding(.horizontal, 28)
						.frame(height: 60)
						.background(
							LinearGradient(colors: [waveColor.opacity(0.8), waveColor], startPoint: .leading, endPoint: .trailing)
						)
						.clipShape(Capsule())
						.shadow(color: waveColor.opacity(0.5), radius: 12, x: 0, y: 6)
					}
					.disabled(cups >= goal)
					
						// Reset button
					Button(action: {
						cups = 0
					}) {
						Image(systemName: "arrow.counterclockwise")
							.font(.system(size: 18, weight: .bold))
							.foregroundColor(cups > 0 ? .white : .white.opacity(0.3))
							.frame(width: 60, height: 60)
							.background(Color.white.opacity(cups > 0 ? 0.15 : 0.05))
							.clipShape(Circle())
					}
					.disabled(cups == 0)
				}
				
				Spacer()
			}
			.padding(.horizontal, 24)
		}
	}
}

#Preview {
	ContentView()
}
