//
//  File.swift
//  
//
//  Created by Bradley Phillips on 4/19/24.
//

import SwiftUI

@available(iOS 15, macOS 10.15, *)
public struct Flow_View: View, Identifiable, Equatable
{
    public var id = UUID().uuidString
    public var view: AnyView
    
    public init(view: AnyView)
    {
        self.view = view
    }
    
    public var body: some View { view }
    
    public static func == (lhs: Flow_View, rhs: Flow_View) -> Bool
    {
        lhs.id == rhs.id
    }
}
