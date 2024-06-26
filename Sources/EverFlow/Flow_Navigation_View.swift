//
//  FlowNavigationView.swift
//  
//
//  Created by Bradley Phillips on 4/19/24.
//

import SwiftUI

@available(iOS 15, macOS 11, *)
public struct Flow_Navigation_View<Navigation_Publisher>: View where Navigation_Publisher: Flow_Navigation_Publisher
{
    @ObservedObject public var navigation_publisher: Navigation_Publisher
    
    @State private var prior_view_offset_x: CGFloat = 0
    @State private var current_view_offset_x: CGFloat = 0
    @State private var prior_view_offset_y: CGFloat = 0
    @State private var current_view_offset_y: CGFloat = 0
    
    @State private var content_width: CGFloat = .zero
    @State private var content_height: CGFloat = .zero
    
    public init(navigation_publisher: Navigation_Publisher)
    {
        self.navigation_publisher = navigation_publisher
    }
    
    public var body: some View
    {
        ZStack
        {
            GeometryReader { geometry in
                Color.clear
                    .onAppear(perform: {
                        content_width = geometry.size.width
                        content_height = geometry.size.height
                    })
                    .onChange(of: geometry.size, perform: { new_size in
                        content_width = new_size.width
                        content_height = new_size.height
                    })
            }
            
            ForEach(navigation_publisher.views)
            { view in
                let index = navigation_publisher.views.firstIndex(where: { $0.id == view.id }) ?? -1
                let z_index: Double = view.id == navigation_publisher.incoming_view.id ? 1 : 0

                view
                    .zIndex(
                        [Flow_Direction.backward, Flow_Direction.down]
                            .contains(navigation_publisher.current_direction) && view.id == navigation_publisher.outgoing_view?.id
                                ? 2
                                : z_index
                    )
                    .offset(
                        x: navigation_publisher.views.count <= 1 ? 0 : (
                            navigation_publisher.views.count > 1 && index > 0 ? current_view_offset_x : prior_view_offset_x
                        ),
                        y: navigation_publisher.views.count <= 1 ? 0 : (
                            navigation_publisher.views.count > 1 && index > 0 ? current_view_offset_y : prior_view_offset_y
                        )
                    )
            }
        }
        .onChange(of: navigation_publisher.incoming_view)
        { route in
            guard let flow_direction = navigation_publisher.current_direction else { return }
            
            switch (flow_direction)
            {
                case Flow_Direction.up:
                    self.prior_view_offset_x = 0
                    self.prior_view_offset_y = 0
                    self.current_view_offset_x = 0
                    self.current_view_offset_y = content_height

                    withAnimation(.spring(duration: navigation_publisher.flow_duration))
                    {
                        self.current_view_offset_y = 0
                    }
                case Flow_Direction.down:
                    self.prior_view_offset_x = 0
                    self.prior_view_offset_y = 0
                    self.current_view_offset_x = 0
                    self.current_view_offset_y = 0

                    withAnimation(.spring(duration: navigation_publisher.flow_duration))
                    {
                        self.prior_view_offset_y = content_height
                    }
                case Flow_Direction.backward:
                    self.prior_view_offset_x = 0
                    self.prior_view_offset_y = 0
                    self.current_view_offset_y = 0
                    self.current_view_offset_x = -content_width * 0.35

                    withAnimation(.spring(duration: navigation_publisher.flow_duration))
                    {
                        self.current_view_offset_x = 0
                        self.prior_view_offset_x = content_width
                    }
                case Flow_Direction.forward:
                    self.prior_view_offset_x = 0
                    self.prior_view_offset_y = 0
                    self.current_view_offset_x = content_width
                    self.current_view_offset_y = 0

                    withAnimation(.spring(duration: navigation_publisher.flow_duration))
                    {
                        self.current_view_offset_x = 0
                        self.prior_view_offset_x = -content_width * (0.35)
                    }
                default:
                    self.prior_view_offset_x = 0
                    self.prior_view_offset_y = 0
                    self.current_view_offset_x = 0
                    self.current_view_offset_y = 0
            }
        }
    }
}
