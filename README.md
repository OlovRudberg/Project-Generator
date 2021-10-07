# Project-Generator
### *A function which generates a random and unpredictable sequence of digits 0:9 or binary 0:1.*
 Downloaded API from SMHI in JavaScript. Wind direction data from Kebnekaise in 
 real time is used as input for the built in Pseudo Random Algorithm which
 is updated almost every hour. Nearest weather station is used at the selected
 grid point. All wind direction data is a 10-day forecast which makes values more
 unpredictable. We use True Nature Randomness (logarithm of real wind direction forecast)
 combined with Pseudo Random Algorithm to create True Random Whole Digits.
 Note that a Pseudo Random Algorithm can be replicated via "set.seed", however
 with the API forecast data of the randomness of weather, the elements in the vector
 will change every hour i.e., set.seed will not output same sequence since the
 Pseudo Random Algorithm is based on the input from the wind direction vector.
 Even though wind direction data may be close in values from hour to hour,
 a slight change in input will output a completely new independent sequence.
 We use the logarithm of the data in order to get continuous numbers for [0:9].
 Further, note that if one chooses "digits" instead of "binary", the function divides
 the logarithmic wind direction vector into equal 10% quantiles such that each
 digit [0:9] will receive a close to uniform distribution. The same goes for the
 "binary" choice, each [0,1] will be approximately of equal size.
