class RegularNode extends Node
{
  public ArrayList<Node> children = new ArrayList<Node>();
  public boolean divided = false, isLeafs = true, allNull = true;
  public Vector rightUpCorner, leftDownCorner;
  public float size;
  
  public RegularNode(Vector rightUpCorner, Vector leftDownCorner)
  {
    this.rightUpCorner = new Vector(rightUpCorner);
    this.leftDownCorner = new Vector(leftDownCorner);
    center = rightUpCorner.AddR(leftDownCorner);
    center.Div(2f);
    size = abs(rightUpCorner.y - leftDownCorner.y);
    for (int i = 0; i < 4; i++){
      children.add(null);
    }
  }
  private void Distribute(Node leaf)
  {    
    if (leaf.center.y >= center.y){
      if (leaf.center.x >= center.x){
        if (children.get(0) == null){
          RegularNode node = new RegularNode(new Vector(rightUpCorner), new Vector(center));
          node.AddLeaf(leaf);
          children.set(0, node);
        }
        else ((RegularNode)children.get(0)).AddLeaf(leaf);
      }
      else {
        if (children.get(1) == null){
          RegularNode node = new RegularNode(new Vector(center.x, rightUpCorner.y), new Vector(leftDownCorner.x, center.y));
          node.AddLeaf(leaf);
          children.set(1, node);
        }
        else ((RegularNode)children.get(1)).AddLeaf(leaf);
      }
    }
    else{
      if (leaf.center.x >= center.x){
        if (children.get(2) == null){
          RegularNode node = new RegularNode(new Vector(rightUpCorner.x, center.y), new Vector(center.x, leftDownCorner.y));
          node.AddLeaf(leaf);
          children.set(2, node);
        }
        else ((RegularNode)children.get(2)).AddLeaf(leaf);
      }
      else {
        if (children.get(3) == null){
          RegularNode node = new RegularNode(new Vector(center), new Vector(leftDownCorner));
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
    massCenter = new Vector();
    if (allNull)
    {
      massCenter.x = Float.NaN;
      massCenter.y = Float.NaN;
    }
    else
    {
      float totalMass = 0;
      for (int i = 0; i < 4; i++)
      {
        if (children.get(i) != null){
          children.get(i).CountMassCenter();
          if (children.get(i).massCenter.isNaN()) continue;
          massCenter.Add(children.get(i).massCenter.MultR(children.get(i).mass));
          totalMass += children.get(i).mass;
        }  
      }
      massCenter.Div(totalMass);
    }
  }
  
  public void MassCenter()
  {
    massCenter = new Vector();
    if (allNull)
    {
      massCenter.x = Float.NaN;
      massCenter.y = Float.NaN;
    }
    else
    {
      float totalMass = 0;
      for (int i = 0; i < 4; i++)
      {
        if (children.get(i) != null){
          if (children.get(i).massCenter.isNaN()) continue;
          massCenter.Add(children.get(i).massCenter.MultR(children.get(i).mass));
          totalMass += children.get(i).mass;
        }  
      }
      massCenter.Div(totalMass);
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
    DrawLine(leftDownCorner.x, leftDownCorner.y, leftDownCorner.x, rightUpCorner.y);
    DrawLine(leftDownCorner.x, leftDownCorner.y, rightUpCorner.x, leftDownCorner.y);
    DrawLine(rightUpCorner.x, rightUpCorner.y, leftDownCorner.x, rightUpCorner.y);
    DrawLine(rightUpCorner.x, rightUpCorner.y, rightUpCorner.x, leftDownCorner.y);
    for (int i = 0; i < 4; i++)
    {
      if (children.get(i) != null)
        children.get(i).DrawSection();
    }
  }
}
