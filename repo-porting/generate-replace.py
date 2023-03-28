import re
import argparse
import os
from pathlib import Path, WindowsPath
from PIL import Image, ImageDraw, ImageFont
from typing import Dict,List,Union


def _GetFileExtension(file:Union[str,Path]):
        name = file
        if type(file) is Path or type(file) is WindowsPath:
            name = file.name
        name = name.lower()
        return name.split(".")[-1]    


class MediaFilesHelper:

    imageTypes = {"gif"}
    # imageTypes = {"jpg", "jpeg", "png", "bmp", "svg", "gif"}
    audioTypes = {"mp3", "wav"}
    videoTypes = {"mp4"}

    @classmethod
    def ReplaceFiles(cls, fileList:List[Path]):
        for file in fileList:
            cls.ReplaceFile(file)

    @classmethod
    def ReplaceFile(cls, file:Path):
        mediaType, mediaExt = cls.GetMediaType(file)
        if mediaType == "image":
            ImageFilesHelper.ReplaceFile(file)
        elif mediaType == "video":
            VideoFilesHelper.ReplaceFile(file)
        elif mediaType == "audio":
            AudioFilesHelper.ReplaceFile(file)
        else:
            return
        

    @classmethod
    def GetMediaType(cls, file:Union[Path,str]):
        ext = _GetFileExtension(file)
        if ext in cls.imageTypes:
            return "image", ext
        elif ext in cls.videoTypes:
            return "video", ext
        elif ext in cls.audioTypes:
            return "audio", ext
        else:
            return "unk", "unk"
        


class ImageFilesHelper:

    imageTypes = {"jpg", "jpeg", "png", "bmp", "svg", "gif"}
    variations = ["null", "WPF", "Windows Presentation Framework", "WPF - Windows Presenation Framework"]
    variation_textbbox = []

    @classmethod
    def ReplaceFile(cls, file:Path):
        imageType = cls.GetImageType(file)
        if imageType == "unk":
            return
        
        img = Image.open(file)
        genImg = cls.GenerateImageFile(img, imageType)
        img.close()
        # newFile = Path(file.parent, "replace-{}".format(file.name))
        genImg.save(file)
        genImg.close()

    @classmethod
    def ReplaceFiles(cls, fileList:List[Path]):
        pass

    @classmethod
    def GenerateImageFile(cls, width, height, mode, imageType:str, variation:int=1):
        pass

    @classmethod
    def GenerateImageFile(cls, img, imageType, variation:int=1):
        newImg = Image.new(img.mode, img.size)
        
        width,height = img.size
        if width <= 2*height:
            variation=1
        elif width <= 3*height:
            variation=2
        else:
            variation=3

        draw = ImageDraw.Draw(newImg)

        text = cls.variations[variation]
        dw,dh  = cls.variation_textbbox[variation]

        scale = min(width // (dw*2), height // (dh*2))
        if variation == 3:
            scale = min(width // (dw*2), (height-10) // (dh))
        fnt = ImageFont.truetype("C:\\Windows\\Fonts\\arialbd.ttf", 8*scale)
        aw = dw*scale
        ah = dh*scale

        draw.text(((width-aw)/2,(height-ah)/2), text, font=fnt, fill="white")

        return newImg

    @classmethod
    def GetImageType(cls, file:Union[Path,str]):
        ext = _GetFileExtension(file)
        if ext in cls.imageTypes:
            return ext
        return "unk"

    @classmethod
    def GetTextBoundingBoxes(cls):
        tempImg = Image.new("RGB", (1000,1000))
        fnt = ImageFont.truetype("C:\\Windows\\Fonts\\arialbd.ttf", 8)
        draw = ImageDraw.Draw(tempImg)
        for variation in cls.variations:
            _, _, width, height = draw.textbbox((0,0), variation, font=fnt)
            cls.variation_textbbox.append((width,height))


class VideoFilesHelper:

    videoTypes = {"mp4"}

    @classmethod
    def ReplaceFile(file:Path):
        pass

    @classmethod
    def ReplaceFiles(fileList:List[Path]):
        pass  


class AudioFilesHelper:

    audioTypes = {"mp3", "wav"}

    @classmethod
    def ReplaceFile(file:Path):
        pass

    @classmethod
    def ReplaceFiles(fileList:List[Path]):
        pass  


def GetMediaFileList(rootDir):
    mediaFiles = []
    for dirName, _ , fileList in os.walk(rootDir):
        for fileName in fileList:
            mediaType, _ = MediaFilesHelper.GetMediaType(fileName)
            if mediaType != "unk":
                fullPath = Path(dirName, fileName)
                mediaFiles.append(fullPath)
    return mediaFiles


def parse_args():
    parser = argparse.ArgumentParser(prog='generate-replace', description="")
    parser.add_argument('-r', '--rootDir', type=Path, 
                            help='Directories and child where to replace media files.')
    return parser.parse_args()

def main():

    ImageFilesHelper.GetTextBoundingBoxes()

    print("Parsing Args:")
    args = parse_args()
    rootDir = args.rootDir.resolve()
    mediaFiles = GetMediaFileList(args.rootDir)
    print(mediaFiles)
    print(len(mediaFiles))
    MediaFilesHelper.ReplaceFiles(mediaFiles)

if __name__ == "__main__":
    main()