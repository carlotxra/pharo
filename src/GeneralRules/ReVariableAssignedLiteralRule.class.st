"
If a variable is only assigned a single literal value then that variable is either nil or that literal value. If the variable is always initialized with that literal value, then you could replace each variable reference with a message send to get the value. If the variable can also be nil, then you might want to replace that variable with another that stores true or false depending on whether the old variable had been assigned.
"
Class {
	#name : #ReVariableAssignedLiteralRule,
	#superclass : #ReAbstractRule,
	#category : #'GeneralRules-Migrated'
}

{ #category : #'testing-interest' }
ReVariableAssignedLiteralRule class >> checksClass [

	^ true
]

{ #category : #running }
ReVariableAssignedLiteralRule >> check: aClass forCritiquesDo: aCriticBlock [

	aClass slots do: [ :slot | 
		self
			check: slot
			of: aClass
			forCritiquesDo: aCriticBlock ]
]

{ #category : #'running-helpers' }
ReVariableAssignedLiteralRule >> check: aSlot of: aClass forCritiquesDo: aCriticBlock [
	| theMethod |

	theMethod := nil.

	aClass withAllSubclassesDo: [ :class |
		class methods do: [ :method |
			(method writesSlot: aSlot) ifTrue: [ 
				theMethod
					ifNotNil: [ ^ self ]
					ifNil: [theMethod := method ] ] ] ].
	
	theMethod ifNil: [ ^ self ].
	
	(self matchMethod: theMethod with: aSlot name) ifTrue: [ 
		aCriticBlock cull: (
			self 
				critiqueFor: aClass
				about: aSlot name) ]
]

{ #category : #'running-helpers' }
ReVariableAssignedLiteralRule >> critiqueFor: aClass about: aVarName [

	| crit |
	crit := ReTrivialCritique
		withAnchor: (ReVarSearchSourceAnchor
			entity: aClass
			string: aVarName)
		by: self.
	
	crit tinyHint: aVarName.
				
	^ crit
]

{ #category : #accessing }
ReVariableAssignedLiteralRule >> group [
	^ 'Design Flaws'
]

{ #category : #'running-helpers' }
ReVariableAssignedLiteralRule >> matchMethod: aCompiledMethod with: aVarName [

	^ ((self matcherFor: aVarName) 
		executeTree: aCompiledMethod ast
		initialAnswer: nil) isNotNil 
]

{ #category : #'running-helpers' }
ReVariableAssignedLiteralRule >> matcherFor: aVarName [


	^ RBParseTreeSearcher new 
		matches: aVarName , ' := `#object'
		do: [ :aNode :answer | aNode ];
		yourself

]

{ #category : #accessing }
ReVariableAssignedLiteralRule >> name [
	^ 'Variable is only assigned a single literal value'
]
