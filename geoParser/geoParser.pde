Table table;
PrintWriter output;

float XFactor = 86.26;
float YFactor = 111.0;
float ZFactor = -1.0;

void setup() {
  output = createWriter("lab3.ply"); 
  table = loadTable("Igna_LAB.xyz", "tsv");

  float minX = 100000, minY = 100000, minZ = 100000;
  for (TableRow row : table.rows ()) {
    if (row.getFloat(0)<minX) minX = row.getFloat(0);
    if (row.getFloat(1)<minY) minY = row.getFloat(1);
    if (row.getFloat(2)<minZ) minZ = row.getFloat(2);
  }

  float xToken = table.getFloat(0, 0);
  println("xtoken = "  + xToken);
  int w;
  for (w=1; w<table.getRowCount (); w++) {
    if ( xToken == table.getFloat(w, 0) )
      break;
  }
  int h = table.getRowCount()/w;
  println("grid size: " + w + " x " + h);

  // START PLY FILE
  output.println("ply");
  output.println("format ascii 1.0");
  output.println("element vertex " + table.getRowCount ());
  output.println("property float x");
  output.println("property float y");
  output.println("property float z");
  output.println("element face " + 2*(w-1)*(table.getRowCount()/w-1));
  output.println("property list uchar int vertex_index");
  output.println("end_header");

  // vertexs
  for (TableRow row : table.rows ()) {
    output.println(XFactor*(row.getFloat(0)-minX) + " " + (YFactor*(row.getFloat(1)-minY)) + " " + (ZFactor*row.getFloat(2)));
  }
  // tris
  for (int x = 0; x<w-1; x++) {
    for (int y = 0; y<h-1; y++) {
      output.println("3 "+(x+y*w)+" "+(x+1+y*w)+" "+(x+(y+1)*w)); // triangle top left
      output.println("3 "+(x+1+y*w)+" "+(x+1+(y+1)*w)+" "+(x+(y+1)*w)); // triangle bottom right
    }
  }

  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
  exit();
}