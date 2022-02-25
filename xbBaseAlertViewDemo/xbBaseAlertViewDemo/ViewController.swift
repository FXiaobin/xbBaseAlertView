//
//  ViewController.swift
//  xbBaseAlertViewDemo
//
//  Created by huadong on 2022/2/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let btn = UIButton(frame: CGRect(x: 100, y: 200, width: 200, height: 60))
        btn.backgroundColor = UIColor.orange
        btn.setTitle("弹窗", for: .normal)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }


    @objc func btnAction() {
//        let av = xbBaseAlertView(title: "提示", message: "俄乌边境冲突加剧", description: "近日，俄乌边境冲突升级，俄军对乌克兰实施多点军事打击。当地时间24日，俄军已控制切尔诺贝利核电站。25日，乌总统称西方已放弃乌克兰。", actionTitles: ["取消","我知道了"], showClose: true) { alertV , index  in
//
//
//        }
//        av.show()
        
//        let av = xbBaseAlertView(title: "提示", message: "俄乌边境冲突加剧", description: "", tvPlaceholder: "请输入评论内容", actionTitles: ["取消","发布"], showClose: true, buttonsClicked: { alert , index  in
//            print("index = \(index)")
//
//        }, textViewDidChanged: { alert , text  in
//            print("text = \(text)")
//        })
//        av.show()
        
        
        let config = xbBaseAlertConfig()
        config.actionBtnMainBgColor = UIColor.brown
        config.titleColor = UIColor.purple
        config.actionBtnMainFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        config.messageFont = UIFont.italicSystemFont(ofSize: 18.0)
        
        let av  = xbBaseAlertView(configure: config ,title: "提示", message: "俄乌边境冲突加剧", description: "", tfPlaceholder: "请输入评论内容", actionTitles: ["取消","发布"], showClose: false) { alert , index  in
            print("index = \(index)")
            
        } textFieldDidChanged: { alert , text  in
            print("text = \(text)")
        }

        av.show()
        
        
    }
}

