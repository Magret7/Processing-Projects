/** Assignment 2: Image Manipulation **/

PImage originalImage, buffer;

void setup() {
  
  // Load images of multiple size
  surface.setResizable(true); 
  originalImage = loadImage("Deadpool.jpg");
  buffer = loadImage("Deadpool.jpg");
  surface.setSize(originalImage.width, originalImage.height);
}

void draw(){
  // Loading the Image on the Screen
  image(buffer, 0, 0);
}

void keyPressed () {
  
  /** No Filter **/
  // When the user presses "0" the image should return to its original form
  
  if (keyPressed == true && key == '0'){
    buffer.copy(originalImage, 0, 0, originalImage.width, originalImage.height, 0, 0, buffer.width, buffer.height);
  }
  
/******************************************************************************************************/

    
  /** Grayscale **/
  // This filter will convert a color image to a grayscale image when the user presses "1".
  
  if ((keyPressed == true) && (key == '1')) {
    
    // Setting up colorMode and loading Pixels
    colorMode(RGB);
    originalImage.loadPixels();
    
    // Looping through every pixel column
    for (int x = 0; x < originalImage.width; x++) {
     // Looping through every pixel row
      for (int y = 0; y < originalImage.height; y++) {
         // Finding the index
         int index = (x + y * originalImage.width);
         
         // Pulling the color components from a pixels
         float r = red(originalImage.pixels[index]);
         float g = green(originalImage.pixels[index]);
         float b = blue(originalImage.pixels[index]);
         int gray = (int)(r+g+b)/3;
         
         // Set the Pixels to the new grayscale color
         buffer.pixels[index] = color(gray);
         
      // Updating the Pixels
      buffer.updatePixels();
      }
    }
    image(buffer, 0, 0);
  }
  
/******************************************************************************************************/

  /** Contrast **/
  // This filter will add higher contrast to an image when the user presses "2".
  // If the pixel's brightness is above a threshold value, additional "brightness" is added.
  // If the pixel's brightness is below a threshold value, this brightness is subtracted.
  
   int threshold = 100;

   if ((keyPressed == true) && (key == '2')) {
     
    // Setting up colorMode and loading Pixels
    colorMode(HSB);
    originalImage.loadPixels();
    
    // Looping through every pixel column
    for (int x = 0; x < originalImage.width; x++) {
      // Looping through every pixel row
      for (int y = 0; y < originalImage.height; y++) {
         // Finding the index
         int index = x + y * originalImage.width;
         
         // Pulling the color components from a pixels
         float h = hue(originalImage.pixels[index]);
         float s = saturation(originalImage.pixels[index]);
         float b = brightness(originalImage.pixels[index]);
           
         // If pixel's brightness > threshold, additional "brightness" is added.
         if (b > threshold) {
           b += 50;
         }
         // If pixel's brightness < threshold, this "brightness" is subtracted.
         else if (b < threshold) {
           b -= 50;
         }
         
         // Constraining hue, saturation, and brightness
         h = constrain(h, 0, 225);
         s = constrain(s, 0, 225);
         b = constrain(b, 0, 225);
         
         // Seting pixels to new grayscale color
         color contrast = color(h, s, b);
         buffer.pixels[index] = color(contrast);
      }
      // Updtaing and loading the buffer image
      buffer.updatePixels();
      image(buffer, 0, 0);
    }
  }
  
/******************************************************************************************************/
 
  /** Gaussian Blur Approximation **/
  // This filter will approximate a Gaussian Blur when the user presses "3". 
  // Since blurring requires neighborhood knowledge of pixels, it will rely on your kernel, or 
  // convolution matrix, to extract and manipulate the necessary pixel information. 
  
  if ((keyPressed == true) && (key == '3')) {
    
    // Setting up colorMode, loading Pixels, defining matrix
    originalImage.loadPixels();    
    colorMode(RGB);
    float[][] matrix = {{.0625, .125, .0625}, {.125, .25, .125}, {.0625, .125, .0625}};
    
    // Looping through every pixel column
    for (int x = 1; x < originalImage.width-1; x++) {
      // Looping through every pixel row
      for (int y = 1; y < originalImage.height-1; y++) {
        float red = 0.0;
        float green = 0.0;
        float blue = 0.0;
        if ((x > 0) && (y > 0) && (x < originalImage.width - 1) && (y < originalImage.height - 1)) {
          // Accessing individual index of matrix
          for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
              int index = (x + i - 1) + originalImage.width*(y + j - 1);
              
              // Performing convolution on red, green and blue color
              red += red(originalImage.pixels[index]) * matrix[i][j];
              green += green(originalImage.pixels[index]) * matrix[i][j];
              blue += blue(originalImage.pixels[index]) * matrix[i][j];
            }
          }
        }
        
        // Constraining the red, green and blue values
        red = constrain(abs(red), 0, 255);
        green = constrain(abs(green), 0, 255);
        blue = constrain(abs(blue), 0, 255);
         
        // Finding the index
        int index = x + y * width;
        buffer.pixels[index] = color(red, green, blue);
      }
    }
    // Updtaing and loading the buffer image
    buffer.updatePixels();
    image(buffer, 0, 0);
  }
  
/******************************************************************************************************/
  
  /** Edge Detection **/
  // This filter will perform edge detection using the Sobel operators when the user presses "4". 
  // Since blurring requires neighborhood knowledge of pixels, it will rely on your kernel, or 
  // convolution matrix, to extract and manipulate the necessary pixel information.
    
    if ((keyPressed == true) && (key == '4')) {
      
      // Loading Pixels abd Matrix
      originalImage.loadPixels();
      float[][] matrixH = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
      float[][] matrixV = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
      
      // Looping through every pixel column
      for (int x = 1; x < originalImage.width-1; x++) {
        // Looping through every pixel row
        for (int y = 1; y < originalImage.height-1; y++) {
          float redV = 0.0;
          float greenV = 0.0;
          float blueV = 0.0;
          
          float redH = 0.0;
          float greenH = 0.0;
          float blueH = 0.0; 
          
          if ((x > 0) && (y > 0) && (x < originalImage.width - 1) && (y < originalImage.height - 1)) {
          // Accessing individual index pixels (x, y)
          for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
              int index = (x + i - 1) + originalImage.width*(y + j - 1);
              
              // Performing convolution on red, green and blue colors
              redV += red(originalImage.pixels[index]) * matrixV[i][j];
              greenV += green(originalImage.pixels[index]) * matrixV[i][j];
              blueV += blue(originalImage.pixels[index]) * matrixV[i][j];

              // Performing convolution on red, green and blue colors
              redH += red(originalImage.pixels[index]) * matrixH[i][j];
              greenH += green(originalImage.pixels[index]) * matrixH[i][j];
              blueH += blue(originalImage.pixels[index]) * matrixH[i][j];
            }
          }
        }
        
        // Constraining red, green and blue values
        redV = constrain(abs(redV), 0, 255);
        greenV = constrain(abs(greenV), 0, 255);
        blueV = constrain(abs(blueV), 0, 255);
 
        redH = constrain(abs(redH), 0, 255);
        greenH = constrain(abs(greenH), 0, 255);
        blueH = constrain(abs(blueH), 0, 255); 
        
        // Neon magnitude
        float redNew = sqrt(pow(redV, 2) + pow(redH, 2));
        float greenNew = sqrt(pow(greenV, 2) + pow(greenH, 2));
        float blueNew = sqrt(pow(blueV, 2) + pow(blueH, 2));
          
        // Finding the index
        int loc = x + y * width;
        buffer.pixels[loc] = color(redNew, greenNew, blueNew);
      }
    }
    // Updtaing and loading the buffer image
    buffer.updatePixels();
    image(buffer, 0, 0);    
  }
}
