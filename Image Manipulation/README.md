
# Image Manipulation


## How To Use
  - Download and Open the Ma57489_assingment2.pde file and click 'Run' to display the image.
  - Click key “1” to convert a color image to a Grayscale image.
  - Click key “2” to add Higher Contrast to the image.
  - Click key “3” to approximate a Gaussian Blur to the image.
  - Click key “4” to perform Edge Detection using the Sobel operators on the image.
  - Click key “0” to return to the image to its original form.

## Infomation 
  - **Grayscale:** This filter will convert a color image to a grayscale image when the user presses "1". One way to do this is by averaging across all color channels     on a per-pixel basis then assigning that value across all three color channels. This roughly preserves the value even if hue and saturation are discarded.
    <img width="632" alt="Screenshot 2024-05-19 at 10 22 20 AM" src="https://github.com/Magret7/Processing-Projects/assets/40001619/56f25f95-dbec-45e6-9758-5cdbbd0985a8">


  - **Contrast:** This filter will add higher contrast to an image when the user presses "2". One way to do this is by calculating the brightness (value) of each pixel.   If the pixel's brightness is above a threshold value, additional "brightness" is added. If the pixel's brightness is below a threshold value, this brightness is         subtracted.
  <img width="632" alt="Screenshot 2024-05-19 at 10 22 26 AM" src="https://github.com/Magret7/Processing-Projects/assets/40001619/4aa2e654-e774-4fb6-9ab2-65cc69c443da">


  - **Gaussian Blur Approximation:** This filter will approximate a Gaussian Blur when the user presses "3". Since blurring requires neighborhood knowledge of pixels,     it will rely on your kernel, or convolution matrix, to extract and manipulate the necessary pixel information. 
  <img width="632" alt="Screenshot 2024-05-19 at 10 22 33 AM" src="https://github.com/Magret7/Processing-Projects/assets/40001619/4118c51f-2882-4ec5-98fd-ad1fcf7bd6d0">
  

  - **Edge detection:** This filter will perform edge detection using the Sobel operators when the user presses "4". This filter also requires neighborhood knowledge of   pixels, and therefore will also use your kernel.
  <img width="632" alt="Screenshot 2024-05-19 at 10 22 37 AM" src="https://github.com/Magret7/Processing-Projects/assets/40001619/4c472d9e-25b9-4893-be40-d61ffe35e531">
