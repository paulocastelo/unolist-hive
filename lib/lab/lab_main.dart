import 'crud_tests/category_crud_test.dart';
import 'crud_tests/task_crud_test.dart';
import 'backup_tests/backup_test.dart';
import 'query_tests/task_query_test.dart';

void main() async {
  print('🧪 Bem-vindo ao UnoList Lab!');

  await categoryCrudTest();
  await taskCrudTest();
  await taskQueryTest();
  await backupTest();

  print('✅ Todos os testes concluídos.');
}
