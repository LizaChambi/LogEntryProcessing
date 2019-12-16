Class {
	#name : #ReportStageError,
	#superclass : #Object,
	#instVars : [
		'nameFile',
		'line'
	],
	#category : #LogFileManager
}

{ #category : #'as yet unclassified' }
ReportStageError class >> nameFile: aString line: aNumber [
	"comment stating purpose of message"
	^ (self new) nameFile: aString line: aNumber.
]

{ #category : #'as yet unclassified' }
ReportStageError >> nameFile: aString line: aNumber [
	"comment stating purpose of message"
	nameFile := aString.
	line:= aNumber.
]
