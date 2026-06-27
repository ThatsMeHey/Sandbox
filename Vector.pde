class Vector
{
  public float x, y;
  private float len;
  public Vector(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  public Vector()
  {
    zero();
  }
  public Vector(Vector vec)
  {
    x = vec.x;
    y = vec.y;
  }
  public void normal()
  {
    len = len();
    if (x == 0 && y == 0) return;
    x /= len;
    y /= len;
  }
  public Vector getNormal()
  {
    float l = len();
    float ang = random(0, 2*PI);
    if (x == 0 && y == 0) return new Vector(cos(ang), sin(ang));
    else return new Vector(x / l, y / l);
  }
  public void zero()
  {
    x = 0;
    y = 0;
  }
  public float len()
  {
    len = sqrt(x*x + y*y);
    return len;
  }
  public Vector AddR(Vector vec)
  {
    return new Vector(x + vec.x, y + vec.y);
  }
  public void Add(Vector vec)
  {
    x += vec.x;
    y += vec.y;
  }
  public Vector SubR(Vector vec)
  {
    return new Vector(x - vec.x, y - vec.y);
  }
  public void Sub(Vector vec)
  {
    x -= vec.x;
    y -= vec.y;
  }
  public void Mult(float num)
  {
    x *= num;
    y *= num;
  }
  public Vector MultR(float num)
  {
    return new Vector(x * num, y * num);
  }
  public void Div(float num)
  {
    if (Float.isNaN(x/num) || Float.isNaN(y/num)) return;
    x /= num;
    y /= num;
  }
  public Vector DivR(float num)
  {
    return new Vector(x / num, y / num);
  }
  public boolean isNaN()
  {
    return Float.isNaN(x) || Float.isNaN(y);
  }
  public float getAngle(){
    float ang = 0;
    if (x == 0 && y == 0) ang = 0;
    else if (y != 0 && x == 0){
      ang = 90 * Math.signum(y);
    }
    else if (x != 0){
      ang = (float)Math.toDegrees(Math.atan(y / x));
      if (x < 0) ang += 180;
    }
    return (float)Math.toRadians(ang);
  }
  public void turnOnDegree(float deg){
    float ang = (float)Math.toRadians(deg);
    float x1 = x*cos(ang) - y*sin(ang);
    float y1 = x*sin(ang) + y*cos(ang);
    
    x = x1;
    y = y1;
  }
  public float scalar(Vector vec1, Vector vec2){
    return vec1.x*vec2.x + vec1.y*vec2.y;
  }
}
