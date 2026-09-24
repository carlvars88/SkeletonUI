#if canImport(SwiftUI)
import SwiftUI

/// A view that renders a moving shimmer effect, typical of skeleton loaders.
///
/// `ShimmerView` provides a high-performance linear gradient that animates
/// across its parent container. It respects the system's "Reduce Motion" setting.
@MainActor
public struct ShimmerView: View {
    @State private var phase: CGFloat = 0
    private let config: SkeletonConfiguration
    
    /// Creates a new ShimmerView.
    ///
    /// - Parameter config: The configuration determining colors and speed.
    public init(config: SkeletonConfiguration = .default) {
        self.config = config
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            // A narrower highlight band (0.6w) sweeps over a *persistent*
            // base fill. The base never disappears — only the highlight
            // moves — so unlike a single sweeping base→highlight→base
            // gradient, the container is never left fully uncovered
            // (showing whatever's behind it) at any point in the loop.
            //
            // The highlight band's own loop endpoints still need to be
            // fully off-screen for the same reason as before: for a band
            // of width b, spanning [0, b] before any offset, the offset
            // that places its right edge at the container's left edge (x=0)
            // is -b, and the offset that places its left edge at the
            // container's right edge (x=width) is +width. So:
            //   phase 0 -> offset = -b       -> band spans [-b, 0]
            //   phase 1 -> offset = +width   -> band spans [width, width+b]
            // i.e. offset(phase) = -b + phase*(b + width).
            let bandWidth = width * 0.6
            ZStack {
                config.baseColor
                LinearGradient(
                    colors: [.clear, config.highlightColor, .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: bandWidth)
                .offset(x: -bandWidth + phase * (bandWidth + width))
            }
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: config.speed).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
        }
    }
}
#endif
