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
		'pathFolder'
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
	log33 := LogEntry timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ) stage:0 source: 'path33'.
	log0 := LogEntry timestamp: 0 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('DateTime' #SmtSupportVASTTypingApp 'Array' #() #() #() ) stage:1 source: 'path0'.
	log8 := LogEntry timestamp: 8 selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames: arguments: #('SmtEntireFileReadStream' #SmtSupportVASTTypingApp 'CfsReadFileStream' #() #() #() ) stage: 0 source: 'path8'.
	path1 := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/resources/stage0-entriesExample.changes'.
	path2 := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfile.changes'.
	path3 := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage0-testfileCr.changes'.
	pathFolder := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/resources'.
]

{ #category : #tests }
LogFileManagerTest >> testAddLog [
	"comment stating purpose of message"
	logFileManager addLog: (LogEntry timestamp: 123456 selector: #doAssignType:to: arguments: #(#Integer #'MoProgramStarter>>sleep:$1') stage: 0 source: 'path').
	self assert: (logFileManager logEntries notEmpty).
]

{ #category : #tests }
LogFileManagerTest >> testAddStage [
	"comment stating purpose of message"
	logFileManager addStage: 1.
	self assert: ((logFileManager stages at:1) stage) equals: (1).
	self assert: ((logFileManager stages at:1) groups isEmpty).
	self assert: (logFileManager stages size) equals: (1).
	
]

{ #category : #tests }
LogFileManagerTest >> testExceptionAddLogNil [
	"comment stating purpose of message"
	logFileManager addLog: (LogEntry timestamp: nil selector: nil arguments:nil stage: nil source: 'path' ).
	self assert: (logFileManager logEntries isEmpty).
]

{ #category : #tests }
LogFileManagerTest >> testFindStage [
	"comment stating purpose of message"
	logFileManager addStage: 0; addStage: 1.
	self assert: ((logFileManager findStage:0) stage ) equals: (0).
	
]

{ #category : #tests }
LogFileManagerTest >> testFindStageException [
	"comment stating purpose of message"
	logFileManager addStage: 0; addStage: 1.
	self should: [(logFileManager findStage:3) stage ] raise: (Error).
	
]

{ #category : #tests }
LogFileManagerTest >> testGroups [
	"comment stating purpose of message"
	logFileManager addStage: 1.
	logFileManager addStage: 2.
	logFileManager addStage: 0.
	self assert: ((logFileManager groups at:1) stage) equals: (0).
	self assert: ((logFileManager groups at:2) stage) equals: (1).
	self assert: ((logFileManager groups at:3) stage) equals: (2).
]

{ #category : #tests }
LogFileManagerTest >> testLogsWithStage0 [
	"comment stating purpose of message"
	| logStream |
	logStream := ReadLogStream onStream: path1 asFileReference readStream.
	logFileManager addLog: log0.
	logFileManager addLog: log33.
	logFileManager addLog: log8.
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
	logFileManager mergeOrderedLogFilesFrom: pathFolder withName: 'sortedLogFiles' 
	matchingACriteria: [:log | log timestamp < 10 ].

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
	self assert: ((result at: 1) source) equals: (path3).
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
	self assert: ((result at: 1) source) equals: (path2).
]

{ #category : #tests }
LogFileManagerTest >> testReadLogEntries [
	"comment stating purpose of message"
	|entryManager|
	entryManager := LogFileManager new.
	self assert: ((entryManager readLogsEntries: (ReadLogStream onStream: path1 asFileReference readStream ) ) size) equals: 3.
]

{ #category : #tests }
LogFileManagerTest >> testReadLogFilesFromFolder [
	"comment stating purpose of message"
	logFileManager := LogFileManager readLogFilesFromFolder: pathFolder.
	self assert: (logFileManager logEntries size) equals: (3).
]

{ #category : #tests }
LogFileManagerTest >> testReadLogsEntriesWithCriteriaTimestamp0 [
	"comment stating purpose of message"
	logFileManager readLogsEntries: (ReadLogStream onStream: path1 asFileReference readStream ) withCriteria: [:log | log timestamp = 0].
	self assert: (logFileManager logEntries size) equals: (1).
]

{ #category : #tests }
LogFileManagerTest >> testReportLogState [
	"comment stating purpose of message"
	| logStream |
	logStream := ReadLogStream onStream: path2 asFileReference readStream.
	logFileManager reportLogErrors: log0 onStream: logStream.
	self assert: ( logFileManager report size) equals: (1).
	self assert: ( (logFileManager report at:1) nameFile) equals: ('stage0-testfile.changes').
	self assert: ( (logFileManager report at:1) line) equals: (0).
]

{ #category : #tests }
LogFileManagerTest >> testSaveFilesEdited [
	"Dado 4 logEntries modificados, grabarlos en sus archivos correspondientes."
	| l1 l2 l3 l4 |
	logFileManager sourceInput: './testManagerFolder/'.
	logFileManager sourceInput asFileReference ensureCreateDirectory.
	
	path1 := logFileManager sourceInput, '/stage0-200-DNU-Setup.changes' .
	path2 := logFileManager sourceInput, '/stage1-3753505986994.changes' .
	
	l1 := LogEntry timestamp: 200 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtGeneratedMethodsCallingDNU' nil #() ) stage: 0 source: path1.
	l2 := LogEntry timestamp: 201 selector: #doSetPackageNamed:asInMigrationSet: arguments: #(#SmtGeneratedMethodsCallingDNU #true ) stage: 0 source: path1.
	l3 := LogEntry timestamp: 40 selector: #doAddPackageNamed:in:prereqs: arguments: #(#SmtGeneratedPools nil #() ) stage: 1 source: path2.
	l4 := LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 source: path1.	
	logFileManager addLog: l1; addLog: l2; addLog: l3; addLog: l4.
	
	logFileManager saveFiles.
	
	l1 editWithLog: (LogEntry timestamp: 250 selector: #doAddPackageNamed: arguments: #('SmtGeneratedMethodsCallingDNU') stage: 0 source: path1).
	l4 editWithLog: (LogEntry timestamp: 99999999999 selector:  #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 source: path1).
	
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
	l1 := LogEntry timestamp: 200 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtGeneratedMethodsCallingDNU' nil #() ) stage: 0 source: path1.
	l2 := LogEntry timestamp: 40 selector: #doAddPackageNamed:in:prereqs: arguments: #(#SmtGeneratedPools nil #() ) stage: 1 source: path2.
	l3 := LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 source: path1.
	l4 := LogEntry timestamp: 666 selector: #doAddPackageNamed: arguments: #('SmtGeneratedMethodsCallingDNU' ) stage: 0 source: path1.
	logFileManager addLog: l1; addLog: l2; addLog: l3.
	
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
	"Dado 4 logEntries modificados, grabarlos en sus archivos correspondientes."
	| l1 l2 l3 l4 |
	logFileManager sourceInput: './testManagerFolder/'.
	logFileManager sourceInput asFileReference ensureCreateDirectory.
	
	path1 := logFileManager sourceInput, '/stage0-200-DNU-Setup.changes' .
	path2 := logFileManager sourceInput, '/stage1-3753505986994.changes' .
	l1 := LogEntry timestamp: 200 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtGeneratedMethodsCallingDNU' nil #() ) stage: 0 source: path1.
	l2 := LogEntry timestamp: 201 selector: #doSetPackageNamed:asInMigrationSet: arguments: #(#SmtGeneratedMethodsCallingDNU #true ) stage: 0 source: path1.
	l3 := LogEntry timestamp: 40 selector: #doAddPackageNamed:in:prereqs: arguments: #(#SmtGeneratedPools nil #() ) stage: 1 source: path2.
	l4 := LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 source: path1.	
	logFileManager addLog: l1; addLog: l2; addLog: l3; addLog: l4.
	
	logFileManager saveFiles.
	
	self should: [l4 editWithLog: (LogEntry timestamp: 3753599495956 selector:  #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 1 source: path1)] raise: Error.
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
	
	l1 := LogEntry timestamp: 200 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtGeneratedMethodsCallingDNU' nil #() ) stage: 0 source: path1.
	l2 := LogEntry timestamp: 40 selector: #doAddPackageNamed:in:prereqs: arguments: #(#SmtGeneratedPools nil #() ) stage: 1 source: path2.
	l3 := LogEntry timestamp: 3753599495956 selector: #doAssignType:to: arguments: #(#String #'NeoJSONTest>>testMaps|BA|1|string' ) stage: 0 source: path1.
	logFileManager addLog: l1; addLog: l2; addLog: l3.
	
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
	path1 := '/home/liza/Pharo/images/Pharo 7.0 - 64bit (stable)/stage1-testfile.changes' .
	path2 := '/home/Pharo/stage0-testfile.changes' .
	log1 := LogEntry timestamp: 0 selector: #doAddClassNamed:in:superclass: arguments: #('DateTime' #SmtSupportVASTTypingApp 'Array') stage: 1 source: path1.
	log2 := LogEntry timestamp: 8 selector: #doAddClassNamed:in: arguments: #('SmtEntireFileReadStream' #SmtSupportVASTTypingApp) stage: 1 source: path2.
	log3 := LogEntry timestamp: 25 selector: #doAddCorrelationRule:to: arguments: #('argument1.argument1' 'ByteArray>>do:') stage: 1 source: path1.
	log4 := LogEntry timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ) stage: 1 source: path2.
	logFileManager addLog: log1; addLog: log2; addLog: log3; addLog: log4.
	logFileManager saveLogsWithSourceFile: path1.
	
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
	|path|
	path := '/home/lizachambi/Pharo/images/Pharo 7.0 - 64bit (stable)/resources/stage0-entriesExample.changes'.
	log33 := LogEntry timestamp: 33 selector: #doAddPackageNamed:in:prereqs: arguments: #('SmtSupportVASTTypingApp' nil #() ) stage:0 source: path.
	log0 := LogEntry timestamp: 0 selector: #doAddClassNamed: arguments: #('DateTime') stage:1 source: '/home/Pharo/resources/stage0-testfile.changes'.
	log8 := LogEntry timestamp: 8 selector: #doAddClassNamed: arguments: #('SmtEntireFileReadStream') stage: 0 source: path.
	logFileManager addLog: log33; addLog: log0; addLog: log8.

	self assert: ( (logFileManager selectWithCriteria: [:each | (each source) = path]) size) equals: (2).
]

{ #category : #tests }
LogFileManagerTest >> testSortLogEntriesByTimestamp [
	"comment stating purpose of message"
	logFileManager addLog: (log33); addLog: (log0); addLog: (log8).
	
	self assert: ((logFileManager sortLogEntriesByTimestamp: logFileManager logEntries) first timestamp) equals: (0).
	self assert: ((logFileManager sortLogEntriesByTimestamp: logFileManager logEntries) second timestamp) equals: (8).
	self assert: ((logFileManager sortLogEntriesByTimestamp: logFileManager logEntries) last timestamp) equals: (33).
]

{ #category : #tests }
LogFileManagerTest >> testStages [
	"comment stating purpose of message"
	logFileManager addStage: 1.
	logFileManager addStage: 2.
	logFileManager addStage: 0.
	self assert: (logFileManager stages size ) equals: (3).
]

{ #category : #tests }
LogFileManagerTest >> testWriteFilesWithName [
	"comment stating purpose of message"
	logFileManager addLog: log33; addLog: log0.
	logFileManager writeFiles: (logFileManager logEntries) withName: './OutputFile.txt'.
	
	self assert: (self readFile: './OututFile.txt') equals: ('self
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
	logFileManager addLog: (log33);addLog: (log0).
	logFileManager writeFiles: (logFileManager logEntries) withName: 'OutputFile.txt'.
	
	self assert: (self readFile:'OututFile.txt') equals: ('self
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
