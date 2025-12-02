import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/usuario_controller.dart';
import '../controllers/produto_controller.dart';
import '../models/produto.dart';
import '../utils/responsive_helper.dart';
import 'login_view.dart';

class CadastroProdutoView extends StatefulWidget {
  const CadastroProdutoView({super.key});

  @override
  State<CadastroProdutoView> createState() => _CadastroProdutoViewState();
}

class _CadastroProdutoViewState extends State<CadastroProdutoView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProdutoController>(context, listen: false).carregarProdutos();
    });
  }

  void _adicionarProduto() {
    _mostrarDialogProduto();
  }

  void _editarProduto(Produto produto) {
    _mostrarDialogProduto(produto: produto);
  }

  Future<void> _removerProduto(Produto produto) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o produto "${produto.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );

    if (confirmacao == true && mounted) {
      final controller = Provider.of<ProdutoController>(context, listen: false);
      final sucesso = await controller.removerProduto(produto.id!);
      
      if (sucesso && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto removido com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted && controller.mensagemErro != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.mensagemErro!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _mostrarDialogProduto({Produto? produto}) {
    final isEdicao = produto != null;
    final isTablet = ResponsiveHelper.isTablet(context);
    
    final nomeController = TextEditingController(text: produto?.nome ?? '');
    final descricaoController = TextEditingController(text: produto?.descricao ?? '');
    final precoController = TextEditingController(
      text: produto?.preco.toStringAsFixed(2) ?? '',
    );
    final estoqueController = TextEditingController(
      text: produto?.quantidadeEstoque.toString() ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          isEdicao ? 'Editar Produto' : 'Novo Produto',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
          ),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: isTablet ? 500 : MediaQuery.of(context).size.width * 0.8,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.trim().isEmpty ?? true ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) =>
                        value?.trim().isEmpty ?? true ? 'Informe a descrição' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: precoController,
                    decoration: const InputDecoration(
                      labelText: 'Preço',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) return 'Informe o preço';
                      if (double.tryParse(value!) == null) return 'Preço inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: estoqueController,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade em Estoque',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) return 'Informe o estoque';
                      if (int.tryParse(value!) == null) return 'Quantidade inválida';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final controller = Provider.of<ProdutoController>(context, listen: false);
                bool sucesso;

                if (isEdicao) {
                  sucesso = await controller.atualizarProduto(
                    id: produto.id!,
                    nome: nomeController.text,
                    descricao: descricaoController.text,
                    preco: double.parse(precoController.text),
                    quantidadeEstoque: int.parse(estoqueController.text),
                  );
                } else {
                  sucesso = await controller.cadastrarProduto(
                    nome: nomeController.text,
                    descricao: descricaoController.text,
                    preco: double.parse(precoController.text),
                    quantidadeEstoque: int.parse(estoqueController.text),
                  );
                }

                if (mounted) {
                  Navigator.pop(dialogContext);
                  
                  if (sucesso) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEdicao
                              ? 'Produto atualizado com sucesso!'
                              : 'Produto cadastrado com sucesso!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (controller.mensagemErro != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(controller.mensagemErro!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(isEdicao ? 'SALVAR' : 'CADASTRAR'),
          ),
        ],
      ),
    );
  }

  void _deslogar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<UsuarioController>(context, listen: false).fazerLogout();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
            child: const Text('SAIR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final usuario = Provider.of<UsuarioController>(context).usuarioLogado;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gerenciar Produtos',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _deslogar,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: ResponsiveHelper.getPadding(context),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                CircleAvatar(
                  radius: isTablet ? 28 : 24,
                  child: const Icon(Icons.admin_panel_settings),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario?.nome ?? 'Administrador',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                      ),
                    ),
                    Text(
                      'Administrador',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ResponsiveHelper.getFontSize(context, 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ProdutoController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.produtos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: isTablet ? 100 : 80,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                        Text(
                          'Nenhum produto cadastrado',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 18),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.carregarProdutos,
                  child: ListView.builder(
                    padding: ResponsiveHelper.getPadding(context),
                    itemCount: controller.produtos.length,
                    itemBuilder: (context, index) {
                      final produto = controller.produtos[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: isTablet ? 12 : 8,
                          vertical: isTablet ? 6 : 4,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(isTablet ? 16 : 12),
                          leading: CircleAvatar(
                            radius: isTablet ? 28 : 24,
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              Icons.shopping_bag,
                              color: Colors.blue.shade700,
                              size: isTablet ? 28 : 24,
                            ),
                          ),
                          title: Text(
                            produto.nome,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.getFontSize(context, 16),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: isTablet ? 6 : 4),
                              Text(
                                produto.descricao,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(context, 14),
                                ),
                              ),
                              SizedBox(height: isTablet ? 6 : 4),
                              Text(
                                '${controller.formatarPreco(produto.preco)} • Estoque: ${produto.quantidadeEstoque}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: ResponsiveHelper.getFontSize(context, 14),
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: isTablet ? 26 : 24,
                                ),
                                onPressed: () => _editarProduto(produto),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: isTablet ? 26 : 24,
                                ),
                                onPressed: () => _removerProduto(produto),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarProduto,
        icon: const Icon(Icons.add),
        label: Text(
          'Adicionar Produto',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 14),
          ),
        ),
      ),
    );
  }
}