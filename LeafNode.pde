class LeafNode extends Node
{
  public float diametr;
  public Vector velocity;
  public Vector acceleration;
  
  //for collision
  public boolean withIndex = false;
  public int ind1, ind2;
  
  public LeafNode(float diametr, Vector position, Vector vel)
  {
    center_x = position.x;
    center_y = position.y;
    this.diametr = diametr;
    mass = 0.01f;
    velocity = new Vector(vel);
    acceleration = new Vector();
    massCenter_x = center_x;
    massCenter_y = center_y;
  }
  public void CountForce(RegularNode tree)
  {
    //игнорируем пустые узлы.
    if (Float.isNaN(tree.massCenter_x) || Float.isNaN(tree.massCenter_y)) return;
    //игнорируем неразделённые узлы, в которых находится рассматриваемое тело.
    if (!tree.divided && this == tree.children.get(0)) return;
    
    float force_x = tree.massCenter_x - center_x;
    float force_y = tree.massCenter_y - center_y;
    float distance = sqrt(force_x*force_x + force_y*force_y);
    if (theta > tree.size / distance || !tree.divided)
    {
      float denom = distance * distance + 100000;
      //force_x /= distance;
      //force_y /= distance;
      
      force_x /= denom;
      force_y /= denom;
      
      force_x *= tree.mass;
      force_y *= tree.mass;
      
      force_x *= G;
      force_y *= G;
      
      acceleration.x += force_x;
      acceleration.y += force_y;
    }
    else
    {
      for (int i = 0; i < tree.children.size(); i++)
      {
        if (tree.children.get(i) != null)
          CountForce((RegularNode)tree.children.get(i));
      }
    }
  }
  public void Move()
  {
    velocity.Add(acceleration);
    center_x += velocity.x;
    center_y += velocity.y;
  }
  @Override
  public void CountMassCenter()
  {
    massCenter_x = center_x;
    massCenter_y = center_y;
  }
  @Override
  public void DrawSection()
  {
    //noStroke();
    //fill(255, 255, 255);
    //rect(center.x + cameraOffset.x, center.y + cameraOffset.y, diametr, diametr);
    //ellipse(center.x + cameraOffset.x, center.y + cameraOffset.y, diametr, diametr);
    
    vertex(center_x + cameraOffset.x, center_y + cameraOffset.y);
    //vertex(dots[i].x, dots[i].y);
  }
}
