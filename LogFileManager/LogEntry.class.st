Class {
	#name : #LogEntry,
	#superclass : #Object,
	#instVars : [
		'arguments',
		'selector',
		'timestamp',
		'stage',
		'source'
	],
	#category : #LogFileManager
}

{ #category : #'as yet unclassified' }
LogEntry class >> chunk: aChunk [
	^ self new convertChunkToLogEntry: aChunk.
]

{ #category : #'as yet unclassified' }
LogEntry class >> readLog: logStream [
	^ self new convertChunkToLogEntry: logStream next withOriginPath: logStream fileReference fullName.
]

{ #category : #'as yet unclassified' }
LogEntry class >> timestamp: anInteger selector: aString arguments: aCollection stage: aStage [
	^ self new timestamp: anInteger selector: aString arguments: aCollection stage: aStage
]

{ #category : #'as yet unclassified' }
LogEntry class >> timestamp: anInteger selector: aString arguments: aCollection stage: aStage source: aPath [
	^ self new timestamp: anInteger selector: aString arguments: aCollection stage: aStage source: aPath asString.
]

{ #category : #comparing }
LogEntry >> <= aLogEntry [
	"comment stating purpose of message"
	^ timestamp asInteger < aLogEntry timestamp asInteger 
]

{ #category : #comparing }
LogEntry >> = aLogEntry [
	"comment stating purpose of message"

	^ (timestamp = aLogEntry timestamp) and: [(arguments = aLogEntry arguments ) and: [selector = aLogEntry selector]].
]

{ #category : #accessing }
LogEntry >> arguments [
	"comment stating purpose of message"
	^ arguments
]

{ #category : #tests }
LogEntry >> convertChunkToLogEntry: aString [
	"comment stating purpose of message"
	[^(OpalCompiler new) source: aString; context: nil; receiver: (self); evaluate] on: "SyntaxErrorNotification" Error do: [ :ex| ^ LogEntry timestamp: nil selector: nil arguments: nil stage:nil source: nil] "ifError: [ ^ LogEntry timestamp: nil selector: nil arguments: nil stage:nil]".
]

{ #category : #tests }
LogEntry >> convertChunkToLogEntry: aChunk withOriginPath: aFileReference [
	"comment stating purpose of message"
	^ (self convertChunkToLogEntry: aChunk) source: aFileReference.
]

{ #category : #accessing }
LogEntry >> editWithLog: aLogEntry [
	"comment stating purpose of message"
	( aLogEntry isValidLog) 
	ifTrue: [
		(aLogEntry hasPathStageDifferent) 
		ifTrue: [ self error: 'El nombre del archivo no coincide con el stage del log.' ] "Abrir un cartelito de advertencia"
		ifFalse: [ 
			(aLogEntry stage asNumber < 0) 
			ifTrue: [self error: 'El valor del stage no es un número válido.']
			ifFalse: [self timestamp: aLogEntry timestamp selector: aLogEntry selector arguments: aLogEntry arguments stage: aLogEntry stage source: aLogEntry source] ] ]
	ifFalse: [self error: 'El log ingresado no es válido.']. "Ventana de error"
]

{ #category : #conversion }
LogEntry >> editable [
	"comment stating purpose of message"
	^'timestamp: ', timestamp asString,'
selector: ', '#', selector asString, '
arguments: ', arguments asString, '
stage: ', stage asString, '
source: ', $' asString , source, $' asString , '.
'.
]

{ #category : #accessing }
LogEntry >> gtInspectorEditLogEntry: composite [
	<gtInspectorPresentationOrder: 5>
| browser morph |
   morph := StringMorph new.
   browser := composite tabulator title: 'Editor'.
   browser
   		row: #main.
   browser transmit
      to: #main;
      andShow: [ :a | a text 
			selectionPopulate: #selection on: $s entitled: 'Save log' with: [:text | self editWithLog: (LogEntry chunk: 'self ', Character cr asString, (text text)) ];
       " onChangeOfPort: #text act: [ :text  |
          morph contents: text text. self editWithLog: (LogEntry chunk: (morph contents) )];" display: [ :log | log editable ]].
 	^ browser
]

{ #category : #accessing }
LogEntry >> gtInspectorLogIn: composite [
	<gtInspectorPresentationOrder: 1>
	composite text
		title: 'PropText';
		display: [:log | log prettyPrint ].
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
	^ aBlock cull: self
]

{ #category : #accessing }
LogEntry >> hasPathStageDifferent [
	"comment stating purpose of message"
	^ (source asFileReference basename beginsWith: ('stage', stage asString)) not.
]

{ #category : #conversion }
LogEntry >> hasStageErrorOn: aLogStream [
	"comment stating purpose of message"
	^ (aLogStream fileReference basename beginsWith: ('stage', self stage asString)) not.
]

{ #category : #accessing }
LogEntry >> isValidLog [
	^ (self timestamp notNil) and: [ (self arguments notNil) and: [ (self selector notNil) and: [(self stage notNil) and: [ self source notNil]] ]].
]

{ #category : #conversion }
LogEntry >> prettyPrint [
	"comment stating purpose of message"
	^ 'self
	timestamp: ', timestamp asString,'
	selector: ', '#', selector asString, '
	arguments: ', arguments asString, '
	stage: ', stage asString, '.
'.
]

{ #category : #accessing }
LogEntry >> properties [
	| props |
	"props := self class allInstVarNames select: [ :prop | prop ~= #source]."
	props := self class allInstVarNames.
	^ props collect: [ :prop | prop , ': ', (self instVarNamed: prop) asString ].
]

{ #category : #accessing }
LogEntry >> propertiesAsociation [
	| props |
	"props := self class allInstVarNames select: [ :prop | prop ~= #source]."
	props := self class allInstVarNames.
	^ props collect: [:prop | (prop -> [:nameProp | self instVarNamed: nameProp]) ].

]

{ #category : #accessing }
LogEntry >> selector [
	"comment stating purpose of message"
	^ selector
]

{ #category : #accessing }
LogEntry >> source [
	"comment stating purpose of message"
	^ source
]

{ #category : #tests }
LogEntry >> source: aFileReference [
	"comment stating purpose of message"
	source:= aFileReference.
]

{ #category : #accessing }
LogEntry >> stage [
	"comment stating purpose of message"
	^ stage.
]

{ #category : #accessing }
LogEntry >> timestamp [
	"comment stating purpose of message"
	^ timestamp. 
]

{ #category : #initialization }
LogEntry >> timestamp: aTimestamp selector: aString arguments: aCollection stage:aStage [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aString.
	arguments := aCollection.
	stage := aStage.
]

{ #category : #initialization }
LogEntry >> timestamp: aTimestamp selector: aString arguments: aCollection stage:aStage source: aPath [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aString.
	arguments := aCollection.
	stage := aStage.
	source := aPath.
]
