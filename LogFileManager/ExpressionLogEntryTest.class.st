Class {
	#name : #ExpressionLogEntryTest,
	#superclass : #PP2CompositeNodeTest,
	#category : #LogFileManager
}

{ #category : #accessing }
ExpressionLogEntryTest >> parserClass [
	^ ExpressionLogEntry
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPArguments [
	"comment stating purpose of message"
	self parse: '#(4 false #NIL #Boolean_N #AbtRow #() #(''rcv'') #''Scaled class>>abt_X-ml:$1'' #''Lo[String,Obj]'' #''BD>>test|BA|4|row'' ''VaS_Ext class'' ''onClass: aClass 
	baseClass := aClass.
	^self'')' rule: #ppArguments.
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPArgumentsWithSpace [
	"comment stating purpose of message"
	self parse: '	 #( 4 false #NIL #Boolean_N #AbtRow #() #(''rcv'') #''Scaled class>>abt_X-ml:$1'' #''Lo[String,Obj]'' #''BD>>test|BA|4|row'' ''VaS_Ext class'' ''onClass: aClass 
	baseClass := aClass.
	^self'' ) 	' rule: #ppArguments.
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPLogEntry [
	"comment stating purpose of message"
	self parse: 'self 
	timestamp:0 
	selector:#method:and:other: 
	arguments:#(4 false #NIL #Boolean_N #AbtRow #() #(''rcv'') #''Scaled class>>abt_X-ml:$1'' #''Lo[String,Obj]'' #''BD>>test|BA|4|row'' ''VaS_Ext class'' ''onClass: aClass 
	baseClass := aClass.
	^self'' ).' rule: #ppLogEntry.
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPSelectorWithAArguments [
	"comment stating purpose of message"
	self parse: '#method:' rule: #ppSelector.
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPSelectorWithSpace [
	"comment stating purpose of message"
	self parse: ' 	#method:and: 	' rule: #ppSelector.
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPSelectorWithTwoArguments [
	"comment stating purpose of message"
	self parse: '#method:and:' rule: #ppSelector.
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPSelectorWithoutArguments [
	"comment stating purpose of message"
	self parse: '#method' rule: #ppSelector.
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPTimestamp [
	"comment stating purpose of message"
	self parse: '0' rule: #ppTimestamp.
]

{ #category : #tests }
ExpressionLogEntryTest >> testPPTimestampWithBlank [
	"comment stating purpose of message"
	self parse: ' 	0 	' rule: #ppTimestamp.
]
