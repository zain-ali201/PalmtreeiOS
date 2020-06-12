//
//  DescriptionTableCell.swift
//  PalmTree
//
//  Created by SprintSols on 4/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol textViewValueDelegate {
    func changeTextViewCharacters(value: String, fieldTitle: String)
}

protocol textValDescDelegate {
    func textValDesc(value: String,indexPath: Int, fieldType:String, section: Int,fieldNam:String)
}


class DescriptionTableCell: UITableViewCell, UITextViewDelegate {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblDescription: UILabel!
    //@IBOutlet weak var richEditorView: RichEditorView!
    @IBOutlet weak var txtDescription: UITextView!
    
    //MARK:- Properties
//    lazy var toolbar: RichEditorToolbar = {
//        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
//        toolbar.options = RichEditorDefaultOption.all
//        return toolbar
//    }()
    
    var fieldName = ""
    var delegate: textViewValueDelegate?
    var delegateDes: textValDescDelegate?
    var index = 0
    var section = 0
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        txtDescription.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print("Change Selection \(textView.text!)")
        delegate?.changeTextViewCharacters(value: txtDescription.text!, fieldTitle: fieldName)
        delegateDes?.textValDesc(value: txtDescription.text!, indexPath: index, fieldType: "textarea", section: section,fieldNam: fieldName)
    }
    

    //MARK:- Custom
//    func richEditorSetting(placeHolder: String) {
//        richEditorView.delegate = self
//        richEditorView.inputAccessoryView = toolbar
//        richEditorView.placeholder = placeHolder
//        toolbar.delegate = self
//        toolbar.editor = richEditorView
//
//        // We will create a custom action that clears all the input text when it is pressed
//        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
//            toolbar.editor?.html = ""
//        }
//
//        var options = toolbar.options
//        options.append(item)
//        toolbar.options = options
//    }
}



//extension  DescriptionTableCell {
//
//    fileprivate func randomColor() -> UIColor {
//        let colors: [UIColor] = [
//            .red,
//            .orange,
//            .yellow,
//            .green,
//            .blue,
//            .purple
//        ]
//
//        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
//        return color
//    }
//
//    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
//        let color = randomColor()
//        toolbar.editor?.setTextColor(color)
//    }
//
//    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
//        let color = randomColor()
//        toolbar.editor?.setTextBackgroundColor(color)
//    }
//
//    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
//        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
//    }
//
//    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
//        // Can only add links to selected text, so make sure there is a range selection first
//        if toolbar.editor?.hasRangeSelection == true {
//            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
//        }
//    }
//}




