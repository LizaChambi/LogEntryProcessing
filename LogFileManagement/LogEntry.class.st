Class {
	#name : #LogEntry,
	#superclass : #Object,
	#instVars : [
		'arguments',
		'selector',
		'timestamp'
	],
	#category : #LogFileManagement
}

{ #category : #'as yet unclassified' }
LogEntry class >> timestamp: anInteger selector: aString arguments: aCollection [ 
	^ self new timestamp: anInteger selector: aString arguments: aCollection.
]

{ #category : #comparing }
LogEntry >> <= aLogEntry [
	"comment stating purpose of message"
	^ timestamp asInteger < aLogEntry timestamp asInteger 
]

{ #category : #comparing }
LogEntry >> = aLogEntry [
	"comment stating purpose of message"

	^ (timestamp = aLogEntry timestamp) and: ((arguments = aLogEntry arguments ) and: (selector = aLogEntry selector)).
]

{ #category : #accessing }
LogEntry >> arguments [
	"comment stating purpose of message"
	^ arguments
]

{ #category : #conversion }
LogEntry >> asStringOutput [
	"comment stating purpose of message"
	^ 'self
	timestamp: ', timestamp asString,'
	selector: ', '#', selector asString,'
	arguments: ', arguments asString,'.
'.
]

{ #category : #tests }
LogEntry >> convertChunkToLogEntry: aString [
	"comment stating purpose of message"
	[(OpalCompiler new) source: aString; context: nil; receiver: (self); evaluate] ifError: [ LogEntry timestamp: nil selector: nil arguments: nil ].
	"* Creo un log invalido <- " 
	"* Corto la ejecucion"
	"* Creo un log invalido y genero un registro de logs erroneos con e mismo string que recibí"
]

{ #category : #accessing }
LogEntry >> gtInspectorLogIn: composite [
	<gtInspectorPresentationOrder: 1>
	composite text
		title: 'PropText';
		display: [:log | log asStringOutput ].
]

{ #category : #accessing }
LogEntry >> gtInspectorTreeLogIn: composite [
	<gtInspectorPresentationOrder: 2>
	composite fastTree 
		title: 'PropTree';
		display: [:each | {each} ];
		children: [ :each | each properties];
		maxDepth:1; rootsExpanded.
]

{ #category : #accessing }
LogEntry >> gtInspectorTreeTableLogIn: composite [
	<gtInspectorPresentationOrder: 3>
	composite fastTreeTable
		title: 'PropTreeTable';
		display: [:each | {each} ];
		children: [ :x | x propertiesAsociation ];
		column: 'Property' evaluated: [:asoc | (asoc class = LogEntry) ifTrue: [asoc] ifFalse: [asoc key ] ];
		column: 'Value' evaluated: [:asoc | (asoc class = LogEntry) ifTrue: [''] ifFalse: [ (asoc value) value: (asoc key)] ];
		maxDepth:1; rootsExpanded.
]

{ #category : #accessing }
LogEntry >> hasCriteria: aBlock [
	"comment stating purpose of message"
	"^ (self isValidLog) and: [ ^ aBlock cull: self  ]"
	^ aBlock cull: self
]

{ #category : #accessing }
LogEntry >> isLogEntry [
	^ true.
]

{ #category : #accessing }
LogEntry >> isValidLog [
	^ (self timestamp = nil) not and: [ (self arguments = nil) not and: [ (self selector = nil) not ] ].  

]

{ #category : #accessing }
LogEntry >> properties [
	^ {'timestamp: ', self timestamp asString . 'selector: ', self selector asString . 'arguments: ', self arguments asString}.
]

{ #category : #accessing }
LogEntry >> propertiesAsociation [
	| props res |
	props := LogEntry allInstVarNames.
	res := OrderedCollection new.
	props do: [:prop | res add: (prop -> [:nameProp | self instVarNamed: nameProp]) ].
	^ res.

]

{ #category : #accessing }
LogEntry >> selector [
	"comment stating purpose of message"
	^ selector
]

{ #category : #accessing }
LogEntry >> timestamp [
	"comment stating purpose of message"
	^ timestamp. 
]

{ #category : #initialization }
LogEntry >> timestamp: aTimestamp selector: aString arguments: aCollection [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aString.
	arguments := aCollection.
]
