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
	^ ppLogEntry parse: aString onError: [ :msg :pos | self error: 'Error at position: ', (pos+1) asString, '. ', msg ].
]

{ #category : #accessing }
LogEntryComposition >> parseAndFlatten: aString [
	|collect collectArguments|
	collect := (self parse: aString) asOrderedCollection.
	collectArguments := (collect at:7) asOrderedCollection removeIndex:3; removeIndex: 1.
	collect removeAt:8.
	collect removeAt:7.
	collect add: (collectArguments at:1).
	^ collect.
]

{ #category : #accessing }
LogEntryComposition >> ppArguments [
	"comment stating purpose of message"
	^ $# asPParser trim, $( asPParser trim, (#any asPParser starLazy: ( $) asPParser trim, $. asPParser trim) ).
]

{ #category : #accessing }
LogEntryComposition >> ppLogEntry [
	"comment stating purpose of message"
	^ (#space asPParser star trim, $s asPParser, $e asPParser, $l asPParser, $f asPParser, #space asPParser star trim) flatten ==> [ :ch | ch trim asString],
		($t asPParser, $i asPParser, $m asPParser, $e asPParser, $s asPParser, $t asPParser, $a asPParser, $m asPParser, $p asPParser, $: asPParser trim) flatten, ppTimestamp, 
		($s asPParser, $e asPParser, $l asPParser, $e asPParser, $c asPParser, $t asPParser, $o asPParser, $r asPParser, $: asPParser trim) flatten, ppSelector,
		($a asPParser, $r asPParser, $g asPParser, $u asPParser, $m asPParser, $e asPParser, $n asPParser, $t asPParser, $s asPParser, $: asPParser trim) flatten, ArgumentsComposition new ppArguments, (#space asPParser star trim, $. asPParser plus trim) flatten.
]

{ #category : #accessing }
LogEntryComposition >> ppMethod [
	"comment stating purpose of message"
	^ #word asPParser plus, $: asPParser star.
]

{ #category : #accessing }
LogEntryComposition >> ppSelector [
	"comment stating purpose of message"
	^ ($# asPParser trim, ppMethod plus, #space asPParser star trim) flatten ==> [ :ch | (ch trimBoth trimLeft: [ :sym | sym = $# ]) asSymbol].
]

{ #category : #accessing }
LogEntryComposition >> ppTimestamp [
	"comment stating purpose of message"
	^ (#space asPParser star trim, $- asPParser star, #digit asPParser plus trim, #space asPParser star trim) flatten ==> [:dig | dig trimBoth asNumber].
]

{ #category : #accessing }
LogEntryComposition >> start [
	"Answer the production to start this parser with."
	^ ppLogEntry end.
]
