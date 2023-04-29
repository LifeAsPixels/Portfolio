from bs4 import BeautifulSoup as bs
import re
import os
import pandas as pd
import webbrowser as wb

# source
# https://www.greatplacetowork.com/best-workplaces/technology/2022
# download entire page - not just html

# VARS
filter1 = re.compile(r'^<li><i.+<\/i>([\w\s,\.]*)<\/li>') # extract text after an <i> inside a <ul>.<li> -- bs didn't catch text like this from sudo tag1: <tag1><tag2 class"someclass" key="value"> text in tag2</tag2> this is the text bs did not catch</tag1>
filter2 = re.compile(r'^<a.*href=\"(.*?)\".*') # extract hyperlink from html href 
export = r'D:\Life\Code\_Asset\Data\Export'
filename = "Fortune-2022-TechLarge.csv"
filepath = export + '\\' + filename
file = open(filepath, 'w', newline = '')

# init vars as lists for proper interaction later
rank = []
name = []
industry = []
location = []
reviewURL = []
sourceName = []
sourceURL = []
article = []
year = []
rankCategory = []
rankLeague = []

html_doc = open(r'Drive:\Path\to\folder\FileName.html')

soup = bs(html_doc, 'html.parser') # choose parser and instantiate bs with file
html_doc.close() # close file source after parsing

section = soup.find(id="list-detail-component") # go to file section that has data
section = section.div.div.div # go to root of the desired item-list

parselist = section.div(class_="row company small no-margin-top") # last time cutting away exterior parts

# gather list-item info here
for i in parselist:
    rank.append(str(i.div.div.string).strip())
    name.append(str(i.div.a.string).strip())

    industry_tmp = str(i.div.find("ul", class_="industry fa-ul").li) # set for readability
    industry.append(filter1.search(industry_tmp).group(1))

    location_tmp = str(i.div.find("ul", class_="location fa-ul").li) # set for readability
    location.append(filter1.search(location_tmp).group(1))
    
    reviewURL_tmp = str(i.div.find("ul", class_="review-link fa-ul").li.a) # set for readability
    reviewURL.append(filter2.search(reviewURL_tmp).group(1))

    sourceName.append('Great Places to Work') # add site name to record
    sourceURL.append('https://www.greatplacetowork.com/') # add site url to record

    article.append(re.sub('[^A-Za-z0-9,_\s\-\|]+', '', soup.title.string)) # add article name to record and only allow words, numbers, and spaces

    year.append(2022)
    rankCategory.append('Technology') # other articles rank businesses categorically -- overall, industry, international, demographic etc.
    rankLeague.append('Large') # other articles rank different scales

fortune2022techlarge = { # make dictionary of {column name : List of values}
    'rank': rank, # number
    'name': name, # company name
    'industry': industry, # industry category
    'location': location, # city, state, nation etc.
    'reviewURL': reviewURL, # a link to article about the company
    'sourceName': sourceName, # name of source
    'sourceURL': sourceURL, # URL to source
    'article': article, # name of article
    'year': year, # year attributed to contest
    'rankCategory': rankCategory, # scope of businesses for the audience
    'rankLeague': rankLeague # size-scale of business qualitative measure
    }

for link in reviewURL: # open all the links to official reviews on the tech fortune 500 best companies to work for list
    wb.open(link)

df = pd.DataFrame.from_dict(fortune2022techlarge) # make pandas dataframe from the dictionary
df.to_csv(file) # save the df to a csv
