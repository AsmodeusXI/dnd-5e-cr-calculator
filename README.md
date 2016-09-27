# dnd-5e-cr-calculator
An npm module that calculates Challenge Rating for Dungeons &amp; Dragons 5th Edition.

## How to Use
The main function of the CR Calculator is is `calculate()` and it takes five arguments: Hit Points, Armor Class, Damage per Round, Attack Bonus, and Save DC. It uses the arguments to calculate the monster's Challenge Rating as described in the Dungeons &amp; Dragons 5th Edition Dungeon Master's Guide.

```javascript
// An example
var cr = require('dnd-5e-cr-calculator');

// Arguments in order: HP, AC, DpR, Atk, Save DC
var value = cr.calculate(5, 14, 30, 5, 14);

// value should equal '1'
console.log("Your challenge rating is: " + value);
```

Alternatively, you can use the `calculateWithDice()` to enter Damage per Round in the dice string format used in the D&amp;D sourcebooks. When this function is used, the Damage per Round is calculated as an average of the dice formula provided. This is then provided to the `calculate()` function to return the CR value.

```javascript
// An example of calculateWithDice()
var cr = require('dnd-5e-cr-calculator');

// Arguments: HP, AC, DpR in dice format, Atk, Save DC
var value = cr.calculateWithDice(5, 14, '7d6+5', 5, 14)

// value should equal '1'
console.log("Your challenge rating is: " + value);
```

##How to Run
The D&amp;D 5e CR Calculator is written in Coffeescript, and the `package.json` contains scripts for compiling the Coffeescript and running tests locally. To get the project up and running locally is very simple:

```
git clone
npm install
npm run compile
```

Also, running the tests is as simple as `npm run test` or `npm run test:watch`.

##Licensing
The `dnd-5e-cr-calculator` package is released under the MIT license.

##Acknowledgements
Dungeons &amp; Dragons is property of Wizards of the Coast.
