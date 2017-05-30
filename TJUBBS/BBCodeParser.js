// aceptable BBcode tags, optionally prefixed with a slash
var tagname_re = /^\/?(?:b|i|u|table|tr|td|font|\*|pre|center|left|right|samp|code|colou?r|backcolou?r|size|noparse|url|link|s|q|(block)?quote|img|list|float|align|li|attimg)$/i;
// color names or hex color
var color_re = /^(:?[A-Za-z]+|#(?:[0-9a-f]{3})?[0-9a-f]{3}|[A-Za-z]+\([0-9,%.]+\))$/i;
// numbers
var number_re = /^[\\.0-9]{1,8}$/i;
// reserved, unreserved, escaped and alpha-numeric [RFC2396]
var uri_re = /^[-;/?:@&=+$,_.!~*'()%0-9a-z]{1,512}$/i;
// main regular expression: CRLF, [tag=option], [tag="option"] [tag] or [/tag]
var postfmt_re = /([\r\n])|(?:\[([a-z@#]{1,16})(?:=([^\x00-\x1F<>[\]]{1,256}))?\])|(?:\[\/([a-z]{1,16})\])/ig;

function BBCode(post, cb) {
  // var attimg = [];
  var opentags = []; // open tag stack
  var crlf2br = true; // convert CRLF to <br>?
  var noparse = false; // ignore BBCode tags?
  var urlstart = -1; // beginning of the URL if zero or greater (ignored if -1)

  // stack frame object
  function taginfo_t(bbtag, etag) {
    return {
      bbtag: bbtag,
      etag: etag
    };
  }

  // check if it's a valid BBCode tag
  function isValidTag(str) {
    if (!str || !str.length)
      return false;
    return tagname_re.test(str);
  }

  /*
   m1 - CR or LF
   m2 - the tag of the [tag=option] expression
   m3 - the option of the [tag=option] expression
   m4 - the end tag of the [/tag] expression
   */
  function textToHtmlCB(mstr, m1, m2, m3, m4, offset, string) {
    // CR LF sequences
    if (m1 && m1.length) {
      if (!crlf2br)
        return mstr;
      switch (m1) {
        case '\r':
          return "";
        case '\n':
          return "<br>";
        default:
          break;
      }
    }
    // handle start tags
    if (isValidTag(m2)) {
      var m2l = m2.toLowerCase();
      // if in the noparse state, just echo the tag
      if (noparse)
        return "[" + m2 + "]";
      // ignore any tags if there's an open option-less [url] tag
      if (opentags.length && (opentags[opentags.length - 1].bbtag === "url" || opentags[opentags.length - 1].bbtag === "link") && urlstart >= 0)
        return "[" + m2 + "]";
      switch (m2l) {
        case "code":
          opentags.push(taginfo_t(m2l, "</code></pre>"));
          crlf2br = false;
          return "<pre><code>";
        case "pre":
          opentags.push(taginfo_t(m2l, "</pre>"));
          crlf2br = false;
          return "<pre>";
        case "center":
        case "left":
        case "right":
          opentags.push(taginfo_t(m2l, "</div>"));
          return '<div style="text-align:'+m2l+'">';
        case "align":
          opentags.push(taginfo_t(m2l, "</div>"));
          if (m3 === 'left' || m3 === 'center' || m3 === 'right') {
            return '<div style="text-align:' + m3 + '">';
          } else {
            return '<div>';
          }
        case "float":
          opentags.push(taginfo_t(m2l, "</div>"));
          if (m3 === 'left' || m3 === 'right') {
            return '<div style="float:' + m3 + '">';
          } else {
            return '<div>';
          }
        case "color":
        case "colour":
          if (!m3 || !color_re.test(m3))
            m3 = "inherit";
          opentags.push(taginfo_t(m2l, "</span>"));
          return "<span style=\"color: " + m3 + "\">";
        case "backcolor":
        case "backcolour":
          if (!m3 || !color_re.test(m3))
            m3 = "inherit";
          opentags.push(taginfo_t(m2l, "</span>"));
          return "<span style=\"background-color: " + m3 + "\">";
        case "font":
          opentags.push(taginfo_t(m2l, "</span>"));
          if (!m3)
            return '<span>';
          else
            return "<span style=\"font-family: " + m3.replace(/"/g, '"') + "\">";
        case "size":
          if (!m3 || !number_re.test(m3)) {
            m3 = '1em';
          } else {
            m3 += 'px';
          }
          opentags.push(taginfo_t(m2l, "</span>"));
          return "<span style=\"font-size: " + m3 + "\">";
        case "s":
          opentags.push(taginfo_t(m2l, "</span>"));
          return "<span style=\"text-decoration: line-through\">";
        case "noparse":
          noparse = true;
          return "";
        case "link":
        case "url":
          opentags.push(taginfo_t(m2l, "</a>"));
          if (m3 && uri_re.test(m3)) {
            urlstart = -1;
            return "<a target=\"_blank\" href=\"" + m3 + "\">";
          }
          urlstart = mstr.length + offset;
          return "<a target=\"_blank\" href=\"";
        case "img":
          opentags.push(taginfo_t(m2l, "\" />"));
          if (m3) {
            var size = m3.split(',');
            return '<' + m2l + ' width="'+size[0]+'" height="'+size[1]+'" src="';
          }
          return "<" + m2l + " src=\"";
        case "q":
        case "quote":
        case "blockquote":
          var qTag = (m2l === "q") ? "q" : "blockquote";
          opentags.push(taginfo_t(m2l, "</" + qTag + ">"));
          return m3 && m3.length && uri_re.test(m3) ? "<" + qTag + " cite=\"" + m3 + "\">" : "<" + qTag + ">";
        case "list":
          var lTtag = m3 && m3 === '1' ? 'ol' : 'ul';
          crlf2br = false;
          opentags.push(taginfo_t('list', '</'+lTtag+'>'));
          return '<'+lTtag+'>';
        case "*":
          opentags.push(taginfo_t('*', '</li>'));
          return '<li>';
        case "b":
          opentags.push(taginfo_t('b', '</strong>'));
          return '<strong>';
        case "i":
          opentags.push(taginfo_t('i', '</em>'));
          return '<em>';
        default:
          // [samp] [u] [table] [tr] [td]
          opentags.push(taginfo_t(m2l, "</" + m2l + ">"));
          return "<" + m2l + ">";
      }
    }
    //
    // process end tags
    //
    if (isValidTag(m4)) {
      var m4l = m4.toLowerCase();
      if (noparse) {
        // if it's the closing noparse tag, flip the noparse state
        if (m4 === "noparse") {
          noparse = false;
          return "";
        }
        // otherwise just output the original text
        return "[/" + m4 + "]";
      }
      // highlight mismatched end tags
      if (!opentags.length || opentags[opentags.length - 1].bbtag !== m4l)
        return "<span style=\"color: red\">[/" + m4 + "]</span>";
      if (m4l === "url" || m4l === "link") {
        // if there was no option, use the content of the [url] tag
        if (urlstart > 0)
          return "\">" + string.substr(urlstart, offset - urlstart) + opentags.pop().etag;
        // otherwise just close the tag
        return opentags.pop().etag;
      }
      else if (m4l === "code" || m4l === "pre" || m4l === "list")
        crlf2br = true;
      else if (m4l === "*")
        crlf2br = false;
      // other tags require no special processing, just output the end tag
      var end = opentags.pop().etag;
      return end;
    }
    return mstr;
  }

  // actual parsing can begin
  var result = '', endtags;
  // convert CRLF to <br> by default
  crlf2br = true;
  // create a new array for open tags
  if (opentags == null || opentags.length)
    opentags = new Array(0);
  // run the text through main regular expression matcher
  if (post) {
    post = post.trim().replace(/&/g, '&amp;').replace(/</g, '&lt;')
      .replace(/>/g, '&gt;').replace(/"/g, '&quot;');

    post = post.replace(/\[\*\](.*)/g, function (m0, m1) {
      return '[li]'+m1+'[/li]';
    });

    post = post.replace(/\[attach(?:=(\d+))?\](.*?)\[\/attach\]/g, function (m0, m1, m2) {
      if (m1) {
        return `<a href="https://bbs.twtstudio.com/api/attach/${m1}?name=${encodeURIComponent(m2)}" target="_blank">附件: ${m2}</a>`;
      } else {
        return `<a href="https://bbs.twtstudio.com/api/attach/${m1}" target="_blank">附件: <i>(未命名: ${m1})</i></a>`;
      }
    });

    post = post.replace(/\[attimg\](.*?)\[\/attimg\]/g, function (m0, m1) {
      return `<img src="https://bbs.twtstudio.com/api/img/${m1}"></a>`;
    });
    // @todo: 附件使用情况统计
    /*
    post = _post.replace(/\[attimg\][/attimg]/g, function (m0, m1) {
      return '['+m1+'li]';
    });
    */
    result = post.replace(postfmt_re, textToHtmlCB);
    // reset noparse, if it was unbalanced
    if (noparse)
      noparse = false;
    // if there are any unbalanced tags, make sure to close them
    if (opentags.length) {
      endtags = '';
      // if there's an open [url] at the top, close it
      if (opentags[opentags.length - 1].bbtag === "url" || opentags[opentags.length - 1].bbtag === "link") {
        opentags.pop();
        endtags += "\">" + post.substr(urlstart, post.length - urlstart) + "</a>";
      }
      // close remaining open tags
      while (opentags.length)
        endtags += opentags.pop().etag;
    }
  }

  result = endtags ? result + endtags : result;
  // & has been escaped to &amp; before processing, 
  return result.replace(/&amp;#91;/g, '[').replace(/&amp;#93;/g, ']');
}
