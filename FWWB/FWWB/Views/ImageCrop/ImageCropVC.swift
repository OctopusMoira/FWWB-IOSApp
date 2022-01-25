//
//  ImageCropVC.swift
//  FWWB
//
//  Created by 叶正茂 on 2018/12/15.
//  Copyright © 2018 fwwb. All rights reserved.
//

// TODO:
// 1. center image view
// 2. forbid going beyond the top and bottom side of image when dragging crop view
// 3. "cancel crop" button
// 4. after taking photos, no option to return to choose the source

import UIKit


class CropView: UIView {

    static var kResizeThumbSize:CGFloat = 60
    private typealias `Self` = CropView
    var isResizingLeftEdge:Bool = false
    var isResizingRightEdge:Bool = false
    var isResizingTopEdge:Bool = false
    var isResizingBottomEdge:Bool = false
    var touchBeginPoint:CGPoint = CGPoint(x: 0, y: 0)

    var corners: CAShapeLayer = CAShapeLayer()
    var imageBounds: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.setCorners(isInit: true)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /* cropview frame改变时重设边角 */
    override func layoutSubviews() {
        setCorners()
    }
    
    /* 更新imageview边界 */
    func updateImageBounds(bounds: CGRect) {
        imageBounds = bounds
    }
    
    /* 设置边角 */
    private func setCorners(isInit: Bool = false) {

        // corners' shape
        let path = UIBezierPath()
        // width and height
        let cornerLength = self.bounds.size.width * 0.05

        // top left corner
        let topLeftP = self.bounds.origin
        path.move(to: topLeftP)
        path.addLine(to: CGPoint(x: topLeftP.x + cornerLength, y: topLeftP.y))
        path.move(to: topLeftP)
        path.addLine(to: CGPoint(x: topLeftP.x, y: topLeftP.y + cornerLength))
        
        // top right corner
        let topRightP = CGPoint(x: topLeftP.x + self.bounds.size.width, y: topLeftP.y)
        path.move(to: topRightP)
        path.addLine(to: CGPoint(x: topRightP.x - cornerLength, y: topRightP.y))
        path.move(to: topRightP)
        path.addLine(to: CGPoint(x: topRightP.x, y: topRightP.y + cornerLength))
        
        // bottom left corner
        let bottomLeftP = CGPoint(x: topLeftP.x, y: topLeftP.y + self.bounds.size.height)
        path.move(to: bottomLeftP)
        path.addLine(to: CGPoint(x: bottomLeftP.x, y: bottomLeftP.y - cornerLength))
        path.move(to: bottomLeftP)
        path.addLine(to: CGPoint(x: bottomLeftP.x + cornerLength, y: bottomLeftP.y))
        
        // bottom right corner
        let bottomRightP = CGPoint(x: bottomLeftP.x + self.bounds.size.width, y: bottomLeftP.y)
        path.move(to: bottomRightP)
        path.addLine(to: CGPoint(x: bottomRightP.x - cornerLength, y: bottomRightP.y))
        path.move(to: bottomRightP)
        path.addLine(to: CGPoint(x: bottomRightP.x, y: bottomRightP.y - cornerLength))
        
        path.close()
        
        // set layer's path
        corners.path = path.cgPath
        // if init, add to view
        if isInit {
            print("init crop view corner")
            corners.lineWidth = 5.0
            corners.strokeColor = UIColor.black.cgColor
            self.layer.addSublayer(corners)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchBeginPoint = touch.location(in: self)

            isResizingLeftEdge = (touchBeginPoint.x < Self.kResizeThumbSize)
            isResizingTopEdge = (touchBeginPoint.y < Self.kResizeThumbSize)
            isResizingRightEdge = (self.bounds.size.width - touchBeginPoint.x < Self.kResizeThumbSize)
            isResizingBottomEdge = (self.bounds.size.height - touchBeginPoint.y < Self.kResizeThumbSize)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            
            // resizing edges
            if isResizingTopEdge {
                if self.frame.height > currentPoint.y {
                    self.frame = CGRect(
                        x: self.frame.origin.x,
                        y: self.frame.origin.y + currentPoint.y,
                        width: self.frame.width,
                        height: self.frame.height - currentPoint.y
                    )
                }
            }
            if isResizingBottomEdge {
                if currentPoint.y > 0 {
                    self.frame = CGRect(
                        x: self.frame.origin.x,
                        y: self.frame.origin.y,
                        width: self.frame.width,
                        height: currentPoint.y
                    )
                }
            }
            if isResizingLeftEdge {
                if currentPoint.x < self.frame.width {
                    self.frame = CGRect(
                        x: self.frame.origin.x + currentPoint.x,
                        y: self.frame.origin.y,
                        width: self.frame.width - currentPoint.x,
                        height: self.frame.height
                    )
                }
            }
            if isResizingRightEdge {
                if currentPoint.x > 0 {
                    self.frame = CGRect(
                        x: self.frame.origin.x,
                        y: self.frame.origin.y,
                        width: currentPoint.x,
                        height: self.frame.height
                    )
                }
            }

            if !isResizingBottomEdge && !isResizingRightEdge && !isResizingLeftEdge && !isResizingTopEdge {
                // hold and move the crop view
                let changeX = currentPoint.x - touchBeginPoint.x
                let changeY = currentPoint.y - touchBeginPoint.y
                var newFrame = CGRect(
                    x: self.frame.origin.x + changeX,
                    y: self.frame.origin.y + changeY,
                    width: self.frame.width,
                    height: self.frame.height
                )
                let screenBounds = UIScreen.main.bounds
                // check if go beyond image
                if newFrame.origin.y < imageBounds.origin.y {
                    newFrame.origin.y = imageBounds.origin.y
                }
                if newFrame.origin.y + newFrame.height > imageBounds.origin.y + imageBounds.height {
                    newFrame.origin.y = imageBounds.origin.y + imageBounds.height - newFrame.height
                }
                if newFrame.origin.x < screenBounds.origin.x {
                    newFrame.origin.x = screenBounds.origin.x
                }
                if newFrame.origin.x + newFrame.width > screenBounds.origin.x + screenBounds.width {
                    newFrame.origin.x = screenBounds.origin.x + screenBounds.width - newFrame.width
                }
                self.frame = newFrame
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            isResizingLeftEdge = false
            isResizingRightEdge = false
            isResizingTopEdge = false
            isResizingBottomEdge = false
        }
    }
}


class ImageCropVC: UIViewController, UIScrollViewDelegate {
    
    var imageView = UIImageView()
    var scrollView = UIScrollView()
    var cropAreaView = CropView()
    var cropButton = UIButton()
    var originalImage:UIImage?
    var croppedImage:UIImage?
    var displayImage:UIImage? {
        didSet {
            displayImage = displayImage?.fixedOrientation()
            imageView.frame.size = displayImage!.size
            imageView.image = displayImage
            // set up init zoom scale to make the image fit the imageview
            let minimumScale = scrollView.frame.size.width / imageView.frame.size.width
            scrollView.minimumZoomScale = minimumScale
            scrollView.maximumZoomScale = 10
            scrollView.zoomScale = minimumScale
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // set up scrollview
        scrollView.frame = view.bounds
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80.0).isActive = true

        // set up imageview
        displayImage = originalImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        // set up crop area view
        cropAreaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cropAreaView)
        cropAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cropAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cropAreaView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cropAreaView.widthAnchor.constraint(equalTo: cropAreaView.heightAnchor, multiplier: 2).isActive = true
        cropAreaView.backgroundColor = UIColor(white: 1, alpha: 0.5)

        // set up button
        cropButton.setTitle("裁剪", for: .normal)
        cropButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cropButton)
        cropButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        cropButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80).isActive = true
        cropButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor,  constant: 20).isActive = true
        cropButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        cropButton.addTarget(self, action: #selector(self.crop), for: .touchDown)
    }

    /* 返回需要缩放的view */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    /* 缩放响应 */
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // set scrollview content size
        let imageViewSize = self.imageView.frame.size
        scrollView.contentSize = imageViewSize
        // 将imageview边界传给cropview
        let imageBounds = CGRect(
            x: scrollView.contentOffset.x,
            y: scrollView.contentOffset.y + scrollView.frame.origin.y,
            width: imageViewSize.width,
            height: imageViewSize.height
        )
        cropAreaView.updateImageBounds(bounds: imageBounds)
    }

    /* scrollview 滚动事件 */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 将imageview边界传给cropview
        let imageBounds = CGRect(
            x: scrollView.frame.origin.x,
            y: scrollView.frame.origin.y,
            width: scrollView.contentSize.width / (scrollView.zoomScale / scrollView.minimumZoomScale),
            height: scrollView.contentSize.height / (scrollView.zoomScale / scrollView.minimumZoomScale)
        )
        cropAreaView.updateImageBounds(bounds: imageBounds)
    }
   
    
    @objc func crop() {
        if cropButton.titleLabel?.text == "裁剪" {
            let cropFrame = cropAreaView.frame
            let cropRect = CGRect(
                x: (scrollView.contentOffset.x + cropFrame.origin.x - scrollView.frame.origin.x) / scrollView.zoomScale * originalImage!.scale,
                y: (scrollView.contentOffset.y + cropFrame.origin.y - scrollView.frame.origin.y) / scrollView.zoomScale * originalImage!.scale,
                width: cropFrame.width / scrollView.zoomScale * originalImage!.scale,
                height: cropFrame.height / scrollView.zoomScale * originalImage!.scale
            )
            let cgImage = displayImage?.cgImage
            croppedImage = UIImage(cgImage: (cgImage!.cropping(to: cropRect))!, scale: originalImage!.scale,orientation: .up)
            displayImage = croppedImage
            cropAreaView.isHidden = true
            cropButton.setTitle("确定", for: .normal)
        } else {
            // 确定
            let storyboard = UIStoryboard(name: "ImageResult", bundle: nil)
            let controller:ImageResultVC = storyboard.instantiateViewController(withIdentifier: "ImageResult") as! ImageResultVC
            controller.image = croppedImage
            self.present(controller, animated: true, completion: nil)
        }
    }
}

// https://gist.github.com/schickling/b5d86cb070130f80bb40#gistcomment-1898578
extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
