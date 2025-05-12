import Foundation
import UIKit
#if os(watchOS)
import ClockKit
import WatchKit
#endif

public enum AccessoryWidgetGroup: String, Comparable {
    case circular
    case corner
    case inline
    case rectangular

    public static func < (lhs: AccessoryWidgetGroup, rhs: AccessoryWidgetGroup) -> Bool {
        lhs.name < rhs.name
    }

    public init(name: String) {
        switch name {
        case "circular":
            self = .circular
        case "corner":
            self = .corner
        case "rectangular":
            self = .rectangular
        case "inline":
            self = .inline
        default:
            Current.Log.warning("Unknown group member name \(name)")
            self = .circular
        }
    }

    #if os(watchOS)
    public init(family: CLKComplicationFamily) {
        switch family {
        case CLKComplicationFamily.graphicCircular:
            self = .circular
        case CLKComplicationFamily.graphicCorner:
            self = .corner
        case CLKComplicationFamily.graphicRectangular:
            self = .rectangular
        case CLKComplicationFamily.utilitarianSmall:
            self = .inline
        default:
            Current.Log.warning("Unknown group member name \(family.rawValue)")
            self = .circular
        }
    }

    public var family: CLKComplicationFamily {
        switch self {
        case .circular:
            return .graphicCircular
        case .corner:
            return .graphicCorner
        case .rectangular:
            return .graphicRectangular
        case .inline:
            return .utilitarianSmall
        }
    }

    public var placeholderComplicationDescriptor: CLKComplicationDescriptor {
        CLKComplicationDescriptor(
            identifier: "placeholder-" + rawValue,
            displayName: L10n.Watch.placeholderComplicationName,
            supportedFamilies: [family]
        )
    }

    #endif

//    #if os(iOS)
//    var family: String {
//        switch self {
//        case .graphicCircular:
//            return "graphicCircular"
//        case .graphicCorner:
//            return "graphicCorner"
//        case .graphicRectangular:
//            return "graphicRectangular"
//        case .utilitarianSmall:
//            return "utilitarianSmall"
//        }
//    }
//    #endif

    public var name: String {
        switch self {
        case .circular:
            return "Circular" //L10n.Watch.Labels.ComplicationGroupMember.GraphicCircular.name
        case .corner:
            return "Corner" //L10n.Watch.Labels.ComplicationGroupMember.GraphicCorner.name
        case .rectangular:
            return "Rectangular" //L10n.Watch.Labels.ComplicationGroupMember.GraphicRectangular.name
        case .inline:
            return "Inline"
        }
    }

    public var description: String {
        switch self {
        case .inline:
            return "A square or rectangular area used in watch faces such as Utility, Motion, Chronograph, and Simple clock faces."
        case .corner:
            return L10n.Watch.Labels.ComplicationGroupMember.ModularSmall.description
        case .circular:
            return L10n.Watch.Labels.ComplicationGroupMember.UtilitarianLarge.description
        case .rectangular:
            return L10n.Watch.Labels.ComplicationGroupMember.UtilitarianSmallFlat.description
        }
    }

    public var templates: [AccessoryWidgetTemplate] {
        switch self {
        case .inline:
            return [.UtilitarianSmallRingImage, .UtilitarianSmallRingText, .UtilitarianSmallSquare, .UtilitarianSmallFlat, .UtilitarianLargeFlat]
        case .corner:
            return [
                .GraphicCornerCircularImage,
                .GraphicCornerGaugeImage,
                .GraphicCornerGaugeText,
                .GraphicCornerStackText,
                .GraphicCornerTextImage,
            ]
        case .circular:
            return [
                .GraphicCircularImage,
                .GraphicCircularClosedGaugeImage,
                .GraphicCircularOpenGaugeImage,
                .GraphicCircularClosedGaugeText,
                .GraphicCircularOpenGaugeSimpleText,
                .GraphicCircularOpenGaugeRangeText,
                .GraphicCircularStackImage,
                .GraphicCircularStackText,
                
            ]
        case .rectangular:
            return [.GraphicRectangularStandardBody, .GraphicRectangularTextGauge, .GraphicRectangularLargeImage]
        }
    }

    #if os(watchOS)
    public func fallbackTemplate(for identifier: String?) -> CLKComplicationTemplate {
        let logoImage = UIImage(named: "RoundLogo")!
        let templateImage = UIImage(named: "TemplateLogo")!
        let hassColor = AppConstants.tintColor
        let isPlaceholder = identifier?.starts(with: "placeholder") == true

        switch self {
        case .circular:
            let template = CLKComplicationTemplateGraphicCircularImage()
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: logoImage)
            return template
        case .corner:
            let template = CLKComplicationTemplateGraphicCornerCircularImage()
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: logoImage)
            return template
        case .rectangular:
            if isPlaceholder {
                let template = CLKComplicationTemplateGraphicRectangularFullImage()
                template.imageProvider = CLKFullColorImageProvider(fullColorImage: logoImage)
                return template
            } else {
                let template = CLKComplicationTemplateGraphicRectangularStandardBody()
                template.headerImageProvider = CLKFullColorImageProvider(fullColorImage: logoImage)
                template.headerTextProvider = CLKSimpleTextProvider(text: "Not configured")
                let desc = ComplicationTemplate.GraphicRectangularStandardBody.description
                template.body1TextProvider = CLKSimpleTextProvider(text: desc)
                template.body2TextProvider = CLKSimpleTextProvider(text: "has not been configured")
                return template
            }
        case .inline:
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            template.imageProvider = CLKImageProvider(onePieceImage: templateImage)
            template.tintColor = hassColor
            return template
        }
    }
    #endif
}

extension AccessoryWidgetGroup: CaseIterable {}

public enum AccessoryWidgetTemplate: String {
    case UtilitarianSmallFlat
    case UtilitarianSmallRingImage
    case UtilitarianSmallRingText
    case UtilitarianSmallSquare
    case UtilitarianLargeFlat
    case GraphicCornerCircularImage
    case GraphicCornerGaugeImage
    case GraphicCornerGaugeText
    case GraphicCornerStackText
    case GraphicCornerTextImage
    case GraphicCircularImage
    case GraphicCircularClosedGaugeImage
    case GraphicCircularOpenGaugeImage
    case GraphicCircularClosedGaugeText
    case GraphicCircularOpenGaugeSimpleText
    case GraphicCircularOpenGaugeRangeText
    case GraphicCircularStackImage
    case GraphicCircularStackText
    case GraphicRectangularStandardBody
    case GraphicRectangularTextGauge
    case GraphicRectangularLargeImage

    public var style: String {
        switch self {
        case .UtilitarianSmallRingImage:
            return L10n.Watch.Labels.ComplicationTemplate.Style.ringImage
        case .UtilitarianSmallRingText:
            return L10n.Watch.Labels.ComplicationTemplate.Style.ringText
        case .GraphicCornerStackText:
            return L10n.Watch.Labels.ComplicationTemplate.Style.stackText
        case .GraphicRectangularStandardBody:
            return L10n.Watch.Labels.ComplicationTemplate.Style.standardBody
        case .UtilitarianSmallFlat:
            return L10n.Watch.Labels.ComplicationTemplate.Style.flat
        case .UtilitarianLargeFlat:
            return "Large flat"
        case .UtilitarianSmallSquare:
            return L10n.Watch.Labels.ComplicationTemplate.Style.square
        case .GraphicCornerCircularImage, .GraphicCircularImage:
            return L10n.Watch.Labels.ComplicationTemplate.Style.circularImage
        case .GraphicCornerGaugeImage:
            return L10n.Watch.Labels.ComplicationTemplate.Style.gaugeImage
        case .GraphicCornerGaugeText:
            return L10n.Watch.Labels.ComplicationTemplate.Style.gaugeText
        case .GraphicCornerTextImage:
            return L10n.Watch.Labels.ComplicationTemplate.Style.textImage
        case .GraphicCircularClosedGaugeImage:
            return L10n.Watch.Labels.ComplicationTemplate.Style.closedGaugeImage
        case .GraphicCircularOpenGaugeImage:
            return L10n.Watch.Labels.ComplicationTemplate.Style.openGaugeImage
        case .GraphicCircularClosedGaugeText:
            return L10n.Watch.Labels.ComplicationTemplate.Style.closedGaugeText
        case .GraphicCircularOpenGaugeSimpleText:
            return L10n.Watch.Labels.ComplicationTemplate.Style.openGaugeSimpleText
        case .GraphicCircularStackImage:
            return "Stack Image"
        case .GraphicCircularStackText:
            return "Stack Text"
        case .GraphicCircularOpenGaugeRangeText:
            return L10n.Watch.Labels.ComplicationTemplate.Style.openGaugeRangeText
        case .GraphicRectangularTextGauge:
            return L10n.Watch.Labels.ComplicationTemplate.Style.textGauge
        case .GraphicRectangularLargeImage:
            return L10n.Watch.Labels.ComplicationTemplate.Style.largeImage
        }
    }

    public var description: String {
        switch self {
        case .UtilitarianSmallFlat:
            return L10n.Watch.Labels.ComplicationTemplate.UtilitarianSmallFlat.description
        case .UtilitarianSmallRingImage:
            return L10n.Watch.Labels.ComplicationTemplate.UtilitarianSmallRingImage.description
        case .UtilitarianSmallRingText:
            return L10n.Watch.Labels.ComplicationTemplate.UtilitarianSmallRingText.description
        case .UtilitarianSmallSquare:
            return L10n.Watch.Labels.ComplicationTemplate.UtilitarianSmallSquare.description
        case .UtilitarianLargeFlat:
            return L10n.Watch.Labels.ComplicationTemplate.UtilitarianLargeFlat.description
        case .GraphicCornerCircularImage:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCornerCircularImage.description
        case .GraphicCornerGaugeImage:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCornerGaugeImage.description
        case .GraphicCornerGaugeText:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCornerGaugeText.description
        case .GraphicCornerStackText:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCornerStackText.description
        case .GraphicCornerTextImage:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCornerTextImage.description
        case .GraphicCircularImage:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCircularImage.description
        case .GraphicCircularClosedGaugeImage:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCircularClosedGaugeImage.description
        case .GraphicCircularOpenGaugeImage:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCircularOpenGaugeImage.description
        case .GraphicCircularClosedGaugeText:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCircularClosedGaugeText.description
        case .GraphicCircularOpenGaugeSimpleText:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCircularOpenGaugeSimpleText.description
        case .GraphicCircularOpenGaugeRangeText:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicCircularOpenGaugeRangeText.description
        case .GraphicCircularStackImage:
            return L10n.Watch.Labels.ComplicationTemplate.CircularSmallStackImage.description
        case .GraphicCircularStackText:
            return L10n.Watch.Labels.ComplicationTemplate.CircularSmallStackText.description
        case .GraphicRectangularStandardBody:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicRectangularStandardBody.description
        case .GraphicRectangularTextGauge:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicRectangularTextGauge.description
        case .GraphicRectangularLargeImage:
            return L10n.Watch.Labels.ComplicationTemplate.GraphicRectangularLargeImage.description
        }
    }

    public var type: String {
        switch self {
        case .UtilitarianSmallFlat, .UtilitarianSmallRingImage, .UtilitarianSmallRingText:
            return "text"
        case .UtilitarianSmallSquare:
            return "image"
        case .UtilitarianLargeFlat:
            return "text"
        case .GraphicCornerGaugeText, .GraphicCornerStackText:
            return "text"
        case .GraphicCornerCircularImage, .GraphicCornerGaugeImage, .GraphicCornerTextImage:
            return "image"
        case .GraphicCircularClosedGaugeText, .GraphicCircularOpenGaugeSimpleText, .GraphicCircularOpenGaugeRangeText, .GraphicCircularStackText:
            return "text"
        case .GraphicCircularImage, .GraphicCircularClosedGaugeImage, .GraphicCircularOpenGaugeImage, .GraphicCircularStackImage:
            return "image"
        case .GraphicRectangularStandardBody, .GraphicRectangularTextGauge:
            return "text"
        case .GraphicRectangularLargeImage:
            return "image"
        }
    }

    public var groupMember: AccessoryWidgetGroup {
        switch self {
        case .UtilitarianSmallRingImage, .UtilitarianSmallRingText, .UtilitarianSmallSquare, .UtilitarianSmallFlat, .UtilitarianLargeFlat:
            return .inline
        case .GraphicCornerCircularImage, .GraphicCornerGaugeImage, .GraphicCornerGaugeText, .GraphicCornerStackText,
             .GraphicCornerTextImage:
            return .corner
        case .GraphicCircularImage, .GraphicCircularClosedGaugeImage, .GraphicCircularOpenGaugeImage,
             .GraphicCircularClosedGaugeText, .GraphicCircularOpenGaugeSimpleText, .GraphicCircularOpenGaugeRangeText, .GraphicCircularStackImage, .GraphicCircularStackText:
            return .circular
        case .GraphicRectangularStandardBody, .GraphicRectangularTextGauge, .GraphicRectangularLargeImage:
            return .rectangular
        }
    }

    public var textAreas: [AccessoryWidgetTextAreas] {
        switch self {
        case .UtilitarianSmallFlat:
            return [.Center]
        case .UtilitarianSmallRingImage:
            return []
        case .UtilitarianSmallRingText:
            return [.InsideRing]
        case .UtilitarianSmallSquare:
            return []
        case .UtilitarianLargeFlat:
            return [.Center]
        case .GraphicCornerCircularImage:
            return []
        case .GraphicCornerGaugeImage:
            return [.Leading, .Trailing]
        case .GraphicCornerGaugeText:
            return [.Outer, .Leading, .Trailing]
        case .GraphicCornerStackText:
            return [.Outer, .Inner]
        case .GraphicCornerTextImage:
            return [.Center]
        case .GraphicCircularImage:
            return []
        case .GraphicCircularClosedGaugeImage:
            return []
        case .GraphicCircularOpenGaugeImage:
            return [.Center]
        case .GraphicCircularClosedGaugeText:
            return [.Center]
        case .GraphicCircularOpenGaugeSimpleText:
            return [.Center, .Bottom]
        case .GraphicCircularOpenGaugeRangeText:
            return [.Center, .Leading, .Trailing]
        case .GraphicCircularStackImage:
            return [.Line2]
        case .GraphicCircularStackText:
            return [.Line1, .Line2]
        case .GraphicRectangularStandardBody:
            return [.Header, .Body1, .Body2]
        case .GraphicRectangularTextGauge:
            return [.Header, .Body1]
        case .GraphicRectangularLargeImage:
            return [.Header]
        }
    }

    #if os(watchOS)
    public init(_ template: CLKComplicationTemplate) {
        switch template {
        case is CLKComplicationTemplateUtilitarianSmallFlat:
            self = .UtilitarianSmallFlat
        case is CLKComplicationTemplateUtilitarianSmallRingImage:
            self = .UtilitarianSmallRingImage
        case is CLKComplicationTemplateUtilitarianSmallRingText:
            self = .UtilitarianSmallRingText
        case is CLKComplicationTemplateUtilitarianSmallSquare:
            self = .UtilitarianSmallSquare
        case is CLKComplicationTemplateUtilitarianLargeFlat:
            self = .UtilitarianLargeFlat
        case is CLKComplicationTemplateGraphicCornerCircularImage:
            self = .GraphicCornerCircularImage
        case is CLKComplicationTemplateGraphicCornerGaugeImage:
            self = .GraphicCornerGaugeImage
        case is CLKComplicationTemplateGraphicCornerGaugeText:
            self = .GraphicCornerGaugeText
        case is CLKComplicationTemplateGraphicCornerStackText:
            self = .GraphicCornerStackText
        case is CLKComplicationTemplateGraphicCornerTextImage:
            self = .GraphicCornerTextImage
        case is CLKComplicationTemplateGraphicCircularImage:
            self = .GraphicCircularImage
        case is CLKComplicationTemplateGraphicCircularClosedGaugeImage:
            self = .GraphicCircularClosedGaugeImage
        case is CLKComplicationTemplateGraphicCircularOpenGaugeImage:
            self = .GraphicCircularOpenGaugeImage
        case is CLKComplicationTemplateGraphicCircularClosedGaugeText:
            self = .GraphicCircularClosedGaugeText
        case is CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText:
            self = .GraphicCircularOpenGaugeSimpleText
        case is CLKComplicationTemplateGraphicCircularOpenGaugeRangeText:
            self = .GraphicCircularOpenGaugeRangeText
        case is CLKComplicationTemplateGraphicCircularStackImage:
            self = .GraphicCircularStackImage
        case is CLKComplicationTemplateGraphicCircularStackText:
            self = .GraphicCircularStackText
        case is CLKComplicationTemplateGraphicRectangularStandardBody:
            self = .GraphicRectangularStandardBody
        case is CLKComplicationTemplateGraphicRectangularTextGauge:
            self = .GraphicRectangularTextGauge
        case is CLKComplicationTemplateGraphicRectangularLargeImage:
            self = .GraphicRectangularLargeImage
        default:
            Current.Log.warning("Unknown template \(template)")
            self = .GraphicCircularImage
        }
    }

    public var CLKComplicationTemplate: CLKComplicationTemplate {
        switch self {
        case .UtilitarianSmallFlat:
            return CLKComplicationTemplateUtilitarianSmallFlat()
        case .UtilitarianSmallRingImage:
            return CLKComplicationTemplateUtilitarianSmallRingImage()
        case .UtilitarianSmallRingText:
            return CLKComplicationTemplateUtilitarianSmallRingText()
        case .UtilitarianSmallSquare:
            return CLKComplicationTemplateUtilitarianSmallSquare()
        case .UtilitarianLargeFlat:
            return CLKComplicationTemplateUtilitarianLargeFlat()
        case .GraphicCornerCircularImage:
            return CLKComplicationTemplateGraphicCornerCircularImage()
        case .GraphicCornerGaugeImage:
            return CLKComplicationTemplateGraphicCornerGaugeImage()
        case .GraphicCornerGaugeText:
            return CLKComplicationTemplateGraphicCornerGaugeText()
        case .GraphicCornerStackText:
            return CLKComplicationTemplateGraphicCornerStackText()
        case .GraphicCornerTextImage:
            return CLKComplicationTemplateGraphicCornerTextImage()
        case .GraphicCircularImage:
            return CLKComplicationTemplateGraphicCircularImage()
        case .GraphicCircularClosedGaugeImage:
            return CLKComplicationTemplateGraphicCircularClosedGaugeImage()
        case .GraphicCircularOpenGaugeImage:
            return CLKComplicationTemplateGraphicCircularOpenGaugeImage()
        case .GraphicCircularClosedGaugeText:
            return CLKComplicationTemplateGraphicCircularClosedGaugeText()
        case .GraphicCircularOpenGaugeSimpleText:
            return CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
        case .GraphicCircularOpenGaugeRangeText:
            return CLKComplicationTemplateGraphicCircularOpenGaugeRangeText()
        case .GraphicCircularStackImage:
            return CLKComplicationTemplateGraphicCircularStackImage()
        case .GraphicCircularStackText:
            return CLKComplicationTemplateGraphicCircularStackText()
        case .GraphicRectangularStandardBody:
            return CLKComplicationTemplateGraphicRectangularStandardBody()
        case .GraphicRectangularTextGauge:
            return CLKComplicationTemplateGraphicRectangularTextGauge()
        case .GraphicRectangularLargeImage:
            return CLKComplicationTemplateGraphicRectangularLargeImage()
        }
    }

    // https://gist.github.com/robbiet480/2a38d499323cb964d47b2f5d8004694a
    public var imageSize: CGSize? {
        // Template: Device Size: Image Size @2x in pixels -- odd format, but what Apple's docs use
        let imageSizes: [Self: [Int: CGSize]] = [
            .UtilitarianLargeFlat: [
                38: CGSize(width: 42, height: 18),
                40: CGSize(width: 44, height: 20),
                42: CGSize(width: 44, height: 20),
                44: CGSize(width: 49, height: 22),
            ],
            .GraphicCornerCircularImage: [
                40: CGSize(width: 64, height: 64),
                44: CGSize(width: 72, height: 72),
            ],
            .GraphicCornerGaugeImage: [
                40: CGSize(width: 40, height: 40),
                44: CGSize(width: 44, height: 44),
            ],
            .GraphicCornerTextImage: [
                40: CGSize(width: 40, height: 40),
                44: CGSize(width: 44, height: 44),
            ],
            .GraphicCircularImage: [
                40: CGSize(width: 84, height: 84),
                44: CGSize(width: 94, height: 94),
            ],
            .GraphicCircularClosedGaugeImage: [
                40: CGSize(width: 54, height: 54),
                44: CGSize(width: 62, height: 62),
            ],
            .GraphicCircularOpenGaugeImage: [
                40: CGSize(width: 22, height: 22),
                44: CGSize(width: 24, height: 24),
            ],
            .GraphicCircularStackImage: [
                40: CGSize(width: 84, height: 84),
                44: CGSize(width: 94, height: 94),
            ],
            .GraphicCircularStackText: [
                40: CGSize(width: 56, height: 28),
                44: CGSize(width: 62, height: 32),
            ],
            .GraphicRectangularLargeImage: [
                40: CGSize(width: 300, height: 94),
                44: CGSize(width: 342, height: 108),
            ],
            .GraphicRectangularStandardBody: [
                40: CGSize(width: 24, height: 24),
                44: CGSize(width: 27, height: 27),
            ],
            .GraphicRectangularTextGauge: [
                40: CGSize(width: 24, height: 24),
                44: CGSize(width: 27, height: 27),
            ],
        ]

        let deviceSize = WKInterfaceDevice.currentResolution().rawValue

        if let sizeDict = imageSizes[self], let size = sizeDict[deviceSize] ?? sizeDict[40] {
            // image sizes are in pixels at 2x, so we need to downsize to points
            return CGSize(width: size.width / 2.0, height: size.height / 2.0)
        }

        return nil
    }
    #endif

    public var hasRing: Bool {
        switch self {
        case .UtilitarianSmallRingImage, .UtilitarianSmallRingText:
            return true
        default:
            return false
        }
    }

    public var hasGauge: Bool {
        switch self {
        case .GraphicCircularClosedGaugeImage, .GraphicCircularClosedGaugeText, .GraphicCircularOpenGaugeImage,
             .GraphicCircularOpenGaugeRangeText, .GraphicCircularOpenGaugeSimpleText, .GraphicCornerGaugeImage,
             .GraphicCornerGaugeText, .GraphicRectangularTextGauge:
            return true
        default:
            return false
        }
    }

    public var gaugeCanBeEitherStyle: Bool {
        switch self {
        case .GraphicCornerGaugeImage, .GraphicCornerGaugeText, .GraphicRectangularTextGauge:
            return true
        default:
            return false
        }
    }

    public var gaugeIsOpenStyle: Bool {
        switch self {
        case .GraphicCircularOpenGaugeImage, .GraphicCircularOpenGaugeRangeText, .GraphicCircularOpenGaugeSimpleText:
            return true
        default:
            return false
        }
    }

    public var gaugeIsClosedStyle: Bool {
        switch self {
        case .GraphicCircularClosedGaugeImage, .GraphicCircularClosedGaugeText:
            return true
        default:
            return false
        }
    }

    public var hasImage: Bool {
        switch self {
        case .GraphicCircularClosedGaugeImage, .GraphicCircularImage,
                .GraphicCircularOpenGaugeImage, .GraphicCornerCircularImage, .GraphicCircularStackImage, .GraphicCornerGaugeImage,
             .GraphicCornerTextImage, .GraphicRectangularLargeImage, .GraphicRectangularStandardBody,
             .GraphicRectangularTextGauge, .UtilitarianLargeFlat,
             .UtilitarianSmallFlat, .UtilitarianSmallRingImage, .UtilitarianSmallSquare:
            return true
        default:
            return false
        }
    }

    public var supportsColumn2Alignment: Bool {
        switch self {
//        case  .ExtraLargeColumnsText:
//            return true
        default:
            return false
        }
    }
}

extension AccessoryWidgetTemplate: CaseIterable {}

public enum AccessoryWidgetTextAreas: String, CaseIterable {
    case Header = "Header"
    case Body1 = "Body 1"
    case Body2 = "Body 2"
    case Center = "Center"
    case Bottom = "Bottom"
    case Inner = "Inner"
    case InsideRing = "Inside Ring"
    case Leading = "Leading"
    case Line1 = "Line 1"
    case Line2 = "Line 2"
    case Outer = "Outer"
    case Row1Column1 = "Row 1, Column 1"
    case Row1Column2 = "Row 1, Column 2"
    case Row2Column1 = "Row 2, Column 1"
    case Row2Column2 = "Row 2, Column 2"
    case Row3Column1 = "Row 3, Column 1"
    case Row3Column2 = "Row 3, Column 2"
    case Trailing = "Trailing"

    public var description: String {
        switch self {
        case .Body1:
            return L10n.Watch.Labels.ComplicationTextAreas.Body1.description
        case .Body2:
            return L10n.Watch.Labels.ComplicationTextAreas.Body2.description
        case .Bottom:
            return L10n.Watch.Labels.ComplicationTextAreas.Bottom.description
        case .Center:
            return L10n.Watch.Labels.ComplicationTextAreas.Center.description
        case .Header:
            return L10n.Watch.Labels.ComplicationTextAreas.Header.description
        case .Inner:
            return L10n.Watch.Labels.ComplicationTextAreas.Inner.description
        case .InsideRing:
            return L10n.Watch.Labels.ComplicationTextAreas.InsideRing.description
        case .Leading:
            return L10n.Watch.Labels.ComplicationTextAreas.Leading.description
        case .Line1:
            return L10n.Watch.Labels.ComplicationTextAreas.Line1.description
        case .Line2:
            return L10n.Watch.Labels.ComplicationTextAreas.Line2.description
        case .Outer:
            return L10n.Watch.Labels.ComplicationTextAreas.Outer.description
        case .Row1Column1:
            return L10n.Watch.Labels.ComplicationTextAreas.Row1Column1.description
        case .Row1Column2:
            return L10n.Watch.Labels.ComplicationTextAreas.Row1Column2.description
        case .Row2Column1:
            return L10n.Watch.Labels.ComplicationTextAreas.Row2Column1.description
        case .Row2Column2:
            return L10n.Watch.Labels.ComplicationTextAreas.Row2Column2.description
        case .Row3Column1:
            return L10n.Watch.Labels.ComplicationTextAreas.Row3Column1.description
        case .Row3Column2:
            return L10n.Watch.Labels.ComplicationTextAreas.Row3Column2.description
        case .Trailing:
            return L10n.Watch.Labels.ComplicationTextAreas.Trailing.description
        }
    }

    public var label: String {
        switch self {
        case .Body1:
            return L10n.Watch.Labels.ComplicationTextAreas.Body1.label
        case .Body2:
            return L10n.Watch.Labels.ComplicationTextAreas.Body2.label
        case .Bottom:
            return L10n.Watch.Labels.ComplicationTextAreas.Bottom.label
        case .Center:
            return L10n.Watch.Labels.ComplicationTextAreas.Center.label
        case .Header:
            return L10n.Watch.Labels.ComplicationTextAreas.Header.label
        case .Inner:
            return L10n.Watch.Labels.ComplicationTextAreas.Inner.label
        case .InsideRing:
            return L10n.Watch.Labels.ComplicationTextAreas.InsideRing.label
        case .Leading:
            return L10n.Watch.Labels.ComplicationTextAreas.Leading.label
        case .Line1:
            return L10n.Watch.Labels.ComplicationTextAreas.Line1.label
        case .Line2:
            return L10n.Watch.Labels.ComplicationTextAreas.Line2.label
        case .Outer:
            return L10n.Watch.Labels.ComplicationTextAreas.Outer.label
        case .Row1Column1:
            return L10n.Watch.Labels.ComplicationTextAreas.Row1Column1.label
        case .Row1Column2:
            return L10n.Watch.Labels.ComplicationTextAreas.Row1Column2.label
        case .Row2Column1:
            return L10n.Watch.Labels.ComplicationTextAreas.Row2Column1.label
        case .Row2Column2:
            return L10n.Watch.Labels.ComplicationTextAreas.Row2Column2.label
        case .Row3Column1:
            return L10n.Watch.Labels.ComplicationTextAreas.Row3Column1.label
        case .Row3Column2:
            return L10n.Watch.Labels.ComplicationTextAreas.Row3Column2.label
        case .Trailing:
            return L10n.Watch.Labels.ComplicationTextAreas.Trailing.label
        }
    }

    public var slug: String {
        var cleanLocation = rawValue
        cleanLocation = cleanLocation.replacingOccurrences(of: " ", with: "")
        cleanLocation = cleanLocation.replacingOccurrences(of: ",", with: "")

        return cleanLocation
    }
}
