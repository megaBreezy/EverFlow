//
//  File.swift
//  
//
//  Created by Bradley Phillips on 4/19/24.
//

import Foundation

@available(iOS 15, macOS 10.15, *)
public protocol Flow_Navigation_Publisher: ObservableObject
{
    var current_direction: Flow_Direction? { get set }
    var incoming_view: Flow_View { get set }
    var outgoing_view: Flow_View? { get set }
    var flow_duration: Double { get set }
    var views: [Flow_View] { get set }
    
    func navigate(
        incoming_view: Flow_View,
        outgoing_view: Flow_View?,
        direction: Flow_Direction,
        on_complete: @escaping () -> Void
    )
}


