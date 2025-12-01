import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/produto.dart';
import '../controllers/produto_controller.dart';
import '../controllers/carrinho_controller.dart';
import 'login_view.dart';

class CompraView extends StatefulWidget {
  final Usuario usuario;

  const CompraView({super.key, required this.usuario});

  @override
  State<CompraView> createState() => _CompraViewState();
}

class _CompraViewState extends State<CompraView> {
  final ProdutoController _produtoController = ProdutoController();
  final CarrinhoController _carrinhoController = CarrinhoController();
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

  void _mostrarDetalhesProduto(Produto produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(produto.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(produto.descricao),
            const SizedBox(height: 12),
            Text(
              'Preço: ${_produtoController.formatarPreco(produto.preco)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text('Estoque disponível: ${produto.quantidadeEstoque} unidades'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FECHAR'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _adicionarAoCarrinho(produto);
            },
            child: const Text('ADICIONAR AO CARRINHO'),
          ),
        ],
      ),
    );
  }

  void _adicionarAoCarrinho(Produto produto) {
    if (produto.quantidadeEstoque <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto sem estoque!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final quantidadeController = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar ${produto.nome}'),
        content: TextField(
          controller: quantidadeController,
          decoration: InputDecoration(
            labelText: 'Quantidade',
            border: const OutlineInputBorder(),
            hintText: 'Máx: ${produto.quantidadeEstoque}',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantidade = int.tryParse(quantidadeController.text);
              if (quantidade == null || quantidade <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quantidade inválida!'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                _carrinhoController.adicionarAoCarrinho(produto, quantidade);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produto adicionado ao carrinho!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString().replaceAll('Exception: ', '')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('ADICIONAR'),
          ),
        ],
      ),
    );
  }

  void _visualizarCarrinho() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Carrinho de Compras',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: _carrinhoController.carrinhoVazio
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Carrinho vazio',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _carrinhoController.itens.length,
                        itemBuilder: (context, index) {
                          final item = _carrinhoController.itens[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${item.quantidade}x'),
                              ),
                              title: Text(item.produto.nome),
                              subtitle: Text(
                                '${_produtoController.formatarPreco(item.produto.preco)} x ${item.quantidade} = ${_produtoController.formatarPreco(item.subtotal)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      try {
                                        _carrinhoController.atualizarQuantidade(
                                          item.produto.id!,
                                          item.quantidade - 1,
                                        );
                                        setModalState(() {});
                                        setState(() {});
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('$e')),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      try {
                                        _carrinhoController.atualizarQuantidade(
                                          item.produto.id!,
                                          item.quantidade + 1,
                                        );
                                        setModalState(() {});
                                        setState(() {});
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              e.toString().replaceAll('Exception: ', ''),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _carrinhoController.removerDoCarrinho(
                                        item.produto.id!,
                                      );
                                      setModalState(() {});
                                      setState(() {});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Item removido do carrinho'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (!_carrinhoController.carrinhoVazio) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _produtoController.formatarPreco(
                          _carrinhoController.totalGeral,
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _finalizarCompra(context),
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('EMITIR NOTA FISCAL'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  Future<void> _finalizarCompra(BuildContext modalContext) async {
    try {
      final sucesso = await _carrinhoController.finalizarCompra();
      
      if (sucesso && mounted) {
        final notaFiscal = _carrinhoController.gerarNotaFiscal(widget.usuario);
        
        Navigator.pop(modalContext);
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nota Fiscal'),
            content: SingleChildScrollView(
              child: Text(
                notaFiscal,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _carrinhoController.limparCarrinho();
                  setState(() {});
                  _carregarProdutos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Compra finalizada com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('FECHAR'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao finalizar compra: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _deslogar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair? O carrinho será perdido.'),
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
        title: const Text('Loja'),
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _visualizarCarrinho,
              ),
              if (!_carrinhoController.carrinhoVazio)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_carrinhoController.totalItens}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
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
            color: Colors.green.shade50,
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
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
                      'Cliente',
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
                              'Nenhum produto disponível',
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
                        child: GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _produtos.length,
                          itemBuilder: (context, index) {
                            final produto = _produtos[index];
                            return Card(
                              elevation: 3,
                              child: InkWell(
                                onTap: () => _mostrarDetalhesProduto(produto),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Icon(
                                            Icons.shopping_bag,
                                            size: 60,
                                            color: Colors.blue.shade300,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        produto.nome,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _produtoController.formatarPreco(produto.preco),
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Estoque: ${produto.quantidadeEstoque}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: produto.quantidadeEstoque > 0
                                              ? Colors.grey.shade600
                                              : Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: produto.quantidadeEstoque > 0
                                              ? () => _adicionarAoCarrinho(produto)
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                          ),
                                          child: const Text(
                                            'Adicionar',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}