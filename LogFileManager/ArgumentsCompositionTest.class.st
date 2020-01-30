Class {
	#name : #ArgumentsCompositionTest,
	#superclass : #PP2CompositeNodeTest,
	#category : #LogFileManager
}

{ #category : #accessing }
ArgumentsCompositionTest >> parserClass [
	^ ArgumentsComposition
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPASymbolsWithEmptyList [
	"comment stating purpose of instance-side message"
	self parse: '#()' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArguments [
	"comment stating purpose of instance-side message"
	self parse: '#(''VaS_Ext class'' nil #() #''Array[String,Obj]'' #AbtRow 4 )' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithSelfError [
	"comment stating purpose of instance-side message"
	self parse: '#(''or: anObject1 
	self error: ''''method #or: should be implemented by subclasses receiving the message'''''' ''Boolean'' #SmtSupportVASTTypingApp )' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithString [
	"comment stating purpose of instance-side message"
	self parse: '#(''VaS_Ext class'')' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPListEmpty [
	"comment stating purpose of instance-side message"
	self parse: '()' rule: #ppList.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPListWith2String [
	"comment stating purpose of instance-side message"
	self parse: '(''rcv'' ''VaS_Ext class'' )' rule: #ppList.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPListWithString [
	"comment stating purpose of instance-side message"
	self parse: '(''rcv'')' rule: #ppList.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPListWithSymbolListString [
	"comment stating purpose of instance-side message"
	self parse: '(#''EsParseNode class'')' rule: #ppList.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPListWithSymbolListStringWithSpace [
	"comment stating purpose of instance-side message"
	self parse: '(#(''EsParseNode class'') )' rule: #ppList.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPListWithSymbolListStringWithoutSpace [
	"comment stating purpose of instance-side message"
	self parse: '(#(''rcv'') )' rule: #ppList.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPListWithSymbolStringWithSpace [
	"comment stating purpose of instance-side message"
	self parse: '(#''EsParseNode class'')' rule: #ppList.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPStringsWithCharactersAndSpaces [
	"comment stating purpose of instance-side message"
	self parse: '#(''onClass: aClass
	baseClass := aClass.
	^ self'')' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPStringsWithSpaces [
	"comment stating purpose of instance-side message"
	self parse: '#(''VaS_Ext class'')' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPStringsWithStrings [
	"comment stating purpose of instance-side message"
	self parse: '#(''return compute-block [:message | self model typeNamed: ''''Interval['''' , (message parent receiver type ifNil: [ ''''?'''' ] ifNotNil: [ :t | t name ]) , '''']'''']'')' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPSymbolsWithCharacters [
	"comment stating purpose of instance-side message"
	self parse: '#Boolean_N' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPSymbolsWithFullList [
	"comment stating purpose of instance-side message"
	self parse: '#(''rcv'' #() nil )' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPSymbolsWithStrings [
	"comment stating purpose of instance-side message"
	self parse: '#(#''BD>>test|BA|4|row'')' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPSymbolsWithStringsAndSpace [
	"comment stating purpose of instance-side message"
	self parse: '#(#''Scaled class>> abtXml:$1'')' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPSymbolsWithStringsAndSpaceFinalSpace [
	"comment stating purpose of instance-side message"
	self parse: '#(#''Scaled class>> abtXml:$1'' )' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPSymbolsWithStringsFinalSpace [
	"comment stating purpose of instance-side message"
	self parse: '#(#''BD>>test|BA|4|row'' )' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPSymbolsWithWords [
	"comment stating purpose of instance-side message"
	self parse: '#NIL' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPWordsWithADigit [
	"comment stating purpose of instance-side message"
	self parse: '4' rule: #ppWords.
]
