import UIKit

public protocol SlideVerifyDelegate {
    func finish()
}

@IBDesignable
open class SlideVerifyView: UIView {

    private var thumbImageView = UIImageView()

    private var thumbnailView: UIView?

    private var successImageView = UIImageView()

    private var successView: UIView?

    private let maskLayer = CALayer()

    private let bgProcessLayer = CALayer()

    private let textLayer = CenterTextLayer()

    private var editable = true

    public var delete: SlideVerifyDelegate?

    @IBInspectable open var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable open var borderColor: UIColor = UIColor.gray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable open var bgColor: UIColor = UIColor.lightGray {
        didSet {
            self.layer.backgroundColor = bgColor.cgColor
        }
    }

    @IBInspectable open var processColor: UIColor = UIColor.red {
        didSet {
            self.bgProcessLayer.backgroundColor = processColor.cgColor
        }
    }

    @IBInspectable open var text: String = "" {
        didSet {
            textLayer.string = text
        }
    }

    @IBInspectable open var textColor: UIColor = UIColor.white {
        didSet {
            textLayer.foregroundColor = textColor.cgColor
        }
    }

    @IBInspectable open var cornerRadius: CGFloat = 8.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable open var thumbImage: UIImage? {
        didSet {
            thumbImageView.image = thumbImage
        }
    }

    @IBInspectable open var successImage: UIImage? {
        didSet {
            successImageView.image = successImage
        }
    }

    private var xtouch: CGFloat = 0.0 {
        didSet {
            refresh()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.backgroundColor = bgColor.cgColor
        self.layer.cornerRadius = cornerRadius
        self.thumbImageView.image = thumbImage
        self.successImageView.image = successImage

        ///init back ground layer
        bgProcessLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        bgProcessLayer.cornerRadius = cornerRadius
        bgProcessLayer.backgroundColor = processColor.cgColor
        layer.addSublayer(bgProcessLayer)

        ///init mask layer
        maskLayer.backgroundColor = UIColor.blue.cgColor
        bgProcessLayer.mask = maskLayer

        ///thumbnail view
        thumbnailView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.height, height: self.layer.frame.size.height))
        thumbnailView!.layer.backgroundColor = UIColor.white.cgColor
        thumbnailView!.contentMode = .center
        thumbImageView.frame = CGRect(x: self.frame.height/2 - 8, y: self.frame.height/2 - 8, width: 16.0, height: 16.0)
        thumbnailView!.addSubview(thumbImageView)
        addSubview(thumbnailView!)

        ///finish check view
        successView = UIView(frame: CGRect(x: self.frame.width - self.frame.height, y: 0.0, width: self.frame.height, height: self.frame.height))
        successView!.layer.backgroundColor = UIColor.white.cgColor
        successView!.contentMode = .center
        successImageView.frame = CGRect(x: self.frame.height/2 - 8, y:  self.frame.height/2 - 8, width: 16, height: 16)
        successView?.addSubview(successImageView)

        ///text layer
        textLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        textLayer.fontSize = 14
        textLayer.foregroundColor = textColor.cgColor
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(textLayer)
    }

    func updateLocation(_ touch: UITouch) {
        let touchLocation = touch.location(in: self)
        self.xtouch = touchLocation.x
    }

    func refresh() {
        ///refresh maskLayer
        maskLayer.frame = CGRect(x: 0.0, y: 0.0, width: xtouch, height: self.frame.size.height)
        maskLayer.removeAllAnimations()
        ///refresh thumbnail view
        thumbnailView?.frame = CGRect(x: xtouch, y: 0.0, width: self.frame.size.height, height: self.frame.size.height)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        ///set frame on layoutSubviews
        bgProcessLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        thumbnailView?.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.height, height: self.layer.frame.size.height)
        thumbImageView.frame = CGRect(x: self.frame.height/2 - 8, y: self.frame.height/2 - 8, width: 16.0, height: 16.0)
        successView?.frame = CGRect(x: self.frame.width - self.frame.height, y: 0.0, width: self.frame.height, height: self.frame.height)
        successImageView.frame = CGRect(x: self.frame.height/2 - 8, y:  self.frame.height/2 - 8, width: 16, height: 16)
        textLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        refresh()
    }

    func toBeginPosAnim() {
        xtouch = 0
    }

    // MARK: - Touch events
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if self.editable {
            updateLocation(touch)
        }
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if self.editable {
            updateLocation(touch)
            if xtouch >= self.frame.size.width - self.frame.size.height {
                editable = false
                self.thumbnailView?.removeFromSuperview()
                self.addSubview(successView!)
                self.delete?.finish()
            }
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.editable {
            toBeginPosAnim()
        }
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.editable {
            toBeginPosAnim()
        }
    }

}
