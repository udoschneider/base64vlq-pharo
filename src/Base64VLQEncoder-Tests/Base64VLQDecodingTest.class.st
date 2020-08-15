Class {
	#name : #Base64VLQDecodingTest,
	#superclass : #TestCase,
	#category : #'Base64VLQEncoder-Tests'
}

{ #category : #tests }
Base64VLQDecodingTest >> testDecode0 [
	self assert: 'A' base64VLQDecoded equals: #(0)
]

{ #category : #tests }
Base64VLQDecodingTest >> testDecodeNegativeInteger [
	self
		assert: 'D' base64VLQDecoded equals: #(-1);
		assert: 'F' base64VLQDecoded equals: #(-2);
		assert: 'L' base64VLQDecoded equals: #(-5);
		assert: 'x+B' base64VLQDecoded equals: #(-1000);
		assert: 'hqjG' base64VLQDecoded equals: #(-100000)
]

{ #category : #tests }
Base64VLQDecodingTest >> testDecodePositiveInteger [
	self
		assert: 'C' base64VLQDecoded equals: #(1);
		assert: 'E' base64VLQDecoded equals: #(2);
		assert: 'K' base64VLQDecoded equals: #(5);
		assert: 'w+B' base64VLQDecoded equals: #(1000);
		assert: 'gqjG' base64VLQDecoded equals: #(100000)
]
