#include <Esplora.h>

const int width = 500;
const int height = 730;
const int blockSize = 64;  // Tamaño del bloque de datos
int currentImage = 0;
int imageIndex = 0;

// Datos de imagen (debe ser reemplazado por los datos reales de la imagen convertidos a matriz de bytes)
const byte image1[width * height / 8] = { /* Insertar datos de imagen1 */ };
const byte image2[width * height / 8] = { /* Insertar datos de imagen2 */ };
const byte image3[width * height / 8] = { /* Insertar datos de imagen3 */ };

const byte* images[] = {image1, image2, image3};

void setup() {
  Esplora.begin();
  Serial.begin(115200);  // Usa una velocidad de baudios más alta
}

void loop() {
  int buttonState = Esplora.readButton(Esplora.BUTTON1);
  int potValue = Esplora.readJoystickX();
  int brightness = map(potValue, 0, 1023, 0, 255);

  if (buttonState == HIGH) {
    currentImage = (currentImage + 1) % 3;
    imageIndex = 0;
    delay(200);
  }

  // Enviar la imagen en bloques
  Serial.print("Image:");
  Serial.print(currentImage);
  Serial.print(" Brightness:");
  Serial.print(brightness);
  Serial.print(" ");
  
  int startIndex = imageIndex * blockSize;
  int endIndex = min(startIndex + blockSize, width * height / 8);

  for (int i = startIndex; i < endIndex; i++) {
    Serial.print(images[currentImage][i], HEX);
    Serial.print(" ");
  }
  
  Serial.println();

  imageIndex++;
  if (imageIndex * blockSize >= width * height / 8) {
    imageIndex = 0;  // Reiniciar el índice de la imagen para la próxima transmisión
    delay(500);  // Esperar antes de enviar la siguiente imagen
  }

  delay(100);
}

