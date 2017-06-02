


//
//  BBCodeParser.swift
//  TJUBBS
//
//  Created by Halcao on 2017/6/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

let base = "https://bbs.tju.edu.cn"
struct BBCodeParser {
    private static var map: [String : String] {
        get {
            var map = [String : String]()
            map = ["&amp;rsquo;":"'",
                   "&lt":"<",
                   "&gt":">",
                   "&rsquo;":"'",
                   "\n":"<br />",
                   
                   /* lowercase */
                
                "\\[b\\](.+?)\\[/b\\]":"<strong>$1</strong>",
                "\\[i\\](.+?)\\[/i\\]":"<i>$1</i>",
                "\\[u\\](.+?)\\[/u\\]":"<u>$1</u>",
                "\\[s\\](.+?)\\[/s\\]":"<s>$1</s>",
                "\\[h1\\](.+?)\\[/h1\\]":"<h1>$1</h1>",
                "\\[h2\\](.+?)\\[/h2\\]":"<h2>$1</h2>",
                "\\[h3\\](.+?)\\[/h3\\]":"<h3>$1</h3>",
                "\\[h4\\](.+?)\\[/h4\\]":"<h4>$1</h4>",
                "\\[h5\\](.+?)\\[/h5\\]":"<h5>$1</h5>",
                "\\[h6\\](.+?)\\[/h6\\]":"<h6>$1</h6>",
                "\\[quote\\]([\\s\\S]+?)\\[/quote\\]":"<blockquote>$1</blockquote>",
                "\\[quote=(.+?)\\](.+?)\\[/quote\\]":"<blockquote>$2</blockquote>",
                "\\[p\\](.+?)\\[/p\\]":"<p>$1</p>",
                "\\[p=(.+?),(.+?)\\](.+?)\\[/p\\]":"<p style=\"text-indent:$1px;line-height:$2%;\">$3</p>",
                "\\[center\\](.+?)\\[/center\\]":"<div align=\"center\">$1",
                "\\[align=(.+?)\\](.+?)\\[/align\\]":"<div align=\"$1\">$2",
                "\\[color=(.+?)\\](.+?)\\[/color\\]":"<font color='$1'>$2</font>",
                "\\[size=(.+?)\\](.+?)\\[/size\\]":"<font size=\"$1\">$2</span>",
//                "\\[img\\](.+?)\\[/img\\]":"<img src=\"\(base)$1\" width=\"100\" height=\"100\"/>",
                "\\[img\\](.+?)\\[/img\\]":"<img src=\"\(base)$1\"/>",
                
                //乔成骚改的
                "\\[attimg\\](.+?)\\[/attimg\\]":"<img src=\"\(base)/api/attach/$1\" />",
                
                "\\[img=(.+?),(.+?)\\](.+?)\\[/img\\]":"<img width=\"$1\" height=\"$2\" src=\"\(base)$3\" />",
                "\\[email\\](.+?)\\[/email\\]":"<a href=\"mailto:$1\">$1</a>",
                "\\[email=(.+?)\\](.+?)\\[/email\\]":"<a href=\"mailto:$1\">$2</a>",
                "\\[url\\](.+?)\\[/url\\]":"<a href=\"$1\">$1</a>",
                "\\[url=(.+?)\\](.+?)\\[/url\\]":"<a href=\"$1\">$2</a>",
                "\\[youtube\\](.+?)\\[/youtube\\]":"<object width=\"640\" height=\"380\"><param name=\"movie\" value=\"http://www.youtube.com/v/$1\"></param><embed src=\"http://www.youtube.com/v/$1\" type=\"application/x-shockwave-flash\" width=\"640\" height=\"380\"></embed></object>",
                "\\[video\\](.+?)\\[/video\\]":"<video src=\"$1\" />",
                
                
                "\\[li\\](.+?)\\[/il\\]":"<li>$1</li>",
                "\\[ol\\](.+?)\\[/ol\\]":"<ol>$1</ol>",
                "\\[ul\\](.+?)\\[/ul\\]":"<ul>$1</ul>",
                
                "\\[list\\](.+?)\\[/list\\]":"<ul>$1</ul>",
                "\\[code\\](.+?)\\[/code\\]":"<code>$1</code>",
                //        "\\[center\\](.+?)\\[/center\\]":"<br /><center>$1</center>"]
                
                /* UPPERCASE */
                
                "\\[B\\](.+?)\\[/B\\]":"<STRONG>$1</STRONG>",
                "\\[I\\](.+?)\\[/I\\]":"<I>$1</I>",
                "\\[U\\](.+?)\\[/U\\]":"<U>$1</U>",
                "\\[S\\](.+?)\\[/S\\]":"<S>$1</S>",
                "\\[H1\\](.+?)\\[/H1\\]":"<H1>$1</H1>",
                "\\[H2\\](.+?)\\[/H2\\]":"<H2>$1</H2>",
                "\\[H3\\](.+?)\\[/H3\\]":"<H3>$1</H3>",
                "\\[H4\\](.+?)\\[/H4\\]":"<H4>$1</H4>",
                "\\[H5\\](.+?)\\[/H5\\]":"<H5>$1</H5>",
                "\\[H6\\](.+?)\\[/H6\\]":"<H6>$1</H6>",
                "\\[QUOTE\\](.+?)\\[/QUOTE\\]":"<BLOCKQUOTE>$1</BLOCKQUOTE>",
                "\\[QUOTE=(.+?)\\](.+?)\\[/QUOTE\\]":"<BLOCKQUOTE>$2</BLOCKQUOTE>",
                "\\[P\\](.+?)\\[/P\\]":"<P>$1</P>",
                "\\[P=(.+?),(.+?)\\](.+?)\\[/P\\]":"<P STYLE=\"TEXT-INDENT:$1PX;LINE-HEIGHT:$2%;\">$3</P>",
                "\\[CENTER\\](.+?)\\[/CENTER\\]":"<DIV ALIGN=\"CENTER\">$1",
                "\\[ALIGN=(.+?)\\](.+?)\\[/ALIGN\\]":"<DIV ALIGN=\"$1\">$2",
                "\\[COLOR=(.+?)\\](.+?)\\[/COLOR\\]":"<FONT COLOR='$1'>$2</FONT>",
                "\\[SIZE=(.+?)\\](.+?)\\[/SIZE\\]":"<SPAN STYLE=\"FONT-SIZE:$1;\">$2</SPAN>",
//                "\\[IMG\\](.+?)\\[/IMG\\]":"<IMG SRC=\"\(base)$1\" width=\"100\" height=\"100\"/>",
                "\\[IMG\\](.+?)\\[/IMG\\]":"<IMG SRC=\"\(base)$1\"/>",
                "\\[IMG=(.+?),(.+?)\\](.+?)\\[/IMG\\]":"<IMG WIDTH=\"$1\" HEIGHT=\"$2\" SRC=\"\(base)$3\" />",
                "\\[EMAIL\\](.+?)\\[/EMAIL\\]":"<A HREF=\"MAILTO:$1\">$1</A>",
                "\\[EMAIL=(.+?)\\](.+?)\\[/EMAIL\\]":"<A HREF=\"MAILTO:$1\">$2</A>",
                "\\[URL\\](.+?)\\[/URL\\]":"<A HREF=\"$1\">$1</A>",
                "\\[URL=(.+?)\\](.+?)\\[/URL\\]":"<A HREF=\"$1\">$2</A>",
                "\\[YOUTUBE\\](.+?)\\[/YOUTUBE\\]":"<OBJECT WIDTH=\"640\" HEIGHT=\"380\"><PARAM NAME=\"MOVIE\" VALUE=\"HTTP://WWW.YOUTUBE.COM/V/$1\"></PARAM><EMBED SRC=\"HTTP://WWW.YOUTUBE.COM/V/$1\" TYPE=\"APPLICATION/X-SHOCKWAVE-FLASH\" WIDTH=\"640\" HEIGHT=\"380\"></EMBED></OBJECT>",
                "\\[VIDEO\\](.+?)\\[/VIDEO\\]":"<VIDEO SRC=\"$1\" />",
                "\\[LIST\\](.+?)\\[/LIST\\]":"<UL>$1</UL>",
                "\\[LI\\](.+?)\\[/IL\\]":"<LI>$1</LI>",
                "\\[OL\\](.+?)\\[/OL\\]":"<OL>$1</OL>",
                "\\[UL\\](.+?)\\[/UL\\]":"<UL>$1</UL>",
                "\\[CODE\\](.+?)\\[/CODE\\]":"<CODE>$1</CODE>"]
            //        "\\[CENTER\\](.+?)\\[/CENTER\\]":"<br /><CENTER>$1</CENTER>"]
            return map
        }
    }
    
    static func parse(string: String) -> String {
        guard string != "" else {
            return ""
        }
        var result = string
        for pattern in Array(map.keys) {
            let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, result.utf16.count)
            result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: map[pattern]!)
        }
        return result
    }
}
