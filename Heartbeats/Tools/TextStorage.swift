//
//  TextStorage.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/5/12.
//  Copyright © 2016年 heart. All rights reserved.
//

/*字体*/
class TextStorage: NSTextStorage {
    
    override var string:String {
        get {
            return contentString.string
        }
    }
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return contentString.attributesAtIndex(location, effectiveRange: range)
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        beginEditing()
        contentString.replaceCharactersInRange(range, withString: str)
        self.edited(NSTextStorageEditActions.EditedCharacters, range: range, changeInLength: str.characters.count - range.length)
        
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
        contentString.setAttributes(attrs, range: range)
        edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
        
    }
    
    override func processEditing() {
        super.processEditing()
        do {
            let regex = try NSRegularExpression(pattern: "Swift", options: [])
            let paragraphRange = (self.string as NSString).paragraphRangeForRange(self.editedRange)
            regex.enumerateMatchesInString(self.string, options: [], range: paragraphRange) { result, flags, stop in
                self.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: result!.range)
            }
        } catch {
        }
    }
    
    var contentString = NSMutableAttributedString()
}
