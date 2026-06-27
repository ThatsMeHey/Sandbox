class Cells{
  public float cellWidth = planetRadius;
  public float fieldWidth = maxDist * 2;
  public ArrayList<ArrayList<ArrayList<Integer>>> table = new ArrayList();
  private int size = 0;
  
  public Cells(){
    size = Math.round(fieldWidth / cellWidth);
    for (int i = 0; i < size; i++){
      ArrayList<ArrayList<Integer>> list = new ArrayList();
      table.add(list);
      for (int j = 0; j < size; j++){
        ArrayList<Integer> intList = new ArrayList();
        list.add(intList);
      }
    }
    println(table.size());
  }
  
  public void Clear(){
    for (int i = 0; i < size; i++){
      for (int j = 0; j < size; j++){
        table.get(i).get(j).clear();
      }
    }
  }
  
  public void AddBody(int index){
    LeafNode node = bodies.get(index);
    
    if (node.withIndex){
      table.get(node.ind1).get(node.ind2).remove((Integer) index);
    }
    
    int i = (int)Math.ceil((node.center.y + maxDist) / cellWidth) - 1;
    if (i < 0) i = 0;
    if (i > size - 1) i = size - 1;
    
    int j = (int)Math.ceil((node.center.x + maxDist) / cellWidth) - 1;
    if (j < 0) j = 0;
    if (j > size - 1) j = size - 1;
    node.withIndex = true;
    node.ind1 = i;
    node.ind2 = j;
    table.get(i).get(j).add(index);
  }
  
  public void AddAll(){
    for (int i = 0; i < bodies.size(); i++){
      AddBody(i);
    }
  }
  
  public void FindCollision(){
    //for (int r = 0; r < 6; r++){
    //  for (int i = 0; i < size; i++){
    //    for (int j = 0; j < size; j++){
    //      for (int k : table.get(i).get(j)){
    //        MoveInCell(i - 1, j - 1, k);
    //        MoveInCell(i, j - 1, k);
    //        MoveInCell(i + 1, j - 1, k);
            
    //        MoveInCell(i - 1, j, k);
    //        MoveInCell(i , j, k);
    //        MoveInCell(i + 1, j, k);
            
    //        MoveInCell(i - 1, j +1, k);
    //        MoveInCell(i, j + 1, k);
    //        MoveInCell(i + 1, j + 1, k);
    //      }
    //    }
    //  }
    //}
    //AddAll();
    int i = 0;
    int j = 0;
    for (int r = 0; r < 3; r++){
      for (int h = 0; h < bodies.size(); h++){
        for (int k : table.get(bodies.get(h).ind1).get(bodies.get(h).ind2)){
          i = bodies.get(h).ind1;
          j = bodies.get(h).ind2;
          
          MoveInCell(i - 1, j - 1, k);
          MoveInCell(i, j - 1, k);
          MoveInCell(i + 1, j - 1, k);
          
          MoveInCell(i - 1, j, k);
          MoveInCell(i , j, k);
          MoveInCell(i + 1, j, k);
          
          MoveInCell(i - 1, j +1, k);
          MoveInCell(i, j + 1, k);
          MoveInCell(i + 1, j + 1, k);
        }
      }
      AddAll();
    }
  }
  
  public void MoveInCell(int i, int j, int t1){
    if (i < 0 || j < 0 || i > size - 1 || j > size - 1) return;
    
    for (int t2 : table.get(i).get(j)){
      if (t1 == t2) continue;
      
      Vector vec = bodies.get(t1).center.SubR(bodies.get(t2).center);
      float dist = vec.len();
      if (dist < cellWidth){
        vec.normal();
        vec.Mult((cellWidth - dist) / 2f);
        bodies.get(t1).center.Add(vec);
        bodies.get(t2).center.Sub(vec);
        
        Vector n = bodies.get(t1).center.SubR(bodies.get(t2).center);
        n.normal();
        Vector t = new Vector(n);
        t.turnOnDegree(90);
        
        float v1n = n.scalar(bodies.get(t1).velocity, n);
        float v1t = n.scalar(bodies.get(t1).velocity, t);
        float v2n = n.scalar(bodies.get(t2).velocity, n);
        float v2t = n.scalar(bodies.get(t2).velocity, t);
        
        Vector V1 = n.MultR(v2n);
        V1.Add(t.MultR(v1t));
        
        Vector V2 = n.MultR(v1n);
        V2.Add(t.MultR(v2t));
        
        
        bodies.get(t1).velocity = new Vector(V1);
        bodies.get(t2).velocity = new Vector(V2);
      }
    }
  }
}
