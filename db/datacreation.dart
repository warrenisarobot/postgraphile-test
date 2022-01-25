import 'dart:io';
import 'dart:math';

class NameGenerator {
  List<String> firstnames = [];
  List<String> lastnames = [];
  Random randGenerator;

  NameGenerator(String firstNameFile, String lastNameFile)
      : randGenerator = Random() {
    var fnF = File(firstNameFile);
    this.firstnames = fnF.readAsLinesSync();
    var lnF = File(lastNameFile);
    this.lastnames = lnF.readAsLinesSync();
  }

  String RandomUsername() {
    var randFirstname =
        firstnames[this.randGenerator.nextInt(firstnames.length)];
    var randLastname = lastnames[this.randGenerator.nextInt(lastnames.length)];
    return "'" + randFirstname + "." + randLastname + "'";
  }

  String RandomName() {
    if (randGenerator.nextInt(2) == 0) {
      return firstnames[this.randGenerator.nextInt(firstnames.length)];
    } else {
      return lastnames[this.randGenerator.nextInt(lastnames.length)];
    }
  }

  String RandomWords() {
    var words = <String>[];
    var size = randGenerator.nextInt(40);
    for (var i = 0; i < size; i++) {
      words.add(RandomName());
    }
    return words.join(" ");
  }
}

void main() {
  var ng = new NameGenerator("./data/firstnames.txt", "./data/lastnames.txt");
  var usernames = <String>[];

  for (var i = 0; i <= 500000; i++) {
    var username = ng.RandomUsername();
    usernames.add("($username)");
  }

  var valueList = usernames.join(",\n\t");
  var usernamesInsert =
      "\\connect forum_example;\n\nINSERT INTO public.user (username) VALUES\n$valueList;";
  var userValues = File("./init/01-data-user.sql");
  userValues.writeAsStringSync(usernamesInsert);

  var postInsert =
      "\\connect forum_example;\n\nINSERT INTO public.post (title, body, author_id) VALUES\n";
  var postValues = File("./init/02-data-post.sql");
  postValues.writeAsStringSync(postInsert);

  for (var i = 0; i < 10000; i++) {
    var words = ng.RandomWords();
    postValues.writeAsStringSync(
        "('Post number $i', '$words', (SELECT id from \"user\" LIMIT 1 OFFSET $i))",
        mode: FileMode.append);
    if (i < 10000 - 1) {
      postValues.writeAsStringSync(",\n", mode: FileMode.append);
    }
  }
  postValues.writeAsStringSync(";", mode: FileMode.append);
}
