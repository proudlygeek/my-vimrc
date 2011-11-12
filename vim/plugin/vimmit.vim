if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

function! Reddit()

python << EOF

import vim
import urllib2
import json

TIMEOUT = 20
URL = "http://reddit.com/.json"

try:
    response = urllib2.urlopen(URL, None, TIMEOUT)
    json_response = json.load(response)
    posts = json_response.get("data", "").get("children", "")

    del vim.current.buffer[:]
    vim.current.buffer[0] = "-" * 80
    
    for post in posts:
            # In the next few lines, we get the post details
            post_data = post.get("data", {})
            up = post_data.get("ups", 0)
            down = post_data.get("downs", 0)
            title = post_data.get("title", "NO TITLE").encode("utf-8")
            score = post_data.get("score", 0)
            permalink = post_data.get("permalink").encode("utf-8")
            url = post_data.get("url").encode("utf-8")
            comments = post_data.get("num_comments")

            # And here we append line by line to the buffer.
            # First the upvotes
            vim.current.buffer.append("↑ %s"%up)
            # Then the title and the url
            vim.current.buffer.append("    %s [%s]"%(title, url,))
            # Then the downvotes and number of comments
            vim.current.buffer.append("↓ %s    | comments: %s [%s]"%(down, comments, permalink,))
            # And last we append some "-" for visual appeal.
            vim.current.buffer.append(80*"-")

except Exception, e:
    print e

EOF
endfunction 
