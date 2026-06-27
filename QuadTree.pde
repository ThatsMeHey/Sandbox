class QuadTree
{
  public RegularNode root;
  
  public QuadTree(float len)
  {
    root = new RegularNode(len, len, -len, -len);
  }
  
  
  public void ProcessTree()
  {
    for (int i = bodies.size() - 1; i >= 0; i--)
    {
      LeafNode node = bodies.get(i);
      if (abs(node.center_x) > maxDist || abs(node.center_y) > maxDist){
        bodies.remove(i);
      }
      else root.AddLeaf(node); //<>// //<>//
    }
    
    //if (root.divided){
    //  Thread[] threads = new Thread[4];
    //  for (int i = 0; i < 4; i++) {
    //    final int threadID = i;
    //    threads[i] = new Thread(new Runnable() {
    //      public void run() {
    //        if (root.children.get(threadID) != null)
    //          root.children.get(threadID).CountMassCenter();
    //      }
    //    });
    //    threads[i].start();
    //  }
      
    //  try {
    //    for (Thread t : threads) {
    //      t.join(); // ждем каждый по очереди
    //    }
    //  } catch (InterruptedException e) {
    //    e.printStackTrace();
    //  }
      
    //  root.MassCenter();
    //}
    //else root.CountMassCenter();
    
    root.CountMassCenter();
    
    for (int i = 0; i < bodies.size(); i++)
    {
      LeafNode leaf = bodies.get(i);
      leaf.acceleration.zero();
      leaf.CountForce(root);
      leaf.Move();
      leaf.center_x -= root.massCenter_x;
      leaf.center_y -= root.massCenter_y;
      leaf.DrawSection();
    }
    //root.DrawSection();
  }
}
