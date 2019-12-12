Class {
	#name : #LogEntry,
	#superclass : #Object,
	#instVars : [
		'arguments',
		'selector',
		'timestamp'
	],
	#category : #LogFileManagement
}

{ #category : #'as yet unclassified' }
LogEntry class >> timestamp: anInteger selector: aString arguments: aCollection [ 
	^ self new timestamp: anInteger selector: aString arguments: aCollection.
]

{ #category : #comparing }
LogEntry >> <= aLogEntry [
	"comment stating purpose of message"
	^ timestamp asInteger < aLogEntry timestamp asInteger 
]

{ #category : #comparing }
LogEntry >> = aLogEntry [
	"comment stating purpose of message"

	^ (timestamp = aLogEntry timestamp) and: ((arguments = aLogEntry arguments ) and: (selector = aLogEntry selector)).
]

{ #category : #accessing }
LogEntry >> arguments [
	"comment stating purpose of message"
	^ arguments
]

{ #category : #conversion }
LogEntry >> asStringOutput [
	"comment stating purpose of message"
	^ 'self
	timestamp: ', timestamp asString,'
	selector: ', '#', selector asString,'
	arguments: ', arguments asString,'.
'.
]

{ #category : #tests }
LogEntry >> convertChunkToLogEntry: aString [
	"comment stating purpose of message"
	[(OpalCompiler new) source: aString; context: nil; receiver: (self); evaluate] ifError: [ LogEntry timestamp: nil selector: nil arguments: nil ].
	"* Creo un log invalido <- " 
	"* Corto la ejecucion"
	"* Creo un log invalido y genero un registro de logs erroneos con e mismo string que recibí"
]

{ #category : #accessing }
LogEntry >> hasCriteria: aBlock [
	"comment stating purpose of message"
	"^ (self isValidLog) and: [ ^ aBlock cull: self  ]"
	^ aBlock cull: self
]

{ #category : #accessing }
LogEntry >> isValidLog [
	^ (self timestamp = nil) not and: [ (self arguments = nil) not and: [ (self selector = nil) not ] ].  

]

{ #category : #accessing }
LogEntry >> selector [
	"comment stating purpose of message"
	^ selector
]

{ #category : #accessing }
LogEntry >> timestamp [
	"comment stating purpose of message"
	^ timestamp. 
]

{ #category : #initialization }
LogEntry >> timestamp: aTimestamp selector: aString arguments: aCollection [
	"comment stating purpose of message"
	timestamp:= aTimestamp.
	selector := aString.
	arguments := aCollection.
]
