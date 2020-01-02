Class {
	#name : #Stage,
	#superclass : #Object,
	#instVars : [
		'stage',
		'groups'
	],
	#category : #LogFileManager
}

{ #category : #'instance creation' }
Stage class >> new: aNumber [
	"comment stating purpose of message"
	^ (self new) stage: aNumber groups: OrderedCollection new.
	
]

{ #category : #'as yet unclassified' }
Stage >> addLog: aLogEntry withSource: aPath [
	"comment stating purpose of message"
	groups at: aPath ifPresent: [ :value | value add: aLogEntry. value. ] ifAbsentPut: [ | newFile | newFile:= OrderedCollection new. newFile add: aLogEntry. newFile].
]

{ #category : #'as yet unclassified' }
Stage >> groups [
	"comment stating purpose of message"
	^ self sources.
]

{ #category : #'as yet unclassified' }
Stage >> gtInspectorLogsEntries: composite [
	<gtInspectorPresentationOrder: 2>
	composite fastList
		title: 'Logs';
		display: [:each | each logEntries].
]

{ #category : #'as yet unclassified' }
Stage >> logEntries [
	"comment stating purpose of message"
	^ groups values inject: (OrderedCollection new) into: [ :collect :each | collect addAll: each].
]

{ #category : #'as yet unclassified' }
Stage >> logFiles [
	"comment stating purpose of message"
	^ groups .
]

{ #category : #'as yet unclassified' }
Stage >> sources [
	"comment stating purpose of message"
	^ groups keys sort.
]

{ #category : #'as yet unclassified' }
Stage >> stage [
	"comment stating purpose of message"
	^ stage.
]

{ #category : #'as yet unclassified' }
Stage >> stage: aNumber groups: aDictionary [
	"comment stating purpose of message"
	stage:= aNumber.
	groups:= aDictionary.
]
