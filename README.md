tw
==

tw is a tiny node script that I often use to avoid switching to a
browser when a Twitter status link is mentioned. It was written a long
time ago, is ugly, but does the job.

What does it do?

    $ tw -h
    Usage: tw <tweet url | tweet id>
     -h                          show help
     -u <nick>                   user's tweets
     -s <search term>            search tweets
     -i <status id | status url> show status

Really, that's it.

    $ tw 'https://twitter.com/#!/CodeWisdom/status/170178134015094784'
    CodeWisdom (16/1/2012 16:10:3 UTC): "Larry Wall is right. Laziness should be a
    virtue. So that's why I prefer automation." - Brendan Eich (creator of
    JavaScript)

