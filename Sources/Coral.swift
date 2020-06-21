//
//  Coral.swift
//

#if canImport(Foundation)

import Foundation

#endif

// MARK: - Alias

enum Alias: Hashable {
    
    case type
}

// MARK: - Block

enum Block: Hashable {
    
    case memberDeclaration
    case sourceFile
}

// MARK: - Clause
    
enum Clause: Hashable {
    
    case `catch`
    case initializer
    case parameter
    case returns
    case typeInheritance
}

// MARK: - Character

extension Character {
    
    public var isIdentifierPart: Bool {
        
        return self.isLetter || self.isNumber || self == "_"
    }
    
    public var isIdentifierStart: Bool {
        
        return self.isLetter || self == "_"
    }
    
    public var isNumberPart: Bool {
        
        return self.isNumber || self == "-" || self == "." || self == "e"
    }
    
    public var isNumberStart: Bool {
        
        return self.isNumber || self == "-" || self == "."
    }
    
    public var isQuotation: Bool {
        
        guard let asciiValue = self.asciiValue else {
            
            return false
        }
        
        return asciiValue == 34
    }
}

// MARK: - Comment

enum Comment: Hashable {
    
    case singleLine(String)
    case multiLine(String)
}

// MARK: - Condition

enum Condition: Hashable {
    
    case optionalBinding
}

// MARK: - Declaration

enum Declaration: Hashable {
    
    case alias
    case `associatedtype`
    case enumation
    case enumeratedCase
    case `extension`
    case function(Function)
    case interface
    case `operator`
    case structure
    case using
    case variable
}

// MARK: - Expression

enum Expression: Hashable {
    
    case array
    case binaryOperator
    case booleanLiteral
    case closure
    case dictionary
    case floatLiteral
    case functionCall
    case identifier
    case integerLiteral
    case memberAccess
    case prefixOperator
    case postfixUnary
    case sequence
    case stringLiteral
}

// MARK: - Function

enum Function: Hashable {
    
    case asynchronous // 'task' or 'async func`
    case synchronous
}

// MARK: - Item

enum Item: Hashable {
    
    case codeBlock
    case memberDeclaration
}

// MARK: - Keyword

enum Keyword: Hashable {
    
    case coral(Coral)
    case ir(IR)
}

// MARK: - Keyword - Init

extension Keyword {
    
    init?(_ rawValue: String) {
        
        if let ir = Keyword.IR(rawValue: rawValue) {
            
            self = .ir(ir)
        }
        else if let coral = Keyword.Coral(rawValue: rawValue) {
            
            self = .coral(coral)
        }
        else {
            
            return nil
        }
    }
}

// MARK: - Keyword - Coral

extension Keyword {
    
    enum Coral: String, Hashable {
        
        case `fileprivate`
        case final
        case `internal`
        case `let`
        case open
        case `public`
        case `private`
        case type
        case `using`
        case `var`
    }
}

// MARK: - Keyword - IR

extension Keyword {
    
    enum IR: String, Hashable {
        
        case `func`
        case `operator`
        case `task`
    }
}

// MARK: - Lexer

struct Lexer: Hashable {
    
    let input: String
    var position: String.Index
}

// MARK: - Lexer - Init

extension Lexer {
    
    #if canImport(Foundation)
    
    init(url: URL) throws {
        
        self.init(input: try String(contentsOf: url))
    }
    
    #endif
    
    init(input: String) {
        
        self.input = input
        
        self.position = self.input.startIndex
    }
}
 
// MARK: - Lexer - Consume

extension Lexer {
    
    @discardableResult
    mutating func consume() -> Character {
        
        let char = self.input[self.position]
        
        self.position = self.input.index(after: self.position)
        
        return char
    }
    
    mutating func consume(_ c: Character) {
        
        assert(self.consume() == c)
    }
    
    mutating func consume(_ s: String) {
        
        for c in s {
            
            self.consume(c)
        }
    }
    
    @discardableResult
    mutating func consume(_ test: ((Character) -> Bool)) -> String {
    
        var result = String()
    
        while !self.isEof && test(self.nextCharacter) {
            
            result.append(self.consume())
        }
    
        return result
    }
    
    @discardableResult
    mutating func consume(until test: String) -> String {
        
        var result = String()
        
        while !self.isEof && self.next(equals: test) {
            
            result.append(self.consume())
        }
        
        return result
    }
    
    mutating func consumeLetters() -> String {
        
        return self.consume { $0.isLetter }
    }
    
    mutating func consumeSpaces() {
        
        self.consume { $0 == " " || $0 == "\t" }
    }
}

// MARK: - Lexer - Lexing

extension Lexer {
    
    public mutating func lexToken() -> Token? {
        
        self.consumeSpaces()
        
        guard !self.isEof else {
            
            return nil
        }
        
        switch true {
            
        case _ where self.next(equals: "("):
            return self.lexLeftParen()
            
        case _ where self.next(equals: ")"):
            return self.lexRightParen()
            
        case _ where self.next(equals: "{"):
            return self.lexLeftBrace()
            
        case _ where self.next(equals: "}"):
            return self.lexRightBrace()
            
        case _ where self.next(equals: "["):
            return self.lexLeftBracket()
            
        case _ where self.next(equals: "]"):
            return self.lexRightBracket()
            
        case _ where self.next(equals: "."):
            return self.lexPeriod()
            
        case _ where self.nextCharacter.isQuotation:
            fatalError()
            
        case _ where self.nextCharacter.isIdentifierStart:
            return self.lexIdentifier()
            
            
        default:
            return self.lexIllegal()
        }
    }
}

// MARK: - Lexer - Lexing - Identifier

extension Lexer {
    
    mutating func lexIdentifier() -> Token {
        
        self.consumeSpaces()
        
        let idOrKeyword = self.consume { $0.isIdentifierPart }
        
        if let keyword = Keyword(idOrKeyword) {
            
            return Token(tokenType: .keyword(keyword))
        }
        
        return Token(tokenType: .identifier(idOrKeyword))
    }
}

// MARK: - Lexer - Lexing - Illegals

extension Lexer {
    
    mutating func lexIllegal() -> Token {
        
        let illegal = self.consume()
        
        return Token(tokenType: .illegal(String(illegal)))
    }
}

// MARK: - Lexer - Lexing - Punctuation

extension Lexer {
    
    mutating func lexLeftParen() -> Token {
        
        self.consume("(")
        
        return Token(tokenType: .punctuation(.leftParen))
    }
    
    mutating func lexRightParen() -> Token {
        
        self.consume(")")
        
        return Token(tokenType: .punctuation(.rightParen))
    }
    
    mutating func lexLeftBrace() -> Token {
        
        self.consume("{")
        
        return Token(tokenType: .punctuation(.leftBrace))
    }
    
    mutating func lexRightBrace() -> Token {
        
        self.consume("}")
        
        return Token(tokenType: .punctuation(.rightBrace))
    }
    
    mutating func lexLeftBracket() -> Token {
        
        self.consume("[")
        
        return Token(tokenType: .punctuation(.leftBracket))
    }
    
    mutating func lexRightBracket() -> Token {
        
        self.consume("]")
        
        return Token(tokenType: .punctuation(.rightBracket))
    }
    
    mutating func lexPeriod() -> Token {
        
        self.consume(".")
        
        return Token(tokenType: .punctuation(.period))
    }
}

// MARK: - Lexer - Next

extension Lexer {
    
    var isEof: Bool {
        
        return self.position == self.input.endIndex
    }
    
    var nextCharacter: Character {
        
        return self.input[self.position]
    }
    
    func next(equals str: String) -> Bool {
        
        guard !self.isEof else {
            
            return false
        }
        
        let start = self.position
        
        guard start < self.input.endIndex else {
            
            return false
        }
        
        let end = self.input.index(start, offsetBy: str.count)
    
        guard end < self.input.endIndex else {
            
            return false
        }
        
        let next = self.input[start..<end]
        
        return next == str
    }
}

// MARK: - List

enum List: Hashable {
    
    case arrayElement
    case catchClause
    case codeBlock
    case condition
    case enumeratedCases
    case expression
    case functionCallArgument
    case functionParameter
    case conformance // inheritedType
    case memberDeclaration
    case modifier
    case patternBinding
}

// MARK: - Node

struct Node: Hashable {
    
    let children: Array<Node>
    let nodeType: NodeType
    let start: String.Index
    let end: String.Index
}

// MARK: - NodeType

enum NodeType: Hashable {
    
    case block(Block)
    case clause(Clause)
    case condition(Condition)
    case declaration(Declaration)
    case declarationModifier
    case dictionaryElement
    case enumCase
    case expression(Expression)
    case functionSignature
    case identifierPattern
    case conformance // inheritedType
    case item(Item)
    case list(List)
    case optionalType
    case path
    case pathComponent(String)
    case pattern(Pattern)
    case patternBinding
    case simpleTypeIdentifier
    case statement(Statement)
    case stringLiteralSegments
    case stringSegment
    case sourceFile
    case token(Token)
    case typeAnnotation
}

// MARK: - Parser

struct Parser: Hashable {
    
    var lexer: Lexer
}

// MARK: - Parser - Init

extension Parser {
    
    #if canImport(Foundation)
    
    init(url: URL) throws {
        
        self.lexer = try Lexer(url: url)
    }
    
    #endif
    
    init(input: String) {
        
        self.lexer = Lexer(input: input)
    }
}

// MARK: - Parser - Coral

extension Parser {
    
    mutating func parseSourceFile() -> Node {
        
        let start = self.lexer.position
        
        let list = self.parseCodeBlockList()
        
        return Node(
            children: [list],
            nodeType: .sourceFile,
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parseCodeBlockList() -> Node {
        
        let start = self.lexer.position
        
        let items = self.parseCodeBlockItems()
        
        return Node(
            children: items,
            nodeType: .list(.codeBlock),
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parseCodeBlockItems() -> Array<Node> {
        
        var items = Array<Node>()
        
        while !self.lexer.isEof {
            
            guard let item = self.parseCodeBlockItem() else {
                
                break
            }
            
            items.append(item)
        }
        
        return items
    }
    
    mutating func parseCodeBlockItem() -> Node? {
        
        let start = self.lexer.position

        var children = Array<Node>()
        
        while !self.lexer.isEof {
            
            let position = self.lexer.position
            
            guard let token = self.lexer.lexToken() else {

                break
            }
            
            if case .punctuation(.rightBrace) = token.tokenType {
                
                break
            }
            
            if case .comment = token.tokenType {
                
                continue
            }
            
            children.append(self.parseToken(token, position, []))
        }
        
        return Node(
            children: children,
            nodeType: .item(.codeBlock),
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parseToken(_ token: Token, _ start: String.Index, _ modifiers: Array<Node>) -> Node {
        
        switch token.tokenType {
            
        case let .keyword(.coral(keyword)):
            return self.parseToken(token, start, keyword, modifiers)
            
        case let .keyword(.ir(keyword)):
            return self.parseToken(token, start, keyword, modifiers)
            
        default:
            return self.parseIllegal(token, start)
        }
    }
    
    mutating func parseToken(_ token: Token, _ start: String.Index, _ keyword: Keyword.Coral, _ modifiers: Array<Node>) -> Node {
        
        switch keyword {
            
        case .let,
             .var:
            return self.parseVariableDeclaration(token, start, modifiers)
            
        case .fileprivate,
             .final,
             .internal,
             .open,
             .private,
             .public:
            return self.parseToken(token, start, modifiers + [self.parseDeclarationModifier(token, start)])
            
        case .using:
            return self.parseUsingDeclaration(token, start)
            
        default:
            return self.parseIllegal(token, start)
        }
    }
    
    mutating func parseUsingDeclaration(_ token: Token, _ start: String.Index) -> Node {
        
        var children = Array<Node>()
        
        children.append(
            Node(
                children: [],
                nodeType: .token(token),
                start: start,
                end: self.lexer.position))
        
        self.lexer.consumeSpaces()
        
        if self.lexer.next(equals: "type") {
            
            let typeStart = self.lexer.position
            
            guard let type = self.lexer.lexToken(), case .keyword(.coral(.type)) = type.tokenType else {
                
                fatalError()
            }
            
            children.append(
                Node(
                    children: [],
                    nodeType: .token(type),
                    start: typeStart,
                    end: self.lexer.position))
        }
        
        self.lexer.consumeSpaces()
        
        let path = self.parsePath()
        
        children.append(path)
        
        return Node(
            children: children,
            nodeType: .declaration(.using),
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parsePath() -> Node {
        
        let start = self.lexer.position
        
        var components = Array<Node>()
        
        while !self.lexer.isEof {
            
            if self.lexer.next(equals: "\n") {
                
                break
            }
            
            if self.lexer.next(equals: " ") {
                
                break
            }
            
            let position = self.lexer.position
            
            guard let token = self.lexer.lexToken() else {
                
                fatalError()
            }
            
            switch token.tokenType {
                
            case let .identifier(identifier):
                
                components.append(
                    Node(
                        children: [],
                        nodeType: .pathComponent(identifier),
                        start: position,
                        end: self.lexer.position))
                
            case .punctuation(.period):
                
                components.append(
                    Node(
                        children: [],
                        nodeType: .token(token),
                        start: position,
                        end: self.lexer.position))
                
            default:
                fatalError()
            }
        }
        
        return Node(
            children: components,
            nodeType: .path,
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parseDeclarationModifier(_ token: Token, _ start: String.Index) -> Node {
        
        return Node(
            children: [
                Node(children: [], nodeType: .token(token), start: start, end: self.lexer.position)
            ],
            nodeType: .declarationModifier,
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parseToken(_ token: Token, _ start: String.Index, _ keyword: Keyword.IR, _ modifiers: Array<Node>) -> Node {
        
        fatalError()
    }
    
    mutating func parseVariableDeclaration(_ token: Token, _ _start: String.Index, _ modifiers: Array<Node>) -> Node {
        
        var start = _start
        
        var children = Array<Node>()
        
        if !modifiers.isEmpty {
            
            start = modifiers.map { $0.start }.min() ?? start
            
            let end = modifiers.map { $0.end }.max() ?? start
            
            children.append(
                Node(
                    children: modifiers,
                    nodeType: .list(.modifier),
                    start: start,
                    end: end))
        }
        
        children.append(
            Node(
                children: [],
                nodeType: .token(token),
                start: start,
                end: self.lexer.position))
        
        let list = self.parsePatternBindingList()
        
        return Node(
            children: [
                list
            ],
            nodeType: .declaration(.variable),
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parsePatternBindingList() -> Node {
        
        let start = self.lexer.position
        
        let patternBinding = self.parsePatternBinding()
        
        return Node(
            children: [patternBinding],
            nodeType: .list(.patternBinding),
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parsePatternBinding() -> Node {
        
        let start = self.lexer.position
        
        let identifierPattern = self.parseIdentifierPattern()
        
        let initializerClause = self.parseInitializerClause()
        
        return Node(
            children: [
                identifierPattern,
                initializerClause
            ],
            nodeType: .patternBinding,
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parseIdentifierPattern() -> Node {
        
        let start = self.lexer.position
        
        let identifier = self.lexer.lexIdentifier()
        
        return Node(
            children: [
                Node(
                    children: [],
                    nodeType: .token(identifier),
                    start: start,
                    end: self.lexer.position)
            ],
            nodeType: .identifierPattern,
            start: start,
            end: self.lexer.position)
    }
    
    mutating func parseInitializerClause() -> Node {
        
        fatalError()
    }
}

// MARK: - Parser - Illegal

extension Parser {
    
    mutating func parseIllegal(_ token: Token, _ start: String.Index) -> Node {
        
        fatalError()
    }
}

// MARK: - Pattern

enum Pattern: Hashable {
    
    case identifier
}

// MARK: - Punctuation

public enum Punctuation: Hashable {

    case leftBrace
    case rightBrace
    case leftParen
    case rightParen
    case leftBracket
    case rightBracket
    case period
    case colon
    case question
    case bang
    case hash
}

// MARK: - Statement

enum Statement: Hashable {
    
    case forIn
    case `if`
    case `return` // ->
    case `switch`
    case `try`
    case `while`
}

// MARK: - Token

struct Token: Hashable {
    
    public let tokenType: TokenType
}

// MARK: - TokenType

enum TokenType: Hashable {
    
    case comment(Comment)
    case identifier(String)
    case illegal(String)
    case keyword(Keyword)
    case punctuation(Punctuation)
}
