/**
 * Methods for manipulating arrays vectors (PVector[]),
 * including centering, mirroring, rotating, translating,
 * and sorting by x, y, heading, or magnitude, as well as
 * finding the bounds and center of a point array.
 * 
 * Sorting may be augmented by writing a custom comparator.
 *
 * Class methods assume that all vectors may be treated as
 * points having a shared origin (0,0).
 */
public static class VecArrayTool {
  /**
   * x comparator: sort vectors by x, then y
   */
  public static final Comparator<PVector> VEC_CMP_X = new Comparator<PVector>() {
    @ Override public final int compare(final PVector a, final PVector b) {
      int cmp;
      return
        (cmp = Float.compare(a.x, b.x)) != 0? cmp :
        Float.compare(a.y, b.y);
    }
  };
  /**
   * y comparator: sort vectors by y, then x
   */
  public static final Comparator<PVector> VEC_CMP_Y = new Comparator<PVector>() {
    @ Override public final int compare(final PVector a, final PVector b) {
      int cmp;
      return
        (cmp = Float.compare(a.y, b.y)) != 0? cmp :
        Float.compare(a.x, b.x);
    }
  };
  /**
   * h comparator: sort vectors by heading (angle of rotation from origin)
   */
  public static final Comparator<PVector> VEC_CMP_HEAD = new Comparator<PVector>() {
    @ Override public final int compare(final PVector a, final PVector b) {
      return Float.compare(a.heading(), b.heading());
    }
  };
  /**
   * m comparator: sort vectors by magnitude (distance from origin)
   */
  public static final Comparator<PVector> VEC_CMP_MAG = new Comparator<PVector>() {
    @ Override public final int compare(final PVector a, final PVector b) {
      return Float.compare(a.mag(), b.mag());
    }
  };

  /**
   * random comparator: example of writing a custom sorting comparator.
   * Use with:
   *
   *   VecArrayTool.sort(vecs, VEC_CMP_RANDOM);
   */
  public static final Comparator<PVector> VEC_CMP_RANDOM = new Comparator<PVector>() {
    @ Override public final int compare(final PVector a, final PVector b) {
      return (Math.random()<0.5) ? -1 : 1;
    }
  };
    
  /**
   * Center a point array based on its bounds.
   * Returns a new array.
   *
   * @param   vecs   array of vectors
   * @return         a new PVector array centered on 0, 0
   */
  public PVector[] center(PVector[] vecs) {
    PVector ctr = this.getCenter(vecs);
    return this.translate(vecs, -ctr.x, -ctr.y);
  }

  /**
   * Get the rectangular bounds of an array of vectors
   * defined as an array of extrema.
   * 
   * These extrema define two corners of a bounding rectangle.
   * The later terms (xmax, ymax) are a coordinate,
   * not width, height.
   *
   * @param   vecs   array of vectors
   * @return         array of two bounds [(xmin, ymin), (xmax, ymax)]
   */
  public PVector[] getBounds(PVector[] vecs) {
    float xmin = vecs[0].x;    
    float xmax = vecs[0].x;
    float ymin = vecs[0].y;    
    float ymax = vecs[0].y;
    for (int i=1; i<vecs.length; i++) {
      xmin = (xmin < vecs[i].x) ? xmin : vecs[i].x;
      xmax = (xmax > vecs[i].x) ? xmax : vecs[i].x;
      ymin = (ymin < vecs[i].y) ? ymin : vecs[i].y;
      ymax = (ymax > vecs[i].y) ? ymax : vecs[i].y;
    }
    PVector[] results = new PVector[]{
      new PVector(xmin, ymin), 
      new PVector(xmax, ymax)
    };
    return results;
    //return new float[]{xmin, ymin, xmax, ymax};
  }  

  /**
   * Get center of the array of vectors,
   * defined as the center of the x/y bounds.
   *
   * @param   vecs   array of vectors
   * @return         center x,y
   */
  public PVector getCenter(PVector[] vecs) {
    PVector[] bnds = this.getBounds(vecs);
    return PVector.lerp(bnds[0], bnds[1], 0.5f);
  }

  /**
   * Get width of the array of vectors, defined on the x axis.
   *
   * @param   vecs   array of vectors
   * @return         width
   */
  public float getWidth(PVector[] vecs) {
    PVector[] bnds = this.getBounds(vecs);
    return bnds[1].x - bnds[0].x;
  }

  /**
   * Get height of the array of vectors, defined on the y axis.
   *
   * @param   vecs   array of vectors
   * @return         height
   */
  public float getHeight(PVector[] vecs) {
    PVector[] bnds = this.getBounds(vecs);
    return bnds[1].y - bnds[0].y;
  }

  /**
   * Mirror (reflect) an array of vectors by x, or y, or x/y.
   * Returns a new array.
   *
   * Works around the origin.
   * To mirror a point cloud around its local center,
   * first center, then mirror:
   *
   *   VecArrayTool vat = new VecArrayTool();
   *   PVector[] mirrored = vat.mirror(vat.center(vecs), true, false).
   *
   * To preserve the offset of the resulting cloud, save the
   * center and translate back:
   *
   *   VecArrayTool vat = new VecArrayTool();
   *   PVector ctr = vat.getCenter(vecs);
   *   PVector[] mirrored = vat.mirror(vat.center(vecs), true, false).
   *   mirrored = vat.translate(ctr);
   *
   * 
   * @param   vecs   array of vectors
   * @param   x      mirror across x axis? (horizontal mirror)
   * @param   y      mirror across y axis? (vertical mirror)
   * @return  a new array of points in the form {@code PVector[]}
   */
  public PVector[] mirror(PVector[] vecs, boolean x, boolean y) {
    PVector results[] = new PVector[vecs.length];
    for (int i=0; i<vecs.length; i++) {
      float vx = vecs[i].x;
      float vy = vecs[i].y;
      results[i] = new PVector(x?-vx:vx, y?-vy:vy);
    }
    return results;
  }

  //PVector[] rotate(PVector[] vecs) {
  //}

  /**
   * @param   vecs  a PVector array of points
   */
  public void shuffle(PVector[] vecs) {
    Collections.shuffle(Arrays.asList(vecs));
  }

  /**
   * Sort a point array by a comparison method.
   * Modifies in-place.
   *
   * The method may be specified as a mode string or passed in
   * as a comparator object.
   *
   * Modes include:
   *
   *   "x" : sort by x, then y
   *   "y" : sort by y, then x
   *   "h" : sort by heading
   *   "m" : sort by magnitude
   *
   * Calling with an object may also use built-in modes, e.g.:
   *
   *   VecArrayTool.sort(vecs, VecArrayTool.VEC_CMP_MAG);
   *
   * Heading and magnitude are calculated from the origin.
   * Some applications may wish to center the point cloud first
   * before sorting.
   *
   * @param   vecs   array of vectors
   * @param   mode   sorting mode ("x" / "y" / "h" / "m")
   */
  public void sort(PVector[] vecs, String mode) {
    if (mode.equals("x")) {
      this.sort(vecs, VEC_CMP_X);
    } else if (mode.equals("y")) {
      this.sort(vecs, VEC_CMP_Y);
    } else if (mode.equals("h")) {
      this.sort(vecs, VEC_CMP_HEAD);
    } else if (mode.equals("m")) {
      this.sort(vecs, VEC_CMP_MAG);
    } else {
      // leave unsorted
    }
  }
  /**
   * @param   vecs   array of vectors
   * @param   cmp    a {@code Comparator<PVector>}
   */
  public void sort(PVector[] vecs, Comparator<PVector> cmp) {
    Arrays.sort(vecs, cmp);
  }

  /**
   * Return an ArrayList of vectors.
   * 
   * @param   vecs   array of vectors
   * @return  new points in an {@code ArrayList<PVector>}
   */
  public ArrayList<PVector> toArrayList(PVector[] vecs) {
    return new ArrayList<PVector>(Arrays.asList(vecs));
  }

  /**
   * Translate all points in array by an offset.
   * Offset may be defined x, y or as a PVector (x,y).
   * Returns a new array.
   *
   * @param   vecs   array of vectors
   * @param   x      x offset to translate
   * @param   y      y offset to translate
   * @return         new array of vectors
   */
  public PVector[] translate(PVector[] vecs, float x, float y) {
    return this.translate(vecs, new PVector(x, y));
  }
  /**
   * @param   vecs    array of vectors
   * @param   xyoff   PVector x,y offset to translate
   * @return          new array of vectors
   */
  public PVector[] translate(PVector[] vecs, PVector xyoff) {
    PVector[] results = new PVector[vecs.length];
    for (int i=0; i<vecs.length; i++) {
      results[i] = PVector.add(vecs[i], xyoff);
    }
    return results;
  }
}