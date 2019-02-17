//
//  DatePickerWidger.swift
//  InstantSearch
//
//  Created by Guy Daher on 05/05/2017.
//
//

import Foundation
import UIKit

/// Widget that controls the Numeric value of attribute. Built on top of `UIDatePicker`.
/// + Remark: You must assign a value to the `attribute` property since the refinement table cannot operate without one. 
/// A FatalError will be thrown if you don't specify anything.
@objcMembers public class DatePickerWidget: UIDatePicker, NumericControlViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var attribute: String = Constants.Defaults.attribute
    @IBInspectable public var `operator`: String = Constants.Defaults.operatorNumericControl
    @IBInspectable public var inclusive: Bool = Constants.Defaults.inclusive
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    // Note: can't have optional Float because IBInspectable have to be bridgable to objc
    // and value types optional cannot be bridged.
    public var clearValue: NSNumber = 0
    
    public var viewModel: NumericControlViewModelDelegate
    
    public override init(frame: CGRect) {
        viewModel = NumericControlViewModel()
        super.init(frame: frame)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = NumericControlViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func set(value: NSNumber) {
        self.setDate(Date(timeIntervalSince1970: value.doubleValue), animated: false)
    }
    
    public func configureView() {
        addTarget(self, action: #selector(numericFilterValueChanged), for: .valueChanged)
        
        // We add the initial value of the slider to the Search
        viewModel.updateNumeric(value: NSNumber(value: date.timeIntervalSince1970), doSearch: false)
    }
    
    @objc func numericFilterValueChanged() {
        viewModel.updateNumeric(value: NSNumber(value: date.timeIntervalSince1970), doSearch: true)
    }
}
