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
		'ppArguments',
		'ppSpace'
	],
	#category : #LogFileManager
}

{ #category : #accessing }
ArgumentsComposition >> parse: aString [
	"comment stating purpose of message"
	^ ppArguments parse: aString onError: [ :msg :pos | self error: 'Error at position: ', (pos) asString, '. Character was found: ', $' asString, (aString at:pos) asString, $' asString, '.', msg ].
]

{ #category : #accessing }
ArgumentsComposition >> ppArg [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	^ (ppWords / ppStrings / ppSymbol) flatten.
]

{ #category : #accessing }
ArgumentsComposition >> ppArguments [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	^ (ppSpace, $# asPParser, ppSpace, $( asPParser, ppSpace) flatten, (ppArg trim) star, (ppSpace, $) asPParser, ppSpace) flatten.
]

{ #category : #accessing }
ArgumentsComposition >> ppCharacters [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	^ (#word asPParser / $_ asPParser / $> asPParser / $| asPParser / $@ asPParser / $[ asPParser / $] asPParser / $- asPParser / $: asPParser / $= asPParser / $. asPParser / $^ asPParser / $, asPParser / '$' asPParser / $/ asPParser ) plus.
]

{ #category : #accessing }
ArgumentsComposition >> ppList [
	"comment stating purpose of instance-side message"
	^ $( asPParser, (ppArg, #space asPParser star trim) star, $) asPParser.
]

{ #category : #accessing }
ArgumentsComposition >> ppSpace [
	"comment stating purpose of instance-side message"
	^ #space asPParser star trim.
]

{ #category : #accessing }
ArgumentsComposition >> ppStrings [
	| nextArg finalArgList finalArg |
	"comment stating purpose of instance-side message"
	nextArg := $' asPParser, ' ' asPParser, ($# asPParser / #word asPParser / $' asPParser).
	finalArgList := $' asPParser, $) asPParser, #space asPParser.
	finalArg := $' asPParser trim end.
	^ $' asPParser, ppSpace, ( ppWords / (' ' asPParser negate star, ' ' asPParser) starLazy: (nextArg / finalArgList / finalArg ) ), $' asPParser star.
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
