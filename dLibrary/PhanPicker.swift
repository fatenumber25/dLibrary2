//
//  PhanPicker.swift
//  dLibrary
//
//  Created by JPN26088 on 2018/03/05.
//  Copyright © 2018年 Disco. All rights reserved.
//

import UIKit

@objc public protocol PhanPickerDelegate: class {
    @objc optional func phanPickerOKWithJPDate(picker: PhanPicker, date: String)
    @objc optional func phanPickerOKWithJPDate2(picker: PhanPicker, date: String)
    @objc optional func phanPickerOKWithENDate(picker: PhanPicker, date: String)
    @objc optional func phanPickerOKWithENDate2(picker: PhanPicker, date: String)
    @objc optional func phanPickerOKWithTime(picker: PhanPicker, time: String)
    @objc optional func phanPickerOKWithValue(picker: PhanPicker, value: String)
    @objc optional func phanPickerOKWithIndex(picker: PhanPicker, index: Int)
    @objc optional func phanPickerCanceled()
}

public class PhanPicker: UIView {
    
    //MARK: PUBLIC
    // Picker's delegate
    weak public var delegate:PhanPickerDelegate?
    // Row's height
    public var rowHeight: CGFloat = 50.0 {
        didSet {
            if isDatePicker { return }
            if picker != nil {
                picker.setNeedsLayout()
                picker.layoutIfNeeded()
                picker.reloadAllComponents()
            }
        }
    }
    // Component's width
    public var widthComponent: CGFloat = 0 {
        didSet {
            if isDatePicker { return }
            if picker != nil {
                picker.setNeedsLayout()
                picker.layoutIfNeeded()
                picker.reloadAllComponents()
            }
        }
    }
    // Picker's title
    public private(set) var title: String = ""
    
    
    //MARK: PRIVATE
    private var contentView: UIView!
    private var cancelBtn: UIButton!
    private var okBtn: UIButton!
    private var pickerLabel: UILabel!
    private var selectedIdx: Int = -1
    private var selectedVal: String = ""
    private var isDatePicker: Bool = false
    private var jpDateFormatter: DateFormatter!
    private var jpDateFormatter2: DateFormatter!
    private var enDateFormatter: DateFormatter!
    private var enDateFormatter2: DateFormatter!
    private var timeFormatter: DateFormatter!
    private var datePicker: UIDatePicker!
    private var pickerDatas: [String]!
    private var picker: UIPickerView!
    
    
    //MARK: DEFINES
    private let kFlatDatePickerBackgroundColor: UIColor = RGB(r: 58.0, g: 58.0, b: 58.0)
    private let kFlatDatePickerBackgroundColorButtonValid: UIColor = RGB(r: 51.0, g: 181.0, b: 229.0)
    private let kFlatDatePickerBackgroundColorButtonCancel: UIColor = RGB(r: 58.0, g: 58.0, b: 58.0)
    private let kFlatDatePickerIconCancel: String = "FlatDatePicker-Icon-Close.png"
    private let kFlatDatePickerIconValid: String = "FlatDatePicker-Icon-Check.png"

    
    //MARK: PRIVATE INIT
    private override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        // Views
        self.backgroundColor = .clear
        
        // Content view
        let pickerHeight = self.height/3.0 + 50.0
        contentView = UIView(frame: CGRect(x: 0, y: self.height, width: self.width, height: pickerHeight))
        contentView.backgroundColor = .darkGray
        self.addSubview(contentView)
        
        // Notification device orientation
        Util.NotifyDeviceOrientation(changeSelector: #selector(deviceOrientationDidChange(notification:)), target: self)
        
        // Params
        widthComponent = contentView.width - 20
        
        // Cancel button
        cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        cancelBtn.backgroundColor = kFlatDatePickerBackgroundColorButtonCancel
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        contentView.addSubview(cancelBtn)
        
        // OK button
        okBtn = UIButton(type: .custom)
        okBtn.frame = CGRect(x: contentView.width-44, y: 0, width: 44, height: 44)
        okBtn.backgroundColor = kFlatDatePickerBackgroundColorButtonValid
        okBtn.addTarget(self, action: #selector(okAction), for: .touchUpInside)
        contentView.addSubview(okBtn)
        
        // Button images
        if let urlString = Bundle.main.path(forResource: "dLibrary", ofType: "framework", inDirectory: "Frameworks") {
            if let bundle = (Bundle(url: URL(fileURLWithPath: urlString))){
                let okImagePath = (bundle.path(forResource: "Images", ofType: "bundle"))! + "/" + kFlatDatePickerIconValid
                if let okImage = UIImage(contentsOfFile: okImagePath) {
                    okBtn.setBackgroundImage(okImage, for: .normal)
                }
                
                let cancelImagePath = (bundle.path(forResource: "Images", ofType: "bundle"))! + "/" + kFlatDatePickerIconCancel
                if let cancelImage = UIImage(contentsOfFile: cancelImagePath) {
                    cancelBtn.setBackgroundImage(cancelImage, for: .normal)
                }
            }
        }
        
        // Title label
        pickerLabel = UILabel.init(frame: CGRect(x: 44, y: 0, width: contentView.width-88, height: 44))
        pickerLabel.backgroundColor = .clear
        pickerLabel.textAlignment = .center
        pickerLabel.textColor = .white
        pickerLabel.font = UIFont.systemFont(ofSize: 20.0)
        contentView.addSubview(pickerLabel)
        
        //
        UIApplication.shared.delegate?.window??.addSubview(self)
    }
    
    //MARK: PUBLIC INIT
    public convenience init(title: String, datePickerMode: UIDatePickerMode){
        self.init(frame: CGRect(x: 0, y: 0, width: App.ScreenWidth, height: App.ScreenHeight))
        
        //
        self.title = title
        isDatePicker = true
        pickerLabel.text = title
        
        // Date formatter
        jpDateFormatter = DateFormatter()
        jpDateFormatter.dateFormat = "yyyy年MM月dd日"
        jpDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        jpDateFormatter2 = DateFormatter()
        jpDateFormatter2.dateFormat = "yyyy年MM月dd日 HH:mm"
        jpDateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        enDateFormatter = DateFormatter()
        enDateFormatter.dateFormat = "yyyyMMdd"
        enDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        enDateFormatter2 = DateFormatter()
        enDateFormatter2.dateFormat = "yyyyMMdd HH:mm"
        enDateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        //
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 44, width: contentView.width, height: contentView.height-44))
        datePicker.backgroundColor = RGB(r: 247.0, g: 247.0, b: 247.0)
        datePicker.datePickerMode = datePickerMode
        contentView.addSubview(datePicker)
    }
    public convenience init(title: String, datePickerMode: UIDatePickerMode, maxDate: Date, minDate: Date){
        self.init(title: title, datePickerMode: datePickerMode)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    public convenience init(title: String, datas: [String]){
        self.init(frame: CGRect(x: 0, y: 0, width: App.ScreenWidth, height: App.ScreenHeight))
        
        //
        self.title = title
        isDatePicker = false
        pickerLabel.text = title
        pickerDatas = datas

        //
        picker = UIPickerView(frame: CGRect(x: 0, y: 44, width: contentView.width, height: contentView.height-44))
        picker.backgroundColor = RGB(r: 247, g: 247, b: 247)
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        if pickerDatas.isEmpty {
            picker.isUserInteractionEnabled = false
        }
        contentView.addSubview(picker)
    }
    public convenience init(title: String, datas: [String], selectedIndex: Int){
        self.init(title: title, datas: datas)
        if selectedIndex >= 0 {
            self.selectedIdx = selectedIndex
        }
        if selectedIndex >= 0 && selectedIndex < pickerDatas.count {
            self.selectedVal = pickerDatas[selectedIndex]
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }
    public convenience init(title: String, datas: [String], selectedValue: String){
        self.init(title: title, datas: datas)
        self.selectedVal = selectedValue
        let selectedIndex = pickerDatas.index(of: selectedValue)
        if (selectedIndex != nil) {
            self.selectedIdx = selectedIndex!
            picker.selectRow(self.selectedIdx, inComponent: 0, animated: false)
        }
    }
    
    
    //MARK: PUBLIC FUNCTIONS
    public func show()
    {
        var rect: CGRect = contentView.frame
        rect.setY(newY: rect.y-contentView.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = rect
        }) { (finished) in
        }
    }
    public func hide()
    {
        var rect: CGRect = contentView.frame
        rect.setY(newY: self.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = rect
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
  
    
    //MARK: Button actions
    @objc private func cancelAction() {
        if let delegate = delegate {
            delegate.phanPickerCanceled!()
        }

        self.hide()
    }
    @objc private func okAction() {
        if isDatePicker {
            if let delegate = self.delegate?.phanPickerOKWithJPDate {
                delegate(self, jpDateFormatter.string(from: datePicker.date))
            }
            if let delegate = self.delegate?.phanPickerOKWithJPDate2 {
                delegate(self, jpDateFormatter2.string(from: datePicker.date))
            }
            if let delegate = self.delegate?.phanPickerOKWithENDate {
                delegate(self, enDateFormatter.string(from: datePicker.date))
            }
            if let delegate = self.delegate?.phanPickerOKWithENDate2 {
                delegate(self, enDateFormatter2.string(from: datePicker.date))
            }
            if let delegate = self.delegate?.phanPickerOKWithTime {
                delegate(self, timeFormatter.string(from: datePicker.date))
            }
        } else {
            if selectedIdx < 0 && selectedVal.isEmpty {
                selectedIdx = 0
                selectedVal = pickerDatas[selectedIdx]
            }
            
            if let delegate = self.delegate!.phanPickerOKWithIndex {
                delegate(self, selectedIdx)
            }
            if let delegate = self.delegate!.phanPickerOKWithValue {
                delegate(self, selectedVal)
            }
        }
        self.hide()
    }
    
    
    //MARK: NOTIFICATION
    @objc private func deviceOrientationDidChange(notification: NSNotification) {
        self.frame = CGRect(x: 0, y: 0, width: App.ScreenWidth, height: App.ScreenHeight)
        
        let pickerHeight: CGFloat = self.height/3.0 + 50.0
        contentView.frame = CGRect(x: 0, y: self.frame.height-pickerHeight, width: self.frame.width, height: pickerHeight)
        okBtn.frame = CGRect(x: contentView.frame.width-44, y: 0, width: 44, height: 44)
        pickerLabel.frame = CGRect(x: 44, y: 0, width: contentView.frame.width-88, height: 44)
        picker.frame = CGRect(x: 0, y: 44, width: contentView.frame.width, height: contentView.frame.height-44)
    }
}

//MARK: Don't call below functions
extension PhanPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDatas.count
    }
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return widthComponent
    }
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if view != nil { return view! }
        
        let label: UILabel  = UILabel(frame: CGRect(x: 5, y: 5, width: widthComponent-10, height: rowHeight-10))
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.isOpaque = false
        label.tag = component + 100
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = pickerDatas[row]
        label.numberOfLines = 0
        return label
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIdx = row
        selectedVal = pickerDatas[row]
    }
}

