class Score {
  final String SCRIPT = "http://grunskis.com/tetris/topscore.php";
  final String SECRET_KEY = "SECRET"; // CHANGE THIS TO SOMETHING SECRET!
  
  String name;
  int score, level;
  int duration; // in seconds
  
  String secret;
  
  Score() {
  }
  
  Score(String name, int score, int level, int duration) {
    this.name = name;
    this.score = score;
    this.level = level;
    this.duration = duration;
    
    this.secret = createSecretKey();
  }
  
  String createSecretKey() {
    // HERE HERE! YOU NEED TO CHANGE THE NEXT LINE
    return SECRET_KEY;
  }
  
  int get() {
    try {
      URL url = new URL(SCRIPT);
      URLConnection conn = url.openConnection();
  
      BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
      String line;
      while ((line = rd.readLine()) != null) {
        this.score = int(line);
      }
      rd.close();
    }
    catch (Exception e) {
      println(e.getMessage());
    }
    
    return this.score;
  }

  boolean post() {
    String result = "ERROR";
    MD5 md5 = new MD5(secret.getBytes());
    
    String params = "name=" + URLEncoder.encode(name) + "&" + 
                    "score=" + score + "&" +
                    "level=" + level + "&" +
                    "duration=" + duration + "&" +
                    "secret=" + md5.toHex(md5.doFinal());

    try {
      URL url = new URL(SCRIPT);
      URLConnection conn = url.openConnection();
      conn.setDoOutput(true);

      OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
      wr.write(params);
      wr.flush();
      
      BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
      while ((result = rd.readLine()) != null) {
      }
      wr.close();
      rd.close();
    } catch (Exception e) {
      println(e.getMessage());
    }
    
    return result == "OK";
  }
} 

