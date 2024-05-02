#!/usr/bin/python3
#@brief Evaluate focus by OpenCV
#@author @remov_b4_flight
import argparse
import cv2
import cv2.quality
import os
import sys
import numpy as np

#Constants
FILE_ERROR = 255
SCORE_WORST = 200
YAML_PATH = "/opt/homebrew/Cellar/opencv/4.9.0_8.reinstall/share/opencv4/quality"
#Option parse
ap = argparse.ArgumentParser(description = "Evaluate image.")
ap.add_argument("file", help = "Image file to process.")
ap.add_argument("-v", help = "verbose outputs", action = 'count', default = 0)
ap.add_argument("-m", "--model", help = "model file", default = "brisque_model_live.yml")
ap.add_argument("-r", "--range", help = "range file", default = "brisque_range_live.yml")
args = vars(ap.parse_args())

model_file = YAML_PATH + os.sep + args["model"]
range_file = YAML_PATH + os.sep + args["range"]

if (args["v"] >= 2):
    print("model file=", model_file)
    print("range file=", range_file)

#Process Image
image_path = args["file"]

print("input image =", image_path)

input_image = cv2.imread(image_path)
if input_image is None:
    print(image_path, "CAN'T READ.")
    sys.exit(FILE_ERROR)

score_array = cv2.quality.QualityBRISQUE_compute(input_image, model_file, range_file)
raw_score = score_array[0]
if (args["v"] >= 1):
    print("BRISQUE raw score =", raw_score)
score_rev = int(raw_score * 2)
score = abs(score_rev - SCORE_WORST)

print("score =", score)

sys.exit(score)
