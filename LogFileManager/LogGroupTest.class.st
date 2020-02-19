Class {
	#name : #LogGroupTest,
	#superclass : #TestCase,
	#instVars : [
		'group',
		'saveFolder',
		'stage'
	],
	#category : #'LogFileManager-Test'
}

{ #category : #running }
LogGroupTest >> readFile: aPath [
	"comment stating purpose of message"
	^ aPath asFileReference readStream upToEnd replaceAll: Character lf with: Character cr.

]

{ #category : #running }
LogGroupTest >> setUp [
	saveFolder := './testFolder/stage0-testFile.changes'.
	saveFolder asFileReference parent fullName asFileReference ensureCreateDirectory.
	stage := Stage new:0.
	group  := LogGroup withSource: saveFolder stage: stage.

]

{ #category : #running }
LogGroupTest >> tearDown [
	"comment stating purpose of message"
	saveFolder asFileReference parent fullName asFileReference ensureDeleteAll.
]

{ #category : #tests }
LogGroupTest >> testFailuresReportWithAllFailures [
	| log1 log2 failures |
	log1 := LogEntry timestamp: 34 selector: #method1 arguments: #() stage: 5 group: group. "group with path stage 0"
	log2 := LogEntry timestamp: 34 selector: #method2: arguments: #(true) stage: 0 group: group.
	group addLog: log1; addLog: log2.
	
	failures := group failuresReport.
	
	self assert: (failures size) equals: (4).
	self assert: ((failures at:1) description) equals: ('Timestamp repeated.').
	self assert: ((failures at:1) nameFile) equals: (group source asFileReference basename).
	self assert: ((failures at:1) logWithTimestamp) equals: (34).
	
	self assert: ((failures at:2) description) equals: ('Timestamp repeated.').
	self assert: ((failures at:2) nameFile) equals: (group source asFileReference basename).
	self assert: ((failures at:2) logWithTimestamp) equals: (34).
	
	self assert: ((failures at:3) description) equals: ('Log stage does not match the file name.').
	self assert: ((failures at:3) nameFile) equals: (group source asFileReference basename).
	self assert: ((failures at:3) logWithTimestamp) equals: (34).
	
	self assert: ((failures at:4) description) equals: ('Stage invalid.'). 
	self assert: ((failures at:4) nameFile) equals: (group source asFileReference basename).
	self assert: ((failures at:4) logWithTimestamp) equals: (34).
]

{ #category : #tests }
LogGroupTest >> testFailuresReportWithoutFailures [
	| log1 log2 |
	log1 := LogEntry timestamp: 34 selector: #method1 arguments: #() stage: 0 group: group.
	log2 := LogEntry timestamp: 28 selector: #method2: arguments: #(true) stage: 0 group: group.
	group addLog: log1; addLog: log2.
	
	self assert: (group failuresReport isEmpty).
]

{ #category : #tests }
LogGroupTest >> testLogsWithRepeatedTimestamp [
	| log1 log2 |
	log1 := LogEntry timestamp: 0 selector: #method1 arguments: #() stage: 0 group: group.
	log2 := LogEntry timestamp: 0 selector: #method2: arguments: #(true) stage: 0 group: group.
	group addLog: log1; addLog: log2.
	self assert: (group logsWithRepeatedTimestamp size) equals: (2).
]

{ #category : #tests }
LogGroupTest >> testLogsWithRepeatedTimestampWithoutRepeated [
	| log1 log2 |
	log1 := LogEntry timestamp: 0 selector: #method1 arguments: #() stage: 0 group: group.
	log2 := LogEntry timestamp: 573746 selector: #method2: arguments: #(true) stage: 0 group: group.
	group addLog: log1; addLog: log2.
	self assert: (group logsWithRepeatedTimestamp size) equals: (0).
]

{ #category : #tests }
LogGroupTest >> testRemoveLogEntry [
	| log1 |
	log1 := LogEntry timestamp: 34 selector: #method1 arguments: #() stage: 0 group: group.
	group addLog: log1.
	
	group removeLogEntry: log1.
	
	self assert: (group logEntries size) equals: (0).
]

{ #category : #tests }
LogGroupTest >> testRemoveLogEntryNonExistent [
	| log1 log2 |
	log1 := LogEntry timestamp: 34 selector: #method1 arguments: #() stage: 0 group: group.
	log2 := LogEntry timestamp: 28 selector: #method2: arguments: #(true) stage: 0 group: group.
	group addLog: log1.
	
	group removeLogEntry: log2.
	
	self assert: (group logEntries size) equals: (1).
	self assert: (group logEntries at:1) equals: (log1).
]

{ #category : #tests }
LogGroupTest >> testSaveGroup [
	| log1 log2 |
	log1 := LogEntry timestamp: 34 selector: #method1 arguments: #() stage: 0 group: group.
	log2 := LogEntry timestamp: 28 selector: #method2: arguments: #(true) stage: 0 group: group.
	group addLog: log1; addLog: log2.
	group saveGroup.
	self assert: (self readFile: group source) equals: ('self
	timestamp: 28
	selector: #method2:
	arguments: #(true)
	stage: 0.
self
	timestamp: 34
	selector: #method1
	arguments: #()
	stage: 0.
').
]

{ #category : #tests }
LogGroupTest >> testSortLogEntriesByTimestamp [
	| log1 log2 sortedCollection |
	log1 := LogEntry timestamp: 34 selector: #method1 arguments: #() stage: 0 group: saveFolder.
	log2 := LogEntry timestamp: 28 selector: #method2: arguments: #(true) stage: 0 group: saveFolder.
	group addLog: log1; addLog: log2.
	sortedCollection := group sortLogEntriesByTimestamp.
	self assert: (sortedCollection at:1) equals: (log2).
	self assert: (sortedCollection at:2) equals: (log1).
	self should: [sortedCollection at:3] raise: SubscriptOutOfBounds.
]

{ #category : #tests }
LogGroupTest >> testSourceFile [
	group name:'nameGroup'.
	self assert: (group sourceFile:'files/Operations') equals: ('files/Operations/stage0-nameGroup.changes').
]

{ #category : #tests }
LogGroupTest >> testWriteLogsEntries [
	| log1 |
	log1 := LogEntry timestamp: 34 selector: #method1 arguments: #() stage: 0 group: saveFolder.
	group addLog: log1.
	group writeLogsEntries: group logEntries.
	self assert: (self readFile: saveFolder) equals: ('self
	timestamp: 34
	selector: #method1
	arguments: #()
	stage: 0.
').
]
