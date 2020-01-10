Class {
	#name : #LogFileManager,
	#superclass : #Object,
	#instVars : [
		'report',
		'logStages'
	],
	#classInstVars : [
		'filesToRead',
		'logEntries',
		'sortedEntries',
		'aLogEntry'
	],
	#category : #LogFileManager
}

{ #category : #'read/write usage' }
LogFileManager class >> readLogFilesFromFolder: aPath [
	"comment stating purpose of message"
	^ self new readLogFilesFromFolder: aPath.
]

{ #category : #adding }
LogFileManager >> addLog: aLogEntry [
	"comment stating purpose of message"
	(aLogEntry isValidLog)
		ifTrue: [ 
			"logEntries add: aLogEntry."
			self addStage: aLogEntry stage.
			(self findStage: aLogEntry stage) addLog: aLogEntry withSource: aLogEntry source.]
]

{ #category : #adding }
LogFileManager >> addNewGroup [
	"comment stating purpose of message"

]

{ #category : #adding }
LogFileManager >> addNewLog [
	"comment stating purpose of message"
	self addStage: self nextStage.
]

{ #category : #adding }
LogFileManager >> addStage: aNumber. [
	"comment stating purpose of message"
	(self existStage: aNumber) ifFalse: [ logStages add: (Stage new:aNumber) ].
]

{ #category : #adding }
LogFileManager >> existStage: aNumber [
	"comment stating purpose of message"
	^ logStages anySatisfy: [ :stage | stage stage = aNumber ].
]

{ #category : #'as yet unclassified' }
LogFileManager >> filesToReadFromFolder: inputDirectory [
	"comment stating purpose of message"
	^ ((inputDirectory asFileReference) children) select: [ :each | each basename endsWith: '.changes' ].

]

{ #category : #adding }
LogFileManager >> findStage: aNumber [
	"comment stating purpose of message"
	^ logStages detect: [ :stage | stage hasStage: aNumber ]. 
]

{ #category : #accessing }
LogFileManager >> groups [
	"comment stating purpose of message"
	^ self stages sort: [:stage1 :stage2 | stage1 stage < stage2 stage].
]

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorReportStages: composite [
	<gtInspectorPresentationOrder: 2>
	composite fastList
		title: 'Warning Report';
		display: [:each | (each report isEmpty ) ifTrue: ( #('No reports') ) ifFalse: [each report]].
]

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorTreeLogFiles3: composite [
 <gtInspectorPresentationOrder: 1>
	| browser |
	browser := composite tabulator.
	browser title: 'DragAndDrop'.
	browser column: #target; column: #source.
	browser transmit to: #target; andShow: [:a | a fastList
			addAction: (GLMGenericAction new action: [ self addNewLog. composite update ]; icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Stage');
			addAction: (GLMGenericAction new action: [ self saveFiles. composite update ]; icon: GLMUIThemeExtraIcons glamorousSave ; title: 'Save changes');
			display: [:each | each logEntries].
			"display: [:each | {each}];
			children: [ :x | x groups];
			column: 'Stages' evaluated: [:each | each print ] width: 1000;
			allowItemDrag: [:item :list | true ];
			maxDepth:2; rootsExpanded."
		].
	(browser transmit) from:#target; to: #source; andShow: [:a |  
		a fastList
			display: [: each | each logEntries ];
			allowDropOnItem: [:draggedObject :targetItem :list | draggedObject isLogEntry ];
			dropOnItem: [:draggedObject :targetItem :list | 
				list entity addLog: (draggedObject).
				list update.
				true ]
			].
	^ browser
]

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorTreeLogFiles: composite [
	<gtInspectorPresentationOrder: 1>
	| browser |
	browser := composite wrapper title: 'StagesTree'.
	browser show: [:a |  a fastTreeTable
			display: [:each | {each}];
			children: [ :x | x groups];
			column: 'Stages' evaluated: [:each | each print ] width: 1000;
			selectionAct: [:tree | (tree selection class = Stage) ifTrue: [ tree selection addNewGroup. composite update] ] icon: GLMUIThemeExtraIcons glamorousAdd entitled: 'Add group';
			maxDepth:2; 
			rootsExpanded;
			"addAction: (GLMGenericAction new action: [ (composite fastTreeTable selection class = Stage) ifTrue:[ composite fastTreeTable selection addNewGroup. composite update] ]; icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Group'; showTitle);"
		addAction: (GLMGenericAction new action: [ self addNewLog. composite update ]; icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Stage'; showTitle);
		addAction: (GLMGenericAction new action: [ self saveFiles. composite update ]; icon: GLMUIThemeExtraIcons glamorousSave ; title: 'Save changes'; showTitle).
			].
	 ^ browser
]

{ #category : #reading }
LogFileManager >> hasTimestampRepeated: aLogEntry [
	"Read a log file and add them as LogEntry files to the log entries"
	^ self logEntries anySatisfy: [ :log | log timestamp = aLogEntry timestamp ].
]

{ #category : #reading }
LogFileManager >> hasTimestampRepeatedInGroup: aLogEntry [
	"Read a log file and add them as LogEntry files to the log entries"
	^ self logEntries anySatisfy: [ :log | (log timestamp = aLogEntry timestamp) and: [ log group = aLogEntry group ] ].
]

{ #category : #initialization }
LogFileManager >> initialize [
	"comment stating purpose of message"
	logStages := OrderedCollection new.
	report  := OrderedCollection new.
]

{ #category : #accessing }
LogFileManager >> logEntries [
	"comment stating purpose of message"
	| logs |
	logs := OrderedCollection new.
	logStages do: [ :stage | logs addAll: stage logEntries ].
	^ logs.
]

{ #category : #reading }
LogFileManager >> logStream: fileReference [
	^ ReadLogStream onStream: fileReference asFileReference readStream.
]

{ #category : #accessing }
LogFileManager >> logsWithStage: aStage [
	"comment stating purpose of message"
	^ (self logEntries select: [ :log | log stage = aStage]) sort: [:log1 :log2 | log1 <= log2] .
]

{ #category : #'read/write usage' }
LogFileManager >> mergeOrderedLogFilesFrom: inputDirectory withName: fileNameOutput [
	"comment stating purpose of message"
	| filesToRead |
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file)].
	self writeFiles: (self sortLogEntriesByTimestamp: self logEntries ) withName: fileNameOutput.
]

{ #category : #'as yet unclassified' }
LogFileManager >> mergeOrderedLogFilesFrom: inputDirectory withName: fileNameOutput matchingACriteria: aBlock [
	"comment stating purpose of message"
	| filesToRead |
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file) withCriteria: aBlock].
	self writeFiles: (self sortLogEntriesByTimestamp: self logEntries) withName: fileNameOutput.
	
	
	
]

{ #category : #adding }
LogFileManager >> nextStage [
	"comment stating purpose of message"
	^(logStages collect: [ :stage | stage stage ]) max + 1. 
]

{ #category : #adding }
LogFileManager >> print [
	"comment stating purpose of message"
	^ self asString.
]

{ #category : #'read/write usage' }
LogFileManager >> readLogFilesFromFolder: inputDirectory [
	"comment stating purpose of message"
	| filesToRead |
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file)].
]

{ #category : #reading }
LogFileManager >> readLogsEntries: logStream [
	"Read a log file and add them as LogEntry files to the log entries"
	| logCreated |
	[ logStream atEnd ] whileFalse: [
		logCreated := LogEntry readLog: logStream.
		self reportLogErrors: logCreated onStream: logStream.
		self addLog: logCreated ].
	^ self logEntries.
]

{ #category : #reading }
LogFileManager >> readLogsEntries: logStream  withCriteria: aBlock [
	"Read a log file and add them as LogEntry files to the log entries"
	| logCreated |
	[ logStream atEnd ] whileFalse: [
		logCreated := LogEntry readLog: logStream.
		self reportLogErrors: logCreated onStream: logStream.
		(logCreated hasCriteria: aBlock) ifTrue: [ self addLog: logCreated ]. 
	].
	^ self logEntries.
]

{ #category : #'as yet unclassified' }
LogFileManager >> removeLogFiles [
	"Borrar los archivos que perdieron referencia"
	| filesToRemove |
	filesToRemove := (((logStages at:1) groups at:1) source asFileReference parent fullName) asFileReference. "Tomo la referencia de la carpeta"
	filesToRemove := filesToRemove children select: [ :each | each basename endsWith: '.changes' ]. "Filtro los archivos que tengo que eliminar"
	filesToRemove do: [:file | file delete]. "Eliminar los archivos enlistados"
	

	
	
	
]

{ #category : #accessing }
LogFileManager >> report [
	"comment stating purpose of message"
	^ report.
]

{ #category : #reading }
LogFileManager >> reportLogErrors: aLogEntry onStream: aStream [ 
	(aLogEntry hasStageErrorOn: aStream) 
		ifTrue: [report add: (ReportLogError description: 'Log stage does not match the file name.' nameFile: aStream fileReference basename line: aStream position)].
	(self hasTimestampRepeated: aLogEntry) 
		ifTrue: [ report add: (ReportLogError description: 'Timestamp repeated.' nameFile: aStream fileReference basename line: aStream position) ].
	(aLogEntry stage > 2) 
		ifTrue: [ report add: (ReportLogError description: 'Stage invalid.' nameFile: aStream fileReference basename line: aStream position) ].
]

{ #category : #'as yet unclassified' }
LogFileManager >> saveFiles [
	"comment stating purpose of message"
	| sources |
	self removeLogFiles.
	sources := (self logEntries collect: [ :log | log source ]) removeDuplicates.
	sources do: [ :source | self saveLogsWithSourceFile: source ].
	

	
	
	
]

{ #category : #'as yet unclassified' }
LogFileManager >> saveLogsWithSourceFile: aFile [
	"comment stating purpose of message"
	| logsToSave |
	logsToSave := self selectWithCriteria: [ :log | log source = aFile  ].
	self writeFiles: (self sortLogEntriesByTimestamp: logsToSave) withName: aFile .
	
	
	
]

{ #category : #reading }
LogFileManager >> selectWithCriteria: aBlock [
	"Read a log file and add them as LogEntry files to the log entries"
	^ self logEntries select:[ :log | log hasCriteria: aBlock ].
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
	^ logStages.
]

{ #category : #'as yet unclassified' }
LogFileManager >> writeFiles: aCollectionLogEntries withName: fileNameOutput [ 
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollectionLogEntries  do: [:log | t nextPutAll: log prettyPrint]].
	fileNameOutput asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]
