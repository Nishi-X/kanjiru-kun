def ocr(image):
    print("func ocr")
    ans = func_ocr(image)
    print("ans",ans)
    return ans

from PIL import Image
import requests
import time
import os
import tempfile

def func_ocr(file):
    # OCR機能使う為の色々
    subscription_key = os.getenv("VISION_SUBSCRIPTION_KEY")
    endpoint = os.getenv("VISION_ENDPOINT")
    text_recognition_url = endpoint + "vision/v3.2/read/analyze"
    headers = {'Ocp-Apim-Subscription-Key': subscription_key, 'Content-Type': 'application/octet-stream'}

    ## 圧縮
    imageData = file.file.read()
    with tempfile.NamedTemporaryFile(delete=True) as t1:
        with tempfile.NamedTemporaryFile(delete=True,suffix=".jpg") as t2:
            # print(t1.name,t2.name)
            with open(t1.name, "wb") as f:
                f.write(imageData)
            img = Image.open(t1.name)
            img_p = img.convert("RGB")
            img_p.save(t2.name, quality=50)
            with open(t2.name, "rb") as f:
                imageData = f.read()
            print("file size",os.path.getsize(t1.name)/1024/1024, os.path.getsize(t2.name)/1024/1024)

    try:  # その他のファイルが来ると怒られるので'ERROR'の文字列
        response = requests.post(text_recognition_url, headers=headers, data=imageData)
        response.raise_for_status()
    except Exception as e:
        print(e)
        print(response,response.text)
        return '[ERROR] Please import Image files.'

    # analysisに解析結果を入れる
    analysis = {}
    cnt = 0
    poll = True
    while poll:
        cnt += 1
        response_final = requests.get(
            response.headers["Operation-Location"], headers=headers)
        analysis = response_final.json()

        time.sleep(1)
        if "analyzeResult" in analysis:
            poll = False
        if "status" in analysis and analysis['status'] == 'failed':
            poll = False

        if cnt > 5:
            poll = False
            break

    # 解析結果から書かれた文字を抽出，出力
    text = ''
    ana_res = analysis['analyzeResult']
    read_res = ana_res['readResults']
    for lines in read_res[0]['lines']:
        text += f'{lines["text"]} '

    return text.replace(" ","")