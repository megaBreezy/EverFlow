//
//  Flow_Navigation_View_Handler.swift
//
//
//  Created by Bradley Phillips on 4/22/24.
//

import Foundation

@available(iOS 15, macOS 11, *)
public class Flow_Navigation_View_Handler: ObservableObject, Flow_Navigation_Publisher
{
    private var views_should_publish: Bool = false
    public var current_direction: Flow_Direction? = nil
    public var incoming_view: Flow_View
    public var outgoing_view: Flow_View? = nil
    public var flow_duration: Double = 0.38
    public var views: [Flow_View] = []
    {
        willSet
        {
            if views_should_publish
            {
                Task { await MainActor.run { objectWillChange.send() } }
            }
        }
    }
    
    public init(incoming_view: Flow_View)
    {
        self.views = [incoming_view]
        self.incoming_view = incoming_view
    }
    
    public func navigate(
        incoming_view: Flow_View,
        outgoing_view: Flow_View?,
        direction: Flow_Direction,
        on_complete: @escaping () -> Void
    )
    {
        self.outgoing_view = outgoing_view
        self.incoming_view = incoming_view
        self.current_direction = direction
        self.views_should_publish = true
        self.views.append(incoming_view)
        
        if self.views.count > 1
        {
            Task
            {
                let delay = switch(self.current_direction ?? Flow_Direction.instant)
                {
                    case Flow_Direction.instant: UInt64(0)
                    default: (UInt64(self.flow_duration * 1_000_000_000))
                }
                try await Task.sleep(nanoseconds: delay)
                await MainActor.run
                {
                    self.views_should_publish = false
                    self.views.removeFirst()
                    on_complete()
                }
            }
        }
        else { on_complete() }
    }
}
