
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mscstts2

<!-- badges: start -->
<!-- badges: end -->

TODO: Mention something about mscstts2 being a rewrite of mscstts.

mscstts2 is a client to the Microsoft Cognitive Services Text to Speech
REST API. The Text to Speech REST API supports neural text to speech
voices, which support specific languages and dialects that are
identified by locale. Each available endpoint is associated with a
region.

Before you use the text to speech REST API, a valid account must be
registered at the [Microsoft Cognitive Services
website](https://azure.microsoft.com/en-us/free/cognitive-services/) and
you must obtain an API key. Without an API key, this package will not
work.

## Installation

You can install the development version of mscstts2 from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("howardbaek/mscstts2")
```

## Getting an API key

You can get a TTS API key here:
<https://azure.microsoft.com/en-us/free/cognitive-services/>. The API
you need to get one from is Cognitive Services, Speech.

1.  Create an Azure account
2.  Go to
    <https://portal.azure.com/#create/Microsoft.CognitiveServicesSpeechServices>.
    If that works, skip to step 5.
3.  Go to <https://portal.azure.com/#home>
4.  Click `+ Create a Resource`
5.  Search “Speech”
6.  Hit `+ Create`
7.  Should be able to create an F0 account (which is free - see below)
    if you hit the pricing tiers

## Setting your API key

You can set your API key in a number of ways:

1.  Edit `~/.Renviron` and set `MS_TTS_API_KEY = "XXXX"`
2.  In `R`, use `options(ms_tts_key = "XXXX")`.
3.  Set `export MS_TTS_API_KEY=XXXX` in `.bash_profile`/`.bashrc` if
    you’re using `R` in the terminal.
4.  Pass `api_key = "XXXX"` in arguments of functions such as
    `ms_list_voices(api_key = "XXXX")`.

## Get a list of voices

`ms_list_voice()` uses the
`tts.speech.microsoft.com/cognitiveservices/voices/list` endpoint to get
a full list of voices for a specific region. It attaches a region prefix
to this endpoint to get a list of voices for that region. For example,
to get a list of all the voices for the `westus` region, it uses the
`https://westus.tts.speech.microsoft.com/cognitiveservices/voices/list`
endpoint.

``` r
ms_list_voice()
```

## Convert text to speech

`ms_synthesize()` uses the
`tts.speech.microsoft.com/cognitiveservices/v1` endpoint to convert text
to speech. The endpoint requires Speech Synthesis Markup Language (SSML)
to specify the language, gender, and full voice name.

Be sure to select the endpoint that matches your Speech resource region.

TODO: Warn users of HTTP 403 Forbidden Error

``` r
ms_synthesize()
```

## Get an access token

`ms_get_token()` makes a request to the `issueToken` endpoint to get an
access token. The function require an API key and region as inputs.

``` r
ms_get_token()
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
