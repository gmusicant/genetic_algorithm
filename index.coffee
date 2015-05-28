# the issue params:

	countOfFormulaArguments = 7
	formulaResult = 841
	formula = (a,b,c,d,e,f,j) -> 
		a + 2*b*a - 3*c*b*a + 4*d*a*b*c - 5*e*d*a*b*c + 6*f*e*d*a*b*c - 7*j*f*e*d*a*b*c

# genetic angorithm params:

	countOfNextGeneration = 100
	countOfNextGenerationBeforeSelection = 500
	mutationRate = 1/3
	maxLooserSteps = 40
	medianLooserSteps = 30

# helper funcitons 

	randomInt = (max) ->
		min = 0
		Math.floor( Math.random() * (max - min) + min )

	sortBy = (a, b, r) ->
		r = if r then 1 else -1
		return -1*r if a > b
		return +1*r if a < b
		return 0

# first generation

	newPrimogenitor = (countOfFormulaArguments, formulaResult) ->
		randomInt(formulaResult) for num in [1..countOfFormulaArguments]

	firstGeneration = (newPrimogenitor(countOfFormulaArguments, formulaResult) for num in [1..countOfNextGeneration])

	step = 0
	looserSteps = 0
	while not generationResult? || (generationResult != 0 && looserSteps <= maxLooserSteps)

		if generationResult? && generationPreviousResult? && generationPreviousResult <= generationResult
			looserSteps++
		else
			looserSteps = 0

	# regenerate population if previous one can't find solution and stuch with the same result

		if medianLooserSteps <= looserSteps
			newPrimogenitor = (countOfFormulaArguments, formulaResult) ->
				randomInt(formulaResult) for num in [1..countOfFormulaArguments]

			firstGeneration = (newPrimogenitor(countOfFormulaArguments, formulaResult) for num in [1..countOfNextGeneration])

	# hybridization

		newGeneration = for num in [1..countOfNextGenerationBeforeSelection]
			firstCandidateKey = randomInt(firstGeneration.length)
			secondCandidateKey = randomInt(firstGeneration.length-1)
			if firstCandidateKey == secondCandidateKey
				secondCandidateKey = secondCandidateKey + 1

			for argumentKey in [0..countOfFormulaArguments-1]
				if Math.round(Math.random()) 
					firstGeneration[firstCandidateKey][argumentKey] 
				else 
					firstGeneration[secondCandidateKey][argumentKey]

	# mutation

		newGeneration = for child in newGeneration
			for argumentKey in [0..countOfFormulaArguments-1]
				if Math.random() < mutationRate
					child[argumentKey] = randomInt(formulaResult)
				else 
					child[argumentKey]

	# selection
		
		newGeneration = newGeneration.concat firstGeneration
		newGeneration.sort (a,b) ->
			a = Math.abs(formulaResult - formula(a...))
			b = Math.abs(formulaResult - formula(b...))
			sortBy(a, b, false)

		newGeneration = newGeneration[0..countOfNextGeneration]

		if generationResult?
			generationPreviousResult = generationResult
		
		generationResult = Math.abs(formulaResult - formula(newGeneration[0]...))

		firstGeneration = newGeneration

		step++
		console.log "Step "+step+". The best child in group has result: "+generationResult

# show result

	if generationResult == 0
		console.log "Result of your expresion: ", newGeneration[0]
	else
		console.log "we can't find result for your expression"

