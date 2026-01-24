//
//  UIHelpers.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import SwiftUI

// 1. The wrapper for each onboarding question
struct OnboardingStepView<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content
    
    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack {
                content
            }
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity)
    }
}

// 2. The interactive buttons for Allergies and Cuisines
struct TagView: View {
    let text: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.green : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .animation(.spring(), value: isSelected)
        }
        .buttonStyle(.plain) // Prevents the whole row from flashing in a List
    }
}

// 3. The thin lines at the top showing progress
struct ProgressBar: View {
    var currentStep: Int
    var totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= currentStep ? Color.green : Color(.systemGray5))
                    .frame(height: 6)
                    .frame(maxWidth: .infinity)
                    .animation(.easeInOut, value: currentStep)
            }
        }
    }
}

// 4. A helper for the custom layout of the cuisine tags
struct FlowLayout: View {
    let items: [String]
    let selectedItems: Set<String>
    var onToggle: (String) -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
            ForEach(items, id: \.self) { item in
                TagView(text: item, isSelected: selectedItems.contains(item)) {
                    onToggle(item)
                }
            }
        }
    }
}

