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
	| print|
	print := self new convertChunkToLogEntry: logStream next withOriginPath: logStream fileReference fullName.
	Transcript show: print prettyPrint.
	^ print.
]

{ #category : #'as yet unclassified' }
LogEntry class >> timestamp: anInteger selector: aString arguments: aCollection [
	^ self new timestamp: anInteger selector: aString arguments: aCollection.
]

{ #category : #'as yet unclassified' }
LogEntry class >> timestamp: anInteger selector: aString arguments: aCollection stage: aStage [
	^ self new timestamp: anInteger selector: aString arguments: aCollection stage: aStage.
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
	^ (timestamp = aLogEntry timestamp) and: [(arguments = aLogEntry arguments ) and: [(selector = aLogEntry selector) and: [(stage = aLogEntry stage) and: [source = aLogEntry source ]]]].
]

{ #category : #accessing }
LogEntry >> arguments [
	"comment stating purpose of message"
	^ arguments
]

{ #category : #tests }
LogEntry >> convertChunkToLogEntry: aString [
	"comment stating purpose of message"
	^[^(OpalCompiler new) source: aString; context: nil; receiver: (self); evaluate] on: "SyntaxErrorNotification" Error do: [ :ex|^ LogEntry timestamp: nil selector: nil arguments: nil stage:nil source: nil]. "ifError: [ ^ LogEntry timestamp: nil selector: nil arguments: nil stage:nil]".
]

{ #category : #tests }
LogEntry >> convertChunkToLogEntry: aChunk withOriginPath: aFileReference [
	"comment stating purpose of message"
	^ ((self convertChunkToLogEntry: aChunk) source: aFileReference).
]

{ #category : #accessing }
LogEntry >> editWithLog: aLogEntry [
	"comment stating purpose of message"
	self
		assert: [ aLogEntry isValidLog ]
		description: 'El log ingresado no es válido'.
	self
		assert: [ aLogEntry timestamp asNumber >= 0 ]
		description: 'El valor del timestamp debe ser un número válido'.
	self
		assert: [ aLogEntry selector isSymbol]
		description: 'Selector debe tener al menos un método.'.
	self
		assert: [ aLogEntry hasANumberCorrectArguments]
		description: 'La cantidad de argumentos no coinciden con los definidos en el selector.'.
	self
		assert: [ aLogEntry stage asNumber >= 0 ]
		description: 'El valor del stage no es un número válido'.
	self
		assert: [ aLogEntry hasPathStageDifferent not ]
		description: 'El nombre del archivo no coincide con el stage del log.'.

	self
		timestamp: aLogEntry timestamp asNumber
		selector: aLogEntry selector
		arguments: aLogEntry arguments
		stage: aLogEntry stage
		source: aLogEntry source.
	^ self
]

{ #category : #conversion }
LogEntry >> editable [
	"comment stating purpose of message"
	^'self
	timestamp: ', timestamp asString,'
	selector: ', '#', selector asString, '
	arguments: ', arguments asString, '.'.
]

{ #category : #accessing }
LogEntry >> editor: aString [
	| newLog |
	"comment stating purpose of message"
	newLog := LogEntry chunk: aString.
	newLog stage: self stage.
	newLog source: self source.
	self editWithLog: newLog.
]

{ #category : #accessing }
LogEntry >> gtInspectorEditLogEntry: composite [
	<gtInspectorPresentationOrder: 5>
| browser morph |
   morph := StringMorph new.
   browser := composite tabulator title: 'LogEditor'.
   browser
   		row: #edit.
   browser transmit
      to: #edit;
      andShow: [ :a | a pharoScript 
			selectionPopulate: #selection on: $s entitled: 'Save log' with: [:text | self editor: text text. composite update];
			display: [ :log | log editable ]
		].
 	^ browser.
]

{ #category : #accessing }
LogEntry >> gtInspectorLogOutput: composite [
	<gtInspectorPresentationOrder: 1>
	composite text
		title: 'PrettyPrint';
		display: [:log | log prettyPrint ].
]

{ #category : #accessing }
LogEntry >> gtInspectorLogTree: composite [
	<gtInspectorPresentationOrder: 2>
	composite fastTree 
		title: 'LogTree';
		display: [:each | {each} ];
		children: [ :each | each properties.];
		maxDepth:1; rootsExpanded.
]

{ #category : #accessing }
LogEntry >> gtInspectorLogTreeTable: composite [
	<gtInspectorPresentationOrder: 3>
	composite fastTreeTable
		title: 'LogTreeTable';
		display: [:each | {each} ];
		children: [ :x | x propertiesAsociation ];
		column: 'Property' evaluated: [:asoc | (asoc class = LogEntry) ifTrue: [asoc] ifFalse: [asoc key ] ];
		column: 'Value' evaluated: [:asoc | (asoc class = LogEntry) ifTrue: [''] ifFalse: [ (asoc value) value: (asoc key)] ];
		maxDepth:1; rootsExpanded.
]

{ #category : #accessing }
LogEntry >> hasANumberCorrectArguments [
	^ selector numArgs = arguments size.
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
LogEntry >> isLogEntry [
	^ true
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
LogEntry >> stage: aNumber [
	"comment stating purpose of message"
	stage := aNumber.
]

{ #category : #accessing }
LogEntry >> timestamp [
	"comment stating purpose of message"
	^ timestamp. 
]

{ #category : #accessing }
LogEntry >> timestamp: aNumber [
	"comment stating purpose of message"
	timestamp := aNumber. 
]

{ #category : #initialization }
LogEntry >> timestamp: aTimestamp selector: aString arguments: aCollection [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aString.
	arguments := aCollection.
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
