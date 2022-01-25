//
//  ViewController.swift
//  FWWB
//
//  Created by ZQ on 2019/3/10.
//  Copyright © 2019年 ZQ. All rights reserved.
//

import UIKit
import CommonCrypto
import AVFoundation
import MediaPlayer

var nationality: Bool = false

func MD5(_ string: String) -> String? {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)
    
    if let d = string.data(using: String.Encoding.utf8) {
        _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            CC_MD5(body, CC_LONG(d.count), &digest)
        }
    }
    
    return (0..<length).reduce("") {
        $0 + String(format: "%02x", digest[$1])
    }
}

class ViewController: UIViewController, TransChatDataSource,UITextFieldDelegate,AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var SrcLanguage: UIImageView!
    @IBOutlet weak var TarLanguage: UIImageView!    //好像名字取反了
    @IBAction func exchange(_ sender: Any) {
        switch nationality
        {
        case true:
            SrcLanguage.image = UIImage(named: "riben.png")
            TarLanguage.image = UIImage(named: "zhongguo.png")
            break
        case false:
            SrcLanguage.image = UIImage(named: "zhongguo.png")
            TarLanguage.image = UIImage(named: "riben.png")
            break
        }
        nationality = !nationality
        print(nationality)
        
    }
    
    var Chats:NSMutableArray!
    var tableView:TransTableView!
    var txtMsg:UITextField!
    var me:TransUserInfo!
    var you:TransUserInfo!
    var avPlayer: AVAudioPlayer!
    var audUrl: NSURL!
    let synth = AVSpeechSynthesizer()
    let audioSession = AVAudioSession.sharedInstance()
    //var kbState: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SrcLanguage.image = UIImage(named: "riben.png")
        TarLanguage.image = UIImage(named: "zhongguo.png")
        
        setupChatTable()
        setupSendPanel()
        
        let target = UITapGestureRecognizer(target: self, action: #selector(self.avatarAction))
        target.numberOfTapsRequired = 1
        self.SrcLanguage.isUserInteractionEnabled = true
        self.SrcLanguage.addGestureRecognizer(target)
        let targetz = UITapGestureRecognizer(target: self, action: #selector(self.avatarAction))
        targetz.numberOfTapsRequired = 1
        self.TarLanguage.isUserInteractionEnabled = true
        self.TarLanguage.addGestureRecognizer(targetz)
        
        let blank = UITapGestureRecognizer(target: self, action: #selector(self.blankTap))
        //self.view.addGestureRecognizer(blank)

         synth.delegate = self
        
    }
    
    @objc func avatarAction()
    {
        print("clicked me")
        UIApplication.shared.keyWindow?.endEditing(true)
        //试图点按头像 开启编辑模式 复杂 暂时舍去
    }
    
    @objc func blankTap(){
            UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    func setupSendPanel()
    {
        print("enter SendPanel")
        let screenWidth = UIScreen.main.bounds.width
        let sendView = UIView(frame:CGRect(x: 20,y: 20+73,width: screenWidth - 40, height: 40))
        
        sendView.backgroundColor=cTabbarButtonSel
        sendView.alpha=0.9
        
        txtMsg = UITextField(frame:CGRect(x: 2,y: 2,width: screenWidth-44, height: 36))
        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor=cTabbarButtonSel
        txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)
        
        print("out sendPanel")
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
    @objc func sendMessage()
    {
        let sender = txtMsg
        
        if(sender!.text! == ""){
            return
        }
        print("not nil")
        let thisChat =  TransMessageItem(body:"\(sender!.text!)" as NSString, user:me, date:Date(), mtype:ChatType.mine)
        Chats.add(thisChat)
        translate(content: sender!.text!)
        print("yes translate")
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        sender?.resignFirstResponder()
        sender?.text = ""
    }
    
    func translate(content: String){
        
        let appid : String = "20160404000017508"
        let secrtkey : String = "P7KflEZwz1LfVqaPdtih"
        
        let languagedic = ["中文":"zh","日文":"jp"]
        var from : String = languagedic["中文"]!
        var to : String = languagedic["日文"]!
        
        switch nationality {
        case true:
            from = languagedic["日文"]!
            to = languagedic["中文"]!
        case false:
            from = languagedic["中文"]!
            to = languagedic["日文"]!
        }
        
        let q : String = content
        
        let salt = "123"
        
        let rawsign = appid+q+salt+secrtkey
        let sign = MD5(rawsign)
        
        let rawurl : String = "https://fanyi-api.baidu.com/api/trans/vip/translate"
        var urlArg : String = "q=" + q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&from=" + from + "&to=" + to
        urlArg = urlArg + "&appid=" + appid + "&salt=" + salt + "&sign=" + sign!
        
        //let audurl : String = "http://tts.baidu.com/text2audio?lan=zh&ie=UTF-8&spd=2&text="
        /*let audurl: String = "http://tsn.baidu.com/text2audio"
        let mac: String = "08:6d:41:cd:4a:14"
        let audtok: String = "24.bb40ec9050b7503fa32555243f1ced77.2592000.1555721510.282335-15809632"
        */
        let url = URL(string: rawurl+"?"+urlArg)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request){ data,respons,error in
            guard let data = data ,error == nil else{
                return
            }
            DispatchQueue.main.sync {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    guard let items = responseJSON["trans_result"] as? [Any] else{return}
                    print(items)
                    guard let lan = items[0] as? [String:String] else{return}
                    let thatChat =  TransMessageItem(body:"\(lan["dst"]!)" as NSString, user:self.you, date:Date(), mtype:ChatType.someone)
                    self.Chats.add(thatChat)
                    self.tableView.chatDataSource = self
                    self.tableView.reloadData()
                    self.speechMessage(message: lan["dst"]!, language: to)
                    //
                    /*var audArg : String = "tex=" + lan["dst"]!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&lan=" + to
                    audArg = audArg + "&cuid=" + mac + "&ctp=1&tok=" + audtok
                    self.audUrl = NSURL(string: audurl + "?" + audArg)
                    //print(audUrl)
                    var audRequest = URLRequest(url: self.audUrl! as URL)
                    audRequest.httpMethod = "GET"
                    audRequest.setValue("audio/mp3", forHTTPHeaderField: "Content-Type")
                    var recdata = NSData(contentsOf: self.audUrl! as URL)
                    let base64Data = recdata!.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                    print(recdata)
                    do{
                        self.avPlayer = try AVAudioPlayer(contentsOf: self.audUrl as URL, fileTypeHint: "mp3")
                        self.avPlayer.prepareToPlay()
                        self.avPlayer.play()
                    }catch let err as NSError{
                        self.avPlayer = nil
                        print(err.localizedDescription)
                    }*/
                }
            }
        }
        task.resume()
    }
    
    func speechMessage(message:String, language:String){
        if !message.isEmpty {
            do {
                try audioSession.setCategory(AVAudioSession.Category.ambient, mode: .default, options: [])
            }catch let error as NSError{
                print(error.code)
            }
            let utterance = AVSpeechUtterance.init(string: message)
            
            var l: String!
            switch language{
            case "zh": l = "zh_CN"; break;
            case "jp": l = "ja-JP"; break; 
            default: break;
            }
            utterance.voice = AVSpeechSynthesisVoice.init(language: l)
            utterance.volume = 1
            utterance.pitchMultiplier = 1.1

            synth.speak(utterance)
        }
    }
    
    func setupChatTable()
    {
        print("enter setupChatTable")
        self.tableView = TransTableView(frame:CGRect(x: 0, y: 20+73+56, width: self.view.frame.size.width, height: self.view.frame.size.height - 76 - 130) )
        //创建一个重用的单元格
        self.tableView!.register(TransTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = TransUserInfo(name:"zhongguo")
        you  = TransUserInfo(name:"riben")
        
        let first =  TransMessageItem(body:"开启我的寻悦之旅", user:me,  date:Date(timeIntervalSinceNow:0), mtype:.mine)
        let second =  TransMessageItem(body:"喜びのために私の探求を開始",user:you, date:Date(timeIntervalSinceNow:0), mtype:.someone)
        
        Chats = NSMutableArray()
        Chats.addObjects(from: [first,second])
        //set the chatDataSource
        self.tableView.chatDataSource = self
        //call the reloadData, this is actually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
        print("out setupChatTable")
    }
    
    func rowsForChatTable(_ tableView:TransTableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView:TransTableView, dataForRow row:Int) -> TransMessageItem
    {
        return Chats[row] as! TransMessageItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
