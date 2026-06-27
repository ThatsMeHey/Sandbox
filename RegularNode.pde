class RegularNode extends Node
{
  public ArrayList<Node> children = new ArrayList<Node>();
  public boolean divided = false, isLeafs = true, allNull = true;
  //public Vector rightUpCorner, leftDownCorner;
  public float rightUpCorner_x, rightUpCorner_y;
  public float leftDownCorner_x, leftDownCorner_y;
  public float size;
  
  public RegularNode(float rightUpCorner_x, float rightUpCorner_y, float leftDownCorner_x, float leftDownCorner_y)
  {
    this.rightUpCorner_x = rightUpCorner_x;
    this.rightUpCorner_y = rightUpCorner_y;
    this.leftDownCorner_x = leftDownCorner_x;
    this.leftDownCorner_y = leftDownCorner_y;
    center_x = rightUpCorner_x + leftDownCorner_x;
    center_y = rightUpCorner_y + leftDownCorner_y;
    center_x /= 2f;
    center_y /= 2f;
    size = abs(rightUpCorner_y - leftDownCorner_y);
    for (int i = 0; i < 4; i++){
      children.add(null);
    }
  }
  private void Distribute(Node leaf)
  {    
    if (leaf.center_y >= center_y){
      if (leaf.center_x >= center_x){
        if (children.get(0) == null){
          RegularNode node = new RegularNode(rightUpCorner_x, rightUpCorner_y, center_x, center_y);
          node.AddLeaf(leaf);
          children.set(0, node);
        }
        else ((RegularNode)children.get(0)).AddLeaf(leaf);
      }
      else {
        if (children.get(1) == null){
          RegularNode node = new RegularNode(center_x, rightUpCorner_y, leftDownCorner_x, center_y);
          node.AddLeaf(leaf);
          children.set(1, node);
        }
        else ((RegularNode)children.get(1)).AddLeaf(leaf);
      }
    }
    else{
      if (leaf.center_x >= center_x){
        if (children.get(2) == null){
          RegularNode node = new RegularNode(rightUpCorner_x, center_y, center_x, leftDownCorner_y);
          node.AddLeaf(leaf);
          children.set(2, node);
        }
        else ((RegularNode)children.get(2)).AddLeaf(leaf);
      }
      else {
        if (children.get(3) == null){
          RegularNode node = new RegularNode(center_x, center_y, leftDownCorner_x, leftDownCorner_y);
          node.AddLeaf(leaf);
          children.set(3, node);
        }
        else ((RegularNode)children.get(3)).AddLeaf(leaf);
      }
    }
  }
  
  public void AddLeaf(Node leaf)
  {
    if (!divided)
    {
      if (isLeafs) 
      {
        for (int i = 0; i < 4; i++){
          if (children.get(i) == null){
            children.set(i, leaf);
            mass += leaf.mass;
            allNull = false;
            break;
          }
          else {
            if (i == 3){
              isLeafs = false;
              AddLeaf(leaf);
              return;
            }
          }
        }
      }
      else
      {
        divided = true;
        ArrayList<Node> copyList = new ArrayList<>();
        for (int i = 0; i < children.size(); i++){
          if (children.get(i) != null){
            copyList.add(children.get(i));
          }
        }
        copyList.add(leaf);
        
        for (int i = 0; i < 4; i++){
          children.set(i, null);
        }
        
        for (int i = 0; i < copyList.size(); i++) {
          Distribute(copyList.get(i));
        }
        
        mass = 0;
        for (int i = 0; i < copyList.size(); i++){
          mass += copyList.get(i).mass;
        }
      }
    }
    else
    {
      Distribute(leaf);
      mass += leaf.mass;
    }
  }
  
  @Override
  public void CountMassCenter()
  {
    massCenter_x = 0;
    massCenter_y = 0;
    if (allNull)
    {
      massCenter_x = Float.NaN;
      massCenter_y = Float.NaN;
    }
    else
    {
      float totalMass = 0;
      for (int i = 0; i < 4; i++)
      {
        if (children.get(i) != null){
          children.get(i).CountMassCenter();
          if (Float.isNaN(children.get(i).massCenter_x) || Float.isNaN(children.get(i).massCenter_y)) continue;
          float childMass = children.get(i).mass;
          massCenter_x += children.get(i).massCenter_x * childMass;
          massCenter_y += children.get(i).massCenter_y * childMass;
          totalMass += childMass;
        }  
      }
      if (!(Float.isNaN(massCenter_x/totalMass) || Float.isNaN(massCenter_y/totalMass))){
        massCenter_x /= totalMass;
        massCenter_y /= totalMass;
      }
    }
  }
  
  public void MassCenter()
  {
    massCenter_x = 0;
    massCenter_y = 0;
    if (allNull)
    {
      massCenter_x = Float.NaN;
      massCenter_y = Float.NaN;
    }
    else
    {
      float totalMass = 0;
      for (int i = 0; i < 4; i++)
      {
        if (children.get(i) != null){
          if (Float.isNaN(children.get(i).massCenter_x) || Float.isNaN(children.get(i).massCenter_y)) continue;
          float childMass = children.get(i).mass;
          massCenter_x += children.get(i).massCenter_x * childMass;
          massCenter_y += children.get(i).massCenter_y * childMass;
          totalMass += childMass;
        }  
      }
      if (!(Float.isNaN(massCenter_x/totalMass) || Float.isNaN(massCenter_y/totalMass))){
        massCenter_x /= totalMass;
        massCenter_y /= totalMass;
      }
    }
  }
  
  private void DrawLine(float x1, float y1, float x2, float y2)
  {
    stroke(30, 255, 209); 
    line(x1 + cameraOffset.x, y1 + cameraOffset.y, x2 + cameraOffset.x, y2 + cameraOffset.y);
  }
  @Override
  public void DrawSection()
  {
    strokeWeight(1 / zoom);
    DrawLine(leftDownCorner_x, leftDownCorner_y, leftDownCorner_x, rightUpCorner_y);
    DrawLine(leftDownCorner_x, leftDownCorner_y, rightUpCorner_x, leftDownCorner_y);
    DrawLine(rightUpCorner_x, rightUpCorner_y, leftDownCorner_x, rightUpCorner_y);
    DrawLine(rightUpCorner_x, rightUpCorner_y, rightUpCorner_x, leftDownCorner_y);
    for (int i = 0; i < 4; i++)
    {
      if (children.get(i) != null)
        children.get(i).DrawSection();
    }
  }
}
