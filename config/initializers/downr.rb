# Downr configuration
#
# @yield configuration for Downr
# @yieldparam config
# @yieldreturn config
Downr.configure do |config|
  config.options = {

    ########################################################
    #
    #  Downr options
    #
    ########################################################
    # use pygmentize to colorize code segments
    pygmentize:                     true,

    # use emojify for icons
    emojify:                        true,

    # should we strip out "unsafe" html elements
    html_sanitization:              true,

    ########################################################
    # The following options are for Redcarpet and can be found at
    # https://github.com/vmg/redcarpet
    ########################################################
    #
    ########################################################
    #
    #  Extensions
    #
    ########################################################
    # do not parse emphasis inside of words.
    # Strings such as foo_bar_baz will not generate <em> tags.
    no_intra_emphasis:              true,

    # parse tables,  PHP-Markdown style.
    tables:                         true,

    # parse fenced code blocks, PHP-Markdown style.
    # Blocks delimited with 3 or more ~ or backticks will be considered as code,
    # without the need to be indented. An optional language name may be
    # added at the end of the opening fence for the code block.
    fenced_code_blocks:             true,

    # parse links even when they are not enclosed in <> characters.
    # Autolinks for the http, https and ftp protocols will be
    # automatically detected. Email addresses are also handled,
    # and http links without protocol, but starting with www.
    autolink:                       true,

    # do not parse usual markdown code blocks. Markdown converts
    # text with four spaces at the front of each line to code blocks.
    # This options prevents it from doing so. Recommended to use with
    # fenced_code_blocks: true.
    disable_indented_code_blocks:   false,

    # parse strikethrough, PHP-Markdown style. Two ~ characters
    # mark the start of a strikethrough, e.g. this is ~~good~~ bad.
    strikethrough:                  true,

    # HTML blocks do not require to be surrounded by an empty line
    # as in the Markdown standard.
    lax_spacing:                    true,

    # A space is always required between the hash at the beginning
    # of a header and its name, e.g. #this is my header would not be a valid header.
    space_after_headers:            false,

    # parse superscripts after the ^ character; contiguous superscripts are nested
    # together, and complex values can be enclosed in parenthesis, e.g. this is
    # the 2^(nd) time.
    superscript:                    true,

    # parse underscored emphasis as underlines. This is _underlined_ but this
    # is still *italic*.
    underline:                      true,

    # parse highlights. This is ==highlighted==. It looks like this:
    # <mark>highlighted</mark>
    highlight:                      true,

    # parse quotes. This is a "quote". It looks like this: <q>quote</q>
    quote:                          true,

    # parse footnotes, PHP-Markdown style. A footnote works very much like a
    # reference-style link: it consists of a marker next to the text (e.g.
    # This is a sentence.[^1]) and a footnote definition on its own line
    # anywhere within the document (e.g. [^1]: This is a footnote.).
    footnotes:                      true,

    ########################################################
    #
    #  Renderers
    #
    ########################################################
    #do not allow any user-inputted HTML in the output.
    filter_html:                    false,

    # do not generate any <img> tags.
    no_images:                      false,

    # do not generate any <a> tags.
    no_links:                       false,

    # do not generate any <style> tags.
    no_styles:                      true,

    # only generate links for protocols which are considered safe.
    safe_links_only:                false,

    # add HTML anchors to each header in the output HTML,
    # to allow linking to each section.
    with_toc_data:                  true,

    # insert HTML <br> tags inside on paragraphs where the origin
    # Markdown document had newlines (by default,
    # Markdown ignores these newlines).
    hard_wrap:                      false,

    # output XHTML-conformant tags. This option is always enabled
    # in the Render::XHTML renderer.
    xhtml:                          false,

    # add prettyprint classes to <code> tags for google-code-prettify.
    prettify:                       true,

    # hash of extra attributes to add to links.
    link_attributes:                true,
  }
end
