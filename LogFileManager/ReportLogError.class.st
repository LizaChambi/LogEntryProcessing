Class {
	#name : #ReportLogError,
	#superclass : #Object,
	#instVars : [
		'description',
		'nameFile',
		'line',
		'logWithTimestamp'
	],
	#category : #LogFileManager
}

{ #category : #'as yet unclassified' }
ReportLogError class >> description: aString nameFile: aPath line: aNumber logTimestamp: otherNumber [
	"comment stating purpose of message"
	^ (self new) description: aString nameFile: aPath line: aNumber logWithTimestamp: otherNumber.
]

{ #category : #'as yet unclassified' }
ReportLogError class >> description: aString nameFile: aNameFileString logTimestamp: aNumber [
	"comment stating purpose of class-side message"
	^ self new description: aString nameFile: aNameFileString logTimestamp: aNumber.
]

{ #category : #'as yet unclassified' }
ReportLogError >> description [
	"comment stating purpose of message"
	^ description.
]

{ #category : #'as yet unclassified' }
ReportLogError >> description: aString nameFile: aPath line: aNumber logWithTimestamp: otherNumber [
	"comment stating purpose of message"
	description := aString.
	nameFile := aPath.
	line:= aNumber.
	logWithTimestamp := otherNumber.
]

{ #category : #'as yet unclassified' }
ReportLogError >> description: aString nameFile: aNameFileString logTimestamp: aNumber [.
	"comment stating purpose of message"
	description := aString.
	nameFile := aNameFileString.
	logWithTimestamp:= aNumber.
]

{ #category : #'as yet unclassified' }
ReportLogError >> line [
	"comment stating purpose of message"
	^ line.
]

{ #category : #'as yet unclassified' }
ReportLogError >> logWithTimestamp [
	"comment stating purpose of message"
	^ logWithTimestamp
]

{ #category : #'as yet unclassified' }
ReportLogError >> nameFile [
	"comment stating purpose of message"
	^ nameFile.
]

{ #category : #'as yet unclassified' }
ReportLogError >> nameFile: aString line: aNumber [
	"comment stating purpose of message"
	nameFile := aString.
	line:= aNumber.
]
