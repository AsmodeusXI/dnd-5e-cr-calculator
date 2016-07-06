challengeThresholds = require './config/challengeThresholds'
_ = require 'lodash'

calculate = (hp, ac, dpr, atk, sdc) ->

  throw "Zero or lower values are not allowed for Hit Points." if hp <= 0
  throw "Zero or lower values are not allowed for Armor Class." if ac <= 0
  throw "Negative values are not allowed for Damage per Round." if dpr < 0
  throw "Negative values are not allowed for Atk Bonus." if atk < 0
  throw "Negative values are not allowed for Save DC." if sdc < 0

  # Base HP CR
  hpIdx = _.findIndex challengeThresholds, (cr) ->
    cr.hplow <= hp <= cr.hphigh

  hpIdx = 33 if hpIdx < 0

  # AC adjustment
  hpIdxAc = challengeThresholds[hpIdx].ac
  acAdjust = roundUpDifference ac, hpIdxAc

  # DEF CR
  defIdx = hpIdx + acAdjust
  defIdx = 0 if defIdx < 0
  defIdx = 33 if defIdx > 33

  # Base DPR CR
  dprIdx = _.findIndex challengeThresholds, (cr) ->
    cr.dprlow <= dpr <= cr.dprhigh

  dprIdx = 33 if dprIdx < 0

  # ATK adjustment
  dprIdxAtk = challengeThresholds[dprIdx].atk
  atkAdjust = roundUpDifference atk, dprIdxAtk

  # SDC adjustment
  dprIdxSdc = challengeThresholds[dprIdx].sdc
  sdcAdjust = roundUpDifference sdc, dprIdxSdc

  # ATK CR (higher of SDC vs. ATK adjustment applied)
  atkIdx = Math.max(dprIdx + atkAdjust, dprIdx + sdcAdjust)
  atkIdx = 0 if atkIdx < 0
  atkIdx = 33 if atkIdx > 33

  if atkIdx is defIdx
    return challengeThresholds[defIdx].cr
  else
    crIdx = _.ceil((defIdx + atkIdx)/2)
    return challengeThresholds[crIdx].cr

roundUpDifference = (one, two) ->
  _.ceil((one - two)/2)

module.exports = {
  calculate: calculate
}
