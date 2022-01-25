//
//  CustomTabBarController.swift
//  FWWB
//
//  Created by 叶正茂 on 2018/11/30.
//  Copyright © 2018 fwwb. All rights reserved.
//

import UIKit
import Photos

/*TabBarContorller*/
open class  MainTabbarVC: UITabBarController,UINavigationControllerDelegate{
    
    let titleArray = [
        NSLocalizedString("zhuye", comment: ""),
        NSLocalizedString("sousuo", comment: ""),
        "",
        NSLocalizedString("fanyi", comment: ""),
        NSLocalizedString("wo", comment: "")]
    let imgArray = ["zhuye","sousuo","paishe","fanyi","wo"]
    let imgArrayS = ["zhuyeS","sousuoS","paisheS","fanyiS","woS"]
    
    var selButton : UIButton?
    var selButtonTag : Int = 0
    fileprivate let defaultsel = 0
    fileprivate let defaulttag = 2000
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.backgroundColor = cTabbarBackground
        
        addButtons()
        addViewControllers()
    }
    
    // 移除Tabbar自带的button
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for view in self.tabBar.subviews{
            if view.isKind(of: NSClassFromString("UITabBarButton")!){
                view.removeFromSuperview()
            }
        }
    }
}

extension MainTabbarVC{
    // 添加控制视图
    fileprivate func addViewControllers(){
        let voidview = UIViewController()
        
        let indexview = UIStoryboard(name: "Index", bundle: nil).instantiateViewController(withIdentifier: "index")
        let translateview = UIStoryboard(name: "Translate", bundle: nil).instantiateViewController(withIdentifier: "translate")
        let searchview = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "search")
        let meview = UIStoryboard(name: "Me", bundle: nil).instantiateViewController(withIdentifier: "me")
        let vcs = [indexview,searchview,voidview,translateview,meview]
        viewControllers = vcs
        selectedIndex = defaultsel
        selButton?.setImage(UIImage(named: imgArrayS[defaultsel]) , for: .normal)
        selButton?.setTitleColor(cTabbarButtonSel, for: .normal)
    }
}

extension MainTabbarVC{
    // 添加Tabbar按钮
    fileprivate func addButtons(){
        let width = tabBar.frame.width
        let height = tabBar.frame.height
        
        for i in 0..<5{
            if i==2 {continue}
            let rect = CGRect(
                x: CGFloat(i)*(width/5.0), y: 0,
                width: width/5.0, height: height)
            let btn = TabBarButton(frame: rect, title: titleArray[i], titleImg: imgArray[i])
            
            if i==defaultsel{
                btn.isSelected = true
                selButton = btn
            }
            btn.tag = i+defaulttag
            btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
            tabBar.addSubview(btn)
        }
        
        let prewidth = width / 5.0
        let bottomRect = CGRect(
            x: tabBar.center.x-prewidth/2.0, y: 0-prewidth*(1-0.618),
            width: prewidth, height: prewidth)
        let btn = TabBarCenterButton(frame: bottomRect)
        btn.button.tag = defaulttag + 2
        btn.button.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
        tabBar.addSubview(btn)
    }
    
    // 按钮响应函数
    @objc fileprivate func btnAction(_ sender:UIButton){
        print("test test down button")
        switch sender.tag {
        case defaulttag + 2:
            chooseImage()
        default:
            selButton?.isSelected = false
            selButton?.setImage(UIImage(named: imgArray[selButtonTag]) , for: .normal)
            selButton?.setTitleColor(cTabbarButtonTitle, for: .normal)
            selButton = sender
            selButtonTag = sender.tag - defaulttag
            selectedIndex = selButtonTag
            selButton?.isSelected = true
            selButton?.setImage(UIImage(named: imgArrayS[selButtonTag]) , for: .normal)
            selButton?.setTitleColor(cTabbarButtonSel, for: .normal)
        }
    }
    
}

extension MainTabbarVC:UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let img = info[.originalImage] as? UIImage
        // let imageChooseVc = UIStoryboard(name: "ImageChoose", bundle: nil).instantiateViewController(withIdentifier: "ImageChoose") as! ImageChooseVC
        // imageChooseVc.originalImage = img
        let imageCropVC = ImageCropVC()
        imageCropVC.originalImage = img
        picker.pushViewController(imageCropVC, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func checkPhotoPermission(){
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        switch photoStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("请求成功")
                }else{
                    print("相机请求失败")
                }
            })
        default:
            break
        }
    }
    
    private func chooseImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "选取", message: "选择来源", preferredStyle: .actionSheet)
        // 未测试 TODO
        actionSheet.addAction(UIAlertAction(title: "照相机", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("照相机不可用")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "照片库", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            // 权限问题
            self.checkPhotoPermission()
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}
