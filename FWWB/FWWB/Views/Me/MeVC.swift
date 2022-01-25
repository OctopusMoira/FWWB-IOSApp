//
//  MeVC.swift
//  FWWB
//
//  Created by ZQ on 2019/3/17.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit

struct appuser {
    let username: String
    let avatar: String
}

class MeVC: UIViewController, UIGestureRecognizerDelegate {
    
    let backGround = MyCanvas(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let sectionView = UIView(frame: CGRect(x: UIScreen.main.bounds.width*0.07, y: UIScreen.main.bounds.height*0.428, width: UIScreen.main.bounds.width*0.816, height: UIScreen.main.bounds.height*0.321))
    let textZu = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.179, y: UIScreen.main.bounds.height*0.519, width: 110, height: 130))
    let textShou = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.456, y: UIScreen.main.bounds.height*0.454, width: 70, height: 80))
    let textJing = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.627, y: UIScreen.main.bounds.height*0.619, width: 110, height: 100))
    let textJi = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.179, y: UIScreen.main.bounds.height*0.448, width: 110, height: 130))
    let textCang = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.73, y: UIScreen.main.bounds.height*0.421, width: 70, height: 80))
    let textShi = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height*0.586, width: 80, height: 80))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userzq = appuser(username: "ShowThailong", avatar: "avatarZQ.png")
        let cr : CGFloat = 30.0
        let avatarImgView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width*0.18 - cr, y: UIScreen.main.bounds.height*0.187-cr, width: cr*2, height: cr*2))
        let nameLabel: UILabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.18 + cr + 15, y: UIScreen.main.bounds.height*0.187 - cr/2, width: UIScreen.main.bounds.width*0.5, height: cr))
        
        self.view.addSubview(backGround)
        
        
        avatarImgView.layer.cornerRadius = cr
        avatarImgView.clipsToBounds = true
        avatarImgView.image = UIImage(named: userzq.avatar)
        self.view.addSubview(avatarImgView)
        
        nameLabel.text = userzq.username
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        self.view.addSubview(nameLabel)
        
        //375 667
        //306 214
        let rec1View = UIView(frame: CGRect(x: 0, y: 0, width: sectionView.bounds.width*0.431, height: sectionView.bounds.height))
        rec1View.backgroundColor = sectionsLight
        rec1View.layer.cornerRadius = 6
        //
        let clickRec1 = UITapGestureRecognizer(target: self, action: #selector(self.click1))
        clickRec1.delegate = self
        rec1View.addGestureRecognizer(clickRec1)
        
        let rec2View = UIView(frame: CGRect(x: sectionView.bounds.width*0.484, y: 0, width: sectionView.bounds.width*0.516, height: sectionView.bounds.height*0.458))
        rec2View.backgroundColor = sectionsLight
        rec2View.layer.cornerRadius = 6
        //
        let clickRec2 = UITapGestureRecognizer(target: self, action: #selector(self.click2))
        clickRec2.delegate = self
        rec2View.addGestureRecognizer(clickRec2)
        
        let rec3View = UIView(frame: CGRect(x: sectionView.bounds.width*0.484, y: sectionView.bounds.height*0.54, width: sectionView.bounds.width*0.516, height: sectionView.bounds.height*0.458))
        rec3View.backgroundColor = sectionsLight
        rec3View.layer.cornerRadius = 6
        //
        let clickRec3 = UITapGestureRecognizer(target: self, action: #selector(self.click3))
        clickRec3.delegate = self
        rec3View.addGestureRecognizer(clickRec3)
        
        //
        let shadowColor0 = UIColor(white: 0, alpha: 0.5).cgColor
        let shadowOffset0 = CGSize(width: 3, height: 3)
        let shadowOpacity0: Float = 0.5
        let shadowRadius0: CGFloat = 5.0
        rec1View.layer.shadowColor = shadowColor0
        rec1View.layer.shadowOffset = shadowOffset0
        rec1View.layer.shadowRadius = shadowRadius0
        rec1View.layer.shadowOpacity = shadowOpacity0
        rec2View.layer.shadowColor = shadowColor0
        rec2View.layer.shadowOffset = shadowOffset0
        rec2View.layer.shadowRadius = shadowRadius0
        rec2View.layer.shadowOpacity = shadowOpacity0
        rec3View.layer.shadowColor = shadowColor0
        rec3View.layer.shadowOffset = shadowOffset0
        rec3View.layer.shadowRadius = shadowRadius0
        rec3View.layer.shadowOpacity = shadowOpacity0
        
        sectionView.addSubview(rec1View)
        sectionView.addSubview(rec2View)
        sectionView.addSubview(rec3View)
        
        self.view.addSubview(sectionView)

    }
    
    @objc func click1(){
        print("click1")
        let sb = UIStoryboard(name: "FootPrint", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "FootPrintVC") as! FootPrintVC
        self.present(vc, animated: true, completion: nil)
    }
    @objc func click2(){
        print("click2")
        let sb = UIStoryboard(name: "CollectView", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CollectViewVC") as! CollectViewVC
        self.present(vc, animated: true, completion: nil)
    }
    @objc func click3(){
        print("click3")
        let sb = UIStoryboard(name: "RecView", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RecViewVC") as! RecViewVC
        self.present(vc, animated: true, completion: nil)
    }
    
    //375 667
    func startAnimation() {
        
        textZu.text = "足"
        textShou.text = "收"
        textJing.text = "景"
        textJi.text = "迹"
        textCang.text = "藏"
        textShi.text = "识"
        
        textZu.textColor = cBubbleColorHeavy
        textZu.alpha = 1.0
        textZu.font = UIFont.boldSystemFont(ofSize: 104)
        self.view.addSubview(textZu)
        
        textShou.textColor = UIColor.white
        textShou.alpha = 1.0
        textShou.font = UIFont.boldSystemFont(ofSize: 58)
        self.view.addSubview(textShou)
        
        textJing.textColor = UIColor.white
        textJing.alpha = 1.0
        textJing.font = UIFont.boldSystemFont(ofSize: 74)
        self.view.addSubview(textJing)
        
        textJi.textColor = cBubbleColorHeavy
        textJi.alpha = 0.0
        textJi.font = UIFont.boldSystemFont(ofSize: 104)
        self.view.addSubview(textJi)
        
        textCang.textColor = UIColor.white
        textCang.alpha = 0.0
        textCang.font = UIFont.boldSystemFont(ofSize: 58)
        self.view.addSubview(textCang)
        
        textShi.textColor = UIColor.white
        textShi.alpha = 0.0
        textShi.font = UIFont.boldSystemFont(ofSize: 62)
        self.view.addSubview(textShi)
        
        ani()
        
    }
    
    func ani(){
        UIView.animate(withDuration: 2.0, delay: 1.3, options: [.curveEaseInOut], animations: {
            self.textZu.alpha = 0.0
            self.textShou.alpha = 0.0
            self.textJing.alpha = 0.0
        }, completion: {(Bool) in
            UIView.animate(withDuration: 5.0, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.textJi.alpha = 1.0
                self.textCang.alpha = 1.0
                self.textShi.alpha = 1.0
            }, completion: {(Bool) in
                self.textZu.removeFromSuperview()
                self.textShou.removeFromSuperview()
                self.textJing.removeFromSuperview()
                print("ended all")
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUserInfo(){
        
    }
    
}

class MyCanvas: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        //band1
        let band11 = CGPoint(x: 0, y: UIScreen.main.bounds.height*0.6)
        let band12 = CGPoint(x: 0, y: UIScreen.main.bounds.height)
        let band13 = CGPoint(x: UIScreen.main.bounds.width*0.4, y: UIScreen.main.bounds.height)
        let band14 = CGPoint(x: UIScreen.main.bounds.width*1.2, y: UIScreen.main.bounds.height*0.22)
        
        let bezierPath1 = UIBezierPath()
        bezierPath1.move(to: band11)
        bezierPath1.addLine(to: band12)
        bezierPath1.addLine(to: band13)
        bezierPath1.addLine(to: band14)
        bezierPath1.close()
        
        cBubbleColorLight.setFill()
        cBubbleColorLight.setStroke()
        bezierPath1.fill()
        bezierPath1.stroke()
        
        context!.saveGState()
        
        //cardMain
        let card = CGRect(x: UIScreen.main.bounds.width*0.18, y: UIScreen.main.bounds.height*0.09, width: UIScreen.main.bounds.width*0.752, height: UIScreen.main.bounds.height*0.773)
        let cardMain = UIBezierPath(roundedRect: card, cornerRadius: 6)
        cBubbleColorHeavy.setFill()
        cBubbleColorHeavy.setStroke()
        cardMain.stroke()
        context!.saveGState()
        
        //shadow
        let shadowColor = UIColor(white: 0, alpha: 0.5).cgColor//UIColor.black.cgColor
        let shadowOffset = CGSize(width: 3, height: 3)
        let shadowBlurRadius:CGFloat = 5.0
        
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadowColor)
        cardMain.fill()
        context!.restoreGState()
        
        //375 667
        
        //band2
        let band21 = CGPoint(x: UIScreen.main.bounds.width*0.35, y: 0)
        let band22 = CGPoint(x: UIScreen.main.bounds.width*0.647, y: 0)
        let band23 = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height*0.16)
        let band24 = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height*0.175)
        
        let bezierPath2 = UIBezierPath()
        bezierPath2.move(to: band21)
        bezierPath2.addLine(to: band22)
        bezierPath2.addLine(to: band23)
        bezierPath2.addLine(to: band24)
        bezierPath2.close()
        
        cBubbleColorLight.setFill()
        cBubbleColorLight.setStroke()
        bezierPath2.stroke()
        
        //shadow
        let shadowColor2 = UIColor(white: 0, alpha: 0.5).cgColor//UIColor.black.cgColor
        let shadowOffset2 = CGSize(width: -3, height: 3)
        let shadowBlurRadius2:CGFloat = 7.0
        
        context?.setShadow(offset: shadowOffset2, blur: shadowBlurRadius2, color: shadowColor2)
        bezierPath2.fill()
        context!.restoreGState()
        
        //avatar back
        let circleR : CGFloat = 35.0
        UIColor.white.setFill()
        context?.fillEllipse(in: CGRect(x: UIScreen.main.bounds.width*0.18 - circleR, y: UIScreen.main.bounds.height*0.187-circleR, width: circleR*2, height: circleR*2))
    }
    
}
