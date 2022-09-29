from .lookup import lookup
from .morpheme import morpheme
from .ocr import ocr

def analysis(image):
    text = ocr(image)
    # text = "台風14号去って広く晴天戻る台風14号は20日(火)午前9時に温帯低気圧に変わりました。"
    words = morpheme(text)
    detail = lookup(words)
    res = {
        "body": text,
        "detail": detail
    }
    return res