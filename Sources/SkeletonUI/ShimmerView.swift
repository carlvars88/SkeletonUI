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
            // Band width is 2w (w = container width). For the loop to reset
            // invisibly, both phase endpoints must place the band fully
            // outside the container's visible range [0, w]:
            //   phase 0 -> band spans [-2w, 0]  (right edge touches 0)
            //   phase 1 -> band spans [w, 3w]   (left edge touches w)
            // The old formula (`-w + phase*2w`) put phase 0 at [-w, w],
            // which fully covers the container instead of hiding the band,
            // and phase 1 at [w, 3w], which fully exposes the container's
            // background — so each loop reset jumped between "band fills
            // everything" and "background fully exposed" instead of
            // sweeping a highlight across a stable base.
            let bandWidth = geometry.size.width * 2
            LinearGradient(
                colors: [config.baseColor, config.highlightColor, config.baseColor],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: bandWidth)
            .offset(x: -bandWidth + phase * (bandWidth + geometry.size.width))
            .onAppear {
                withAnimation(.linear(duration: config.speed).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
        }
    }
}
#endif
