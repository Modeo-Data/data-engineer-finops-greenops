# Guide des requêtes SQL pour FinOps dans Snowflake

### Ce guide propose une collection de requêtes SQL conçues pour optimiser la gestion financière des ressources cloud dans Snowflake.

- automatic_clustering_cost_history_per_day_per_objet :

Cette requête aide à identifier la consommation de crédits par optimisation de recherche dans Snowflake, par table sur les 30 derniers jours. Elle permet de repérer facilement les anomalies ou une consommation élevée, essentiel pour optimiser les coûts et les performances.
 
- automatic_clustering_history_and_average_over_several_days :

Cette requête montre les crédits quotidiens moyens consommés par Snowpipe, groupés par semaine, au cours de l’année dernière. Elle aide à identifier les anomalies dans les moyennes quotidiennes sur l’année, ce qui vous permet d’analyser les changements inattendus dans la consommation.

- consumption_of_credits_by_partner_tools

Cette requête identifie les outils/solutions partenaires de Snowflake (par exemple BI, ETL, etc.) qui consomment le plus de crédits. Cela peut aider à identifier les solutions partenaires qui consomment plus de crédits que prévu.

- credit_consumption_by_warehouse_over_a_given_period.sql

Cette requête permet d’identifier les entrepôts qui consomment plus de crédits que les autres et les entrepôts spécifiques qui consomment plus de crédits que prévu.

- optimize_ressource_utilization.sql

Cette requête permet aux utilisateurs d’identifier les opportunités pour réduire le temps d'exécution et le volume de données traitées, menant à une optimisation des requêtes et à une réduction significative des coûts.

- query_acceleration_service_cost_per_warehouse.sql

Cette requête renvoie le nombre total de crédits utilisés par chaque entrepôt de votre compte pour Query Acceleration Service, depuis le début du mois. Cela permet de surveiller  l'utilisation des ressources et de gérer les coûts associés de manière plus proactive.

- set_up_cost_effective_data_pipelines.sql

Cette requête fournit une vue précise de l'activité de chargement, essentielle pour optimiser l'intégration des données et la gestion des erreurs. Les résultats facilitent l'identification rapide des chargements les plus importants.

- total_cost_of_the_task.sql

Cette requête répertorie l’utilisation actuelle des crédits pour toutes les tâches sans serveur.

- total_usage_costs.sql

Cette requête affiche le coût d'utilisation par compte sur les derniers 30 jours, totalisé et présenté en monnaie locale. Les résultats offrent une vision claire des dépenses, facilitant la surveillance et l'optimisation budgétaire.

- use_storage_wisely.sql

Cette requête fournit une vue d'ensemble de l'utilisation du stockage par table. L'objectif est d'aider les utilisateurs à identifier où le stockage est le plus utilisé et à optimiser la gestion de l'espace pour réduire les coûts associés. 

- warehouse_daily_compute_spend.sql

Cette requête SQL permet une analyse détaillée des coûts liés à l'utilisation des entrepôts, permettant une gestion optimisée des dépenses. 