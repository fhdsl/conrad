
<!-- README.md is generated from README.Rmd. Please edit that file -->

# conrad

<!-- badges: start -->
<!-- badges: end -->

:exclamation:*conrad is a reboot of
[mscstts](https://github.com/muschellij2/mscstts). Instead of
[httr](https://httr.r-lib.org/#status), which is superseded and not
recommended, we use [httr2](https://httr2.r-lib.org/) to perform HTTP
requests to the Microsoft Cognitive Services Text to Speech REST API.*

conrad serves as a client to the [Microsoft Cognitive Services Text to
Speech REST
API](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=streaming).
The Text to Speech REST API supports neural text to speech voices, which
support specific languages and dialects that are identified by locale.
Each available endpoint is associated with a region.

Before you use the text to speech REST API, a valid account must be
registered at the [Microsoft Azure Cognitive
Services](https://azure.microsoft.com/en-us/free/cognitive-services/)
and you must obtain an API key. Without an API key, this package will
not work.

## Installation

You can install the development version of conrad from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("howardbaek/conrad")
```

## Getting an API key

1.  Sign in/Create an Azure account on [Microsoft Azure Cognitive
    Services](https://azure.microsoft.com/en-us/free/cognitive-services/).
2.  Click `+ Create a resource` (below “Azure services” or click on the
    Hamburger button)
3.  Search for “Speech” and Click `Create` -\> `Speech`
4.  Create a [Resource
    group](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group)
    and a “Name”.
5.  Choose `Pricing tier` (you can choose the free version with
    `Free F0`)
6.  Click `Review + create`, review the Terms, and click `Create`.

If the deployment was successful, you should see :white_check_mark:
**Your deployment is complete** on the next page.

7.  Under `Next steps`, click `Go to resource`
8.  Look on the left sidebar and under `Resource Management`, click
    `Keys and Endpoint`
9.  Copy either `KEY 1` or `KEY 2` to clipboard. Only one key is
    necessary to make an API call.

Once you complete these steps, you have successfully retrieved your API
keys to access the API.

:warning: Remember your `Location/Region`, which you use to make calls
to the API. Specifying a different region will lead to a [HTTP 403
Forbidden
response](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403).

## Setting your API key

You can set your API key in a number of ways:

1.  Edit `~/.Renviron` and set `MS_TTS_API_KEY = "YOUR_API_KEY"`
2.  In `R`, use `options(ms_tts_key = "YOUR_API_KEY")`.
3.  Set `export MS_TTS_API_KEY=YOUR_API_KEY` in
    `.bash_profile`/`.bashrc` if you’re using `R` in the terminal.
4.  Pass `api_key = "YOUR_API_KEY"` in arguments of functions such as
    `ms_list_voices(api_key = "YOUR_API_KEY")`.

## Get a list of voices

`ms_list_voice()` uses the
`tts.speech.microsoft.com/cognitiveservices/voices/list` endpoint to get
a full [list of
voices](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=streaming#get-a-list-of-voices)
for a specific region. It attaches a region prefix to this endpoint to
get a list of voices for that region.

For example, to get a list of all the voices for the `westus` region, it
uses the
`https://westus.tts.speech.microsoft.com/cognitiveservices/voices/list`
endpoint.

:warning: Be sure to specify the Speech resource region that corresponds
to your API Key.

``` r
ms_list_voice(api_key = "YOUR_API_KEY", region = "westus")
```

## Convert text to speech

`ms_synthesize()` uses the
`tts.speech.microsoft.com/cognitiveservices/v1` endpoint to convert
[text to
speech](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=streaming#convert-text-to-speech).
The endpoint requires [Speech Synthesis Markup Language
(SSML)](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/speech-synthesis-markup)
to specify the language, gender, and full voice name.

:warning: Be sure to specify the Speech resource region that corresponds
to your API Key.

``` r
ms_synthesize(script = "Hello, this is a talking computer", region = "westus")
```

## Get an access token

`ms_get_token()` makes a request to the `issueToken` endpoint to get an
[access
token](https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=streaming#how-to-get-an-access-token).
The function require an API key and region as inputs. The access token
is used to send requests to the API.

:warning: Be sure to specify the Speech resource region that corresponds
to your API Key.

``` r
ms_get_token(api_key = "YOUR_API_KEY", region = "westus")
```

## Major differences to mscstts

- To enhance the reliability of our package, we have transitioned from
  using [httr](https://httr.r-lib.org/) to
  [httr2](https://httr2.r-lib.org/) for handling HTTP requests to the
  [Text to Speech REST
  API](https://learn.microsoft.com/en-us/azure/cognitive-services/Speech-Service/rest-text-to-speech?tabs=streaming).
  This change was motivated by the fact that
  [httr](https://httr.r-lib.org/#status) is no longer being actively
  maintained, with updates limited to those necessary for CRAN
  compatibility. In contrast, httr2 represents a modern reimagining of
  httr and is strongly recommended for usage.
- It resolves the HTTP 403 Forbidden
  [issue](https://github.com/muschellij2/mscstts/issues/13). The
  occurrence of an HTTP 403 Forbidden response status code signifies
  that the server comprehends the request but denies authorization. In
  the case of
  [`mscstts::ms_synthesize()`](https://github.com/muschellij2/mscstts/blob/master/R/ms_synthesize.R),
  the [problem](https://github.com/muschellij2/mscstts/issues/13) arose
  due to the use of an invalid voice within the HTTP request,
  specifically concerning the chosen region. For instance, the SSML
  might have contained a voice name that was not supported in the
  `westus` region. As a consequence, the server would reject the HTTP
  request.
- We have made significant improvements to the documentation across the
  entire package. These enhancements include simpler function names,
  commented functions for clarity, removal of unnecessary functions and
  arguments, and URLs directing users to pages that explain
  text-to-speech jargon.

We believe that these improvements will greatly enhance the usability of
the package and make it even more reliable in the long-term.

## Acknowledgements

conrad wouldn’t be possible without prior work on
[mscstts](https://github.com/muschellij2/mscstts) by [John
Muschelli](https://github.com/muschellij2) and
[httr2](https://github.com/r-lib/httr2) by [Hadley
Wickham](https://github.com/hadley).
