Class {
	#name : #ExpressionLogEntry,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'identifier',
		'ppTimestamp',
		'ppSelector',
		'ppArguments'
	],
	#category : #LogFileManager
}

{ #category : #accessing }
ExpressionLogEntry >> identifier [
	"comment stating purpose of message"
	^ #blank asPParser star, $s asPParser, $e asPParser, $l asPParser, $f asPParser, #blank asPParser star trim, #space asPParser star trim, #blank asPParser star trim,
		$t asPParser, $i asPParser, $m asPParser, $e asPParser, $s asPParser, $t asPParser, $a asPParser, $m asPParser, $p asPParser, $: asPParser trim, self ppTimestamp, 
		$s asPParser, $e asPParser, $l asPParser, $e asPParser, $c asPParser, $t asPParser, $o asPParser, $r asPParser, $: asPParser trim, self ppSelector,
		$a asPParser, $r asPParser, $g asPParser, $u asPParser, $m asPParser, $e asPParser, $n asPParser, $t asPParser, $s asPParser, $: asPParser trim, self ppArguments.
]

{ #category : #accessing }
ExpressionLogEntry >> parse: aString [
	"comment stating purpose of message"
	^ identifier parse: aString onError: [ :msg :pos | self error: 'Error at position: ', (pos+1) asString", '. Caracter: ', (text at:pos ) asString", ' .', msg ].
]

{ #category : #accessing }
ExpressionLogEntry >> parserValidator: aString [
	"comment stating purpose of message"
	^ identifier parse: aString onError: [ :msg :pos | self error: 'Error at position: ', (pos+1) asString", '. Caracter: ', (text at:pos ) asString, ' .', msg "].
]

{ #category : #accessing }
ExpressionLogEntry >> ppArguments [
	"comment stating purpose of message"
	^ $# asPParser trim, $( asPParser trim, (#any asPParser starLazy: ( $) asPParser trim, $. asPParser trim) ).
]

{ #category : #accessing }
ExpressionLogEntry >> ppSelector [
	"comment stating purpose of message"
	| ppMethod |
	ppMethod := PP2LiteralSequenceNode new.
	ppMethod := #word asPParser plus, $: asPParser star, #blank asPParser star trim, #space asPParser star trim, #blank asPParser star trim.
	^ $# asPParser trim, ppMethod plus.
]

{ #category : #accessing }
ExpressionLogEntry >> ppTimestamp [
	"comment stating purpose of message"
	^ #digit asPParser plus trim.
]

{ #category : #accessing }
ExpressionLogEntry >> start [
	"Answer the production to start this parser with."
	^ identifier end.
]
