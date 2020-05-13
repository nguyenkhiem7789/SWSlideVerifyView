import UIKit

@IBDesignable
class SlideVerifyView: UIView {

    private var thumbImageView = UIImageView()

    private var thumbnailView: UIView?

    private var successImageView = UIImageView()

    private var successView: UIView?

    let maskLayer = CALayer()

    let bgLayer = CALayer()

    private var editable = true

    @IBInspectable
    open var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    open var borderColor: CGColor = UIColor.gray.cgColor {
        didSet {
            self.layer.borderColor = borderColor
        }
    }

    @IBInspectable
    open var cornerRadius: CGFloat = 8.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    open var thumbImage: UIImage? {
        didSet {
            thumbImageView.image = thumbImage
        }
    }

    @IBInspectable
    open var successImage: UIImage? {
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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = cornerRadius
        self.thumbImageView.image = thumbImage
        self.successImageView.image = successImage

        ///init back ground layer
        bgLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        bgLayer.cornerRadius = cornerRadius
        bgLayer.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(bgLayer)

        /// thumbnail view
        thumbnailView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.height, height: self.layer.frame.size.height))
        thumbnailView!.layer.backgroundColor = UIColor.white.cgColor
        thumbnailView!.contentMode = .center
        thumbImageView.frame = CGRect(x: self.frame.height/2 - 8, y: self.frame.height/2 - 8, width: 16.0, height: 16.0)
        thumbnailView!.addSubview(thumbImageView)
        addSubview(thumbnailView!)

        /// finish check view
        successView = UIView(frame: CGRect(x: self.frame.width - self.frame.height, y: 0.0, width: self.frame.height, height: self.frame.height))
        successView!.layer.backgroundColor = UIColor.white.cgColor
        successView!.contentMode = .center
        successImageView.frame = CGRect(x: self.thumbnailView!.frame.width/2 - 8, y:  self.thumbnailView!.frame.height/2 - 8, width: 16, height: 16)
        successView?.addSubview(successImageView)
    }

    func updateLocation(_ touch: UITouch) {
        let touchLocation = touch.location(in: self)
        self.xtouch = touchLocation.x
    }

    func refresh() {
        ///refresh maskLayer
        maskLayer.frame = CGRect(x: 0.0, y: 0.0, width: xtouch, height: self.frame.size.height)
        maskLayer.backgroundColor = UIColor.blue.cgColor
        maskLayer.removeAllAnimations()
        bgLayer.mask = maskLayer
        ///refresh thumbnail view
        thumbnailView?.frame = CGRect(x: xtouch, y: 0.0, width: self.frame.size.height, height: self.frame.size.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func toBeginPosAnim() {
        xtouch = 0
    }

    // MARK: - Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if self.editable {
            updateLocation(touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if self.editable {
            updateLocation(touch)
            if xtouch >= self.frame.size.width - self.frame.size.height {
                editable = false
                self.thumbnailView?.removeFromSuperview()
                self.addSubview(successView!)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.editable {
            toBeginPosAnim()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        toBeginPosAnim()
    }

}
