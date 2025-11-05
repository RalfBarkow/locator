Class {
	#name : #LocatorLepiterParser,
	#superclass : #Object,
	#category : #Locator
}

{ #category : #'as yet unclassified' }
LocatorLepiterParser class >> pageFromDictionary: dict [
  | pageClass page title uuid snippets |

  pageClass := Smalltalk at: #LocatorLepiterPage ifAbsent: [
    Object
      subclass: #LocatorLepiterPage
      instanceVariableNames: 'title uuid snippets raw'
      classVariableNames: ''
      package: 'Locator' ].

  page := pageClass new.

  title := dict at: #title ifAbsent: [
             dict at: 'title' ifAbsent: [''] ].
  uuid := dict at: #uuid ifAbsent: [
            dict at: #uid ifAbsent: [
              dict at: 'uuid' ifAbsent: [''] ] ].
  snippets := dict at: #snippets ifAbsent: [
                dict at: 'snippets' ifAbsent: [
                  dict at: #content ifAbsent: [
                    dict at: 'content' ifAbsent: [ #() ] ] ] ].

  page
    instVarNamed: 'title' put: (title ifNil: ['']) asString;
    instVarNamed: 'uuid' put: (uuid ifNil: ['']) asString;
    instVarNamed: 'snippets' put: (snippets isArray
                                      ifTrue: [ snippets ]
                                      ifFalse: [ Array with: snippets ]);
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
  | dict |
  dict := [
    self parseJSON: aString ]
      on: Error
      do: [ 
        [ self parseSTON: aString ]
          on: Error
          do: [ Dictionary new ] ].
  ^ self pageFromDictionary: dict
]
