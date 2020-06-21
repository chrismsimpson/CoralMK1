//
//  SimpleUsingTests.swift
//

import XCTest
@testable import Coral

final class SimpleUsingTests: XCTestCase {
    
    var source: String {
        
        return """
using MyLibrary
"""
    }
    
    // MARK: - Setup
    
    func setupSourceFile() -> Node {
        
        var parser = Parser(input: self.source)
        
        let sourceFile = parser.parseSourceFile()
        
        return sourceFile
    }
    
    func setupCodeBlockList() -> Node {
        
        let sourceFile = self.setupSourceFile()
        
        guard let codeBlockList = sourceFile.children.first else {
            
            fatalError()
        }
        
        return codeBlockList
    }
    
    func setupCodeBlock() -> Node {
        
        let codeBlockList = self.setupCodeBlockList()
        
        guard let codeBlock = codeBlockList.children.first else {
            
            fatalError()
        }
        
        return codeBlock
    }
    
    func setupUsingDeclaration() -> Node {
        
        let codeBlock = self.setupCodeBlock()
        
        guard let usingDeclaration = codeBlock.children.first else {
            
            fatalError()
        }
        
        return usingDeclaration
    }
    
    func setupUsingDeclarationPath() -> Node {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        guard let path = usingDeclaration.children.last else {
            
            fatalError()
        }
        
        return path
    }
    
    // MARK: - Tests
    
    func testSourceFile() {
        
        let sourceFileNode = self.setupSourceFile()
        
        assert(sourceFileNode.nodeType == .sourceFile)
    }
    
    func testSourceFileChildren() {
        
        let sourceFileNode = self.setupSourceFile()
        
        assert(sourceFileNode.children.count == 1)
    }
    
    func testCodeBlockList() {
        
        let codeBlockList = self.setupCodeBlockList()
        
        assert(codeBlockList.nodeType == .list(.codeBlock))
    }
    
    func testCodeBlockListChildren() {
        
        let codeBlockList = self.setupCodeBlockList()
        
        assert(codeBlockList.children.count == 1)
    }
    
    func testCodeBlock() {
        
        let codeBlock = self.setupCodeBlock()
        
        assert(codeBlock.nodeType == .item(.codeBlock))
    }
    
    func testCodeBlockChildren() {
        
        let codeBlock = self.setupCodeBlock()
        
        assert(codeBlock.children.count == 1)
    }
    
    func testUsingDeclaration() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        assert(usingDeclaration.nodeType == .declaration(.using))
    }
    
    func testUsingDeclarationChildren() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        assert(usingDeclaration.children.count == 2)
    }
    
    func testUsingDeclarationUsingToken() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        guard let usingToken = usingDeclaration.children.first else {
            
            fatalError()
        }
        
        guard case let .token(token) = usingToken.nodeType else {
            
            fatalError()
        }
        
        assert(token.tokenType == .keyword(.coral(.using)))
    }
    
    func testUsingDeclarationPath() {
        
        let path = self.setupUsingDeclarationPath()
        
        assert(path.nodeType == .path)
    }
    
    func testUsingDeclarationPathChildren() {
        
        let path = self.setupUsingDeclarationPath()
        
        assert(path.children.count == 1)
    }
    
    func testUsingDeclarationPathComponent() {
        
        let path = self.setupUsingDeclarationPath()
        
        guard let pathComponent = path.children.first else {
            
            fatalError()
        }
        
        guard case let .pathComponent(component) = pathComponent.nodeType else {
            
            fatalError()
        }
        
        assert(component == "MyLibrary")
    }
}
