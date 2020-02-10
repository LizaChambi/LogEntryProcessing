Class {
	#name : #LogGroupTest,
	#superclass : #TestCase,
	#instVars : [
		'group',
		'saveFolder'
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
	group  := LogGroup withSource: saveFolder.

]

{ #category : #running }
LogGroupTest >> tearDown [
	"comment stating purpose of message"
	saveFolder asFileReference parent fullName asFileReference ensureDeleteAll.
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
