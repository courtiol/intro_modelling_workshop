## Technical Notes & Development (long-form)

## About Large Language Models usage

I never asked LLMs to produce slides or R content from scratch.

I did use a combination of Claude Sonnet 5 and Gemma 4 to perform the following tasks:

- convert some existing LibreOffice slides into Quarto (it did capture the text, but the formatting was very wonky)
- ask for suggestions of how to solve Quarto/LaTeX formatting issues (Gemma 4 was rather hopeless on that front, Sonnet sometimes helped, but often burned a huge amount of tokens to suggest solutions that did not work)
- review my decks of slides with prompts such as:

> Here is the beginning of a stats course aimed at people working on biodiversity assessment with camera traps. I know that it renders well in Quarto, so no need to inspect the formatting. Can you instead analyze the content and see if there are typos, inaccurate statistical statements, illogical steps, or big missing conceptual gaps.

Such reviews were thorough and very helpful. Both Gemma 4 and Sonnet 5 provided useful, often non-overlapping feedback.
Gemma appeared much more sycophantic than Sonnet.

In fact, such reviewing capabilities of LLMs provide a new justification for spending time on creating slides using code.
The LLMs can explore this code in depth at minimal effort.
Of course, LLMs can also explore, say, PowerPoint presentations, but such documents represent a huge amount of  XML code in the background, so I predict it won't work as well, and will certainly burn many more tokens.

### About the workflow

I wanted to create PDF slides since I like their stability (I had too many issues with HTML slides in the past).
There are many options to do so in code, and I have used many of them, but I had never tried the Quarto/Beamer combo seriously.
It turned out to be a rather disappointing experience...

In more detail: I have been writing LaTeX slides in Beamer for years and I always found it very verbose, so the idea that most of the content could be written in Markdown was attractive at first.
Unfortunately, Markdown can only go so far, and I thus ended up relying on LaTeX extensively for formatting.
The results are documents which are a mix of YAML, Markdown, CSS-like code used by Quarto, and LaTeX. Together with R chunks, the code reads as a weird polyglot cacophony. 

The mix is also problematic in practice since Quarto, Pandoc and LaTeX often interact in unpredictable ways.
In particular, the spacing between items differs depending on whether it is created directly in LaTeX or via a list in Markdown, and hacking the spacing seems to go nowhere.
Also, LaTeX environments such as boxes prevent the code inside them from being interpreted as Markdown.

In the future, I will either stick to Quarto/Beamer but keep formatting to a minimum, or go back to Sweave.
