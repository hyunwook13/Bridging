//
//  HapticManager.swift
//  Core
//
//  Created by 이현욱 on 5/19/25.
//

import UIKit

public final class HapticManager {
    public static let shared = HapticManager()

    private init() {}

    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)

    private let notification = UINotificationFeedbackGenerator()
    private let selection = UISelectionFeedbackGenerator()

    // MARK: - Impact (물리적인 톡 건드림)
    public func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    public func lightImpact() {
        impactLight.prepare()
        impactLight.impactOccurred()
    }

    public func mediumImpact() {
        impactMedium.prepare()
        impactMedium.impactOccurred()
    }

    public func heavyImpact() {
        impactHeavy.prepare()
        impactHeavy.impactOccurred()
    }

    // MARK: - Notification (성공/실패/경고)
    public func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notification.prepare()
        notification.notificationOccurred(type)
    }

    // MARK: - Selection (값 선택 전환 시)
    public func selectionChanged() {
        selection.prepare()
        selection.selectionChanged()
    }
}
