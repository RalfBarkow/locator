Class {
	#name : #LocatorLepiterPage,
	#superclass : #Object,
	#instVars : [
		'raw',
		'snippets',
		'title',
		'uuid'
	],
	#category : #Locator
}

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> raw [
	^ raw
]

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> raw: aDict [
	raw := aDict
]

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> snippets [
	^ snippets ifNil: [ #() ]
]

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> snippets: aCollection [
	snippets := aCollection
]

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> textSnippets [
	"Collect textual payloads from common Lepiter snippet shapes."

	| texts keys |
	texts := OrderedCollection new.
	keys := #(#text #string #content #source 'text' 'string' 'content' 'source').
	self snippets
		do: [ :s | 
			s isString
				ifTrue: [ texts add: s ]
				ifFalse: [ s isDictionary
						ifTrue: [ keys
								do: [ :k | 
									| v |
									v := s at: k ifAbsent: [ nil ].
									v ifNotNil: [ texts add: v asString ] ] ] ] ].
	^ texts asArray
]

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> title [
	^ title
]

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> title: aString [
	title := aString
]

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> uuid [
	^ uuid
]

{ #category : #'as yet unclassified' }
LocatorLepiterPage >> uuid: aString [
	uuid := aString
]
