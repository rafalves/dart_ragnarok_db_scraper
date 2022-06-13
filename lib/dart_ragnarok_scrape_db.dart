import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

void main() async {
  Future ragScrape() async {
    var client = Client();
    Response response = await client.get(
      Uri.parse(
          'https://db.irowiki.org/db/card-search/?search&type=0&sort=1,1'),
    );

    var document = parse(response.body);
    List<dynamic> links = document.querySelectorAll(
        'html > body > div.pageBody > table.bgLtTable > tbody > tr');
    print(links.length);
    List<Element> listWithoutHeaders = [];
    for (var i = 0; i < links.length; i++) {
      if (i == 0 || i % 21 == 0) i++;
      listWithoutHeaders.add(links[i]);
    }
    List<Map<String, String?>> listOfCards = [];
    for (var i = 0; i < listWithoutHeaders.length; i++) {
      var elementFormated = {};
      if (i % 2 == 0) {
        elementFormated = {
          'cardIcon': listWithoutHeaders[i]
              .querySelector('td.bgLtRow3 > img')
              ?.attributes['src'],
          'cardName':
              listWithoutHeaders[i].querySelector('td.bgLtRow1 > a')?.innerHtml,
          'cardImage': listWithoutHeaders[i]
              .querySelector('td.bgLtRow1 > a')
              ?.attributes['href'],
          'cardGear':
              listWithoutHeaders[i].querySelector('td.bgLtRow2')?.innerHtml,
          'cardDescription': listWithoutHeaders[i]
              .getElementsByClassName('bgLtRow1.padded')[1]
              .innerHtml,
        };
      } else {
        elementFormated = {
          'cardIcon': listWithoutHeaders[i]
              .querySelector('td.bgLtRow4 > img')
              ?.attributes['src'],
          'cardName':
              listWithoutHeaders[i].querySelector('td.bgLtRow2 > a')?.innerHtml,
          'cardImage': listWithoutHeaders[i]
              .querySelector('td.bgLtRow2  > a')
              ?.attributes['href'],
          'cardGear':
              listWithoutHeaders[i].querySelector('td.bgLtRow3')?.innerHtml,
          'cardDescription': listWithoutHeaders[i]
              .getElementsByClassName('bgLtRow2.padded')[1]
              .innerHtml,
        };
      }

      print('----');
      print('card icon: ${elementFormated['cardIcon']}');
      print('card name: ${elementFormated['cardName']}');
      print('card image: ${elementFormated['cardImage']}');
      print('card gear: ${elementFormated['cardGear']}');
      print('card description: ${elementFormated['cardDescription']}');
      print('----');
    }
    //print('List of Cards lenght: ${listOfCards.length}');
  }

  await ragScrape();
}


//  var elementFormated = {
//         'cardIcon': listWithoutHeaders[i]
//             .querySelector('td.bgLtRow4.papped.centered > img')
//             ?.attributes['src'],
//         'cardName': listWithoutHeaders[i]
//             .querySelector('td.bgLtRow2.papped > a')
//             ?.innerHtml,
//         'cardImge': listWithoutHeaders[i]
//             .querySelector('td.bgLtRow2.papped > a')
//             ?.attributes['href'],
//         'cardGear': listWithoutHeaders[i]
//             .querySelector('td.bgLtRow3.papped')
//             ?.innerHtml,
//         'cardDescription': listWithoutHeaders[i]
//             .querySelector('td.bgLtRow2.papped')
//             ?.innerHtml,
//       };