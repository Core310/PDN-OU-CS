# AI Usage
DISCLAIMER: As with all AI tools, I understand that they are good for generating *templates* **not** for actual code. Overly relying on AI generated code quickly leads to immense tech debt and what many people call "vibe coding clean-up" roles. Most of what was used was either a) proof of concept to see how well the tools fair with heavy user influence, or b) to check exisitng work currently written as a "helper" to optmize performance and readability.

While documentation was tidied and used to generate suggestions with the Gemni CLI workflow, most of it still ended up handwritten.

The primary use of AI used two main tech stacks:
- [surf sense](https://www.surfsense.com/)
- [gemni cli](https://github.com/google-gemini/gemini-cli)


GSD (getshitdone) was used for the initial project planning (as seen below). Then I manually went in and edited by hand parts that didn't seem good, or fit with the code structure.
## Gemni CLI
I used the following GSD model ontop of gemni CLI to better verify the work and assumptions done:
- [getshitdone](https://github.com/rokicool/gsd-opencode)

Additionally I have my own custom rule-set script which is pretty long so won't be included here.

Several model types were used dependent on what needed to be done.

As with most GSD workflows for each new PDN project I would go with the following:

- Initialization (`/gsd-new-project`)
	- Inital questions
	- PDF Document upload of problems
	- Assumptions being made (and fixed)
	- Code style wished to be generated
	- codebase linked
	- README generated
	- Point towards internal data that should be used (all 3 textbooks, path to local repo)
- Research
	- Custom phase with gemni
	- able to do more in depth analysis of the project given along with sources pointed to
	- additionally looks out for more sources online
	- I usually search myself for stackoverflow topics I may think useful. I will then point it to my surfsense model to see if it makes sense to implement it, then feed it to GSD to write in.
- Planning (`/gsd-plan-phase <number>`)
	- Split each problem and sub problem into their own atomic phases/tasks
	- A plan checker ensuring nothing was missed
	- Context Isolation and verification of tasks
- Execution (`/gsd-run-phase <number>`)
	- execution of per phase as outlined in generated README
	- tasks are run per wave with atomic commits
	- Each commit is then showed of what changed and I can go in and ask / edit the changes it made
- Verification
	- Spawn any debug agents
	- generate potential ticket issues

## Surf Sense
Ontop of the current sourcing, surf sense was used more as a generalized explainer rather than giving answers for robust problems. Surf Sense was hosted on a docker container, with an exposed port on my home server, using tailscale to connect to the endpoint. Several connectors were used to gather information from the following sources
- Obsidan
- Unraid
- outlook
- google notebook
- My github

These sources are then used during query and write time to generate quick answers. Surf Sense is generally used as a search feature to find any pre-exisitng sources I may have on a topic in order to help gemni+GSD run better.
