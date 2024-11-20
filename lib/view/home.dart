import 'package:flutter/material.dart';
import 'package:oferty_pracy/controller/home/controller.dart';
import 'package:oferty_pracy/model/offer.dart';
import 'package:oferty_pracy/view/widgets/async_widget.dart';
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
            children: [
              const TopBar(),
              MainPage(height: height, width: width),
              const AboutBottomBar()
            ],
          ),
        )
      ],
    );
  }
}

class AboutBottomBar extends StatelessWidget {
  const AboutBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Copyright 2024. All rights reserved',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(
            width: 50,
          ),
          Text(
            'Made with Flutter',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key, required this.height, required this.width});

  final double height;
  final double width;
  final HomeController controller = HomeController();

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
              SizedBox(
                  height: 50, child: CityFilterBar(controller: controller)),
              SizedBox(
                  height: 50, child: PositionFilterBar(controller: controller)),
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: AsyncWidget(
                  asyncAction: controller.fetchOffers(),
                  onWaiting: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, _) => WaitingOfferCard()),
                  onSuccess: (data) => ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        WorkOfferCard(offer: data[index]),
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                  ),
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

class CityFilterBar extends StatelessWidget {
  const CityFilterBar({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Filtruj po miastach',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            )),
        Expanded(
          child: AsyncWidget(
              asyncAction: controller.fetchCityFilters(),
              onWaiting: Container(),
              onSuccess: (data) => ListView.builder(
                    itemBuilder: (context, index) => FilterButton(
                      text: data[index],
                      onPressed: () {},
                      isClicked: controller.isCityFilterClikced(index),
                    ),
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                  )),
        )
      ],
    );
  }
}

class PositionFilterBar extends StatelessWidget {
  const PositionFilterBar({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Filtruj po pozycjach',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            )),
        Expanded(
          child: AsyncWidget(
              asyncAction: controller.fetchPositionFilters(),
              onWaiting: Container(),
              onSuccess: (data) => ListView.builder(
                    itemBuilder: (context, index) => FilterButton(
                      text: data[index],
                      onPressed: () {},
                      isClicked: controller.isPositionFilterClikced(index),
                    ),
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                  )),
        )
      ],
    );
  }
}

class WorkOfferCard extends StatelessWidget {
  const WorkOfferCard({super.key, required this.offer});

  final Offer offer;

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
              offer.position,
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
              offer.company,
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
              offer.description,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Telefon',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              offer.phoneNumber,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Email',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              offer.email,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Data wygaśniecia oferty pracy',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '${offer.endDate.day}/${offer.endDate.month}/${offer.endDate.year}',
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

class WaitingOfferCard extends StatefulWidget {
  const WaitingOfferCard({super.key});

  @override
  State<WaitingOfferCard> createState() => _WaitingOfferCardState();
}

class _WaitingOfferCardState extends State<WaitingOfferCard>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation colorTween;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    colorTween = ColorTween(begin: Colors.white, end: Colors.grey.shade200)
        .animate(animationController);
    animationController.repeat(min: 0, max: 1, reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorTween.value),
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(5.0),
            height: 80));
  }
}