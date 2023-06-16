import 'package:flutter/material.dart';
import 'package:ttt/const/const.dart';
import 'package:ttt/services/avatar.dart';

class AvatarPage extends StatelessWidget {
  final List<Avatar> avatars;
  final Avatar selectedAvatar;
  final Function(Avatar) onSelectAvatar;

  const AvatarPage({
    Key? key,
    required this.avatars,
    required this.selectedAvatar,
    required this.onSelectAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Avatar> otherAvatars =
        avatars.where((avatar) => avatar != selectedAvatar).toList();

    return Scaffold(
      backgroundColor: const Color(0xffFEB85A),
      appBar: AppBar(
        title: const Text('Choose Avatar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 70,
                  backgroundImage:
                      NetworkImage('${Constants.url}${selectedAvatar.image}'),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Choose Your Avatar',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 50,
                  mainAxisSpacing: 20,
                  children: List.generate(otherAvatars.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        onSelectAvatar(otherAvatars[index]);
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 70,
                          backgroundImage: NetworkImage(
                              '${Constants.url}${otherAvatars[index].image}'),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
