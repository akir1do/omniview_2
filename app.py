from flask import Flask, request, jsonify
from flask_cors import CORS
from PIL import Image
from transformers import BlipProcessor, BlipForConditionalGeneration
import torch
import io

app = Flask(__name__)
CORS(app)  # Allow CORS for Flutter app

# Initialize BLIP model for image captioning
processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
model = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-base")

@app.route('/caption', methods=['POST'])
def caption_image():
    # Get the image from the request
    file = request.files['image']
    image = Image.open(io.BytesIO(file.read()))

    # Preprocess the image and use BLIP to generate caption
    inputs = processor(images=image, return_tensors="pt")
    out = model.generate(**inputs)
    caption = processor.decode(out[0], skip_special_tokens=True)

    # Return the caption as JSON
    return jsonify({'caption': caption})

if __name__ == '__main__':
    app.run(debug=True)
