Class {
	#name : #Base64VLQEncodingTest,
	#superclass : #TestCase,
	#category : #'Base64VLQEncoder-Tests'
}

{ #category : #tests }
Base64VLQEncodingTest >> testEncode0 [
	self assert: #(0) base64VLQEncoded equals: 'A'
]

{ #category : #tests }
Base64VLQEncodingTest >> testEncodeNegativeInteger [
	self
		assert: #(-1) base64VLQEncoded equals: 'D';
		assert: #(-2) base64VLQEncoded equals: 'F';
		assert: #(-5) base64VLQEncoded equals: 'L';
		assert: #(-1000) base64VLQEncoded equals: 'x+B';
		assert: #(-100000) base64VLQEncoded equals: 'hqjG'
]

{ #category : #tests }
Base64VLQEncodingTest >> testEncodePositiveInteger [
	self
		assert: #(1) base64VLQEncoded equals: 'C';
		assert: #(2) base64VLQEncoded equals: 'E';
		assert: #(5) base64VLQEncoded equals: 'K';
		assert: #(1000) base64VLQEncoded equals: 'w+B';
		assert: #(100000) base64VLQEncoded equals: 'gqjG'
]
