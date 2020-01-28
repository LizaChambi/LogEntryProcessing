Class {
	#name : #ArgumentsComposition,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'ppArg',
		'ppWords',
		'ppSymbol',
		'ppCharacters',
		'ppStrings',
		'ppList',
		'ppArguments'
	],
	#category : #LogFileManager
}

{ #category : #accessing }
ArgumentsComposition >> ppArg [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	^ ppWords / ppStrings / ppSymbol.
]

{ #category : #accessing }
ArgumentsComposition >> ppArguments [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	^ (ppArg, #space asPParser) star flatten.
]

{ #category : #accessing }
ArgumentsComposition >> ppCharacters [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	^ (#word asPParser / $_ asPParser / $> asPParser / $| asPParser / $@ asPParser / $[ asPParser / $] asPParser / $- asPParser / $: asPParser / $= asPParser / $. asPParser / $^ asPParser / $, asPParser / '$' asPParser ) plus.
]

{ #category : #accessing }
ArgumentsComposition >> ppList [
	"comment stating purpose of instance-side message"
	^ $( asPParser, (ppArg, #space asPParser star trim) star, $) asPParser.
]

{ #category : #accessing }
ArgumentsComposition >> ppStrings [
	"comment stating purpose of instance-side message"
	^ $' asPParser, #space asPParser star, (ppCharacters / #space asPParser) plus, #space asPParser star, $' asPParser.
]

{ #category : #accessing }
ArgumentsComposition >> ppSymbol [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	^ $# asPParser, ( ppCharacters / ppStrings / ppList).
]

{ #category : #accessing }
ArgumentsComposition >> ppWords [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	^ #word asPParser plus.
]

{ #category : #accessing }
ArgumentsComposition >> start [
	"Answer the production to start this parser with."
	^ ppArguments end
]
