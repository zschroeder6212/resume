from flask import Flask
from dotenv import load_dotenv
from os import getenv
from os.path import join, realpath, dirname
import json

import static

load_dotenv()

app = Flask(__name__)
app.secret_key = getenv('APP_SECRET_KEY')
app.config['DEBUG'] = (getenv('APP_DEBUG') == 'True')

app.add_url_rule('/', view_func=static.index, methods=['GET'])
app.add_url_rule('/favicon.ico', view_func=static.favicon, methods=['GET'])

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=getenv('PORT'))