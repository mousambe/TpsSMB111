import logging

import azure.functions as func


import ddddsr
from PIL import Image
import io
from numpy import asarray


def main(myblobTrigger: func.InputStream, inputImg: bytes, outputImg: func.Out[func.InputStream]) -> None:
    logging.info(f"Python blob trigger function processed blob \n"
                 f"Name: {myblobTrigger.name}\n"
                 f"Blob Size: {myblobTrigger.length} bytes")

    PilimageGangogh = Image.open(io.BytesIO(inputImg))
    numpydata = asarray(PilimageGangogh)
    Hdnumpydata = ddddsr.SR()(numpydata)
    PilImgHd = Image.fromarray(Hdnumpydata)
    dataout = io.BytesIO()
    PilImgHd.save(dataout, 'jpeg')
    dataout.seek(0)
    outputImg.set(dataout)
                