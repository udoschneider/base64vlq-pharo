Class {
	#name : #Base64VLQEncoder,
	#superclass : #Object,
	#instVars : [
		'alphabet',
		'inverse'
	],
	#classVars : [
		'BaseMask',
		'BaseShift',
		'ContinutationBit',
		'DefaultAlphabet',
		'DefaultInverse',
		'NegateBit'
	],
	#category : #'Base64VLQEncoder-Core'
}

{ #category : #'class initialization' }
Base64VLQEncoder class >> initialize [
	DefaultAlphabet := String
		withAll: ($A to: $Z) , ($a to: $z) , ($0 to: $9) , #($+ $/).
	DefaultInverse := Array new: 128.
	0 to: 127 do: [ :each | 
		| offset |
		offset := DefaultAlphabet
			indexOf: each asCharacter
			ifAbsent: [ nil ].
		DefaultInverse at: each + 1 put: (offset ifNotNil: [ offset - 1 ]) ].
	ContinutationBit := 2r100000.
	NegateBit := 2r1.
	BaseMask := 2r011111.
	BaseShift := 5
]

{ #category : #accessing }
Base64VLQEncoder >> alphabet [
	"Return the alphabet that I am using to encode byte values"
	
	^ alphabet 
]

{ #category : #accessing }
Base64VLQEncoder >> alphabet: string [
	"Set the alphabet to use to string, containing 64 characters to represent 64 byte values.
	I automatically compute the inverse used for fast decoding."
	
	self assert: string size = 64 description: '64 characters are needed for a Base64 alphabet'.
	alphabet := string.
	inverse := Array new: 128.
	0 to: 127 do: [ :each | 
		| offset |
		offset := alphabet indexOf: each asCharacter ifAbsent: [ nil ].
		inverse at: each + 1 put: (offset ifNotNil: [ offset - 1 ]) ]
]

{ #category : #converting }
Base64VLQEncoder >> characterForValue: value [
	^ alphabet at: value + 1
]

{ #category : #converting }
Base64VLQEncoder >> decode: string [
	"Decode a Base64 VLQ encoded string and return the resulting  array"

	^ Array
		streamContents: [ :arrayStream | self decode: string readStream to: arrayStream ]
]

{ #category : #converting }
Base64VLQEncoder >> decode: stringStream to: arrayStream [
	[ stringStream atEnd ]
		whileFalse: [ | vlq shift continuation negate |
			vlq := 0.
			shift := 0.
			continuation := true.
			[ continuation ]
				whileTrue: [ | digit |
					digit := self valueForCharacter: stringStream next.
					continuation := (digit bitAnd: ContinutationBit) > 0.
					digit := digit bitAnd: BaseMask.
					vlq := vlq + (digit << shift).
					shift := shift + BaseShift ].
			negate := (vlq bitAnd: NegateBit) > 0.
			vlq := negate
				ifTrue: [ (vlq >> 1) negated ]
				ifFalse: [ vlq >> 1 ].
			arrayStream nextPut: vlq ]
]

{ #category : #converting }
Base64VLQEncoder >> encode: integerArray [
	"Encode integerArray using Base64 VLQ encoding and return the resulting string"

	^ String
		streamContents:
			[ :stringStream | self encode: integerArray readStream to: stringStream ]
]

{ #category : #converting }
Base64VLQEncoder >> encode: integerStream to: stringStream [
	[ integerStream atEnd ]
		whileFalse: [ | vlq |
			vlq := integerStream next.
			vlq := vlq negative
				ifTrue: [ vlq negated << 1 bitOr: NegateBit ]
				ifFalse: [ vlq << 1 ].
			[ | digit |
			digit := vlq bitAnd: BaseMask.
			vlq := vlq >> BaseShift.
			digit := vlq > 0
				ifTrue: [ digit bitOr: ContinutationBit ]
				ifFalse: [ digit ].
			stringStream nextPut: (self characterForValue: digit).
			vlq > 0 ] whileTrue ]
]

{ #category : #initialization }
Base64VLQEncoder >> initialize [
	super initialize.
	alphabet := DefaultAlphabet.
	inverse := DefaultInverse
]

{ #category : #converting }
Base64VLQEncoder >> valueForCharacter: char [
	| code |
	(code := char asciiValue) < 128
		ifTrue: [ 
			(inverse at: code + 1)
				ifNotNil: [ :byteValue | ^ byteValue ] ].
	ZnCharacterEncodingError signal: 'Illegal Base64 VLQ input'
]
