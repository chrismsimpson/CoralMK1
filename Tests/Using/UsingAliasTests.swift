//
//  File.swift
//

import XCTest
@testable import Coral

final class UsingAliasTests: XCTestCase {
    
    var source: String {
        
        return """
using MyLibrary as MyAlias
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
        
        assert(usingDeclaration.children.count == 4)
    }
    
    func testUsingDeclarationUsingToken() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let usingToken = usingDeclaration.children[0]
        
        guard case let .token(token) = usingToken.nodeType else {
            
            fatalError()
        }
        
        assert(token.tokenType == .keyword(.coral(.using)))
    }
    
    func testUsingDeclarationPath() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let path = usingDeclaration.children[1]
        
        assert(path.nodeType == .path)
    }
    
    func testUsingDeclarationAsToken() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let asToken = usingDeclaration.children[2]
        
        guard case let .token(token) = asToken.nodeType else {
            
            fatalError()
        }
        
        assert(token.tokenType == .keyword(.coral(.as)))
    }
    
    func testUsingDeclarationAliasToken() {
        
        let usingDeclaration = self.setupUsingDeclaration()
        
        let aliasToken = usingDeclaration.children[3]
        
        guard case let .token(token) = aliasToken.nodeType else {
            
            fatalError()
        }
        
        guard case let .identifier(identifier) = token.tokenType else {
            
            fatalError()
        }
        
        assert(identifier == "MyAlias")
    }
}
