_ = require 'lodash'

diceInputErrorMsg = "All dice inputs need to be in the following format: {number}d{number}\+{number}-{number}."

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

calculateWithDice = (hp, ac, diceDpr, atk, sdc) ->
  avgDpr = getAverageDieValue diceDpr
  calculate hp, ac, avgDpr, atk, sdc

getAverageDieValue = (diceDpr) ->
  dprComponents = diceDpr.split(/(\d+d\d+|\-|\+)/)
  averageComponents = []
  componentModifier = 1
  for component in dprComponents
    if component.match(/\d+d\d+/)
      componentSplit = component.split(/d/)
      numberComponent = parseInt(componentSplit[0])
      dieValueComponent = parseInt(componentSplit[1])
      localDprAverage = ((dieValueComponent + 1) * numberComponent)/2
      averageComponents.push localDprAverage * componentModifier
    else if component.match(/\+/)
      componentModifier = 1
    else if component.match(/\-/)
      componentModifier = -1
    else if component.match(/^[0-9]+$/)
      averageComponents.push parseInt(component) * componentModifier
    else if component is ''
      continue
    else
      throw diceInputErrorMsg
  Math.round(_.sum averageComponents)

module.exports = {
  calculate: calculate
  calculateWithDice: calculateWithDice
}

# CR Information
challengeThresholds = [
  {
    "cr": "0",
    "prof": 2,
    "ac": 13,
    "hplow": 1,
    "hphigh": 6,
    "atk": 3,
    "dprlow": 0,
    "dprhigh": 1,
    "sdc": 13
  },
  {
    "cr": "1/8",
    "prof": 2,
    "ac": 13,
    "hplow": 7,
    "hphigh": 35,
    "atk": 3,
    "dprlow": 2,
    "dprhigh": 3,
    "sdc": 13
  },
  {
    "cr": "1/4",
    "prof": 2,
    "ac": 13,
    "hplow": 36,
    "hphigh": 49,
    "atk": 3,
    "dprlow": 4,
    "dprhigh": 5,
    "sdc": 13
  },
  {
    "cr": "1/2",
    "prof": 2,
    "ac": 13,
    "hplow": 50,
    "hphigh": 70,
    "atk": 3,
    "dprlow": 6,
    "dprhigh": 8,
    "sdc": 13
  },
  {
    "cr": "1",
    "prof": 2,
    "ac": 13,
    "hplow": 71,
    "hphigh": 85,
    "atk": 3,
    "dprlow": 9,
    "dprhigh": 14,
    "sdc": 13
  },
  {
    "cr": "2",
    "prof": 2,
    "ac": 13,
    "hplow": 86,
    "hphigh": 100,
    "atk": 3,
    "dprlow": 15,
    "dprhigh": 20,
    "sdc": 13
  },
  {
    "cr": "3",
    "prof": 2,
    "ac": 13,
    "hplow": 101,
    "hphigh": 115,
    "atk": 4,
    "dprlow": 21,
    "dprhigh": 26,
    "sdc": 13
  },
  {
    "cr": "4",
    "prof": 2,
    "ac": 14,
    "hplow": 116,
    "hphigh": 130,
    "atk": 5,
    "dprlow": 27,
    "dprhigh": 32,
    "sdc": 14
  },
  {
    "cr": "5",
    "prof": 3,
    "ac": 15,
    "hplow": 131,
    "hphigh": 145,
    "atk": 6,
    "dprlow": 33,
    "dprhigh": 38,
    "sdc": 15
  },
  {
    "cr": "6",
    "prof": 3,
    "ac": 15,
    "hplow": 146,
    "hphigh": 160,
    "atk": 6,
    "dprlow": 39,
    "dprhigh": 44,
    "sdc": 15
  },
  {
    "cr": "7",
    "prof": 3,
    "ac": 15,
    "hplow": 161,
    "hphigh": 175,
    "atk": 6,
    "dprlow": 45,
    "dprhigh": 50,
    "sdc": 15
  },
  {
    "cr": "8",
    "prof": 3,
    "ac": 16,
    "hplow": 176,
    "hphigh": 190,
    "atk": 7,
    "dprlow": 51,
    "dprhigh": 56,
    "sdc": 16
  },
  {
    "cr": "9",
    "prof": 4,
    "ac": 16,
    "hplow": 191,
    "hphigh": 205,
    "atk": 7,
    "dprlow": 57,
    "dprhigh": 62,
    "sdc": 16
  },
  {
    "cr": "10",
    "prof": 4,
    "ac": 17,
    "hplow": 206,
    "hphigh": 220,
    "atk": 7,
    "dprlow": 63,
    "dprhigh": 68,
    "sdc": 16
  },
  {
    "cr": "11",
    "prof": 4,
    "ac": 17,
    "hplow": 221,
    "hphigh": 235,
    "atk": 8,
    "dprlow": 69,
    "dprhigh": 74,
    "sdc": 17
  },
  {
    "cr": "12",
    "prof": 4,
    "ac": 17,
    "hplow": 236,
    "hphigh": 250,
    "atk": 8,
    "dprlow": 75,
    "dprhigh": 80,
    "sdc": 17
  },
  {
    "cr": "13",
    "prof": 5,
    "ac": 18,
    "hplow": 251,
    "hphigh": 265,
    "atk": 8,
    "dprlow": 81,
    "dprhigh": 86,
    "sdc": 18
  },
  {
    "cr": "14",
    "prof": 5,
    "ac": 18,
    "hplow": 266,
    "hphigh": 280,
    "atk": 8,
    "dprlow": 87,
    "dprhigh": 92,
    "sdc": 18
  },
  {
    "cr": "15",
    "prof": 5,
    "ac": 18,
    "hplow": 281,
    "hphigh": 295,
    "atk": 8,
    "dprlow": 93,
    "dprhigh": 98,
    "sdc": 18
  },
  {
    "cr": "16",
    "prof": 5,
    "ac": 18,
    "hplow": 296,
    "hphigh": 310,
    "atk": 9,
    "dprlow": 99,
    "dprhigh": 104,
    "sdc": 18
  },
  {
    "cr": "17",
    "prof": 6,
    "ac": 19,
    "hplow": 311,
    "hphigh": 325,
    "atk": 10,
    "dprlow": 105,
    "dprhigh": 110,
    "sdc": 19
  },
  {
    "cr": "18",
    "prof": 6,
    "ac": 19,
    "hplow": 326,
    "hphigh": 340,
    "atk": 10,
    "dprlow": 111,
    "dprhigh": 116,
    "sdc": 19
  },
  {
    "cr": "19",
    "prof": 6,
    "ac": 19,
    "hplow": 341,
    "hphigh": 355,
    "atk": 10,
    "dprlow": 117,
    "dprhigh": 122,
    "sdc": 19
  },
  {
    "cr": "20",
    "prof": 6,
    "ac": 19,
    "hplow": 356,
    "hphigh": 400,
    "atk": 10,
    "dprlow": 123,
    "dprhigh": 140,
    "sdc": 19
  },
  {
    "cr": "21",
    "prof": 7,
    "ac": 19,
    "hplow": 401,
    "hphigh": 445,
    "atk": 11,
    "dprlow": 141,
    "dprhigh": 158,
    "sdc": 20
  },
  {
    "cr": "22",
    "prof": 7,
    "ac": 19,
    "hplow": 446,
    "hphigh": 490,
    "atk": 11,
    "dprlow": 159,
    "dprhigh": 176,
    "sdc": 20
  },
  {
    "cr": "23",
    "prof": 7,
    "ac": 19,
    "hplow": 491,
    "hphigh": 535,
    "atk": 11,
    "dprlow": 177,
    "dprhigh": 194,
    "sdc": 20
  },
  {
    "cr": "24",
    "prof": 7,
    "ac": 19,
    "hplow": 536,
    "hphigh": 580,
    "atk": 12,
    "dprlow": 195,
    "dprhigh": 212,
    "sdc": 21
  },
  {
    "cr": "25",
    "prof": 8,
    "ac": 19,
    "hplow": 581,
    "hphigh": 625,
    "atk": 12,
    "dprlow": 213,
    "dprhigh": 230,
    "sdc": 11
  },
  {
    "cr": "26",
    "prof": 8,
    "ac": 19,
    "hplow": 626,
    "hphigh": 670,
    "atk": 12,
    "dprlow": 231,
    "dprhigh": 248,
    "sdc": 21
  },
  {
    "cr": "27",
    "prof": 8,
    "ac": 19,
    "hplow": 671,
    "hphigh": 715,
    "atk": 13,
    "dprlow": 249,
    "dprhigh": 266,
    "sdc": 22
  },
  {
    "cr": "28",
    "prof": 8,
    "ac": 19,
    "hplow": 716,
    "hphigh": 760,
    "atk": 13,
    "dprlow": 267,
    "dprhigh": 284,
    "sdc": 22
  },
  {
    "cr": "29",
    "prof": 9,
    "ac": 19,
    "hplow": 761,
    "hphigh": 805,
    "atk": 13,
    "dprlow": 285,
    "dprhigh": 302,
    "sdc": 22
  },
  {
    "cr": "30",
    "prof": 9,
    "ac": 19,
    "hplow": 806,
    "hphigh": 850,
    "atk": 14,
    "dprlow": 303,
    "dprhigh": 320,
    "sdc": 23
  }
]
