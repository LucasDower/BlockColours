void setup() {
  size(750, 750);
  noLoop();
}

void draw() {
  background(255);
  float radius = min(width, height)/2;
  
  // Colour Wheel
  colorMode(HSB);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float dx = i - width/2;
      float dy = height/2 - j;
      float mag = sqrt(pow(dx, 2) + pow(dy, 2));
      if (mag > radius) {
        continue;
      }
      mag = map(mag, 0, radius, 0, 255);
      float ang = (atan2(dy, dx) + 2*PI) % (2*PI);
      ang = map(ang, 0, 2*PI, 0, 255);
      stroke(ang, mag, 255);
      point(i, j);
    }
  }
  
  // Blocks
  colorMode(RGB);
  String dir = "blocks";
  File images_dir = new File(sketchPath(dir));
  String[] images = images_dir.list();
  PImage image;
  for (String image_path : images) {
    image = loadImage(dir + "/" + image_path);
    image.loadPixels();
    float r = 0, g = 0, b = 0, samples = 0;
    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        color c = image.pixels[j * image.width + i];
        float weight = alpha(c)/255;
        r += red(c) * weight;
        g += green(c) * weight;
        b += blue(c) * weight;
        samples += weight;
      }
    }
    color avg = color(r/samples, g/samples, b/samples);
    float hue = map(hue(avg), 0, 255, 2 * PI, 0);
    float sat = map(saturation(avg), 0, 255, 0, radius);
    float x = width/2 + sat * cos(hue);
    float y = height/2 + sat * sin(hue);
    image(image, x - image.width/2, y - image.height/2);
  }
  save("output.png");
}
