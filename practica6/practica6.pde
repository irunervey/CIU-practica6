import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;

Capture cam;
CVImage img;

CascadeClassifier face;
String faceFile;
ArrayList<Pelota> pelotas;
boolean modo, rectangulo, rand,menu;
int puntuacion;

void setup() {
  menu=true;
  rectangulo=true;
  puntuacion=0;
  rand=true;
  modo =true;
  size(640, 480);
  cam = new Capture(this, width , height);
  cam.start(); 
  
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);
  
  faceFile = "haarcascade_frontalface_default.xml";
  face = new CascadeClassifier(dataPath(faceFile));
  
  pelotas=new ArrayList<Pelota> ();
  for(int i = 0; i<10;i++){
    generarPelotas();
  }  
}

void generarPelotas(){
  pelotas.add(new Pelota(random(45)+5,new float[]{random(255),random(255),random(255)},new float[]{random(10)-10,random(10)-10},new float[]{random(width),random(height)}));
}

void draw() {  
    
  if (cam.available()) {
    background(0);
    
    cam.read();
    
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    Mat gris = img.getGrey();
    image(img,0,0);
    FaceDetect(gris);
    
    if(modo){
      stroke(120);
      fill(120);
      rect(18, height-30, 100, 20, 7);
      fill(0);
      text("Puntuacion "+puntuacion, 20,height-20);
    }
    if(menu){
      stroke(255);
      fill(255);
      rect(18, 20, 200, 110, 7);
      fill(0);
      text("Pulse espacio para salir del menu", 20,30);
      
      if(modo){
        String mostrar;
        text("Modo(e): juego", 20,45);
        if(rand)mostrar="renovar";
        else mostrar="eliminar";
        text("tratamiento(r): "+mostrar, 25,60);
        
      }else {
        text("Modo(e): revote", 20,45);
      }
      text("Mostrar rectangulo facial(t)", 20,75);
      text("Para modificar los valores pulse\nla tecla entre parenteris", 20,90);
      
    } else{
      moverPelotas();
      imprimirEsferas();
    }
    gris.release();
  }
}

void imprimirEsferas(){
  for(Pelota pelota: pelotas){
      fill(pelota.getColor());
      noStroke();
      float[] datos= pelota.getDatos();
      ellipse(datos[1],datos[2],datos[0],datos[0]);
    }
}

void moverPelotas(){
   for(Pelota pelota: pelotas){
     pelota.moverPelota();
   }
}

void FaceDetect(Mat grey)
{
  
  //Detección de rostros
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(grey, faces, 1.15, 3, 
    Objdetect.CASCADE_SCALE_IMAGE, 
    new Size(60, 60), new Size(200, 200));
  Rect [] facesArr = faces.toArray();
  noFill();
  stroke(255,0,0);
  strokeWeight(2);
  
  for (Rect r : facesArr) {    
    if(rectangulo)rect(r.x, r.y, r.width, r.height);
    int i=0;
    ArrayList<Integer> eliminar =new ArrayList <Integer>();
    for(Pelota pelota:pelotas){
      if(pelota.comprobarColision(r.x, r.y, r.width, r.height) && modo) eliminar.add(i);
      i++;
    }
    if(!menu){
      int j=0;
      for(int elimino: eliminar){
        pelotas.remove(elimino-j);
        j++;
        if(rand){
          generarPelotas();
        }
      }
      if(i!=0)puntuacion+=100*j/i;
    }
   }
  
  faces.release();
}

void mousePressed(){
  if(!menu) pelotas.add(new Pelota(random(45)+5,new float[]{random(255),random(255),random(255)},new float[]{random(20)-10,random(20)-10},new float[]{mouseX,mouseY}));
 
}
 void keyPressed(){
   if(key==' '){
     menu=menu^true;
   }
   if(key=='r'||key=='R'){
     rand=rand^true;
   }
   if(key=='e'|| key=='E'){
     modo=modo^true;
   }
   if(key=='t'|| key=='t'){
     rectangulo=rectangulo^true;
   }
 }
