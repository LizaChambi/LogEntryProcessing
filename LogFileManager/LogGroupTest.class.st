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
	saveFolder asFileReference absolutePath parent asFileReference ensureCreateDirectory.
	group  := LogGroup withSource: saveFolder.

]

{ #category : #running }
LogGroupTest >> tearDown [
	"comment stating purpose of message"
	saveFolder asFileReference absolutePath parent asFileReference ensureDeleteAll.
]

{ #category : #tests }
LogGroupTest >> testWriteLogsEntries [
	| log1 log2 |
	log1 := LogEntry timestamp: 34 selector: #method1 arguments: #() stage: 0 source: saveFolder.
	log2 := LogEntry timestamp: 28 selector: #method2: arguments: #(true) stage: 0 source: saveFolder.
	group addLog: log1; addLog: log2.
	group writeLogsEntries: group logEntries.
	self assert: (self readFile: saveFolder) equals: ('self
	timestamp: 34
	selector: #method1
	arguments: #()
	stage: 0.
self
	timestamp: 28
	selector: #method2:
	arguments: #(true)
	stage: 0.
').
]
