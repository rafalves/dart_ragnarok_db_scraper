import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:path/path.dart' as p;

void main() async {
  await cardsFullDescription();
}

Future cardsFullDescription() async {
  List<dynamic>? filterCardDescription(Element td) {
    Element? ul = td.querySelector('ul');
    List<Element>? listLi = ul?.children;
    var formatedDescriptionList = [];

    listLi?.forEach((Element liElement) {
      List<Element>? hasChildren = liElement.children;

      if (hasChildren.isNotEmpty) {
        List<String> text = [];

        for (var liInsideLi in hasChildren) {
          List<Element>? hasChildrenLi = liInsideLi.children;

          for (var li in hasChildrenLi) {
            text.add(li.text.toString());
          }
        }

        formatedDescriptionList.add(
          {
            'conditionalDescription': liElement.firstChild.toString(),
            'description': text.toString(),
          },
        );
      } else {
        formatedDescriptionList.add(
          {'description': liElement.text.toString()},
        );
      }
    });

    return formatedDescriptionList;
  }

  String? isThisACard(String? name) {
    if (name != null && (name.contains('card') || name.contains('Card'))) {
      return name;
    } else {
      return null;
    }
  }

  var client = Client();
  Response response = await client.get(
    Uri.parse(
        'https://db.irowiki.org/db/card-search/?search&full&type=0&sort=1,1'),
  );

  var document = parse(response.body);

  List<dynamic> links = document.querySelectorAll(
      'html > body > div.pageBody > table.bgLtTable > tbody > tr');

  List<Element> listWithoutHeaders = [];
  for (var i = 0; i < links.length; i++) {
    if (i == 0 || i % 21 == 0) i++;
    listWithoutHeaders.add(links[i]);
  }
  List<Map<String, dynamic>> listOfCards = [];
  for (var i = 0; i < listWithoutHeaders.length; i++) {
    Map<String, dynamic> elementFormated = {};
    if (i % 2 == 0) {
      elementFormated = {
        'cardIcon': listWithoutHeaders[i]
            .querySelector('td.bgLtRow3 > img')
            ?.attributes['src'],
        'cardName': isThisACard(
            listWithoutHeaders[i].querySelector('td.bgLtRow1 > a')?.innerHtml),
        'cardImage': listWithoutHeaders[i]
            .querySelector('td.bgLtRow1 > a')
            ?.attributes['href'],
        'cardGear':
            listWithoutHeaders[i].querySelector('td.bgLtRow2')?.innerHtml,
        'cardDescription': filterCardDescription(
            listWithoutHeaders[i].getElementsByClassName('bgLtRow1.padded')[1])
      };
      if (elementFormated['cardName'] != null) {
        listOfCards.add(elementFormated);
      }
    } else {
      elementFormated = {
        'cardIcon': listWithoutHeaders[i]
            .querySelector('td.bgLtRow4 > img')
            ?.attributes['src'],
        'cardName': isThisACard(
            listWithoutHeaders[i].querySelector('td.bgLtRow2 > a')?.innerHtml),
        'cardImage': listWithoutHeaders[i]
            .querySelector('td.bgLtRow2  > a')
            ?.attributes['href'],
        'cardGear':
            listWithoutHeaders[i].querySelector('td.bgLtRow3')?.innerHtml,
        'cardDescription': filterCardDescription(
            listWithoutHeaders[i].getElementsByClassName('bgLtRow2.padded')[1]),
      };
      if (elementFormated['cardName'] != null) {
        listOfCards.add(elementFormated);
      }
    }
  }
  var convertedFileResult = File('${p.current}/text_filtered.json');
  convertedFileResult.writeAsString(json.encode(listOfCards));
  var rawFileResult = File('${p.current}/text_response.txt');
  rawFileResult.writeAsString(response.body);
}

Future cardsSimpleDescription() async {
  var client = Client();
  Response response = await client.get(
    Uri.parse('https://db.irowiki.org/db/card-search/?search&type=0&sort=1,1'),
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
  List<Map<String, dynamic>> listOfCards = [];
  for (var i = 0; i < listWithoutHeaders.length; i++) {
    Map<String, dynamic> elementFormated = {};
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
      listOfCards.add(elementFormated);
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
      listOfCards.add(elementFormated);
    }

    // print('----');
    // print('card icon: ${elementFormated['cardIcon']}');
    // print('card name: ${elementFormated['cardName']}');
    // print('card image: ${elementFormated['cardImage']}');
    // print('card gear: ${elementFormated['cardGear']}');
    // print('card description: ${elementFormated['cardDescription']}');
    // print('----');
  }
  print('List of Cards lenght: ${listOfCards.length}');
}
