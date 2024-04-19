//
//  File.swift
//  
//
//  Created by Bradley Phillips on 4/19/24.
//

import SwiftUI

@available(iOS 15, macOS 10.15, *)
public struct Flow_View: View, Identifiable
{
    public var id = UUID().uuidString
    public var view: AnyView
    public var route: String
    
    init(view: AnyView, route: String)
    {
        self.view = view
        self.route = route
    }
    
    public var body: some View { view }
}
