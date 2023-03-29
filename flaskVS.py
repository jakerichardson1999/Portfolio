#importing libraries
from flask import Flask, request, render_template, redirect, url_for
import os
from dotenv import load_dotenv
from prompts import get_stoic_advice

#creating the flask aplication object assigned to the variable 'app'
app = Flask(__name__)

#loading key
load_dotenv('key.env')

#empty list to store user chat history
chat_history = []

#create route for app that can accept both get and post
@app.route('/', methods=['GET', 'POST'])
#define function to execute when user visits page
def index():
    global chat_history
    stoic_advice = ''
    if request.method == 'POST':
        user_input = request.form['user_input'] #extracts value of input, call get-stoic-advice to generate response
        stoic_advice = get_stoic_advice(user_input)
        chat_history.append((user_input, stoic_advice)) #append input and advice to chat_history list
    return render_template('index.html', chat_history=chat_history, stoic_advice=stoic_advice) #return html template


@app.route('/reset') #resets flask chat history
def reset():
    global chat_history
    chat_history = []
    return redirect(url_for('index'))


@app.route('/refresh') #refresh history
def refresh():
    global chat_history
    chat_history = []
    return redirect(url_for('reset'))


if __name__ == '__main__':
    app.run(debug=True, port=5001)
