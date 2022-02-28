//
//  xbBaseAlertView.swift
//  FSCycleSwift
//
//  Created by huadong on 2022/2/25.
//

import UIKit
import xbTextView

public class xbBaseAlertConfig: NSObject {
    
    /** 弹窗距离屏幕的左右间距*/
    public var leftRightMargin: CGFloat = 30.0
    /** 标题距离弹窗的左右间距*/
    public var leftSpace: CGFloat = 15.0
    public var titleTop: CGFloat = 15.0
    public var textField_H: CGFloat = 44.0
    public var textView_H: CGFloat = 80.0
    /** textField, textView 左右距离背景的间距*/
    public var textLeftSpace: CGFloat = 10.0
    /** 弹窗距离中心Y的间距*/
    public var offsetY: CGFloat = 0.0
    /** 是否手动来控制弹窗的消失，默认自动消失*/
    public var isManualDismiss: Bool = false
    /** 是否点击半透明背景弹窗的消失，默认不消失*/
    public var isTapDismiss: Bool = false
    
    public var titleColor: UIColor = xbBaseAlertView.hex(hexString: "#2F343A")
    public var titleFont:  UIFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    
    public var messageColor: UIColor = xbBaseAlertView.hex(hexString: "#333333")
    public var messageFont:  UIFont = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    
    public var descriptionColor: UIColor = xbBaseAlertView.hex(hexString: "#888888")
    public var descriptionFont:  UIFont = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    
    public var themeColor: UIColor = xbBaseAlertView.hex(hexString: "#127CF9")
    
    public var actionBtnMainBgColor: UIColor = xbBaseAlertView.hex(hexString: "#127CF9")
    public var actionBtnMainColor: UIColor = UIColor.white
    public var actionBtnMainFont:  UIFont = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    
    public var actionBtnNormalBgColor: UIColor = xbBaseAlertView.hex(hexString: "#eeeeee")
    public var actionBtnNormalColor: UIColor = xbBaseAlertView.hex(hexString: "#666666")
    public var actionBtnNormalFont:  UIFont = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    
    public var placeholderColor: UIColor = xbBaseAlertView.hex(hexString: "#999999")
    
    public var textViewBgColor: UIColor = xbBaseAlertView.hex(hexString: "#f8f8f8")
}

public class xbBaseAlertView: UIView {

    private let kWidth = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    private let kHeight = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
   
    private var actionButtons: [UIButton] = []
    
    public typealias kBaseAlertViewButtonsClickedBlock = ((xbBaseAlertView, Int) -> Void)
    public typealias kBaseAlertViewTextFieldDidChangedBlock = ((xbBaseAlertView, String) -> Void)
    public typealias kBaseAlertViewTextViewDidChangedBlock = ((xbBaseAlertView, String) -> Void)
    public typealias kBaseAlertViewCompletedBlock = ((xbBaseAlertView, Bool) -> Void)
    
    private var btnClickedBlock: kBaseAlertViewButtonsClickedBlock?
    private var textFieldBlock: kBaseAlertViewTextFieldDidChangedBlock?
    private var textViewBlock: kBaseAlertViewTextViewDidChangedBlock?
    
    /** 基本配置， 可自定义配置，也可使用默认配置*/
    private var config: xbBaseAlertConfig = xbBaseAlertConfig()
    
    /** 普通弹窗方法*/
    public convenience init(configure: xbBaseAlertConfig? = nil, title: String?, message: String?, actionTitles: [String], buttonsClicked: kBaseAlertViewButtonsClickedBlock?){
        
        self.init(configure: configure, title: title, message: message, description: nil, tfPlaceholder: nil, tvPlaceholder: nil, actionTitles: actionTitles, showClose: false, buttonsClicked: buttonsClicked, textFieldDidChanged: nil, textViewDidChanged: nil)
    }
    
    /** 普通弹窗方法2 */
    public convenience init(configure: xbBaseAlertConfig? = nil, title: String?, message: String?, description: String?, actionTitles: [String], showClose: Bool, buttonsClicked: kBaseAlertViewButtonsClickedBlock?){
        
        self.init(configure: configure, title: title, message: message, description: description, tfPlaceholder: nil, tvPlaceholder: nil, actionTitles: actionTitles, showClose: showClose, buttonsClicked: buttonsClicked, textFieldDidChanged: nil, textViewDidChanged: nil)
    }
    
    /** textField 弹窗*/
    public convenience init(configure: xbBaseAlertConfig? = nil, title: String?, message: String?, description: String?, tfPlaceholder: String?,  actionTitles: [String], showClose: Bool, buttonsClicked: kBaseAlertViewButtonsClickedBlock?, textFieldDidChanged: kBaseAlertViewTextFieldDidChangedBlock?) {
        
        self.init(configure: configure, title: title, message: message, description: description, tfPlaceholder: tfPlaceholder, tvPlaceholder: nil, actionTitles: actionTitles, showClose: showClose, buttonsClicked: buttonsClicked, textFieldDidChanged: textFieldDidChanged, textViewDidChanged: nil)
    }
    
    /** textView 弹窗*/
    public convenience init(configure: xbBaseAlertConfig? = nil, title: String?, message: String?, description: String?, tvPlaceholder: String?, actionTitles: [String], showClose: Bool, buttonsClicked: kBaseAlertViewButtonsClickedBlock?, textViewDidChanged: kBaseAlertViewTextViewDidChangedBlock?) {
        
        self.init(configure: configure, title: title, message: message, description: description, tfPlaceholder: nil, tvPlaceholder: tvPlaceholder, actionTitles: actionTitles, showClose: showClose, buttonsClicked: buttonsClicked, textFieldDidChanged: nil, textViewDidChanged: textViewDidChanged)
    }
    
    
    /** 通用弹窗方法*/
    public init(configure: xbBaseAlertConfig? = nil, title: String?, message: String?, description: String?, tfPlaceholder: String?, tvPlaceholder: String?, actionTitles: [String], showClose: Bool, buttonsClicked: kBaseAlertViewButtonsClickedBlock?, textFieldDidChanged: kBaseAlertViewTextFieldDidChangedBlock?, textViewDidChanged: kBaseAlertViewTextViewDidChangedBlock?) {
        
        self.btnClickedBlock = buttonsClicked
        self.textFieldBlock = textFieldDidChanged
        self.textViewBlock = textViewDidChanged
        
        if configure != nil {
            config = configure!
        }
     
        let frame: CGRect = CGRect(x: 0, y: 0, width: kWidth - config.leftRightMargin * 2, height: 0.0)
        super.init(frame: frame)
        
        initSettings()
        
        self.closeBtn.isHidden = !showClose
        
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.desLabel.text = description
        if let placeholder = tfPlaceholder {
            let holder = NSMutableAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : config.placeholderColor])
            self.textField.attributedPlaceholder = holder
            
        }
        self.textView.placeholder = tvPlaceholder
        
        if let msg = message {
            if (msg.count > 0) {
                self.messageLabel.attributedText = xbBaseAlertView.paragraphStyleWith(string: msg, lineSpacing: 3.0, fontSize: config.messageFont.pointSize, alignment: .center)
                self.messageLabel.numberOfLines = 0
            }
        }
        
        if let des = description {
            if des.count > 0 {
                self.desLabel.attributedText = xbBaseAlertView.paragraphStyleWith(string: des, lineSpacing: 3.0, fontSize: config.descriptionFont.pointSize, alignment: .center)
                self.desLabel.numberOfLines = 0
            }
        }
        
        // 添加操作按钮
        for i in 0..<actionTitles.count {
            let btn: UIButton = UIButton(type: .custom)
            btn.setTitle(actionTitles[i], for: .normal)
            btn.setTitleColor(config.actionBtnNormalColor, for: .normal)
            btn.titleLabel?.font = config.actionBtnNormalFont
            btn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            btn.tag = 30001 + i
            btn.backgroundColor = config.actionBtnNormalBgColor
            
            if (i == actionTitles.count - 1) {
                btn.backgroundColor = config.actionBtnMainBgColor
                btn.titleLabel?.font = config.actionBtnMainFont
                btn.setTitleColor(config.actionBtnMainColor, for: .normal)
            }
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 6.0
            self.addSubview(btn)
            self.actionButtons.append(btn)
        }
        
        updateAllSubviewsFrame()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: UI布局
    
    func initSettings() {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.cornerRadius = 6.0
        
        self.frame = CGRect(x: 0, y: 0, width: kWidth - 2 * config.leftRightMargin, height: 0.0)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.messageLabel)
        self.addSubview(self.desLabel)
        self.addSubview(self.closeBtn)
        
        self.addSubview(self.tfBgView)
        self.tfBgView.addSubview(self.textField)
        
        self.addSubview(self.tvBgView)
        self.tvBgView.addSubview(self.textView)
       
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldValueChanged(sender:)), name: UITextField.textDidChangeNotification, object: self.textField)
    }
    
    func updateAllSubviewsFrame() {
        
        let leftRightMargin: CGFloat = config.leftRightMargin,leftSpace: CGFloat = config.leftSpace
        
        let width: CGFloat = kWidth - leftRightMargin * 2;
        let textWidth: CGFloat = width - leftSpace * 2;

        self.closeBtn.frame = CGRect(x: width - 40.0, y: 0, width: 40.0, height: 40.0)
        
        var bottomH: CGFloat = 0.0;
        
        self.titleLabel.sizeToFit()
        self.titleLabel.frame = CGRect(x: leftSpace, y: config.titleTop, width: textWidth, height: 0.0)
        if let title = self.titleLabel.text {
            if title.count > 0 {
                self.titleLabel.frame = CGRect(x: leftSpace, y: config.titleTop, width: textWidth, height: 30.0)
            }
        }
       
        bottomH = self.titleLabel.frame.maxY

        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = 3.0

        self.messageLabel.sizeToFit()
        self.messageLabel.frame = CGRect(x: self.titleLabel.frame.minX, y: bottomH, width: textWidth, height: 0.0)

        if let message = self.messageLabel.attributedText?.string {
            if message.count > 0 {
                let messageH: CGFloat = xbBaseAlertView.textHeight(withAttributedString: self.messageLabel.attributedText!, limitWidth: textWidth)
                // 取整 ： 大于或等于参数的最近的整数
                self.messageLabel.frame = CGRect(x: self.titleLabel.frame.minX, y: bottomH + 15.0, width: textWidth, height: messageH)
            }
        }
        
        bottomH = self.messageLabel.frame.maxY

        self.desLabel.sizeToFit()
        self.desLabel.frame = CGRect(x: self.messageLabel.frame.minX, y: bottomH, width: textWidth, height: 0.0)
        if let des = self.desLabel.attributedText?.string {
            if des.count > 0 {
                let desH = xbBaseAlertView.textHeight(withAttributedString: self.desLabel.attributedText!, limitWidth: textWidth)
                self.desLabel.frame = CGRect(x: self.messageLabel.frame.minX, y: bottomH + 15.0, width: textWidth, height: desH)
            }
        }
        
        bottomH = self.desLabel.frame.maxY
        
        self.tfBgView.frame = CGRect(x: self.desLabel.frame.minX, y: bottomH, width: textWidth, height: 0.0)
        self.textField.frame = CGRect(x: config.textLeftSpace, y: 0.0, width: self.tfBgView.frame.size.width - config.textLeftSpace * 2, height: 0.0)
   
        if let placeholder = self.textField.placeholder {
            if placeholder.count > 0 {
                self.tfBgView.frame = CGRect(x: self.desLabel.frame.minX, y: bottomH + 15.0, width: textWidth, height: config.textField_H)
                self.textField.frame = CGRect(x: config.textLeftSpace, y: 0.0, width: self.tfBgView.frame.size.width - config.textLeftSpace * 2, height: self.tfBgView.frame.size.height)
                
                bottomH = self.tfBgView.frame.maxY
            }
        }
        
        self.tvBgView.frame = CGRect(x: self.desLabel.frame.minX, y: bottomH, width: textWidth, height: 0.0)
        self.textView.frame = CGRect(x: config.textLeftSpace, y: 0.0, width: self.tvBgView.frame.size.width - config.textLeftSpace * 2, height: 0.0)
        
        if let placeholder = self.textView.placeholder {
            if placeholder.count > 0 {
                self.tvBgView.frame = CGRect(x: self.desLabel.frame.minX, y: bottomH + 15.0, width: textWidth, height: config.textView_H)
                self.textView.frame = CGRect(x: config.textLeftSpace, y: 10.0, width: self.tvBgView.frame.size.width - config.textLeftSpace * 2, height: self.tvBgView.frame.size.height - 20.0)
       
                bottomH = self.tvBgView.frame.maxY
            }
        }

        // 按钮布局
        var itemW: CGFloat = width - leftSpace * 2
        let itemSpace: CGFloat = 25.0, itemH: CGFloat = 40.0,itemTopMargin: CGFloat = 25.0, itemBottomMargin: CGFloat = 25.0
        if (self.actionButtons.count == 1) {
            let btn: UIButton = self.actionButtons.first!
            btn.frame = CGRect(x: leftSpace, y: bottomH + itemTopMargin, width: itemW, height: itemH)

        }else if (self.actionButtons.count > 1) {
            itemW = (width - CGFloat(leftSpace * 2) - (CGFloat(self.actionButtons.count - 1) * itemSpace)) / CGFloat(self.actionButtons.count)

            for i in 0..<self.actionButtons.count{
                let btn: UIButton = self.actionButtons[i]
                btn.frame = CGRect(x: leftSpace + (itemW + itemSpace) * CGFloat(i), y: bottomH + itemTopMargin, width: itemW, height: itemH)
            }
        }

        let height: CGFloat = bottomH + (itemTopMargin + itemH + itemBottomMargin)
        self.frame = CGRect(x: (kWidth - width) / 2.0 , y: (kHeight - height) / 2.0 , width: width, height: height)

    }
    
    // MARK: 点击事件
 
    @objc func buttonAction(sender: UIButton) {
        if !config.isManualDismiss {
            self.dismiss()
        }
        
        let index = sender.tag - 30000
        if let block = self.btnClickedBlock {
            block(self, index)
        }
    }
   
    @objc func textFieldValueChanged(sender: Notification){
        if let block = self.textFieldBlock {
            block(self, self.textField.text ?? "")
        }
    }
    
   @objc func tapDismiss() {
        if config.isTapDismiss {
            dismiss()
        }
   }
    
    
    // MARK: 懒加载
    
    lazy var bgMaskView: UIView = {
        let bg = UIView(frame: UIScreen.main.bounds)
        bg.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        bg.isUserInteractionEnabled = true
        bg.addGestureRecognizer(tap)
        
        return bg
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.text = "温馨提示"
        label.textAlignment = .center
        label.textColor = config.titleColor
        label.font = config.titleFont

        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel.init()
        label.text = "一条消息"
        label.textAlignment = .center
        label.textColor = config.messageColor
        label.font = config.messageFont
        label.numberOfLines = 0
        
        return label
    }()
  
    lazy var desLabel: UILabel = {
        let label = UILabel.init()
        label.text = "一段描述"
        label.textAlignment = .center
        label.textColor = config.descriptionColor
        label.font = config.descriptionFont
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var tfBgView: UIView = {
        let bg = UIView()
        bg.backgroundColor = config.textViewBgColor
        
        return bg
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.clear
        tf.tintColor = config.themeColor
        tf.textColor = config.messageColor
        tf.font = config.messageFont
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing

        return tf
    }()
    
    lazy var tvBgView: UIView = {
        let bg = UIView()
        bg.backgroundColor = config.textViewBgColor
        
        return bg
    }()
    
    lazy var textView: xbTextView = {
        let tv = xbTextView()
        tv.backgroundColor = UIColor.clear
        tv.xb_Delegate = self
        tv.font = config.messageFont
        tv.tintColor = config.themeColor
        tv.textColor = config.messageColor
        tv.placeholder = nil
        tv.placeholderColor = config.placeholderColor
//        tv.maxLength = 20
        
        return tv
    }()
    
    
    lazy var closeBtn: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "close_black"), for: .normal)
        btn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        btn.tag = 30000
        
        return btn
    }()


    

}

public extension xbBaseAlertView {
 
   func show(completed: (() -> Void)? = nil) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(self.bgMaskView)
        window.addSubview(self)
        
        var center: CGPoint = window.center
        center.y += config.offsetY
        self.center = center
        
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
        } completion: { finished in
            
            UIView.animate(withDuration: 1.0/15.0) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
               
            } completion: { finished in
                UIView.animate(withDuration: 1.0/7.5) {
                    self.transform = CGAffineTransform.identity
                    
                    
                } completion: { finished in
                    if let block = completed{
                        block()
                    }
                }
            }
        }
    }
    
    func dismiss(completed: (() -> Void)? = nil) {
        self.transform = CGAffineTransform.identity
        self.bgMaskView.alpha = 1.0
        self.alpha = 1.0
        UIView.animate(withDuration: 0.25) {
            self.bgMaskView.alpha = 0.1
            self.alpha = 0.1
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        } completion: { finished in
            self.bgMaskView.removeFromSuperview()
            self.removeFromSuperview()
            if let block = completed{
                block()
            }
        }
    }
    
}

extension xbBaseAlertView: xbTextViewDelegate{
    public func xb_textViewDidChanged(textView: xbTextView, text: String?) {
        if let block = self.textViewBlock {
            block(self, self.textView.text)
        }
    }
    
    public func xb_textViewDidEndEditing(textView: xbTextView, text: String?) {
        if let block = self.textViewBlock {
            block(self, self.textView.text)
        }
    }
    
    public func xb_heightWith(textView: xbTextView, textHeight: CGFloat, textViewHeight: CGFloat) {
        //debugPrint("textView height = \(textViewHeight)")
    }
}

extension xbBaseAlertView {
    
    /** 获取行间距属性字符串*/
    static func paragraphStyleWith(string: String ,lineSpacing: CGFloat, fontSize: CGFloat, alignment: NSTextAlignment) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle, NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)])
        
        return attributedText
    }
    
    
    /** 计算属性字符串高度*/
    static func textHeight(withAttributedString: NSAttributedString, limitWidth: CGFloat) -> CGFloat{
        let rect = withAttributedString.boundingRect(with: CGSize(width: limitWidth, height: 1000), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading], context: nil)
        // 取整 ： 大于或等于参数的最近的整数
        return ceil(rect.size.height)
    }
  
    /** 色值 #F56544 0xF56544 F56544 */
    static func hex(hexString:String, alpha:Float = 1.0) -> UIColor{
        var cStr = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        
        if(cStr.length < 6){
            return UIColor.clear;
        }
        
        if(cStr.hasPrefix("0x")) {
            cStr = cStr.substring(from: 2) as NSString
        }
        
        if(cStr.hasPrefix("#")){
            cStr = cStr.substring(from: 1) as NSString
        }
        
        if(cStr.length != 6){
            return UIColor.clear;
        }
        
        let rStr = (cStr as NSString).substring(to: 2)
        let gStr = ((cStr as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bStr = ((cStr as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r : UInt32 = 0x0
        var g : UInt32 = 0x0
        var b : UInt32 = 0x0
        
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha));
    }
}
