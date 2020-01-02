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
StageTest >> testAddLogWithSource [
	"comment stating purpose of message"
	| log1 |
	log1 := LogEntry timestamp: 0303456 selector: #()  arguments: #(ninguno:) stage: 0 source: 'path'.
	self assert: (stage addLog: log1 withSource: 'path')
	"testear el addLog:WithSource: de Stage. No está agregando más de un log en su colección."

]
