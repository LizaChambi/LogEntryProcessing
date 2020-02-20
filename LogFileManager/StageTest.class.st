Class {
	#name : #StageTest,
	#superclass : #TestCase,
	#instVars : [
		'stage'
	],
	#category : #'LogFileManager-Test'
}

{ #category : #tests }
StageTest >> readFile: aPath [
	"comment stating purpose of message"
	^ aPath asFileReference readStream upToEnd replaceAll: Character lf with: Character cr.
]

{ #category : #running }
StageTest >> setUp [
	stage := Stage new:0.
]

{ #category : #tests }
StageTest >> testAddGroup [
	"comment stating purpose of message"
	stage addGroup: 'aGroupName'.
	self assert: (stage groups size) equals:(1).
	self assert: (stage groups first name) equals:('aGroupName').
]

{ #category : #tests }
StageTest >> testAddGroupExist [
	"comment stating purpose of message"
	stage addGroup: 'groupName1'.
	stage addGroup: 'groupName2'.
	stage addGroup: 'groupName1'.
	self assert: (stage groups size) equals:(2).
	self assert: (stage groups first name) equals:('groupName1').
	self assert: (stage groups second name) equals:('groupName2').
]

{ #category : #tests }
StageTest >> testAddLogWithSource [
	"comment stating purpose of message"
	| log1 group |
	log1 := LogEntry timestamp: 0303456 selector: #method: arguments: #(arg ) stage: 0.
	stage addLog: log1 withSource: 'stage0-groupName.changes'.
	self assert: (stage level) equals:(0).
	self assert: (stage groups size) equals:(1).
	self assert: (stage groups first name) equals:('groupName').
	self assert: (stage groups first logEntries first) equals:(log1).

]

{ #category : #tests }
StageTest >> testLogEntries [
	"comment stating purpose of message"
	| log1 log2 log3 |
	
	log1 := LogEntry timestamp: 030 selector: #() arguments: #() stage: 0.
	log2 := LogEntry timestamp: 03034 selector: #() arguments: #() stage: 1.
	log3 := LogEntry timestamp: 0303456 selector: #() arguments: #() stage: 1.
	
	stage addLog: log1 withSource: 'stage0-fileName1.changes'.
	stage addLog: log2 withSource: 'stage1-fileName2.changes'.
	stage addLog: log3 withSource: 'stage1-fileName2.changes'.
	
	self assert: (stage logEntries size) equals: (3).
	self assert: (stage logEntries includes:log1).
	self assert: (stage logEntries includes:log2).
	self assert: (stage logEntries includes:log3).
]

{ #category : #tests }
StageTest >> testPrint [
	"comment stating purpose of message"
	self assert: (stage print) equals: ('Stage 0').
]

{ #category : #tests }
StageTest >> testSaveStage [
	| log1 log2 log3 sourceFolder stage1 |
	stage1 := Stage new:1.
	sourceFolder := './testFolder'.
	sourceFolder asFileReference ensureCreateDirectory.

	log1 := LogEntry timestamp: 0 selector: #method arguments: #() stage: 1.
	log2 := LogEntry timestamp: 56 selector: #method: arguments: #(false) stage: 1.
	log3 := LogEntry timestamp: 34 selector: #method:and: arguments: #(1 nil) stage: 1.
	
	stage1 addLog: log1 withSource: ('stage1-testFile1.changes').
	stage1 addLog: log2 withSource: ('stage1-testFile2.changes').
	stage1 addLog: log3 withSource: ('stage1-testFile2.changes').
	
	stage1 saveStageOnFolder: sourceFolder.
	
	self assert: (self readFile: (sourceFolder, '/stage1-testFile1.changes')) equals: ('self
	timestamp: 0
	selector: #method
	arguments: #()
	stage: 1.
').
	self assert: (self readFile: (sourceFolder, '/stage1-testFile2.changes')) equals: ('self
	timestamp: 34
	selector: #method:and:
	arguments: #(1 nil)
	stage: 1.
self
	timestamp: 56
	selector: #method:
	arguments: #(false)
	stage: 1.
').
	sourceFolder asFileReference ensureDeleteAll.
]
