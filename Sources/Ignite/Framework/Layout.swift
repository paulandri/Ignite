//
// Layout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Layouts allow you to have complete control over the HTML used to generate
/// your pages.
///
/// Example:
/// ```swift
/// struct BlogLayout: Layout {
///     var body: Document {
///         Body {
///             content
///             Footer()
///         }
///     }
/// }
/// ```
@MainActor
public protocol Layout {
    /// The main content of the layout, built using the HTML DSL
    @DocumentBuilder var body: Document { get }
}

public extension Layout {
    /// The current page being rendered.
    var content: some HTML {
        Section(PublishingContext.shared.environment.pageContent)
            .class("ig-main-content") // For replacing the main content with search results
    }
}
