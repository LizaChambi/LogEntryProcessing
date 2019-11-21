Class {
	#name : #LogFileManagementTest,
	#superclass : #TestCase,
	#instVars : [
		'logFileManagement'
	],
	#classInstVars : [
		'text',
		'logFileManagement'
	],
	#category : #'LogFileManagement-Test'
}

{ #category : #'as yet unclassified' }
LogFileManagementTest >> logEntrySource [
^ 'self
	timestamp: 0
	selector: #doAddPackageNamed:in:prereqs:
	arguments: #(''SmtSupportVASTTypingApp'' nil #() ).
self
	timestamp: 0
	selector: #doAddClassNamed:in:superclass:instVarNames:classVarNames:classInstVarNames:
	arguments: #(''DateTime'' #SmtSupportVASTTypingApp ''Array'' #() #() #() ).'
]

{ #category : #running }
LogFileManagementTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	logFileManagement := LogFileManagement new.
]

{ #category : #tests }
LogFileManagementTest >> testAsArrayString [
	"comment stating purpose of message"
	|entryManagement|
	entryManagement := LogFileManagement new.
	self assert: (entryManagement asArrayLogEntry: self logEntrySource ) notEmpty
]

{ #category : #tests }
LogFileManagementTest >> testReadFile [
	"comment stating purpose of message"
	self assert: (logFileManagement readFile:'Readme') = 'Texto.
'.
]
