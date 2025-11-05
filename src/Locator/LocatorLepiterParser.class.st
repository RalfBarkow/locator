Class {
	#name : #LocatorLepiterParser,
	#superclass : #Object,
	#category : #Locator
}

{ #category : #'as yet unclassified' }
LocatorLepiterParser class >> ensureRawUrl: aString [
	| url segs owner repo sha path |
	Smalltalk at: #ZnUrl ifAbsent: [ ^ aString ].
	url := [ ZnUrl fromString: aString ] on: Error do: [ ^ aString ].
	(url host = 'github.com' and: [ url pathSegments includes: 'blob' ])
		ifFalse: [ ^ aString ].
	segs := url pathSegments.
	(segs size < 5 or: [ (segs at: 3) ~= 'blob' ]) ifTrue: [ ^ aString ].
	owner := segs first.
	repo := segs second.
	sha := segs fourth.
	path := String
			streamContents: [ :s | 
				(segs copyFrom: 5 to: segs size)
					doWithIndex: [ :each :i | 
						s nextPutAll: each.
						i < (segs size - 4) ifTrue: [ s nextPut: $/ ] ] ].
	^ 'https://raw.githubusercontent.com/' , owner , '/' , repo , '/' , sha , '/'
		, path
]

{ #category : #'as yet unclassified' }
LocatorLepiterParser class >> flattenSnippetTextsFrom: aPage [
	| texts |
	texts := OrderedCollection new.
	aPage textSnippets do: [ :t | texts add: t asString ].	"Common nested forms where snippet is a dict with {language -> {text: ...}}"
	aPage snippets
		do: [ :s | 
			s isDictionary
				ifTrue: [ s
						keysDo: [ :k | 
							| v |
							v := s at: k.
							(v isDictionary
								and: [ (v includesKey: #text) or: [ v includesKey: 'text' ] ])
								ifTrue: [ texts add: (v at: #text ifAbsent: [ v at: 'text' ]) ] ] ] ].
	^ texts asArray
]

{ #category : #'as yet unclassified' }
LocatorLepiterParser class >> pageFromDictionary: dict [
	| pageClass page title uuid snippets |
	pageClass := Smalltalk
			at: #LocatorLepiterPage
			ifAbsent: [ Object
					subclass: #LocatorLepiterPage
					instanceVariableNames: 'title uuid snippets raw'
					classVariableNames: ''
					package: 'Locator' ].

	page := pageClass new.

	title := dict at: #title ifAbsent: [ dict at: 'title' ifAbsent: [ '' ] ].
	uuid := dict
			at: #uuid
			ifAbsent: [ dict at: #uid ifAbsent: [ dict at: 'uuid' ifAbsent: [ '' ] ] ].
	snippets := dict
			at: #snippets
			ifAbsent: [ dict
					at: 'snippets'
					ifAbsent: [ dict at: #content ifAbsent: [ dict at: 'content' ifAbsent: [ #() ] ] ] ].

	page
		instVarNamed: 'title' put: (title ifNil: [ '' ]) asString;
		instVarNamed: 'uuid' put: (uuid ifNil: [ '' ]) asString;
		instVarNamed: 'snippets'
			put: (snippets isArray ifTrue: [ snippets ] ifFalse: [ Array with: snippets ]);
		instVarNamed: 'raw' put: dict.

	^ page
]

{ #category : #'as yet unclassified' }
LocatorLepiterParser class >> parseFileReference: aFileReference [
	| content |
	content := aFileReference readStreamDo: [ :s | s contents ].
	^ self parseString: content
]

{ #category : #'as yet unclassified' }
LocatorLepiterParser class >> parseJSON: aString [
	| reader |
	reader := Smalltalk at: #NeoJSONReader ifAbsent: [ ^ Dictionary new ].
	^ reader fromString: aString
]

{ #category : #'as yet unclassified' }
LocatorLepiterParser class >> parseSTON: aString [
	| ston |
	ston := Smalltalk at: #STON ifAbsent: [ ^ Dictionary new ].
	^ ston fromString: aString
]

{ #category : #'as yet unclassified' }
LocatorLepiterParser class >> parseString: aString [
	"Robustly parse Lepiter 4.x/5.x files that are typically JSON; 
   gracefully fall back to STON if needed."

	| dict |
	dict := [ self parseJSON: aString ]
			on: Error
			do: [ [ self parseSTON: aString ] on: Error do: [ Dictionary new ] ].
	^ self pageFromDictionary: dict
]

{ #category : #'as yet unclassified' }
LocatorLepiterParser >> parsedLepiterPage [
	<gtExample>
	| base file page texts |
	base := FileLocator home / 'workspace' / 'locator' / 'lepiter'.
	file := base / '9i8vfwxmce4zospdaoov833go.lepiter'.

	page := LocatorLepiterParser parseFileReference: file.
	texts := LocatorLepiterParser flattenSnippetTextsFrom: page
]
