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
    center = new Vector(position);
    this.diametr = diametr;
    mass = 0.01f;
    velocity = new Vector(vel);
    acceleration = new Vector();
    massCenter = new Vector(center);
  }
  public void CountForce(RegularNode tree)
  {
    //игнорируем пустые узлы.
    if (tree.massCenter.isNaN()) return;
    //игнорируем неразделённые узлы, в которых находится рассматриваемое тело.
    if (!tree.divided && this == tree.children.get(0)) return;
    
    Vector force = tree.massCenter.SubR(center);
    float distance = force.len();
    if (theta > tree.size / distance || !tree.divided)
    {
      //force.normal();
      force.Div(distance * distance + 100000);
      //force.Mult();
      acceleration.Add(force.MultR(tree.mass));
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
    center.Add(velocity);
  }
  @Override
  public void CountMassCenter()
  {
    massCenter = new Vector(center);
  }
  @Override
  public void DrawSection()
  {
    //noStroke();
    //fill(255, 255, 255);
    //rect(center.x + cameraOffset.x, center.y + cameraOffset.y, diametr, diametr);
    //ellipse(center.x + cameraOffset.x, center.y + cameraOffset.y, diametr, diametr);
    
    vertex(center.x + cameraOffset.x, center.y + cameraOffset.y);
    //vertex(dots[i].x, dots[i].y);
  }
}
