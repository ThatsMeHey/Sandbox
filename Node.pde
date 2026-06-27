abstract class Node
{
  public float mass = 0;
  
  public float center_x, center_y;
  public float massCenter_x, massCenter_y;
  
  
  public abstract void CountMassCenter();
  public abstract void DrawSection();
}
