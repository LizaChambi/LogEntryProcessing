Class {
	#name : #LogFileManagerTest,
	#superclass : #TestCase,
	#instVars : [
		'logFileManager',
		'log0',
		'log8',
		'log33',
		'path1',
		'path2',
		'path3',
		'pathFolder',
		'pathWithEmptyFiles'
	],
	#classInstVars : [
		'text',
		'logFileManagement'
	],
	#category : #'LogFileManager-Test'
}

{ #category : #tests }
LogFileManagerTest >> readFile: aPath [
	"comment stating purpose of message"
	^ aPath asFileReference readStream upToEnd replaceAll: Character lf with: Character cr.
]

{ #category : #running }
LogFileManagerTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	logFileManager := LogFileManager new.
	
	log33 := LogEntry timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ) stage:0.
	log0 := LogEntry timestamp: 0 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('DateTime' #SmtSupportVASTTypingApp 'Array' #() #() #() ) stage:1.
	log8 := LogEntry timestamp: 8 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('SmtEntireFileReadStream' #SmtSupportVASTTypingApp 'CfsReadFileStream' #() #() #() ) stage: 0.
	path1 := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/resources/stage0-entriesExample.changes'.
	path2 := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfile.changes'.
	path3 := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfileCr.changes'.
	pathFolder := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/resources'.
	
]

{ #category : #tests }
LogFileManagerTest >> testAddLogFromFile [
	"comment stating purpose of message"
	| aLogEntry |
	aLogEntry := LogEntry timestamp: '123456' selector: '#doAssignType:to:' arguments: '#(#Integer #''MoProgramStarter>>sleep:$1'')' stage: '0'.
	logFileManager addLog: aLogEntry fromFile: 'stage0-file.changes'.
	self assert: (logFileManager logEntries size) equals: (1).
	self assert: (logFileManager logEntries at:1) equals: (aLogEntry).
]

{ #category : #tests }
LogFileManagerTest >> testAddLogFromFileWithStageFinal [
	"comment stating purpose of message"
	| aLogEntry |
	aLogEntry := LogEntry timestamp: '123456' selector: '#doAssignType:to:' arguments: '#(#Integer #''MoProgramStarter>>sleep:$1'')' stage: 'Final'.
	logFileManager addLog: aLogEntry fromFile: 'stage0-file.changes'.
	self assert: (logFileManager logEntries size) equals: (1).
	self assert: (logFileManager logEntries at:1) equals: (aLogEntry).
]

{ #category : #tests }
LogFileManagerTest >> testAddRepeatStage [
	"comment stating purpose of message"
	logFileManager addStage: 1.
	logFileManager addStage: 1.
	self assert: ((logFileManager stages at:1) level) equals: (1).
	self assert: ((logFileManager stages at:1) groups isEmpty).
	self assert: (logFileManager stages size) equals: (1).
	
]

{ #category : #tests }
LogFileManagerTest >> testAddStage [
	"comment stating purpose of message"
	logFileManager addStage: 1.
	self assert: ((logFileManager stages at:1) level) equals: (1).
	self assert: ((logFileManager stages at:1) groups isEmpty).
	self assert: (logFileManager stages size) equals: (1).
	
]

{ #category : #tests }
LogFileManagerTest >> testAddStageFinal [
	"comment stating purpose of message"
	logFileManager addStage: #Final.
	self assert: ((logFileManager stages at:1) level) equals: (#Final).
	self assert: ((logFileManager stages at:1) groups isEmpty).
	self assert: (logFileManager stages size) equals: (1).
	
]

{ #category : #tests }
LogFileManagerTest >> testChildrens [
	| childrens |
	"comment stating purpose of message"
	logFileManager addStage: 1.
	logFileManager addStage: #Final.
	logFileManager addStage: 2.
	logFileManager addStage: 0.
	childrens := logFileManager childrens.
	self assert: ((childrens at:1) level) equals: (0).
	self assert: ((childrens at:2) level) equals: (1).
	self assert: ((childrens at:3) level) equals: (2).
	self assert: ((childrens at:4) level) equals: (#Final).
]

{ #category : #tests }
LogFileManagerTest >> testExceptionAddLogNil [
	"comment stating purpose of message"
	logFileManager addLog: (LogEntry timestamp: nil selector: nil arguments:nil stage: nil group: nil) withSource: 'path'.
	self assert: (logFileManager logEntries isEmpty).
]

{ #category : #tests }
LogFileManagerTest >> testFindStage [
	"comment stating purpose of message"
	logFileManager addStage: 0; addStage: 1.
	self assert: ((logFileManager searchStageLevel:0) level ) equals: (0).
	
]

{ #category : #tests }
LogFileManagerTest >> testFindStageException [
	"comment stating purpose of message"
	logFileManager addStage: 0; addStage: 1.
	self should: [(logFileManager searchStageLevel:3) stage ] raise: (Error).
	
]

{ #category : #tests }
LogFileManagerTest >> testFindStageFinal [
	"comment stating purpose of message"
	logFileManager addStage: 0; addStage: 1; addStage:#Final.
	self assert: ((logFileManager searchStageLevel:#Final) level ) equals: (#Final).
	
]

{ #category : #tests }
LogFileManagerTest >> testFindStageFinalNotFound [
	"comment stating purpose of message"
	logFileManager addStage: 0; addStage: 1.
	self should:[ logFileManager searchStageLevel:#Final ] raise: (NotFound).
	
]

{ #category : #tests }
LogFileManagerTest >> testLogsWithStage0 [
	"comment stating purpose of message"
	| logStream |
	logStream := ReadLogStream onStream: path1 asFileReference readStream.
	logFileManager addLog: log0 withSource: 'path0'.
	logFileManager addLog: log33 withSource: 'path33'.
	logFileManager addLog: log8 withSource: 'path8'.
	self assert: ( (logFileManager logsWithStage:0) size) equals: (2).
]

{ #category : #tests }
LogFileManagerTest >> testMergeOrderedALogFileFromPath [
	"comment stating purpose of message"
	logFileManager mergeOrderedLogFilesFrom: pathFolder withName: 'sortedLogFiles'.
	
	self assert: (self readFile: 'sortedLogFiles') equals: 'self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #())
	stage: 1.
self
	timestamp: 8
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''SmtEntireFileReadStream'' #SmtSupportVASTTypingApp ''CfsReadFileStream'' #() #() #())
	stage: 0.
self
	timestamp: 33
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #())
	stage: 0.
'.
	'sortedLogFiles' asFileReference ensureDelete.
]

{ #category : #tests }
LogFileManagerTest >> testMergeOrderedALogFileFromPathWithCriteria [
	"comment stating purpose of message"
	logFileManager mergeOrderedLogFilesFrom: pathFolder withName: 'sortedLogFiles' matchingACriteria: [:log | log timestamp < 10 ].

	self assert: (self readFile: 'sortedLogFiles') equals: 'self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #())
	stage: 1.
self
	timestamp: 8
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''SmtEntireFileReadStream'' #SmtSupportVASTTypingApp ''CfsReadFileStream'' #() #() #())
	stage: 0.
'.
	'sortedLogFiles' asFileReference ensureDelete.
]

{ #category : #tests }
LogFileManagerTest >> testNoReportLogState [
	"comment stating purpose of message"
	| logStream |
	logStream := ReadLogStream onStream: path2 asFileReference readStream.
	logFileManager reportLogErrors: log33 onStream: logStream.
	self assert: ( logFileManager report size) equals: (0).
]

{ #category : #tests }
LogFileManagerTest >> testOneEntryWithCR [
	"comment stating purpose of message"
	| result |
	result := logFileManager readLogsEntries: (ReadLogStream onStream: path3 asFileReference readStream ).
	self assert: result notEmpty.
	self assert: ((result at: 1) timestamp) equals: (0).
	self assert: ((result at: 1) selector) equals: (#doAddCorrelationRule:to:).
	self assert: ((result at: 1) arguments) equals: ( #('argument1.argument1 same-as #Integer' 'ByteArray>>do:')).
	self assert: ((result at: 1) stage) equals: (0).
	self assert: ((result at: 1) groupName) equals: ('testfileCr').
]

{ #category : #tests }
LogFileManagerTest >> testOneEntryWithoutCR [
	"comment stating purpose of message"
	| result |
	result := logFileManager readLogsEntries: (ReadLogStream onStream: path2 asFileReference readStream ).
	self assert: result notEmpty.
	self assert: ((result at: 1) timestamp) equals: (0).
	self assert: ((result at: 1) selector) equals: (#doAddCorrelationRule:to:).
	self assert: ((result at: 1) arguments) equals: ( #('argument1.argument1 same-as #Integer' 'ByteArray>>do:') ).
	self assert: ((result at: 1) stage) equals: (0).
	self assert: ((result at: 1) groupName) equals: ('testfile').
]

{ #category : #tests }
LogFileManagerTest >> testReadLogEntries [
	"comment stating purpose of message"
	|entryManager|
	entryManager := LogFileManager new.
	self assert: ((entryManager readLogsEntries: (ReadLogStream onStream: path1 asFileReference readStream ) ) size) equals: (3).
]

{ #category : #tests }
LogFileManagerTest >> testReadLogFilesFromFolder [
	"comment stating purpose of message"
	| stages|
	logFileManager := LogFileManager readLogFilesFromFolder: pathFolder.
	self assert: (logFileManager logEntries size) equals: (3).
	stages := logFileManager stages.
	self assert: ( stages size) equals: (2).
	self assert: ( (stages at:1) groups size) equals: (2).
	self assert: ( ((stages at:1) groups at:1) logEntries size) equals: (0).
	self assert: ( ((stages at:1) groups at:2) logEntries size) equals: (2).
	
]

{ #category : #tests }
LogFileManagerTest >> testReadLogsEntriesWithCriteriaTimestamp0 [
	"comment stating purpose of message"
	logFileManager readLogsEntries: (ReadLogStream onStream: path1 asFileReference readStream ) withCriteria: [:log | log timestamp = 0].
	self assert: (logFileManager logEntries size) equals: (1).
]

{ #category : #tests }
LogFileManagerTest >> testRemoveLogEntry [
	"comment stating purpose of message"
	logFileManager addLog: log0 withSource: 'path1/stage1-algo1.changes'.
	logFileManager addLog: log8 withSource: 'path2/stage0-algo2.changes'.
	logFileManager removeLogEntry: (log0).
	self assert: (logFileManager logEntries size) equals: (1).
	self assert: ((logFileManager logEntries at:1) timestamp) equals: (log8 timestamp).
	self assert: ((logFileManager logEntries at:1) selector) equals: (log8 selector).
	self assert: ((logFileManager logEntries at:1) arguments) equals: (log8 arguments).
	self assert: ((logFileManager logEntries at:1) stage) equals: (log8 stage).
	self assert: ((logFileManager logEntries at:1) groupName) equals: ('algo2').
]

{ #category : #tests }
LogFileManagerTest >> testRemoveLogGroup [
	| group1 result |
	result := OrderedCollection new.
	logFileManager addLog: log0 withSource: 'path1/stage1-algo1.changes'.
	logFileManager addLog: log8 withSource: 'path2/stage0-algo2.changes'.
	group1 := (logFileManager stages at:1 ) groups at:1.
	
	logFileManager removeLogGroup: group1.
	
	logFileManager stages do: [ :stage | result addAll: stage groups ].
	self assert: (result size) equals: (1).
	self assert: ((result at:1) name) equals: ('algo2').
	self assert: ((result at:1) logEntries size) equals: (1).
	self assert: (((result at:1) logEntries at:1) timestamp) equals: (8).
]

{ #category : #tests }
LogFileManagerTest >> testRemoveStage [
	| aStage |
	logFileManager addLog: log0 withSource: 'path1/stage1-algo1.changes'.
	logFileManager addLog: log8 withSource: 'path2/stage0-algo2.changes'.
	aStage := logFileManager stages at:1.
	
	logFileManager removeStage: aStage.
	
	self assert: (logFileManager stages size) equals: (1).
	self assert: ((logFileManager stages at:1) level) equals: (0).
]

{ #category : #tests }
LogFileManagerTest >> testReportLogState [
	"comment stating purpose of message"
	| logStream |
	logStream := ReadLogStream onStream: path2 asFileReference readStream.
	logFileManager reportLogErrors: log0 onStream: logStream.
	self assert: ( logFileManager report size) equals: (1).
	self assert: ( (logFileManager report at:1) nameFile) equals: ('stage0-testfile.changes').
	self assert: ( (logFileManager report at:1) description) equals: ('Log stage does not match the file name.').
	self assert: ( (logFileManager report at:1) line) equals: (0).
]

{ #category : #tests }
LogFileManagerTest >> testReportLogStateInvalid [
	"comment stating purpose of message"
	| logStream logE |
	logE := log0 stage: 5.
	logStream := ReadLogStream onStream: path2 asFileReference readStream.
	logFileManager reportLogErrors: logE onStream: logStream.
	self assert: ( logFileManager report size) equals: (2).
	self assert: ( (logFileManager report at:1) nameFile) equals: ('stage0-testfile.changes').
	self assert: ( (logFileManager report at:1) description) equals: ('Log stage does not match the file name.').
	self assert: ( (logFileManager report at:2) nameFile) equals: ('stage0-testfile.changes').
	self assert: ( (logFileManager report at:2) description) equals: ('Stage invalid.').
]

{ #category : #tests }
LogFileManagerTest >> testReportTimestampRepeated [
	"comment stating purpose of message"
	| logStream |
	logStream := ReadLogStream onStream: path2 asFileReference readStream.
	logFileManager reportLogErrors: (log33 timestamp:0) onStream: logStream.
	logFileManager addLog: (log33 timestamp:0) withSource: path2.
	logFileManager reportLogErrors: (log8 timestamp:0) onStream: logStream.
	self assert: ( logFileManager report size) equals: (1).
	self assert: ( (logFileManager report at:1) nameFile) equals: ('stage0-testfile.changes').
	self assert: ( (logFileManager report at:1) description) equals: ('Timestamp repeated').
]

{ #category : #tests }
LogFileManagerTest >> testSaveFilesEdited [
	"Dado 4 logEntries modificados, grabarlos en sus archivos correspondientes."
	| l1 l2 l3 l4 |
	logFileManager sourceInput: './testManagerFolder'.
	logFileManager sourceInput asFileReference ensureCreateDirectory.
	
	path1 := logFileManager sourceInput, '/stage0-200-DNU-Setup.changes' .
	path2 := logFileManager sourceInput, '/stage1-3753505986994.changes' .
	
	l1 := LogEntry timestamp: 200 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtGeneratedMethodsCallingDNU' nil #() ) stage: 0.
	l2 := LogEntry timestamp: 201 selector: #doSetPackageNamed:asInMigrationSet: arguments: #(#SmtGeneratedMethodsCallingDNU #true ) stage: 0.
	l3 := LogEntry timestamp: 40 selector: #doAddPackageNamed:in:prereqs: arguments: #(#SmtGeneratedPools nil #() ) stage: 1.
	l4 := LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0.	
	logFileManager addLog: l1 fromFile: '/stage0-200-DNU-Setup.changes'; 
	addLog: l2 fromFile: '/stage0-200-DNU-Setup.changes'; 
	addLog: l3 fromFile: '/stage1-3753505986994.changes'; 
	addLog: l4 fromFile: '/stage1-3753505986994.changes'.
	
	logFileManager saveFiles.
	
	l1 editWithLog: (LogEntry timestamp: 250 selector: #doAddPackageNamed: arguments: #('SmtGeneratedMethodsCallingDNU') stage: 0 group: l1 group).
	l4 editWithLog: (LogEntry timestamp: 99999999999 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 group: l1 group).
	
	logFileManager saveFiles.
	
	self assert: (self readFile: path1) equals:('self
	timestamp: 201
	selector: #doSetPackageNamed:asInMigrationSet:
	arguments: #(#SmtGeneratedMethodsCallingDNU #true)
	stage: 0.
self
	timestamp: 250
	selector: #doAddPackageNamed:
	arguments: #(''SmtGeneratedMethodsCallingDNU'')
	stage: 0.
self
	timestamp: 99999999999
	selector: #doAssignType:to:
	arguments: #(#String #''NeoJSONTest>>testMaps|BA|1|string'')
	stage: 0.
').
	self assert: (self readFile: path2) equals:('self
	timestamp: 40
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(#SmtGeneratedPools nil #())
	stage: 1.
').	
	logFileManager sourceInput asFileReference ensureDeleteAll.
]

{ #category : #tests }
LogFileManagerTest >> testSaveFilesEditedAndRemoved [
	"Dado 4 log entries, los graba en sus archivos correspondientes."
	| l1 l2 l3 l4|
	logFileManager sourceInput: './testManagerFolder/'.
	logFileManager sourceInput asFileReference ensureCreateDirectory.
	
	path1 := logFileManager sourceInput, '/stage0-200-DNU-Setup.changes'.
	path2 := logFileManager sourceInput, '/stage1-3753505986994.changes'.
	path3 := logFileManager sourceInput, '/stage0-blankFile.changes'.
	l1 := LogEntry timestamp: 200 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtGeneratedMethodsCallingDNU' nil #() ) stage: 0 group: nil.
	l2 := LogEntry timestamp: 40 selector: #doAddPackageNamed:in:prereqs: arguments: #(#SmtGeneratedPools nil #() ) stage: 1 group: nil.
	l3 := LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 group: nil.
	l4 := LogEntry timestamp: 666 selector: #doAddPackageNamed: arguments: #('SmtGeneratedMethodsCallingDNU' ) stage: 0 group: path1.
	logFileManager addLog: l1 withSource:path1; 
	addLog: l2 withSource: path2; 
	addLog: l3 withSource: path1.
	
	path1 asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: l4 prettyPrint].
	path3 asFileReference ensureDelete; writeStreamDo: [ :stream | stream nextPutAll: '' ].
	
	logFileManager saveFiles.
	
	self assert: (logFileManager logEntries size) equals: (3).
	self assert: (self readFile: path1) equals:('self
	timestamp: 200
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtGeneratedMethodsCallingDNU'' nil #())
	stage: 0.
self
	timestamp: 3753599495956
	selector: #doAssignType:to:
	arguments: #(#String #''NeoJSONTest>>testMaps|BA|1|string'')
	stage: 0.
').
	self assert: (self readFile: path2) equals:('self
	timestamp: 40
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(#SmtGeneratedPools nil #())
	stage: 1.
').	
	self should: [self readFile: path3] raise:(FileDoesNotExistException).	
	logFileManager sourceInput asFileReference ensureDeleteAll.
]

{ #category : #tests }
LogFileManagerTest >> testSaveFilesEditedWithError [
	"Dado 4 logEntries modificados, grabarlos en sus archivos correspondientes." "EL MÉTODO QUE TOMA LA ESCEPCION ESTA COENTADO, POR ESO NO ASSERTTEA. LEER COMENTARIO"
	| l1 l2 l3 l4 |
	logFileManager sourceInput: './testManagerFolder/'.
	logFileManager sourceInput asFileReference ensureCreateDirectory.
	
	path1 := '/stage0-200-DNU-Setup.changes' .
	path2 := '/stage1-3753505986994.changes' .
	l1 := LogEntry timestamp: 200 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtGeneratedMethodsCallingDNU' nil #() ) stage: 0.
	l2 := LogEntry timestamp: 201 selector: #doSetPackageNamed:asInMigrationSet: arguments: #(#SmtGeneratedMethodsCallingDNU #true ) stage: 0.
	l3 := LogEntry timestamp: 40 selector: #doAddPackageNamed:in:prereqs: arguments: #(#SmtGeneratedPools nil #() ) stage: 1.
	l4 := LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 1.	
	logFileManager addLog: l1 fromFile: path1; 
	addLog: l2 fromFile: path1; 
	addLog: l3 fromFile: path2; addLog: l4 fromFile: path1.
	
	logFileManager saveFiles.
	
	self should: [l4 editWithLog: (LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 group: l4 group)] raise: Error.
	logFileManager sourceInput asFileReference ensureDeleteAll.
]

{ #category : #tests }
LogFileManagerTest >> testSaveFilesNews [
	"Dado 4 log entries, los graba en sus archivos correspondientes."
	| l1 l2 l3 |
	logFileManager sourceInput: './testManagerFolder/'.
	logFileManager sourceInput asFileReference ensureCreateDirectory.
	
	path1 := logFileManager sourceInput, '/stage0-200-DNU-Setup.changes' .
	path2 := logFileManager sourceInput, '/stage1-3753505986994.changes' .
	
	l1 := LogEntry timestamp: 200 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtGeneratedMethodsCallingDNU' nil #() ) stage: 0 group: path1.
	l2 := LogEntry timestamp: 40 selector: #doAddPackageNamed:in:prereqs: arguments: #(#SmtGeneratedPools nil #() ) stage: 1 group: path2.
	l3 := LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 group: path1.
	logFileManager addLog: l1 withSource: path1; addLog: l2 withSource: path2; 
	addLog: l3 withSource: path1.
	
	logFileManager saveFiles.
	
	self assert: (logFileManager logEntries size) equals: (3).
	self assert: (self readFile: path1) equals:('self
	timestamp: 200
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtGeneratedMethodsCallingDNU'' nil #())
	stage: 0.
self
	timestamp: 3753599495956
	selector: #doAssignType:to:
	arguments: #(#String #''NeoJSONTest>>testMaps|BA|1|string'')
	stage: 0.
').
	self assert: (self readFile: path2) equals:('self
	timestamp: 40
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(#SmtGeneratedPools nil #())
	stage: 1.
').	
	logFileManager sourceInput asFileReference ensureDeleteAll.
]

{ #category : #tests }
LogFileManagerTest >> testSaveLogsWithSourceFile [
	"comment stating purpose of message"
	| log1 log2 log3 log4 |
	path1 := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage1-testfile.changes' asFileReference basename.
	path2 := '/home/Pharo/stage0-testfile.changes' asFileReference basename.
	log1 := LogEntry timestamp: 0 selector: #doAddClassNamed:in:superclass: arguments: #('DateTime' #SmtSupportVASTTypingApp 'Array') stage: 1."p1"
	log2 := LogEntry timestamp: 8 selector: #doAddClassNamed:in: arguments: #('SmtEntireFileReadStream' #SmtSupportVASTTypingApp) stage: 1."p2"
	log3 := LogEntry timestamp: 25 selector: #doAddCorrelationRule:to: arguments: #('argument1.argument1' 'ByteArray>>do:') stage: 1. "p1"
	log4 := LogEntry timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ) stage: 1. "p2"
	logFileManager addLog: log1 fromFile: path1;
	addLog: log2 fromFile: path2; 
	addLog: log3 fromFile: path1; 
	addLog: log4 fromFile: path2.
	logFileManager saveLogsWithSourceFile: '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage1-testfile.changes'.
	
	self assert: ( self readFile: path1) equals: 'self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'')
	stage: 1.
self
	timestamp: 25
	selector: #doAddCorrelationRule:to:
	arguments: #(''argument1.argument1'' ''ByteArray>>do:'')
	stage: 1.
'.
]

{ #category : #tests }
LogFileManagerTest >> testSelectWithCriteria [
	"comment stating purpose of message"
	|path |
	path := '/home/lizachambi/Pharo/images/Pharo 7.0 - 64bit (stable)/resources/stage0-entriesExample.changes' asFileReference basename.
	path2 := '/home/Pharo/resources/stage0-testfile.changes' asFileReference basename.
	log33 := LogEntry timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ) stage:0. "p1"
	log0 := LogEntry timestamp: 0 selector: #doAddClassNamed: arguments: #('DateTime') stage:1. "p2"
	log8 := LogEntry timestamp: 8 selector: #doAddClassNamed: arguments: #('SmtEntireFileReadStream') stage: 0 group: path. "p1"
	logFileManager addLog: log33 fromFile: path; addLog: log0 fromFile: path2; addLog: log8 fromFile: path.

	self assert: ( (logFileManager selectWithCriteria: [:logE | (logE fileName) = path]) size) equals: (2).
]

{ #category : #tests }
LogFileManagerTest >> testSortLogEntriesByTimestamp [
	"comment stating purpose of message"
	logFileManager addLog: log33 withSource: '/home/Pharo/resources/stage0-testfile.changes'; 
	addLog: log0 withSource: '/home/Pharo/resources/stage0-testfile.changes'; 
	addLog: log8 withSource: '/home/Pharo/resources/stage0-testfile.changes'.
	
	self assert: ((logFileManager sortLogEntriesByTimestamp: logFileManager logEntries) first timestamp) equals: (0).
	self assert: ((logFileManager sortLogEntriesByTimestamp: logFileManager logEntries) second timestamp) equals: (8).
	self assert: ((logFileManager sortLogEntriesByTimestamp: logFileManager logEntries) last timestamp) equals: (33).
]

{ #category : #tests }
LogFileManagerTest >> testStages [
	"comment stating purpose of message"
	logFileManager addStage: 0.
	logFileManager addStage: 1.
	logFileManager addStage: #Final.
	self assert: (logFileManager stages size ) equals: (3).
	self assert: ((logFileManager stages at:1) level ) equals: (0).
	self assert: ((logFileManager stages at:2) level ) equals: (1).
	self assert: ((logFileManager stages at:3) level ) equals: (#Final).
]

{ #category : #tests }
LogFileManagerTest >> testUpdatesFailureWithStageInvalid [
	"comment stating purpose of message"
	| logStream logE |
	logE := log0 stage: 5.
	logStream := ReadLogStream onStream: path2 asFileReference readStream.
	logFileManager reportLogErrors: logE onStream: logStream.
	logFileManager addLog: logE withSource: path2. 
	self assert: ( logFileManager report size) equals: (2).
	
	logE stage:2.
	logFileManager updateFailures.
	
	self assert: ( logFileManager report size) equals: (1).
]

{ #category : #tests }
LogFileManagerTest >> testUpdatesFailuresWithNameAndStageNotMatching [
	| logStream |
	logStream := ReadLogStream onStream: path2 asFileReference readStream. "Path with name stage 0"
	logFileManager reportLogErrors: log0 onStream: logStream. "LogEntry with stage 1"
	self assert: ( logFileManager report size) equals: (1).
	
	log0 stage: 0.
	logFileManager updateFailures.
	
	self assert: ( logFileManager report size) equals: (0).
]

{ #category : #tests }
LogFileManagerTest >> testUpdatesFailuresWithTimestampRepeated [
	"comment stating purpose of message"
	| logStream log1 log2 |
	log1 := log33 timestamp:0.
	log2 := log8 timestamp:0.
	logStream := ReadLogStream onStream: path2 asFileReference readStream.
	logFileManager reportLogErrors: log1 onStream: logStream.
	logFileManager addLog: log1 withSource: path2.
	logFileManager reportLogErrors: log2 onStream: logStream.
	logFileManager addLog: log2 withSource: path2.
	self assert: ( logFileManager report size) equals: (1).
	
	log1 timestamp: 11111111.
	logFileManager updateFailures.
	
	self assert: ( logFileManager report size) equals: (0).
]

{ #category : #tests }
LogFileManagerTest >> testWriteFilesWithName [
	"comment stating purpose of message"
	logFileManager addLog: log33 withSource: '/home/Pharo/resources/stage0-testfile.changes'; 
	addLog: log0 withSource: '/home/Pharo/resources/stage0-testfile.changes'.
	logFileManager writeFiles: (logFileManager logEntries) withName: './OutputFile.txt'.
	
	self assert: (self readFile: './OutputFile.txt') equals: ('self
	timestamp: 33
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #())
	stage: 0.
self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #())
	stage: 1.
').
	'./OutputFile.txt' asFileReference ensureDelete.
]

{ #category : #tests }
LogFileManagerTest >> testWritingOutputFilesWithName [
	"comment stating purpose of message"
	logFileManager addLog: log33 withSource: '/home/Pharo/resources/stage0-testfile.changes'; 
	addLog: log0 withSource: '/home/Pharo/resources/stage0-testfile.changes'.
	logFileManager writeFiles: (logFileManager logEntries) withName: 'OutputFile.txt'.
	
	self assert: (self readFile:'OutputFile.txt') equals: ('self
	timestamp: 33
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #())
	stage: 0.
self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #())
	stage: 1.
').
	'OutputFile.txt' asFileReference ensureDelete.
]
