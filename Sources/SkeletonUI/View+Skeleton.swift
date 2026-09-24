#if canImport(SwiftUI)
import SwiftUI

public extension View {
    /// Adds a shimmering skeleton overlay to the view when a condition is met.
    ///
    /// - Parameters:
    ///   - active: If true, the skeleton shimmer is visible.
    ///   - config: Custom configuration for the shimmer effect.
    /// - Returns: A view that displays a skeleton when active.
    @MainActor
    func skeleton(active: Bool, config: SkeletonConfiguration = .default) -> some View {
        self.modifier(SkeletonModifier(isLoading: active, shape: .rectangle(cornerRadius: config.cornerRadius), config: config))
    }
}
#endif
