import wn

ja = wn.Wordnet("omw-ja:1.4")

def lookup(words):
    for d in words:
        word = d["original"]
        ss = ja.synsets(word)
        if len(ss)==0:
            continue
        meaning = ss[0].definition()
        d["meaning"] = meaning
    return words