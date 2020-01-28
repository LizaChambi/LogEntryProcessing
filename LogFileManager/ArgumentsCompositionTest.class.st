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
ArgumentsCompositionTest >> testPPArguments [
	"comment stating purpose of instance-side message"
	self parse: '#(''VaS_Ext class'' nil #() #''Array[String,Obj]'' #AbtRow 4 )' rule: #ppArguments.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithSymbolsCharacters [
	"comment stating purpose of instance-side message"
	self parse: '#Boolean_N' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithSymbolsCharacters2 [
	"comment stating purpose of instance-side message"
	self parse: '#NIL' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithSymbolsEmptyList [
	"comment stating purpose of instance-side message"
	self parse: '#()' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithSymbolsFullList [
	"comment stating purpose of instance-side message"
	self parse: '#(''rcv'' #() nil )' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithSymbolsStrings [
	"comment stating purpose of instance-side message"
	self parse: '#''BD>>test|BA|4|row''' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithSymbolsStringsAndSpace [
	"comment stating purpose of instance-side message"
	self parse: '#''Scaled class>> abtXml:$1''' rule: #ppSymbol.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithWordsDigit [
	"comment stating purpose of instance-side message"
	self parse: '4' rule: #ppWords.
]

{ #category : #tests }
ArgumentsCompositionTest >> testPPArgumentsWithWordsLetters [
	"comment stating purpose of instance-side message"
	self parse: '''onClass: aClass
	baseClass := aClass.
	^ self''' rule: #ppStrings.
]
