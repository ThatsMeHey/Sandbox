float widthHalf;
float heightHalf;
ArrayList<LeafNode> bodies = new ArrayList<LeafNode>();
boolean pressed;
Vector createPos = new Vector(), mousePos = new Vector(), cameraOffset = new Vector();
float scale = 10f;

float zoom = 1.0;
float zoomMin = 0.0025, zoomMax = 5.0;
float zoomFactor = 1.1;
float panX = 0, panY = 0;

float planetRadius = 5;
float maxDist = 150000;
float theta = 0.7f;

//Cells cells;

Vector utils = new Vector();


void setup() 
{
  fullScreen(P2D);
  smooth();
  ellipseMode(CENTER);
  pressed = false;
  widthHalf = width / 2f;
  heightHalf = height / 2f;
  
  //CreateCloud(1000, 1000, 8000);
  //cells = new Cells();
  CreateCloud(200, 500, 0, -90, 15000);
  CreateCloud(200, -200, -1.5f, 90, 15000);
}



void mousePressed() 
{
  if (mouseButton == LEFT) 
  {
    if (!pressed) HoldToCreate(mousePos.SubR(cameraOffset));
  }
}
void mouseReleased() 
{
  if (mouseButton == LEFT) 
  {
    if (pressed) ReleaseToCreate(mousePos.SubR(cameraOffset));
  }
}

void CreateCloud(float radius, float posY, float vel, float A, int amount)
{  
  float A_ = A * PI / 180f;
  for (int i = 0; i < amount; i++)
  {
    float k = random(0f, 360f);
    float ang = radians(k);
    Vector pos = new Vector(cos(ang), sin(ang));
    float dist = random (0.01f, radius);
    pos.Mult(dist);
    Vector vel_ = new Vector(cos(ang + A_), sin(ang + A_));
    //vel_.zero();
    vel_.Mult(10f * dist/500f);
    pos.y += posY;
    vel_.x += vel;
    LeafNode body = new LeafNode(planetRadius, pos, vel_);
    bodies.add(body);
  }
}
void CreateCloud(float x, float y, int amount)
{
  for (int i = 0; i < amount; i++)
  {
    float k = random(0f, 360f);
    float ang = radians(k);
    Vector pos = new Vector(random(-x, x), random(-y, y));
    Vector vel_ = new Vector(cos(ang)*10, sin(ang)*5);
    //vel_ = new Vector(0, 0);
    LeafNode body = new LeafNode(10, pos, vel_);
    bodies.add(body);
  }
}

void draw() 
{
  
  background(0);
  translate(widthHalf, heightHalf);
  scale(zoom);
  
  if (keyPressed) ProcessKey();
  
  //mousePos = new Vector(mouseX - widthHalf, mouseY - heightHalf);
  //mousePos.Div(zoom);
  
  //DrawSample();
  stroke(255);
  strokeWeight(4);
  beginShape(POINTS);
  
  QuadTree tree = new QuadTree(maxDist);
  tree.ProcessTree();
  
  endShape();
}

void DrawSample()
{
  if (!pressed)
  {
    noStroke();
    fill(240, 15, 139);
    ellipse(mousePos.x, mousePos.y, planetRadius*2, planetRadius*2);
  }
  else
  {
    noStroke();
    fill(240, 15, 139);
    ellipse(createPos.x + cameraOffset.x, createPos.y + cameraOffset.y, planetRadius*2, planetRadius*2);
  } 
}

private Vector Offset()
{
  Vector offset = new Vector();
  offset.x = random(0.01f, 0.015f);
  offset.y = random(0.01f, 0.015f);
  return offset;
}

private void HoldToCreate(Vector mousePos)
{
  pressed = true;
  createPos = mousePos.AddR(Offset());
}
private void ReleaseToCreate(Vector mousePos)
{
  pressed = false;
  LeafNode body = new LeafNode(planetRadius, createPos, createPos.SubR(mousePos).DivR(80));
  bodies.add(body);
}
void ProcessKey()
{
  Vector off = new Vector();
  if (key == 'w') off.y += 5 / zoom;
  if (key == 'a')  off.x += 5 / zoom;
  if (key == 's')  off.y -= 5 / zoom;
  if (key == 'd') off.x -= 5 / zoom;
  cameraOffset.Add(off);
  if (cameraOffset.x > maxDist) cameraOffset.x = maxDist;
  if (cameraOffset.x < -maxDist) cameraOffset.x = -maxDist;
  if (cameraOffset.y > maxDist) cameraOffset.y = maxDist;
  if (cameraOffset.y < -maxDist) cameraOffset.y = -maxDist;
  
  if (keyCode == LEFT) 
  {
    scale -= 0.4;
    if (scale < 0.025) scale = 0.25;
  }
  if (keyCode == RIGHT) 
  {
    scale += 0.4;
    if (scale > 1000) scale = 1000;
  }
  if (key == '+' || key == '=') 
  {
    float newZoom = constrain(zoom * zoomFactor, zoomMin, zoomMax);
    zoom = newZoom;
  } else if (key == '-') 
  {
    float newZoom = constrain(zoom / zoomFactor, zoomMin, zoomMax);
    zoom = newZoom;
  }
}
