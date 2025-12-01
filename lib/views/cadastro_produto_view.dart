import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/produto.dart';
import '../controllers/produto_controller.dart';
import 'login_view.dart';

class CadastroProdutoView extends StatefulWidget {
  final Usuario usuario;

  const CadastroProdutoView({super.key, required this.usuario});

  @override
  State<CadastroProdutoView> createState() => _CadastroProdutoViewState();
}

class _CadastroProdutoViewState extends State<CadastroProdutoView> {
  final ProdutoController _produtoController = ProdutoController();
  List<Produto> _produtos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    setState(() => _isLoading = true);
    try {
      final produtos = await _produtoController.listarProdutos();
      setState(() => _produtos = produtos);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar produtos: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
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

    if (confirmacao == true) {
      try {
        await _produtoController.removerProduto(produto.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto removido com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          _carregarProdutos();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao remover produto: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _mostrarDialogProduto({Produto? produto}) {
    final isEdicao = produto != null;
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
      builder: (context) => AlertDialog(
        title: Text(isEdicao ? 'Editar Produto' : 'Novo Produto'),
        content: SingleChildScrollView(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  if (isEdicao) {
                    await _produtoController.atualizarProduto(
                      id: produto.id!,
                      nome: nomeController.text,
                      descricao: descricaoController.text,
                      preco: double.parse(precoController.text),
                      quantidadeEstoque: int.parse(estoqueController.text),
                    );
                  } else {
                    await _produtoController.cadastrarProduto(
                      nome: nomeController.text,
                      descricao: descricaoController.text,
                      preco: double.parse(precoController.text),
                      quantidadeEstoque: int.parse(estoqueController.text),
                    );
                  }
                  
                  if (mounted) {
                    Navigator.pop(context);
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
                    _carregarProdutos();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro: ${e.toString().replaceAll('Exception: ', '')}'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
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
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.admin_panel_settings),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.usuario.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'Administrador',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _produtos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum produto cadastrado',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _carregarProdutos,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _produtos.length,
                          itemBuilder: (context, index) {
                            final produto = _produtos[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Icon(
                                    Icons.shopping_bag,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                title: Text(
                                  produto.nome,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(produto.descricao),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_produtoController.formatarPreco(produto.preco)} • Estoque: ${produto.quantidadeEstoque}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _editarProduto(produto),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _removerProduto(produto),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarProduto,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Produto'),
      ),
    );
  }
}