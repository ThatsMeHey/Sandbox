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
        node.center_x = 0;
        node.center_y = 0;
        node.velocity.zero();
        node.Move();
      }
      root.AddLeaf(node);  //<>//
    }
    //if (!root.divided){
    //  CountDownLatch latch = new CountDownLatch(threads);
    //  for (int i = 0; i < 4; i++) {
    //      final int id = i;
    //      pool.submit(new Runnable() {
    //          public void run() {
    //              try {
    //                if (root.children.get(id) != null)
    //                  root.children.get(id).CountMassCenter();
    //              } finally {
    //                  latch.countDown(); // Сигналим, что поток закончил
    //              }
    //          }
    //      });
    //  }
    //  try {
    //      latch.await(); // Блокируемся, пока все 4 не закончат
    //  } catch (InterruptedException e) {
    //      e.printStackTrace();
    //  }
    //  root.MassCenter();
    //}
    //else root.CountMassCenter();
    root.CountMassCenter();
    
    if (bodies.size() > 100){
      CountDownLatch latch = new CountDownLatch(threads);
      for (int i = 0; i < threads; i++) {
          final int id = i;
          final int len = (bodies.size() - bodies.size() % threads) / threads;
          pool.submit(new Runnable() {
              public void run() {
                  try {
                    int start = id * len;
                    int end = 0;
                    if (id == threads - 1) end = bodies.size();
                    else end = start + len;
                    for (int k = start; k < end; k++)
                    {
                      LeafNode leaf = bodies.get(k);
                      leaf.acceleration.zero();
                      leaf.CountForce(root);
                      leaf.Move();
                      leaf.center_x -= root.massCenter_x;
                      leaf.center_y -= root.massCenter_y;
                    }
                  } finally {
                      latch.countDown(); // Сигналим, что поток закончил
                  }
              }
          });
      }
      try {
          latch.await(); // Блокируемся, пока все 4 не закончат
      } catch (InterruptedException e) {
          e.printStackTrace();
      }
      
      for (int i = 0; i < bodies.size(); i++){
        bodies.get(i).DrawSection();
      }
    }
    else{
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
    }
    //root.DrawSection();
  }
}
