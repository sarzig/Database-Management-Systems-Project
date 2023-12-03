from flask import Flask, render_template, request

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/process', methods=['POST'])
def process():
    # Get values from the form
    input_text = request.form['input_text']
    button_value = request.form['button_value']

    # Process the values (you can add your logic here)
    processed_text = f'Input Text: {input_text}, Button Value: {button_value}'

    # Pass the processed result back to the template
    return render_template('index.html', result=processed_text)


if __name__ == '__main__':
    app.run(debug=True)
