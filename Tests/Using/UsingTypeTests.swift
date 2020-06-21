//
//  UsingTypeTests.swift
//

import XCTest
@testable import Coral

final class UsingTypeTests: XCTestCase {
    
    var source: String {
        
        return """
using type MyLibrary.MyType
"""
    }
    
    let myClosure = { (n: String) -> Bool in
        
        return true
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
        
        assert(usingDeclaration.children.count == 3)
    }
    
    func testUsingDeclarationUsingToken() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let usingToken = usingDeclaration.children[0]
        
        guard case let .token(token) = usingToken.nodeType else {
            
            fatalError()
        }
        
        assert(token.tokenType == .keyword(.coral(.using)))
    }
    
    func testUsingDeclarationTypetoken() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let typeToken = usingDeclaration.children[1]
        
        guard case let .token(token) = typeToken.nodeType else {
            
            fatalError()
        }
        
        assert(token.tokenType == .keyword(.coral(.type)))
    }
    
    func testUsingDeclarationPath() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let path = usingDeclaration.children[2]
        
        assert(path.nodeType == .path)
    }
    
    func testUsingDeclarationPathChildren() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let path = usingDeclaration.children[2]
        
        assert(path.children.count == 3)
    }
    
    func testUsingDeclarationPathComponent0() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let path = usingDeclaration.children[2]
        
        let component0 = path.children[0]
        
        guard case let .pathComponent(component) = component0.nodeType else {
            
            fatalError()
        }
        
        assert(component == "MyLibrary")
    }
    
    func testUsingDeclarationPathComponent1() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let path = usingDeclaration.children[2]
        
        let component1 = path.children[1]
        
        guard case let .token(token) = component1.nodeType else {
            
            fatalError()
        }
        
        assert(token.tokenType == .punctuation(.period))
    }
    
    func testUsingDeclarationPathComponent2() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let path = usingDeclaration.children[2]
        
        let component2 = path.children[2]
        
        guard case let .pathComponent(component) = component2.nodeType else {
            
            fatalError()
        }
        
        assert(component == "MyType")
    }
}
