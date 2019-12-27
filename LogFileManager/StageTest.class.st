Class {
	#name : #StageTest,
	#superclass : #TestCase,
	#instVars : [
		'stage'
	],
	#category : #'LogFileManager-Test'
}

{ #category : #running }
StageTest >> setUp [
	stage := Stage new:0.
]

{ #category : #tests }
StageTest >> testAddGroup [
	"comment stating purpose of message"
	stage addGroup: 'path'.
	self assert: (stage groups size) equals:(1).
	self assert: (stage groups first source) equals:('path').
]

{ #category : #tests }
StageTest >> testAddGroupExist [
	"comment stating purpose of message"
	stage addGroup: 'path1'.
	stage addGroup: 'path2'.
	stage addGroup: 'path1'.
	self assert: (stage groups size) equals:(2).
	self assert: (stage groups first source) equals:('path1').
	self assert: (stage groups second source) equals:('path2').
]

{ #category : #tests }
StageTest >> testAddLogWithSource [
	"comment stating purpose of message"
	| log1 |
	log1 := LogEntry timestamp: 0303456 selector: #()  arguments: #(ninguno:) stage: 0 source: 'path'.
	stage addLog: log1 withSource: 'path'.
	self assert: (stage stage) equals:(0).
	self assert: (stage groups first source) equals:('path').
	self assert: (stage groups first logEntries first) equals:(log1).

]

{ #category : #tests }
StageTest >> testLogEntries [
	"comment stating purpose of message"
	| log1 log2 log3 |
	log1 := LogEntry timestamp: 030 selector: #() arguments: #() stage: 0 source: 'path1'.
	log2 := LogEntry timestamp: 03034 selector: #() arguments: #() stage: 1 source: 'path2'.
	log3 := LogEntry timestamp: 0303456 selector: #() arguments: #() stage: 1 source: 'path2'.
	
	stage addLog: log1 withSource: 'path1'.
	stage addLog: log2 withSource: 'path2'.
	stage addLog: log3 withSource: 'path2'.
	
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
