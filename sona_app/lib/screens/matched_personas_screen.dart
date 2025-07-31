import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/persona/persona_service.dart';
import '../models/persona.dart';

class MatchedPersonasScreen extends StatelessWidget {
  const MatchedPersonasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          '매칭된 소나',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PersonaService>(
        builder: (context, personaService, child) {
          final matchedPersonas = personaService.matchedPersonas;
          
          if (matchedPersonas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '아직 매칭된 소나가 없어요',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '새로운 소나를 만나보세요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matchedPersonas.length,
            itemBuilder: (context, index) {
              final persona = matchedPersonas[index];
              return _PersonaCard(persona: persona);
            },
          );
        },
      ),
    );
  }
}

class _PersonaCard extends StatelessWidget {
  final Persona persona;
  
  const _PersonaCard({required this.persona});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/chat',
              arguments: persona,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 프로필 이미지
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: persona.photoUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: persona.photoUrls.first,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            persona.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getRelationshipColor(persona.currentRelationship).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              persona.currentRelationship.displayName,
                              style: TextStyle(
                                fontSize: 11,
                                color: _getRelationshipColor(persona.currentRelationship),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${persona.age}세 • ${persona.personality}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 14,
                            color: Colors.pink[300],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '친밀도 ${persona.relationshipScore}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 화살표
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getRelationshipColor(RelationshipType type) {
    switch (type) {
      case RelationshipType.friend:
        return Colors.blue;
      case RelationshipType.crush:
        return Colors.orange;
      case RelationshipType.dating:
        return Colors.pink;
      case RelationshipType.perfectLove:
        return Colors.red;
    }
  }
}