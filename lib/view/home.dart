import 'package:flutter/material.dart';
import 'package:oferty_pracy/view/widgets/cupertino_blur.dart';
import 'package:oferty_pracy/view/widgets/mesh_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        const MeshBackground(),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [TopBar(), MainPage(height: height, width: width)],
          ),
        )
      ],
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isLessThan550 = height < 550;

    return Column(
      children: [
        MainHeader(isLessThan550: isLessThan550),
        const SizedBox(
          height: 200,
        ),
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          width: width * 0.8,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const NewOffersLabel(),
              FilterBar(),
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => WorkOfferCard(),
                  itemCount: 10,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MainHeader extends StatelessWidget {
  const MainHeader({
    super.key,
    required this.isLessThan550,
  });

  final bool isLessThan550;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      alignment: Alignment.centerLeft,
      child: Text(
        'Znajdź idealną ofertę pracy\nDla siebie!',
        style: TextStyle(
            color: Colors.white,
            fontSize: isLessThan550 ? 20 : 45,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NewOffersLabel extends StatelessWidget {
  const NewOffersLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(
        'Najnowsze oferty',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Filtruj',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterButton(
                isClicked: false,
                onPressed: () {},
                text: 'One',
              ),
              FilterButton(
                isClicked: false,
                onPressed: () {},
                text: 'Two',
              ),
              FilterButton(
                isClicked: true,
                onPressed: () {},
                text: 'Three',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkOfferCard extends StatelessWidget {
  const WorkOfferCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 3)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stanowisko',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Software Developer',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Firma',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Nokia',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Opis',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Bardzo rozwoje stanowisko...fsdfsd ...f sdjfhksjdhf psdofkpsodjfpojds jlskdfjlskdjflj sdslfjksld \n jsldkfjlsdjflksd',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ));
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: CupertinoBlur(
        opacity: 0.3,
        radius: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              child: const Row(
                children: [
                  Icon(
                    Icons.work,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Strona główna',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
            TopBarButton(
              text: 'Nowa oferta pracy',
              onPressed: () {},
            ),
            TopBarButton(
              text: 'O nas',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.text,
    required this.isClicked,
    required this.onPressed,
  });

  final Function() onPressed;
  final bool isClicked;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              backgroundColor:
                  isClicked ? Colors.blue.shade200 : Colors.grey.shade200),
          child: Text(
            text,
            style: TextStyle(
                color: isClicked ? Colors.blue : Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}

class TopBarButton extends StatelessWidget {
  const TopBarButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(backgroundColor: Colors.transparent),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
