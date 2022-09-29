import MeCab
import unidic
from pprint import pprint
import pykakasi

wakati = MeCab.Tagger()
kks = pykakasi.kakasi()

def morpheme(text):
    # print("func morpheme", text[:10])
    res = wakati.parse(text)
    # print(res)
    data = []
    for line in res.split("\n")[:-1]:
        t = line.split(",")
        if len(t)<2:
            continue
        # print(t)
        original = t[0].split("\t")[0]
        try:
            d = {
                "original": original,
                "read": kks.convert(original)[0]["hira"],
                "meaning": "("+t[0].split("\t")[1]+")"
            }
        except:
            continue
        data.append(d)
    # pprint(data)
    return data