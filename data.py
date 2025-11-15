import requests

# ========== Retrieving/formatting xkcd content ==========

def latest_comic():
    # Gets the latest comic from xkcd
    url = "https://xkcd.com/info.0.json" 
    response = requests.get(url)
    return response.json()

def get_comic(num, session):
    # Gets a comic from xkcd by number
    url = f"https://xkcd.com/{str(num)}/info.0.json" 
    response = session.get(url)
    return response.json()

def format_date(comic):
    # Returns the formated date from an xkcd comic
    return f"{int(comic['year']):04d}-{int(comic['month']):02d}-{int(comic['day']):02d}"

# ========== Retrieving explain xkcd content ==========

def format_page_title(num, session):
    # Formats the explain xkcd wiki page title based on comic number
    title = get_comic(num, session)['title'].replace(" ", "_")
    return f"{num}:_{title}"

def get_sections(page, session):
    # Gets the sections on the explain xkcd page for a comic
    URL = "https://www.explainxkcd.com/wiki/api.php"
    PARAMS = {
        "action": "parse",
        "format": "json",
        "page": page,
        "prop": "sections",
    }
    R = session.get(url=URL, params=PARAMS)
    return R.json()['parse']['sections']

def get_transcript_page(page, section, session):
    # Gets the transcript data for a given comic
    URL = "https://www.explainxkcd.com/wiki/api.php"
    PARAMS = {
                "action": "parse",
                "format": "json",
                "page": page,
                "prop": "wikitext",
                "section": section
            }
    R = session.get(url=URL, params=PARAMS)
    return R.json()

# ========== Formatting transcript ==========

def format_transcript(data_str):
    data_str = remove_str_start(data_str, "==Transcript==")
    data_str = remove_str_end(data_str, "{{Comic discussion}}")
    for newline in ["\\n:", "\\n"]:
        data_str = data_str.replace(newline, "\n")
    data_str = data_str.replace("\\'", "*")
    data_str = data_str.strip()
    return data_str

def remove_str_start(str, removal):
    # Removes substring (and everything before it) from str if found
    index = str.upper().find(removal.upper())
    if index != -1:
        str = str[index + len(removal):]
    return str

def remove_str_end(str, removal):
    # Removes substring (and everything after it) from str if found
    index = str.upper().find(removal.upper())
    if index != -1:
        str = str[:index]
    return str

def get_formatted_transcript(num, session):
    # Gets the explain xkcd comic transcript for the given comic number
    page = format_page_title(num, session)
    sections = get_sections(page, session)
    for section in sections:
        if section['line'] == "Transcript":
            data = get_transcript_page(page, section.get('index'), session)
            data_str = str(data['parse']['wikitext'])
            return format_transcript(data_str)
    return "Transcript not found"

def get_panels(transcript):
    # A list of phrases that indicate single-panel comics
    for phrase in [
        "Caption below the",
        "Caption beneath the panel",
        "below the panel",
        "above panel",
        "[a timeline",
        "top of the image",
        "xkcd Phone",
        "[A large triangle",
        "Caption under the black"]:
        if transcript.upper().find(phrase.upper()) != -1:
            return 1
    double_lines = transcript.count("\n\n")
    # If there's no quote marks and the panel number seems high
    if (transcript.upper().find("\"") == -1) and (double_lines > 4):
        return 1
    return double_lines + 1

def get_dialogue(transcript):
    pass

def get_speakers(transcript):
    pass

def get_descriptive(transcript):
    pass