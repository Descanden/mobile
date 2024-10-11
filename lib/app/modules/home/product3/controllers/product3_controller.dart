import 'package:get/get.dart';

class Product3Controller extends GetxController {

  final productList = [
    Product(
      image: 'lib/assets/coat1.avif',
      title: 'Checked Coatt',
      price: 145000,
      description: 'Premium Fabric:The light bomber jacket for men with the premium linen fabric for providing you the best feeling and comfort.Made in a beautiful checked fabric, this soft-tailored fully lined coat is a double breasted style with a revers collar and patch pockets.',
    ),
    Product(
      image: 'lib/assets/coat2.webp',
      title: 'Check Oversized Coat',
      price: 150000,
      description: 'Wrap up in the latest coats and jackets and get out-there with your outerwear. Breathe life into your new season layering with the latest coats and jackets from boohoo. Supersize your silhouette in a padded jacket, stick to sporty styling with a bomber, or protect yourself from the elements in a plastic raincoat. For a more luxe layering piece, faux fur coats come in fondant shades and longline duster coats give your look an androgynous edge.',
    ),
    Product(
      image: 'lib/assets/coat3.webp',
      title: 'Relaxed-Fit Wool Checked Coat',
      price: 102000,
      description: 'Invitingly soft and in a mood-boosting checked print, this coat is the ideal addition to the British winter. It’s cut to a relaxed fit with dropped shoulders and topped with a classic revere collar. Staying warm never looked so good.',
    ),
    Product(
      image: 'llib/assets/coat4.webp',
      title: 'Plus Wool Look Check Raglan Overcoat',
      price: 102000,
      description: 'Rev up your outerwear inventory with our unrivalled collection of coats and jackets for men. Whether you are looking for a heavy coat to combat the low temperatures or a lightweight jacket to stand out at your favourite festival. We have got the trendiest designs to finish off your outfit. Puffers parkas and borg jackets are the perfect choices if you want to bundle up without sacrificing on style, and they look great when teamed up with knitwear and denim.',
    ),
  ].obs;

  var isLoading = false.obs;
}

class Product {
  final String image;
  final String title;
  final int price;
  final String description;

  var id;

  Product({
    required this.image,
    required this.title,
    required this.price,
    required this.description,
  });
}

