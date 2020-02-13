Class {
	#name : #LogFileManager,
	#superclass : #Object,
	#instVars : [
		'logStages',
		'sourceInput',
		'failures'
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
LogFileManager >> addLog: aLogEntry withSource: aPath [
	"comment stating purpose of message"
	(aLogEntry isValidLog)
		ifTrue: [ 
			"logEntries add: aLogEntry."
			self addStage: aLogEntry stage.
			(self findStage: aLogEntry stage) addLog: aLogEntry withSource: aPath.]
]

{ #category : #adding }
LogFileManager >> addNewStage [
	"comment stating purpose of message"
	self addStage: self nextStage.
]

{ #category : #adding }
LogFileManager >> addStage: aNumber [.
	"comment stating purpose of message"
	(self existStage: aNumber) ifFalse: [ logStages add: (Stage new:aNumber) ].
]

{ #category : #accessing }
LogFileManager >> childrens [
	"comment stating purpose of message"
	^ self stages sort: [:stage1 :stage2 | stage1 stage < stage2 stage].
]

{ #category : #'as yet unclassified' }
LogFileManager >> editFileGroup: aLogEntry to: pathString [
	| newLogEntry| 
	newLogEntry := LogEntry timestamp: aLogEntry timestamp selector: aLogEntry selector arguments: aLogEntry arguments stage: aLogEntry stage.
	(aLogEntry hasStageErrorOn: pathString asFileReference)
		ifTrue: [ self error: 'Log stage does not match the file name.' ]
		ifFalse:[ (aLogEntry source = pathString trim) 
			ifFalse: [ 
				self removeLogEntry: aLogEntry. "Remove log entry with old group"
				self addLog: newLogEntry withSource: pathString ] ] "Add/create a log entry with his properties and new path"
		
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

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorBugsReport: composite [
	<gtInspectorPresentationOrder: 2>
	composite fastList
		title: 'Failures';
		display: [:each | (each report isEmpty ) ifTrue: ( #('No failures.') ) ifFalse: [each report]].
]

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorTreeLogFiles2: composite [
	<gtInspectorPresentationOrder: 2>
	|tabulator finder|
	tabulator := GLMTabulator new.
	tabulator title: 'StagesTree2'.
	tabulator row: #Tree; row:#'Toolbar' size:60.
	(tabulator transmit) to:#Tree;
		andShow: [ :cp | cp fastTreeTable
			display: [:each | {each}];
			children: [ :x | x childrens];
			column: 'Stages' evaluated: [:each | each print ] width: 1000;
			selectionAct: [:tree | (tree selection class = Stage) ifTrue: [ tree selection addNewGroup. composite update] ] 
				icon: GLMUIThemeExtraIcons glamorousAdd entitled: 'Add group';
			maxDepth:2; 
			rootsExpanded;
			addAction: (GLMGenericAction new action: [ self addNewStage. composite update ]; icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Stage'; showTitle);
			addAction: (GLMGenericAction new action: [ self saveFiles. composite update ]; icon: GLMUIThemeExtraIcons glamorousSave ; title: 'Save changes'; showTitle).
		].
	(tabulator transmit) to:#Toolbar; from:#Tree;
		andShow: [ :x | |data| x text 
			display: [:dataTree | data:= dataTree. '']; 
			withGhostText: 'Input a group path...';
			addAction: (GLMGenericAction new action: [:path | (data class = Stage) ifTrue: [data addGroup: path text. composite update.] ]; 
				icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Group'; showTitle).
	].
	" (tabulator transmit) to:#Inspect; from:#Tree;
		andShow: [ :x | x list dynamicActionsOnSelection: [:text | OrderedCollection with: (GLMGenericAction new title: 'Print selection'; action: [text selectedText Smalltalk tools inspector]; yourself) ] ]."

	composite custom: tabulator.
]

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorTreeLogFiles3: composite [
	<gtInspectorPresentationOrder: 0>
	|tabulator |
	tabulator := composite tabulator.
	tabulator title: 'Administrator'.
	tabulator column: [: c | c row: #TreePanel; row:#GroupPanel size:55]; column: #InspectPanel.
	(tabulator transmit) to: #TreePanel;
		andShow: [ :comp2 | comp2 fastTreeTable 
			display: [:each | {each}];
			children: [ :x | x childrens];
			column: 'Stages' evaluated: [:each | each print ] width: 1000;
			maxDepth:2; 
			allExpanded;
			addAction: (GLMGenericAction new action: [ self addNewStage. composite update ]; icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Stage'; showTitle);
			addAction: (GLMGenericAction new action: [ self updateFailures. self saveFiles. self refreshFiles. composite update ]; icon: GLMUIThemeExtraIcons glamorousSave ; title: 'Save changes'; showTitle);
			addAction: (GLMGenericAction new action: [ :tree | tree selection inspect]; icon: GLMUIThemeExtraIcons glamorousInspect ; title: 'Inspect It'; showTitle);
			addAction: (GLMGenericAction new action: [ :tree | (tree selection class = LogGroup) ifTrue: [ tree selection addNewLogEntry. composite update ] ]; 
				icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add LogEntry'; showTitle);
				"El selectionAct sí funciona en las estructuras de aŕbol"
			selectionAct: [ :tree | self removeLogGroup: (tree selection). composite update ] entitled: 'Remove group' enabledWhen: [ :presentation | presentation selection class = LogGroup];
			selectionAct: [ :tree | self removeStage: (tree selection). composite update ] entitled: 'Remove stage' enabledWhen: [ :presentation | presentation selection class = Stage]
			].
		(tabulator transmit) from: #TreePanel; to: #GroupPanel;
			andShow: [ :comp3 | | data | comp3 text 
				display: [ :objModel | data := objModel. '' ];
				withGhostText: 'Input a group path...';
				addAction: (GLMGenericAction new action: [:textInput | (data class = Stage) ifTrue: [data addGroup: textInput text asString. composite update.] ]; 
					icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Group'; showTitle).
			].
		(tabulator transmit) from: #TreePanel; to:#InspectPanel; 
			andShow: [ :comp4 | comp4 fastList
				display: [ :each | each logEntries sort: [:log1 :log2 | log1 <= log2. ]];
				act: [ :list | list selection inspect ] icon: GLMUIThemeExtraIcons glamorousInspect entitled: 'Inspect';
				act: [ :list | list selection remove. composite update ] icon: GLMUIThemeExtraIcons glamorousTrash entitled: 'Remove';
				act: [ :list | self openEditStageOn: list selection from: composite.] icon: GLMUIThemeExtraIcons glamorousEdit entitled: 'Change Stage';
				act: [ :list | self openEditFileOn: list selection from:composite ] icon: GLMUIThemeExtraIcons glamorousBrowse entitled: 'Change file';
				act: [ :list | |tmpBrowser|
							tmpBrowser := GLMTabulator new row: #one; initialExtent: 400@200 ; title: 'Error:' ;yourself.
							tmpBrowser transmit to: #one ; 
								andShow: [:b | b morph
									display: [ ('Error message' asText) 
								addAttribute: (TextFontReference toFont: (LogicalFont familyName: 'Source Code Pro' pointSize: 10));
								"ignored addAttibute:() when font family cannot be found"
								yourself ].
								].
							tmpBrowser startOn: list selection.
							tmpBrowser open.
					] icon: GLMUIThemeExtraIcons glamorousCancel entitled: 'Error Message';
				
				
				
				"<*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*>"
				" SPAWN EXAMPLE "
				selectionSpawn: [:listPresentation | |tmpBrowser|
					tmpBrowser := GLMTabulator new row: #one; initialExtent: 400@200 ; title: 'Error:' ;yourself.
					tmpBrowser transmit to: #one ; 
						andShow: [:b | b text
							format: [ :x | ('Error message' asText) 
								makeColor: Color blue from: 2 to: 4; 
								makeColor: Color red from: 4 to: 5; "notice overlap"
								addAttribute: (TextFontReference toFont: (LogicalFont familyName: 'Source Code Pro' pointSize: 36)) from: 1 to: 1; 
								"ignored addAttibute:() when font family cannot be found"
								yourself]
						].
					tmpBrowser startOn: listPresentation selection
				] entitled: 'Open browser'.
			"<*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*>"
			
			]. 
]

{ #category : #'as yet unclassified' }
LogFileManager >> gtInspectorTreeLogFiles: composite [
	<gtInspectorPresentationOrder: 1>
	|tabulator pager|
	tabulator := GLMTabulator new.
	pager:= GLMPager new.
	tabulator title: 'StagesTree'.
	tabulator addRow:#Tree; addRow:#Toolbar size: 60.
	tabulator transmit to:#Tree; 
		"andShow: [ :cp | cp fastTreeTable"
		andShow: [ :cp | cp pager show: [ :algo | algo fastTreeTable  
			display: [:each | {each}];
			children: [ :x | x childrens];
			column: 'Stages' evaluated: [:each | each print ] width: 1000;
			selectionAct: [:tree | (tree selection class = Stage) ifTrue: [ tree selection addNewGroup. composite update] ] 
				icon: GLMUIThemeExtraIcons glamorousAdd entitled: 'Add group';
			maxDepth:2; 
			rootsExpanded;
			addAction: (GLMGenericAction new action: [ self addNewStage. composite update ]; icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Stage'; showTitle);
			addAction: (GLMGenericAction new action: [ self saveFiles. composite update ]; icon: GLMUIThemeExtraIcons glamorousSave ; title: 'Save changes'; showTitle).
		].].
	tabulator transmit to:#Toolbar; from:#Tree;
		andShow: [ :x | |data| x text 
			display: [:dataTree | data:= dataTree. '']; 
			withGhostText: 'Input a group path...';
			addAction: (GLMGenericAction new action: [:path | (data class = Stage) ifTrue: [data addGroup: path text. composite update.] ]; 
				icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Group'; showTitle).
	].

	composite custom: tabulator.
]

{ #category : #reading }
LogFileManager >> hasTimestampRepeated: aLogEntry inGroup: aSource [
	"Read a log file and add them as LogEntry files to the log entries"
	^ self logEntries anySatisfy: [ :log | (log timestamp = aLogEntry timestamp) and: [ log group source = aSource] ].
]

{ #category : #reading }
LogFileManager >> hasTimestampRepeatedInGroup: aLogEntry [
	"Read a log file and add them as LogEntry files to the log entries"
	^ self logEntries anySatisfy: [ :log | (log timestamp = aLogEntry timestamp) and: [ log group source = aLogEntry group source] ].
]

{ #category : #initialization }
LogFileManager >> initialize [
	"comment stating purpose of message"
	logStages := OrderedCollection new.
	failures  := OrderedCollection new.
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

{ #category : #'as yet unclassified' }
LogFileManager >> openEditFileOn: itemSelection from: aComposite [
	|tmpBrowser|
	tmpBrowser := GLMTabulator new row: #inputPath; initialExtent: 400@200 ; title: 'Change file' ;yourself.
	tmpBrowser transmit to: #inputPath ; 
		andShow: [:b | b text
			display: [ ('' asText) 
				addAttribute: (TextFontReference toFont: (LogicalFont familyName: 'Source Code Pro' pointSize: 10));
				yourself];
			withGhostText: 'Input a group path...';
			addAction: (GLMGenericAction new 
				action: [:textInput | [self editFileGroup: itemSelection to: textInput text asString. aComposite update] on: Error do: [:ex| self openErrorBrowserOn: itemSelection withMessage: ex messageText ]]; 
				icon: GLMUIThemeExtraIcons glamorousBrowse ; title: 'Change file'; showTitle)].
	tmpBrowser startOn: itemSelection.
	tmpBrowser open.
]

{ #category : #'as yet unclassified' }
LogFileManager >> openErrorBrowserOn: itemSelection withMessage: errorString [
	|tmpBrowser|
	tmpBrowser := GLMTabulator new row: #message; initialExtent: 400@200 ; title: 'Edition error' ;yourself.
	tmpBrowser transmit to: #message ; 
		andShow: [:b | b morph
			display: [ ( ('Error: ', errorString, Character cr asString, ' >> The source file must have the format: ''stage', itemSelection stage asString, '-aNameFile.changes') asText) 
				addAttribute: (TextFontReference toFont: (LogicalFont familyName: 'Source Code Pro' pointSize: 10));
				yourself].
		].
	tmpBrowser startOn: itemSelection.
	tmpBrowser open.
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
	sourceInput := inputDirectory.
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file)].
]

{ #category : #reading }
LogFileManager >> readLogsEntries: logStream [
	"Read a log file and add them as LogEntry files to the log entries"
	| logCreated |
	[ logStream atEnd] whileFalse: [
		logCreated := LogEntry readLog: logStream.
		self reportLogErrors: logCreated onStream: logStream.
		self addLog: logCreated withSource: logStream fileReference fullName].
	^ self logEntries.
]

{ #category : #reading }
LogFileManager >> readLogsEntries: logStream  withCriteria: aBlock [
	"Read a log file and add them as LogEntry files to the log entries"
	| logCreated |
	[ logStream atEnd ] whileFalse: [
		logCreated := LogEntry readLog: logStream.
		self reportLogErrors: logCreated onStream: logStream.
		(logCreated hasCriteria: aBlock) ifTrue: [ self addLog: logCreated withSource: logStream fileReference fullName].
	].
	^ self logEntries.
]

{ #category : #'as yet unclassified' }
LogFileManager >> refreshFiles [
	"comment stating purpose of instance-side message"
	logStages removeAll.
	self readLogFilesFromFolder: sourceInput.
]

{ #category : #adding }
LogFileManager >> removeLogEntry: aLogEntry [ 
	aLogEntry group removeLogEntry: aLogEntry.
]

{ #category : #'as yet unclassified' }
LogFileManager >> removeLogGroup: aLogGroup [
	logStages do: [ :stage | stage removeLogGroup: aLogGroup ].
	
]

{ #category : #'as yet unclassified' }
LogFileManager >> removeOlderLogFiles [
	"Borrar los archivos que perdieron referencia"
	| filesToRemove |
	"filesToRemove := (((logStages at:1) groups at:1) source asFileReference parent fullName) asFileReference." "Tomo la referencia de la carpeta"
	filesToRemove := sourceInput asFileReference children select: [ :each | each basename endsWith: '.changes' ]. "Filtro los archivos que tengo que eliminar de la carpeta"
	filesToRemove do: [:file | file delete]. "Eliminar los archivos enlistados"
	

	
	
	
]

{ #category : #removing }
LogFileManager >> removeStage: aStage [
	logStages removeAllSuchThat: [ :stage | stage = aStage].
]

{ #category : #accessing }
LogFileManager >> report [
	"comment stating purpose of message"
	^ failures.
]

{ #category : #reading }
LogFileManager >> reportLogErrors: aLogEntry onStream: aStream [
	"Con el método #updateFailures NO se puede cargar las inconsistencias porque solo el ReadLogStream conoce la posición de lectura actual."
	(aLogEntry isValidLog) ifTrue:
	[ (aLogEntry hasStageErrorOn: aStream fileReference) 
			ifTrue: [failures add: (ReportLogError description: 'Log stage does not match the file name.' nameFile: aStream fileReference basename line: aStream position logTimestamp: aLogEntry timestamp)].
		(self hasTimestampRepeated: aLogEntry inGroup: aStream fileReference fullName) 
			ifTrue: [ failures add: (ReportLogError description: 'Timestamp repeated' nameFile: aStream fileReference basename line: aStream position logTimestamp: aLogEntry timestamp) ].
		(aLogEntry stage > 2) 
			ifTrue: [ failures add: (ReportLogError description: 'Stage invalid.' nameFile: aStream fileReference basename line: aStream position logTimestamp: aLogEntry timestamp) ].
	].
]

{ #category : #'to deprecate' }
LogFileManager >> saveFiles [
	"comment stating purpose of message"
	(failures isEmpty) 
		ifTrue: [ self removeOlderLogFiles. logStages do: [ :stage | stage saveStage ]. ]
		ifFalse: [ self error: 'There are bug reports, fix them before saving.' ]. "Reemplazarlo por un mensaje de advertencia al usuario"
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

{ #category : #'as yet unclassified' }
LogFileManager >> sourceInput [
	"comment stating purpose of message"
	^ sourceInput

]

{ #category : #'as yet unclassified' }
LogFileManager >> sourceInput: aPathString [
	"comment stating purpose of message"
	sourceInput := aPathString.

]

{ #category : #accessing }
LogFileManager >> stages [
	"comment stating purpose of message"
	^ logStages.
]

{ #category : #'to deprecate' }
LogFileManager >> updateFailures [
	failures removeAll.
	logStages collect: [ :stage | failures addAll: stage failuresReport ].
]

{ #category : #'as yet unclassified' }
LogFileManager >> writeFiles: aCollectionLogEntries withName: fileNameOutput [ 
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollectionLogEntries  do: [:log | t nextPutAll: log prettyPrint]].
	fileNameOutput asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]
