from wordcloud import WordCloud,STOPWORDS,ImageColorGenerator
from loggers import logger
import sys

def load_stopwords(path):
    try:
        with open(path, encoding="utf-8", mode="r+") as f: 
            logger.info("\nLoading stopword list...\n")
            stopwords = []
            for line in f.readlines():
                stopwords.append(line.strip())
            return stopwords

    except:
        logger.error("Stop word list not found in assets")
        return []


def load_corpus(path):
    try: 
        with open(path, encoding="utf-8", mode="r+") as f:
            text = ""
            for line in f.readlines(): 
                text += line.strip()
                text += "\n"
            return text 
    except:
        logger.error("Text file not found in corpus")
        exit 


if __name__ == "__main__":

    print("=============================================================================================")
    logger.info("\n Now start to Generate word cloud\n")    
    keyword = sys.argv[1]
    stopword_path = "./assets/stopwords.txt" 
    corpus_path = f"corpus/{keyword}_corpus.txt"
    stopwords_cn = load_stopwords(stopword_path)
    corpus = load_corpus(corpus_path)

    w = WordCloud(width=1200, height=800,
                            background_color="white",
                            contour_width=1,
                            contour_color='steelblue',
                            font_path="msyh.ttc",
                            max_words=300, 
                            collocations=False,
                            stopwords=stopwords_cn
                        )

    print("=============================================================================================")
    logger.info("\n Generating word cloud... \n")    
    w.generate(corpus)
    w.to_file(f'wordclouds/印象-{keyword}.png') 
    logger.info("\nWord Cloud successfully generated. Check the wordclouds directory for results.\n")



