Class {
	#name : #GtTallyPythonFile,
	#superclass : #Object,
	#instVars : [
		'file',
		'name',
		'methods',
		'fullName'
	],
	#category : #GToolkit4Python
}

{ #category : #accessing }
GtTallyPythonFile >> file [
	^ file
]

{ #category : #accessing }
GtTallyPythonFile >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtTallyPythonFile >> fullName [
	^ fullName
]

{ #category : #accessing }
GtTallyPythonFile >> fullName: anObject [
	fullName := anObject
]

{ #category : #accessing }
GtTallyPythonFile >> gtDisplayOn: aStream [
	file ifNil: [ aStream << name ] ifNotNil: [ file gtDisplayOn: aStream ]
]

{ #category : #accessing }
GtTallyPythonFile >> initialize [
	super initialize.
	methods := Dictionary new
]

{ #category : #accessing }
GtTallyPythonFile >> methodNamed: aString line: aNumber [
	^ methods
		at: {aString.
				aNumber}
		ifAbsentPut: [ GtTallyPythonMethod new
				file: self;
				name: aString;
				line: aNumber;
				yourself ]
]

{ #category : #accessing }
GtTallyPythonFile >> methods [
	^ methods
]

{ #category : #accessing }
GtTallyPythonFile >> name [
	^ name
]

{ #category : #accessing }
GtTallyPythonFile >> name: anObject [
	name := anObject
]
