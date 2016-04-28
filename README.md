# DoIt!_BookSelector
This is my implementation of the simple app designed on the whiteboard today (Apr 21) at DoITT

## Update
The first implementation (still tagged, in the git log, for reference) followed the specifications slavishly.

The current implementation tries to be more user-centric:
* UI improvement: color scheme
* UX improvement: single VC, rather than two
* UX: pull down menu for selecting results
* UX: real-time search results

Code Improvements:
* Best Practices: Moves delegates to protocol extensions, a la Apple Docs' recommendation
* SOLID: Adds an APIClient object, encapsulating network calls
* SOLID: decouples Book model from API client (b/c book info can come from many sources, potentially)
* 'Linted', polished and spit-shined.
