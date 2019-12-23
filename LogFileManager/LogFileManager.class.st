Class {
	#name : #LogFileManager,
	#superclass : #Object,
	#instVars : [
		'logEntries',
		'report'
	],
	#classInstVars : [
		'filesToRead',
		'logEntries',
		'sortedEntries',
		'aLogEntry'
	],
	#category : #LogFileManager
}

{ #category : #adding }
LogFileManager >> addLog: aLogEntry [
	"comment stating purpose of message"
	(aLogEntry isValidLog)
		ifTrue: [ logEntries add: aLogEntry. aLogEntry addDependent: self] "ifFalse: [ - se puede guardar el log erroneo en un archivo con los logs erroneos - ]".
]

{ #category : #'as yet unclassified' }
LogFileManager >> filesToReadFromFolder: inputDirectory [
	"comment stating purpose of message"
	^ ((inputDirectory asFileReference) children) select: [ :each | each basename endsWith: '.changes' ].

]

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorReportStages: composite [
	<gtInspectorPresentationOrder: 2>
	composite fastList
		title: 'Report';
		display: [:each | (each report isEmpty ) ifTrue: ( #('No reports') ) ifFalse: [each report]].
]

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorTreeLogFiles: composite [
	<gtInspectorPresentationOrder: 1>
	| browser |
	browser := composite wrapper title: 'StagesTree'.
	browser show: [:a | 
		a fastTreeTable 
			display: [:each | {each}];
			children: [ :x | x sortLogsByStage ];
			column: 'Stages' evaluated: [:logs | (logs class = LogFileManager ) ifTrue: [ logs ] ifFalse: [ 'Stage ', (logs at:1) stage asString] ];
			maxDepth:1; rootsExpanded]; addAction: (GLMGenericAction new action: [ self saveFiles ]; icon: GLMUIThemeExtraIcons glamorousSave ; title: 'Save changes').
	^ browser
]

{ #category : #initialization }
LogFileManager >> initialize [
	"comment stating purpose of message"
	logEntries := OrderedCollection new..
	report  := OrderedCollection new..
]

{ #category : #accessing }
LogFileManager >> logEntries [
	"comment stating purpose of message"
	^ logEntries.
]

{ #category : #reading }
LogFileManager >> logStream: fileReference [
	^ ReadLogStream onStream: fileReference asFileReference readStream.
]

{ #category : #accessing }
LogFileManager >> logsWithStage: aStage [
	"comment stating purpose of message"
	^ (logEntries select: [ :log | log stage = aStage]) sort: [:log1 :log2 | log1 <= log2] .
]

{ #category : #'read/write usage' }
LogFileManager >> mergeOrderedLogFilesFrom: inputDirectory withName: fileNameOutput [
	"comment stating purpose of message"
	| filesToRead |
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file)].
	self writeFiles: (self sortLogEntriesByTimestamp: logEntries ) withName: fileNameOutput.
]

{ #category : #'as yet unclassified' }
LogFileManager >> mergeOrderedLogFilesFrom: inputDirectory withName: fileNameOutput matchingACriteria: aBlock [
	"comment stating purpose of message"
	| filesToRead |
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file) withCriteria: aBlock].
	self writeFiles: (self sortLogEntriesByTimestamp: logEntries) withName: fileNameOutput.
	
	
	
]

{ #category : #reading }
LogFileManager >> readLogsEntries: logStream [
	"Read a log file and add them as LogEntry files to the log entries"
	| logCreated |
	[ logStream atEnd ] whileFalse: [
		logCreated := LogEntry readLog: logStream.
		self reportLogStageError: logCreated onStream: logStream.
		self addLog: logCreated ].
	^ logEntries.
]

{ #category : #reading }
LogFileManager >> readLogsEntries: logStream  withCriteria: aBlock [
	"Read a log file and add them as LogEntry files to the log entries"
	| logCreated |
	[ logStream atEnd ] whileFalse: [
		logCreated := LogEntry readLog: logStream.
		self reportLogStageError: logCreated onStream: logStream.
		(logCreated hasCriteria: aBlock) ifTrue: [ self addLog: logCreated ]. 
	].
	^ logEntries.
]

{ #category : #accessing }
LogFileManager >> report [
	"comment stating purpose of message"
	^ report.
]

{ #category : #reading }
LogFileManager >> reportLogStageError: aLogEntry onStream: aStream [ 
	"Read a log file and add them as LogEntry files to the log entries"
	(aLogEntry hasStageErrorOn: aStream) ifTrue: [report add: (ReportStageError nameFile: aStream fileReference basename line: aStream position)].
]

{ #category : #'as yet unclassified' }
LogFileManager >> saveFiles [
	"comment stating purpose of message"
	| sources |
	sources := (logEntries collect: [ :log | log source ]) removeDuplicates.
	sources do: [ :source | self saveLogsWithSourceFile: source ].
	

	
	
	
]

{ #category : #'as yet unclassified' }
LogFileManager >> saveLogsWithSourceFile: aFile [
	"comment stating purpose of message"
	| logsToSave |
	logsToSave := self selectWithCriteria: [ :log | log source fullPath = aFile fullPath ].
	self writeFiles: (self sortLogEntriesByTimestamp: logsToSave) withName: aFile fullPath.
	
	
	
]

{ #category : #reading }
LogFileManager >> selectWithCriteria: aBlock [
	"Read a log file and add them as LogEntry files to the log entries"
	^ logEntries select:[ :log | log hasCriteria: aBlock ].
]

{ #category : #sorting }
LogFileManager >> sortLogEntriesByTimestamp: logs [
	"Sort the log entries by timestamp"
	|sortedEntries|
	sortedEntries := SortedCollection sortBlock: [:log1 :log2 | log1 timestamp <= log2 timestamp ].
	sortedEntries addAll: logs.
	^ sortedEntries.
]

{ #category : #accessing }
LogFileManager >> sortLogsByStage [
	"comment stating purpose of message"
	^ self stages collect: [:num | self logsWithStage: num ].
]

{ #category : #accessing }
LogFileManager >> stages [
	"comment stating purpose of message"
	^ (logEntries collect: [ :log | log stage]) removeDuplicates sort.
]

{ #category : #'as yet unclassified' }
LogFileManager >> writeFiles: aCollectionLogEntries withName: fileNameOutput [ 
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollectionLogEntries  do: [:log | t nextPutAll: log prettyPrint]].
	fileNameOutput asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]
