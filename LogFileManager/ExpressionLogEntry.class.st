Class {
	#name : #ExpressionLogEntry,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'ppLogEntry',
		'ppTimestamp',
		'ppSelector',
		'ppArguments'
	],
	#category : #LogFileManager
}

{ #category : #accessing }
ExpressionLogEntry >> parse: aString [
	"comment stating purpose of message"
	^ ppLogEntry parse: aString onError: [ :msg :pos | self error: 'Error at position: ', (pos+1) asString, '. Character: ', (aString at:pos) asString, ' .', msg ].
]

{ #category : #accessing }
ExpressionLogEntry >> ppArguments [
	"comment stating purpose of message"
	^ $# asPParser trim, $( asPParser trim, (#any asPParser starLazy: ( $) asPParser trim, $. asPParser trim) ).
]

{ #category : #accessing }
ExpressionLogEntry >> ppLogEntry [
	"comment stating purpose of message"
	^ (#space asPParser star trim, $s asPParser, $e asPParser, $l asPParser, $f asPParser, #space asPParser star trim,
		$t asPParser, $i asPParser, $m asPParser, $e asPParser, $s asPParser, $t asPParser, $a asPParser, $m asPParser, $p asPParser, $: asPParser trim, ppTimestamp, 
		$s asPParser, $e asPParser, $l asPParser, $e asPParser, $c asPParser, $t asPParser, $o asPParser, $r asPParser, $: asPParser trim, ppSelector,
		$a asPParser, $r asPParser, $g asPParser, $u asPParser, $m asPParser, $e asPParser, $n asPParser, $t asPParser, $s asPParser, $: asPParser trim, ppArguments),
		#space asPParser star trim, $) asPParser plus, #space asPParser star trim, $. asPParser plus trim.
]

{ #category : #accessing }
ExpressionLogEntry >> ppSelector [
	"comment stating purpose of message"
	| ppMethod |
	ppMethod := PP2LiteralSequenceNode new.
	ppMethod := #word asPParser plus, $: asPParser star.
	^ $# asPParser trim, ppMethod plus, #space asPParser star trim.
]

{ #category : #accessing }
ExpressionLogEntry >> ppTimestamp [
	"comment stating purpose of message"
	^ #digit asPParser plus trim.
]

{ #category : #accessing }
ExpressionLogEntry >> start [
	"Answer the production to start this parser with."
	^ ppLogEntry end.
]
