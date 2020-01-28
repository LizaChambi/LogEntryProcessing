Class {
	#name : #LogEntryComposition,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'ppLogEntry',
		'ppTimestamp',
		'ppSelector',
		'ppArguments',
		'ppMethod'
	],
	#category : #LogFileManager
}

{ #category : #accessing }
LogEntryComposition >> parse: aString [
	"comment stating purpose of message"
	^ ppLogEntry parse: aString onError: [ :msg :pos | self error: 'Error at position: ', (pos) asString, '. Character was found: ', $' asString, (aString at:pos) asString, $' asString, '.', msg ].
]

{ #category : #accessing }
LogEntryComposition >> ppArguments [
	"comment stating purpose of message"
	^ $# asPParser trim, $( asPParser trim, (#any asPParser starLazy: ( $) asPParser trim, $. asPParser trim) ).
]

{ #category : #accessing }
LogEntryComposition >> ppLogEntry [
	"comment stating purpose of message"
	^ (#space asPParser star trim, $s asPParser, $e asPParser, $l asPParser, $f asPParser, #space asPParser star trim) flatten,
		($t asPParser, $i asPParser, $m asPParser, $e asPParser, $s asPParser, $t asPParser, $a asPParser, $m asPParser, $p asPParser, $: asPParser trim) flatten, ppTimestamp, 
		($s asPParser, $e asPParser, $l asPParser, $e asPParser, $c asPParser, $t asPParser, $o asPParser, $r asPParser, $: asPParser trim) flatten, ppSelector,
		($a asPParser, $r asPParser, $g asPParser, $u asPParser, $m asPParser, $e asPParser, $n asPParser, $t asPParser, $s asPParser, $: asPParser trim) flatten, ArgumentsComposition new ppArguments, (#space asPParser star trim, "$) asPParser plus, #space asPParser star trim," $. asPParser plus trim) flatten.
]

{ #category : #accessing }
LogEntryComposition >> ppMethod [
	"comment stating purpose of message"
	^ #word asPParser plus, $: asPParser star.
]

{ #category : #accessing }
LogEntryComposition >> ppSelector [
	"comment stating purpose of message"
	^ ($# asPParser trim, ppMethod plus, #space asPParser star trim) flatten ==> [ :sym | (sym trimLeft: [:ch | ch = $#]) asSymbol].
]

{ #category : #accessing }
LogEntryComposition >> ppTimestamp [
	"comment stating purpose of message"
	^ (#space asPParser star trim, #digit asPParser plus trim, #space asPParser star trim) flatten ==> [:dig | dig trimmed asNumber].
]

{ #category : #accessing }
LogEntryComposition >> start [
	"Answer the production to start this parser with."
	^ ppLogEntry end.
]
