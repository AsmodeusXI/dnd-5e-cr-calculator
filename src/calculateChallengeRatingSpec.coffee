test = require 'tape'

cr = require './calculateChallengeRating'

test 'calculate() calculates the correct CR when stats fit an exact template', (assert) ->

  actual = cr.calculate 5, 13, 1, 3, 13
  expected = '0'

  assert.equal actual, expected, "Expected 5 HP, 13 AC, 1 DpR, +3 ATK, and 13 SDC to be CR #{expected}"

  actual = cr.calculate 170, 15, 47, 6, 15
  expected = '7'

  assert.equal actual, expected, "Expected 170 HP, 15 AC, 47 DpR, +6 ATK, and 15 SDC to be CR #{expected}"

  assert.end()

test 'calculate() accurately averages ATK CR and DEF CR', (assert) ->

  actual = cr.calculate 5, 13, 10, 3, 13
  expected = '1/4'

  assert.equal actual, expected, "Expected the average of CR 0 DEF and CR 1 ATK to be CR #{expected}"

  actual = cr.calculate 60, 13, 22, 4, 12
  expected = '2'

  assert.equal actual, expected, "Expected the average of CR 1/2 DEF and CR 3 ATK to be CR #{expected}"

  assert.end()

test 'calculate() chooses to prioritize SDC or ATK based on what provides the greater CR adjustment', (assert) ->

  actual = cr.calculate 20, 13, 3, 2, 15
  expected = '1/4'

  assert.equal actual, expected, "Expected the adjustment of CR 1/8 DEF, DPR 3, and SDC 15 to be CR #{expected}"

  actual = cr.calculate 20, 13, 3, 2, 18
  expected = '1/2'

  assert.equal actual, expected, "Expected the adjustment of CR 1/8 DEF, DPR 3, and SDC 18 to be CR #{expected}"

  assert.end()

test 'calculate() increases and decreases by half the difference of HP CR and AC CR', (assert) ->

  actual = cr.calculate 90, 15, 17, 3, 13
  expected = '3'

  assert.equal actual, expected, "Expected 15 AC on a CR 2 monster to make it CR #{expected}"

  actual = cr.calculate 200, 11, 60, 7, 16
  expected = '8'

  assert.equal actual, expected, "Expected 11 AC on a CR 9 monster to make it CR #{expected}"

  assert.end()

test 'calculate() increases and decreases by half the difference of DPR CR and ATK CR', (assert) ->

  actual = cr.calculate 150, 15, 42, 8, 15
  expected = '7'

  assert.equal actual, expected, "Expected +8 ATK on a CR 6 monster to make it CR #{expected}"

  actual = cr.calculate 140, 15, 35, 2, 11
  expected = '4'

  assert.equal actual, expected, "Expected +2 ATK on a CR 5 monster to make it CR #{expected}"

  assert.end()

test 'calculate() rejects invalid values for each field', (assert) ->

  actual = ->
    cr.calculate -1, 13, 0, 3, 13
  expected = /Zero or lower values are not allowed for Hit Points\./

  assert.throws actual, expected, "Expected a negative HP to yield an exception."

  actual = ->
    cr.calculate 5, -1, 1, 3, 13
  expected = /Zero or lower values are not allowed for Armor Class\./

  assert.throws actual, expected, "Expected a negative AC to yield an exception."

  actual = ->
    cr.calculate 5, 13, -5, 3, 13
  expected = /Negative values are not allowed for Damage per Round\./

  assert.throws actual, expected, "Expected a negative DpR to yield an exception."

  actual = ->
    cr.calculate 5, 13, 1, -1, 13
  expected = /Negative values are not allowed for Atk Bonus\./

  assert.throws actual, expected, "Expected a negative Atk to yield an exception."

  actual = ->
    cr.calculate 5, 13, 1, 3, -1
  expected = /Negative values are not allowed for Save DC\./

  assert.throws actual, expected, "Expected a negative Save DC to yield an exception."

  assert.end()

test 'calculate() defaults to CR 0 when arguments are lower than CR 0', (assert) ->

  actual = cr.calculate 1, 5, 0, 3, 13
  expected = '0'

  assert.equals actual, expected, "Expected values lower than expected for CR 0 to yield a CR of 0."

  actual = cr.calculate 1, 13, 0, 1, 1
  expected = '0'

  assert.equals actual, expected, "Expected values lower than CR 0's to yield a CR of 0."

  actual = cr.calculate 1, 1, 0, 1, 1
  expected = '0'

  assert.equals actual, expected, "Expected minimal allowed values to yield a CR of 0."

  assert.end()

test 'calculate() defaults to CR 30 when arguments are higher than CR 30', (assert) ->

  actual = cr.calculate 900, 25, 315, 14, 23
  expected = '30'

  assert.equals actual, expected, "Expected defense numbers that exceeded those of CR 30 to result in CR 30."

  actual = cr.calculate 850, 19, 350, 20, 30
  expected = '30'

  assert.equals actual, expected, "Expected offense numbers that exceeded those of CR 30 to result in CR 30."

  assert.end()
