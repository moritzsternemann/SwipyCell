import UIKit

public class GradientView: UIView {

    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

}
