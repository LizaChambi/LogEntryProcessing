Class {
	#name : #LogFileManager,
	#superclass : #Object,
	#instVars : [
		'sourceInput',
		'failures',
		'stages',
		'file'
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
LogFileManager >> addGroupWithName: aGroupName onStage: anNumberOrSymbol [
	"comment stating purpose of instance-side message"
	| searchStage |
	searchStage :=	stages detect: [ :stage | stage hasGroupWithName:aGroupName ] ifNone: [ stages detect: [:stage2 | stage2 hasLevel: anNumberOrSymbol] ].
	^ searchStage addGroup: aGroupName.
]

{ #category : #adding }
LogFileManager >> addLog: aLogEntry withSource: aFileName [
	"comment stating purpose of message"
	(aLogEntry isValidLog)
		ifTrue: [ 
			self stageParsing: aLogEntry.
			(self addStage: aLogEntry stage) addLog: aLogEntry withSource: aFileName.
		]
]

{ #category : #adding }
LogFileManager >> addNewStage [
	"comment stating purpose of message"
	self addStage: self nextStage.
]

{ #category : #adding }
LogFileManager >> addStage: aLevel [.
	"comment stating purpose of message"
	^ stages detect: [ :stage | stage level = aLevel] ifNone: [ stages add: (Stage new: aLevel) ].
	
	"(self existStage: aLevel) ifFalse: [ stages add: (Stage new: aLevel) ]."
]

{ #category : #accessing }
LogFileManager >> childrens [
	"comment stating purpose of message"
	^ self sortStages.
]

{ #category : #'as yet unclassified' }
LogFileManager >> editLogEntryGroup: aLogEntry to: aGroupName [
	| selectedStage |
	
	selectedStage := aLogEntry group stage.
	self removeLogEntry: aLogEntry.
	selectedStage addLog: aLogEntry withSource: selectedStage stageNamePrefix,'-', aGroupName,'.changes' . 
	

"	| newLogEntry | 
	newLogEntry := LogEntry timestamp: aLogEntry timestamp selector: aLogEntry selector arguments: aLogEntry arguments stage: aLogEntry stage.
	self removeLogEntry: aLogEntry.
	(self addGroupWithName: aGroupName onStage: newLogEntry stage) addLog: newLogEntry."
	
	
	
"	self addLog: newLogEntry fromFile: aGroupName ]"
	
"	(aLogEntry hasStageErrorOn: aGroupName asFileReference)
		ifTrue: [ self error: 'Log stage does not match the file name.' ]
		ifFalse:[ (aLogEntry source = aGroupName trim) 
			ifFalse: [ 
				self removeLogEntry: aLogEntry. Remove log entry with old group
				self addLog: newLogEntry withSource: aGroupName ] 
			] " "Add/create a log entry with his properties and new path"
		
]

{ #category : #'as yet unclassified' }
LogFileManager >> editStage: aLogEntry to: aLevelString [
	| newLevelStage  groupNameTemp|
	[	(aLevelString trim = 'Final') 
			ifTrue: [ newLevelStage := #Final ] 
			ifFalse: [(aLevelString isString) ifTrue: [ newLevelStage := aLevelString asNumber ] ]
	] on: Error do:[ self error: 'Invalid stage value:', Character cr asString, 'The values can be ''(aNumber >= 0)'' or ''Final''' ].
	
	(aLogEntry stage = newLevelStage) ifFalse: [
							groupNameTemp := aLogEntry group name.
							"self removeLogEntry: aLogEntry."
							aLogEntry group removeLogEntry: aLogEntry.
							aLogEntry stage: aLevelString.
							self addLog: aLogEntry withSource: ('stage', newLevelStage asString, '-', aLogEntry group name, '.changes' )].
	
]

{ #category : #'as yet unclassified' }
LogFileManager >> editStage: aLevelString withGroup: aName on: aLogEntry [
	| newLevelStage groupNameTemp |
		"ES CASI EL MISMO CODIGO DE #editStage:to: QUE VA A REEMPLAZARLO A LA HORA DE EDITAR EL STAGE" 
	groupNameTemp := aName.
	[	(aLevelString trim = 'Final') ifTrue: [ newLevelStage := #Final ].
	(aLevelString isString) ifTrue: [ newLevelStage := aLevelString asNumber ] ] on: 
		Error do:[ self error: 'Invalid stage value:', Character cr asString, 'The values can be ''(aNumber >= 0)'' or ''Final''' ].
	
	(aLogEntry stage = newLevelStage) "Si el stage ingresado es diferente al que tenia, empiezo la edicion..."
		ifFalse: [ (aName isEmpty) ifTrue: [ groupNameTemp := aLogEntry group name]. "Si no se ingresó un grupo entonces se usa el que ya tenia definido el log."
							aLogEntry group removeLogEntry: aLogEntry.
							aLogEntry stage: aLevelString.
							self addLog: aLogEntry withSource: ('stage', newLevelStage asString, '-', groupNameTemp, '.changes' )
					].
]

{ #category : #adding }
LogFileManager >> existStage: aNumber [
	"comment stating purpose of message"
	^ stages anySatisfy: [ :stage | stage level = aNumber ].
]

{ #category : #'as yet unclassified' }
LogFileManager >> filesToReadFromFolder: inputDirectory [
	"comment stating purpose of message"
	^ ((inputDirectory asFileReference) children) select: [ :each | each basename endsWith: '.changes' ].

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
			addAction: (GLMGenericAction new action: [ [self updateFailures. self saveFiles. self refreshFiles. composite update] on: Error do: [ :ex | self openErrorBrowserOn: composite withMessage: ex messageText ] ]; icon: GLMUIThemeExtraIcons glamorousSave ; title: 'Save changes'; showTitle);
			addAction: (GLMGenericAction new action: [ :tree | tree selection inspect]; icon: GLMUIThemeExtraIcons glamorousInspect ; title: 'Inspect It'; showTitle);
			addAction: (GLMGenericAction new action: [ :tree | (tree selection class = LogGroup or: [tree selection class = LogEntry]) 
				ifTrue: [ tree selection addNewLogEntry. composite update ] 
				ifFalse: [self openErrorBrowserOn: tree selection withMessage: 'Select the Group where the LogEntry will be created.'] ]; 
				icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add LogEntry'; showTitle);
			selectionAct: [ :tree | self removeLogGroup: (tree selection). composite update ] entitled: 'Remove group' enabledWhen: [ :presentation | presentation selection class = LogGroup];
			selectionAct: [ :tree | self removeStage: (tree selection). composite update ] entitled: 'Remove stage' enabledWhen: [ :presentation | presentation selection class = Stage]
			].
		(tabulator transmit) from: #TreePanel; to: #GroupPanel;
			andShow: [ :comp3 | | data | comp3 text 
				display: [ :objModel | data := objModel. '' ];
				withGhostText: 'Input a group path...';
				addAction: (GLMGenericAction new action: [:textInput | ((data class = Stage) or: [ data class = LogGroup ] ) 
					ifTrue: [ [data addGroup: textInput text asString. composite update] on: Error do: [ :ex | self openErrorBrowserOn: comp3 withMessage: ex messageText ] ] 
					ifFalse:[ self openErrorBrowserOn: comp3 withMessage: 'Select a Stage to add the new LogGroup.' ]]; 
					icon: GLMUIThemeExtraIcons glamorousAdd ; title: 'Add Group'; showTitle).
			].
		(tabulator transmit) from: #TreePanel; to:#InspectPanel; 
			andShow: [ :comp4 | comp4 fastList
				display: [ :each | each logEntries sort: [:log1 :log2 | log1 <= log2. ]];
				act: [ :list | list selection inspect ] icon: GLMUIThemeExtraIcons glamorousInspect entitled: 'Inspect';
				act: [ :list | list selection remove. composite update ] icon: GLMUIThemeExtraIcons glamorousTrash entitled: 'Remove';
				act: [ :list | self openEditStageOn: list selection from: composite] icon: GLMUIThemeExtraIcons glamorousEdit entitled: 'Change Stage';
				act: [ :list | self openEditFileOn: list selection from:composite ] icon: GLMUIThemeExtraIcons glamorousBrowse entitled: 'Change file'
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
LogFileManager >> hasTimestampRepeated: aLogEntry inGroup: aGroupName [
	"Read a log file and add them as LogEntry files to the log entries. (aLogEntry aun no tiene group)" 
	^ self logEntries anySatisfy: [ :log | (log timestamp = aLogEntry timestamp) and: [ log group name = aGroupName] ].
]

{ #category : #initialization }
LogFileManager >> initialize [
	"comment stating purpose of message"
	stages := OrderedCollection new.
	failures  := OrderedCollection new.
	sourceInput :=''.
]

{ #category : #accessing }
LogFileManager >> logEntries [
	"comment stating purpose of message"
	| logs |
	logs := OrderedCollection new.
	stages do: [ :stage | logs addAll: stage logEntries ].
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
	sourceInput := inputDirectory.
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file)].
	self writeFiles: (self sortLogEntriesByTimestamp: self logEntries ) withName: fileNameOutput.
]

{ #category : #'as yet unclassified' }
LogFileManager >> mergeOrderedLogFilesFrom: inputDirectory withName: fileNameOutput matchingACriteria: aBlock [
	"comment stating purpose of message"
	| filesToRead |
	sourceInput := inputDirectory.
	filesToRead := self filesToReadFromFolder: inputDirectory.
	filesToRead do: [ :file | self readLogsEntries: (self logStream: file) withCriteria: aBlock].
	self writeFiles: (self sortLogEntriesByTimestamp: self logEntries) withName: fileNameOutput.
	
	
	
]

{ #category : #adding }
LogFileManager >> nextStage [
	"comment stating purpose of message"
	^(stages collect: [ :stage | stage level ]) max + 1. 
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
				action: [:textInput | [self editLogEntryGroup: itemSelection to: textInput text asString. self updateFailures. aComposite update] on: Error do: [:ex| self openErrorBrowserOn: itemSelection withMessage: ('Error: ', ex messageText, Character cr asString, ' >> The source file must have the format: ''stage', itemSelection stage asString, '-aNameFile.changes''')]]; 
				icon: GLMUIThemeExtraIcons glamorousBrowse ; title: 'Change file'; showTitle)].
	tmpBrowser startOn: itemSelection.
	tmpBrowser open.
]

{ #category : #'as yet unclassified' }
LogFileManager >> openEditStageOn: itemSelection from: aComposite [
	|tmpBrowser|
	tmpBrowser := GLMTabulator new row: #inputPath; initialExtent: 400@200 ; title: 'Change stage' ;yourself.
	tmpBrowser transmit to: #inputPath ;
		andShow: [:b | b text
			display: [ ('' asText) 
				addAttribute: (TextFontReference toFont: (LogicalFont familyName: 'Source Code Pro' pointSize: 10));
				yourself];
			withGhostText: 'Input a stage...';
			addAction: (GLMGenericAction new 
				action: [:textInput | [ self editStage: itemSelection to: textInput text asString. self updateFailures. aComposite update ] on: Error do: [:ex| self openErrorBrowserOn: itemSelection withMessage: ex messageText ] ]; 
				icon: GLMUIThemeExtraIcons glamorousBrowse ; title: 'Change stage'; showTitle)].
	tmpBrowser startOn: itemSelection.
	tmpBrowser open.
]

{ #category : #'as yet unclassified' }
LogFileManager >> openErrorBrowserOn: itemSelection withMessage: errorString [
	|tmpBrowser|
	tmpBrowser := GLMTabulator new row: #message; initialExtent: 400@200 ; title: 'Edition error' ;yourself.
	tmpBrowser transmit to: #message ; 
		andShow: [:b | b morph
			display: [ ( errorString asText) 
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

{ #category : #'as yet unclassified' }
LogFileManager >> readEmptyFile: aFileName [
	| level levelPosition |
	levelPosition := 6.
	(aFileName beginsWith: ('stageFinal')) ifTrue: [ level:=#Final ].
	(aFileName beginsWith: ('stage')) ifTrue: [ level:= (aFileName at:levelPosition) digitValue ].
	
	[ self addStage: level. (self searchStageLevel: level) addGroup: (aFileName readStream upTo:$-; upToEnd)] on: 
		Error do: [ failures add: (ReportLogError description: 'The file name does not have the stage reference.' nameFile: aFileName) ].
	
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
	| createdLog |
	( logStream isEmptyFile) 
		ifTrue: [self readEmptyFile: logStream fileReference base]
		ifFalse: [ [ logStream atEnd] whileFalse: 
			[	createdLog := LogEntry readLog: logStream.
				self reportLogErrors: createdLog onStream: logStream.
				self addLog: createdLog withSource: logStream fileReference basename].
			^ self logEntries.
		]
]

{ #category : #reading }
LogFileManager >> readLogsEntries: logStream  withCriteria: aBlock [
	"Read a log file and add them as LogEntry files to the log entries"
	| logCreated |
	( logStream isEmptyFile) 
		ifTrue: [self readEmptyFile: logStream fileReference base ]
		ifFalse: [ [ logStream atEnd ] whileFalse: 
			[ logCreated := LogEntry readLog: logStream.
				self reportLogErrors: logCreated onStream: logStream.
				(logCreated hasCriteria: aBlock) ifTrue: [ self addLog: logCreated withSource: logStream fileReference basename]].
			^ self logEntries.
		]
	
]

{ #category : #'as yet unclassified' }
LogFileManager >> refreshFiles [
	"comment stating purpose of instance-side message"
	stages removeAll.
	self readLogFilesFromFolder: sourceInput.
]

{ #category : #adding }
LogFileManager >> removeLogEntry: aLogEntry [ 
	aLogEntry group removeLogEntry: aLogEntry.
]

{ #category : #'as yet unclassified' }
LogFileManager >> removeLogGroup: aLogGroup [
	aLogGroup stage removeLogGroup: aLogGroup.
	
]

{ #category : #'as yet unclassified' }
LogFileManager >> removeOlderLogFiles [
	| filesToRemove |
	filesToRemove := sourceInput asFileReference children select: [ :each | each basename endsWith: '.changes' ].
	filesToRemove do: [:file | file delete]. 
	

	
	
	
]

{ #category : #removing }
LogFileManager >> removeStage: aStage [
	stages removeAllSuchThat: [ :stage | stage hasLevel: aStage level].
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
		(self hasTimestampRepeated: aLogEntry inGroup: (aStream fileReference base readStream upTo:$-; upToEnd)) 
			ifTrue: [ failures add: (ReportLogError description: 'Timestamp repeated' nameFile: aStream fileReference basename line: aStream position logTimestamp: aLogEntry timestamp) ].
	].
]

{ #category : #'read/write usage' }
LogFileManager >> saveFiles [
	"comment stating purpose of message"
	(failures isEmpty) 
		ifTrue: [ self removeOlderLogFiles. stages do: [ :stage | stage saveStageOnFolder: sourceInput ]. ]
		ifFalse: [ self error: 'There are bug reports, fix them before saving.' ].
]

{ #category : #adding }
LogFileManager >> searchStageLevel: aLevel [
	"comment stating purpose of message"
	^ stages detect: [ :stage | stage hasLevel: aLevel ]. 
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

{ #category : #sorting }
LogFileManager >> sortStages [
	"comment stating purpose of instance-side message"
	^ stages sort: [ :stage1 :stage2 | stage1 < stage2 ].
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

{ #category : #'as yet unclassified' }
LogFileManager >> stageParsing: aLogEntry [
	"comment stating purpose of instance-side message"
	(aLogEntry stage = #Final) ifTrue:[ ^ aLogEntry ].
	(aLogEntry stage == 'Final') ifTrue: [ ^ aLogEntry stage: #Final ].
	(aLogEntry stage isCharacter ) ifTrue: [ ^ aLogEntry stage: aLogEntry stage digitValue ] ifFalse:[ ^ aLogEntry stage: aLogEntry stage asNumber ].
	" $0 isCharacter => true ".
	
]

{ #category : #accessing }
LogFileManager >> stages [
	"comment stating purpose of message"
	^ stages.
]

{ #category : #'to deprecate' }
LogFileManager >> updateFailures [
	failures removeAll.
	stages collect: [ :stage | failures addAll: stage failuresReport ].
]

{ #category : #'as yet unclassified' }
LogFileManager >> writeFiles: aCollectionLogEntries withName: fileNameOutput [ 
	"Write a file with the log entries with the given name"
	| text |	
	text := String streamContents: [:t | aCollectionLogEntries  do: [:log | t nextPutAll: log prettyPrint]].
	fileNameOutput asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: text ].
]
