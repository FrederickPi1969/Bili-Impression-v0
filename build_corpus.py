from bs4 import BeautifulSoup
from time import sleep
import re
import sys
import requests
from loggers import logger
from dicts import order_opt_dict, tid_opt_dict

def argv_parser():
    keyword = sys.argv[1] 

    try:
        max_pages = int(float(sys.argv[2]))
        if max_pages == 0: max_pages += 1    
    except:
        print("Sorry, the input max_pages was illegal. Please input a positive integer!")     
        exit
    
    order_opt= sys.argv[3]
    order = order_opt_dict[order_opt]

    tid_opt = sys.argv[4] 
    tid  = tid_opt_dict[tid_opt]
    return keyword, max_pages, order, tid



def construct_bili_query(key, max_pages, order, tid):
    template = lambda i : f"https://search.bilibili.com/all?keyword={key}&from_source=nav_search_new&order={order}&duration=0&tids_1={tid}&page={i}"
    return [template(i) for i in range(1, max_pages+1)]  


# extract urls of video in one html page
# then return them as a list 
def extract_video_urls(q): 
    src_html = requests.get(q).text
    parser = BeautifulSoup(src_html, "lxml")   
    all_video_info = parser.select("a[href^='//www']")
    urls = []

    for i in range(len(all_video_info)): 
        url = "https:" + all_video_info[i].attrs["href"] 
        try: 
            _ = url.index("bangumi") # bangumis are not extractable
        except:
            urls.append(url)  

    return urls
        
"""
extract oid for one video from video source html
@param url the
@return the oid of given video url
"""
def extract_video_oid(url):
    src_html = requests.get(url).text  

    try:
        locator = src_html.index("upg")
        oid_info = src_html[locator:locator+50] 
        oid = re.findall(r"upgcxcode/[0-9]{1,3}/[0-9]{1,3}/([0-9]*?)/", oid_info)[0]
        return oid 

    except:
        return "NA" 
        
"""
given one video oid, get the video's default shown danmaku
TODO: add DATE parameter   
@param oid - oid of a video extracted previously
@return - a list of danmaku of this video  
"""
def extract_danmaku(oid):
    try: 
        danmaku_url = f"https://api.bilibili.com/x/v1/dm/list.so?oid={oid}"
        src_xml = requests.get(danmaku_url, "xml").content 

    except:
        return []
    
    parser = BeautifulSoup(src_xml, "lxml") 
    danmaku = [elem.text for elem in parser.select("d")] 
    return danmaku


def print_progress(i,  max_len, per=1):    
    if (i + 1) % per != 0: return
    print(f"Progress: {i + 1} / {max_len}")


if __name__ == "__main__":

    keyword, max_pages, order, tid = argv_parser() 
    all_queries = construct_bili_query(keyword, max_pages, order, tid)
    all_video_urls = []
    url2oid = {}
    all_danmaku = []
    
    # Collect all candidate videos 
    logger.info("Collecting all candidate videos...\n\n")

    for i, q in enumerate(all_queries):  
        print_progress(i, len(all_queries))
        urls = extract_video_urls(q) 
        logger.info(f"Detected {len(urls)} videos on page {i + 1}")
        all_video_urls.extend(urls)  

    print("\n\n----------------------------------------------------------\n\n")
    logger.info("Collecting videos urls done!")
    logger.info(f"Totally detected {len(all_video_urls)} videos.")
    print("\n\n----------------------------------------------------------\n\n")

    # Collect all oid of videos
    print("\n\n\n")
    logger.info("Collecting danmaku from videos...\n\n") 
    for i, url in enumerate(all_video_urls):
        print_progress(i, len(all_video_urls), per=5)
        oid = extract_video_oid(url)
        url2oid[url] = oid 
        danmaku_list = extract_danmaku(oid) 
        all_danmaku.extend(danmaku_list)

    print("\n\n----------------------------------------------------------\n\n")
    logger.info("Retriving damnaku done!")
    logger.info(f"Totally collected {len(all_danmaku)} danmakus from {len(all_video_urls)} videos.")
    print("\n\n----------------------------------------------------------\n\n")

    print("\n\n\n")
    # Write corpus
    with open(f"corpus/{keyword}_corpus.txt", encoding="utf-8", mode="a+") as file: 
        for danmaku in all_danmaku:
            file.write(danmaku)
            file.write("\n") 
    
    logger.info(f"{keyword}_corpus.txt has been created in the corpus directory.")
        
            
    
    

    



    