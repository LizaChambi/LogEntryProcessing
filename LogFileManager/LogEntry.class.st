Class {
	#name : #LogEntry,
	#superclass : #Object,
	#instVars : [
		'arguments',
		'selector',
		'timestamp',
		'stage',
		'group'
	],
	#category : #LogFileManager
}

{ #category : #'as yet unclassified' }
LogEntry class >> chunk: aChunk [
	^ self new convertChunkToLogEntry: aChunk.
]

{ #category : #'as yet unclassified' }
LogEntry class >> readLog: logStream [
	| logString |
	logString := self new convertChunkToLogEntry: (logStream next) withGroup: (LogGroup withSource:(logStream fileReference fullName)).
	^ logString.
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
LogEntry class >> timestamp: anInteger selector: aString arguments: aCollection stage: aStage group: aGroup [
	^ self new timestamp: anInteger selector: aString arguments: aCollection stage: aStage group: aGroup.
]

{ #category : #comparing }
LogEntry >> <= aLogEntry [
	"comment stating purpose of message"
	^ timestamp asInteger < aLogEntry timestamp asInteger 
]

{ #category : #comparing }
LogEntry >> = aLogEntry [
	"comment stating purpose of message"
	^ (timestamp = aLogEntry timestamp) and: [(arguments = aLogEntry arguments ) and: [(selector = aLogEntry selector) and: [(stage = aLogEntry stage) and: [(self group = aLogEntry group) ]]]].
]

{ #category : #accessing }
LogEntry >> arguments [
	"comment stating purpose of message"
	^ arguments
]

{ #category : #tests }
LogEntry >> convertChunkToLogEntry: aString [
	"comment stating purpose of message"
	^[^(OpalCompiler new) source: aString; context: nil; receiver: (self); evaluate] on: "SyntaxErrorNotification" Error do: [ :ex| ^ LogEntry timestamp: nil selector: nil arguments: nil stage:nil group: nil]. "ifError: [ ^ LogEntry timestamp: nil selector: nil arguments: nil stage:nil]".
]

{ #category : #tests }
LogEntry >> convertChunkToLogEntry: aChunk withGroup: aGroup [
	"comment stating purpose of message"
	^ ((self convertChunkToLogEntry: aChunk) group: aGroup).
]

{ #category : #editing }
LogEntry >> editWithLog: aLogEntry [
	"comment stating purpose of message"
	self
		assert: [ aLogEntry isValidLog ]
		description: 'Invalid log entered: The log is composed with ''self timestamp: aNumber selector: aMethod arguments: anArray'''.
	
	self
		assert: [ (aLogEntry stage = #Final) or: [ aLogEntry stage asNumber >= 0] ]
		description: 'Invalid stage value: ''stage: (aNumber >= 0)'' or #Final'.
	self
		assert: [ aLogEntry hasPathStageDifferent not ]
		description: 'File name do not matching with stage: File name must have prefix ''stage'' with number stage (Example, ''stage1-...'')'.

	self
		timestamp: aLogEntry timestamp asNumber
		selector: aLogEntry selector
		arguments: aLogEntry arguments
		stage: aLogEntry stage
		group: aLogEntry group.
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
	| newLog parsing |
	"comment stating purpose of message"
	parsing := LogEntryComposition new parseAndFlatten: aString.
	self parserValidation: parsing.
	newLog := LogEntry chunk: aString.
	newLog stage: self stage.
	newLog group: self group.
	self editWithLog: newLog.
]

{ #category : #'as yet unclassified' }
LogEntry >> failuresInGroup: aPathString [
	| failures |
	failures := OrderedCollection new.
	(self hasStageErrorOn: aPathString asFileReference)
		ifTrue: [ failures add: (ReportLogError description: 'Log stage does not match the file name.' nameFile: aPathString asFileReference basename logTimestamp: timestamp) ].
	(stage > 2)
		ifTrue: [ failures add: (ReportLogError description: 'Stage invalid.' nameFile: aPathString asFileReference basename logTimestamp: timestamp) ].
	^ failures.
]

{ #category : #accessing }
LogEntry >> group [
	"comment stating purpose of message"
	^ group.
]

{ #category : #tests }
LogEntry >> group: aLogGroup [
	"comment stating purpose of message"
	group:= aLogGroup.
]

{ #category : #accessing }
LogEntry >> gtInspectorEditLogEntry: composite [
	<gtInspectorPresentationOrder: 5>
	composite  pharoScript 
		title: 'Editor';
		selectionPopulate: #selection on: $s entitled: 'Save log' with: [:text | self editor: text text. composite update];
		display: [ :log | log editable ].
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
	^ (self source asFileReference basename beginsWith: ('stage', stage asString)) not.
]

{ #category : #conversion }
LogEntry >> hasStageErrorOn: aFileReference [
	"comment stating purpose of message"
	^ (aFileReference basename beginsWith: ('stage', self stage asString)) not.
]

{ #category : #accessing }
LogEntry >> isLogEntry [
	^ true
]

{ #category : #accessing }
LogEntry >> isValidLog [
	^ (self timestamp notNil) and: [ (self arguments notNil) and: [ (self selector notNil) and: [self stage notNil] ]].
]

{ #category : #accessing }
LogEntry >> parserValidation: aCollection [
	"index 1: self			
			2: timestamp 	3: aNumber
			4: selector 		5: aSymbol
			6: arguments 	7: aCollection "
	self
		assert: [ (aCollection at: 5) numArgs = (aCollection at: 7) size ]
		description: 'Numbers of arguments does not matching with number of arguments the selector'.
	self 
		assert: [ (aCollection at: 3) asNumber >= 0  ]
		description: 'Invalid timestamp: Timestamp value should be >= 0'.
	
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
	^ (group source).
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
LogEntry >> timestamp: aTimestamp selector: aString arguments: aCollection stage:aStage group: aGroup [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aString.
	arguments := aCollection.
	stage := aStage.
	group := aGroup.
]
