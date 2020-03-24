class Pelota{
  float tamano;
  color c;
  float [] posicion, velocidad;
  
  Pelota(float t, float [] colo,float[] veloc,float[] pos){
    tamano=t;
    c=color(colo[0],colo[1],colo[2]);
    velocidad=veloc;
    posicion=pos;
  }
  
  float[] getDatos(){
    return new float[]{tamano,posicion[0],posicion[1]};
  }
  
  color getColor(){
    return c;
  }
  
  boolean comprobarColision(float x, float y, float rwidth, float rheight){
    
    if(posicion[0]>=x&&posicion[0]<=x+rwidth&&posicion[1]>=y&&posicion[1]<=y+rheight){
      
      velocidad[0]*=(-1);
      posicion[0]+=velocidad[0];
      velocidad[1]*=(-1);
      posicion[1]+=velocidad[1];
      return true;
    }
    return false;
  }
  
  void moverPelota(){
    if(posicion[0]+velocidad[0]>=width){
      posicion[0]=width;
      velocidad[0]*=(-1);
    } else if(posicion[0]+velocidad[0]<=0){
      posicion[0]=0;
      velocidad[0]*=(-1);
    } else{
      posicion[0]+=velocidad[0];
    }
    if(posicion[1]+velocidad[1]>=height){
      posicion[1]=height;
      velocidad[1]*=(-1);
    }else if(posicion[1]+velocidad[1]<=0){
      posicion[1]=0;
      velocidad[1]*=(-1);
    } else{
      posicion[1]+=velocidad[1];
    }
  }
}
