import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/usuario_controller.dart';
import '../controllers/produto_controller.dart';
import '../controllers/carrinho_controller.dart';
import '../models/produto.dart';
import '../utils/responsive_helper.dart';
import 'login_view.dart';

class CompraView extends StatefulWidget {
  const CompraView({super.key});

  @override
  State<CompraView> createState() => _CompraViewState();
}

class _CompraViewState extends State<CompraView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProdutoController>(context, listen: false).carregarProdutos();
    });
  }

  void _mostrarDetalhesProduto(Produto produto) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final produtoController = Provider.of<ProdutoController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          produto.nome,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.getFontSize(context, 15),
              ),
            ),
            SizedBox(height: isTablet ? 6 : 4),
            Text(
              produto.descricao,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 14),
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'Preço: ${produtoController.formatarPreco(produto.preco)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.getFontSize(context, 18),
                color: Colors.green,
              ),
            ),
            SizedBox(height: isTablet ? 10 : 8),
            Text(
              'Estoque disponível: ${produto.quantidadeEstoque} unidades',
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 14),
              ),
            ),
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
      builder: (dialogContext) => AlertDialog(
        title: Text('Adicionar ${produto.nome}'),
        content: TextField(
          controller: quantidadeController,
          decoration: InputDecoration(
            labelText: 'Quantidade',
            border: const OutlineInputBorder(),
            hintText: 'Máx: ${produto.quantidadeEstoque}',
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
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

              final carrinhoController = Provider.of<CarrinhoController>(context, listen: false);
              final sucesso = carrinhoController.adicionarProduto(produto, quantidade);
              
              Navigator.pop(dialogContext);
              
              if (sucesso) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produto adicionado ao carrinho!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (carrinhoController.mensagemErro != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(carrinhoController.mensagemErro!),
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
    final isTablet = ResponsiveHelper.isTablet(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer2<CarrinhoController, ProdutoController>(
        builder: (context, carrinhoController, produtoController, child) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: ResponsiveHelper.getPadding(context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Carrinho de Compras',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(context, 20),
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
                  child: carrinhoController.carrinhoVazio
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: isTablet ? 100 : 80,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              Text(
                                'Carrinho vazio',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(context, 18),
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: carrinhoController.itens.length,
                          itemBuilder: (context, index) {
                            final item = carrinhoController.itens[index];
                            return Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.all(isTablet ? 16 : 12),
                                leading: CircleAvatar(
                                  radius: isTablet ? 28 : 24,
                                  child: Text(
                                    '${item.quantidade}x',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  item.produto.nome,
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getFontSize(context, 16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${produtoController.formatarPreco(item.produto.preco)} x ${item.quantidade} = ${produtoController.formatarPreco(item.subtotal)}',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getFontSize(context, 14),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        size: isTablet ? 26 : 24,
                                      ),
                                      onPressed: () {
                                        carrinhoController.atualizarQuantidade(
                                          item.produto.id!,
                                          item.quantidade - 1,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        size: isTablet ? 26 : 24,
                                      ),
                                      onPressed: () {
                                        final sucesso = carrinhoController.atualizarQuantidade(
                                          item.produto.id!,
                                          item.quantidade + 1,
                                        );
                                        if (!sucesso && carrinhoController.mensagemErro != null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(carrinhoController.mensagemErro!),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: isTablet ? 26 : 24,
                                      ),
                                      onPressed: () {
                                        //carrinhoController.removerDoCarrinho(item.produto.id!);
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
                if (!carrinhoController.carrinhoVazio) ...[
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          produtoController.formatarPreco(carrinhoController.totalGeral),
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 24),
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 56 : 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _finalizarCompra(context),
                      icon: const Icon(Icons.receipt_long),
                      label: Text(
                        'EMITIR NOTA FISCAL',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(context, 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _finalizarCompra(BuildContext modalContext) async {
    final carrinhoController = Provider.of<CarrinhoController>(context, listen: false);
    final produtoController = Provider.of<ProdutoController>(context, listen: false);
    final usuarioController = Provider.of<UsuarioController>(context, listen: false);

    try {
      // Atualizar estoque de cada produto
      for (var item in carrinhoController.itens) {
        await produtoController.atualizarEstoque(
          item.produto.id!,
          item.quantidade,
        );
      }

      final notaFiscal = carrinhoController.gerarNotaFiscal(usuarioController.usuarioLogado!);
      
      Navigator.pop(modalContext);
      
      if (mounted) {
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
                  carrinhoController.limparCarrinho();
                  produtoController.carregarProdutos();
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
            content: Text('Erro ao finalizar compra: $e'),
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
              Provider.of<UsuarioController>(context, listen: false).fazerLogout();
              Provider.of<CarrinhoController>(context, listen: false).limparCarrinho();
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
    final gridColumns = ResponsiveHelper.getGridColumns(context);
    final aspectRatio = ResponsiveHelper.getProductCardAspectRatio(context);
    final usuario = Provider.of<UsuarioController>(context).usuarioLogado;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loja',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<CarrinhoController>(
            builder: (context, controller, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: _visualizarCarrinho,
                  ),
                  if (!controller.carrinhoVazio)
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
                          '${controller.totalItens}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
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
            padding: ResponsiveHelper.getPadding(context),
            color: Colors.green.shade50,
            child: Row(
              children: [
                CircleAvatar(
                  radius: isTablet ? 28 : 24,
                  child: const Icon(Icons.person),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario?.nome ?? 'Cliente',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                      ),
                    ),
                    Text(
                      'Cliente',
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
                          'Nenhum produto disponível',
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
                  child: GridView.builder(
                    padding: ResponsiveHelper.getPadding(context),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      childAspectRatio: aspectRatio,
                      crossAxisSpacing: isTablet ? 12 : 8,
                      mainAxisSpacing: isTablet ? 12 : 8,
                    ),
                    itemCount: controller.produtos.length,
                    itemBuilder: (context, index) {
                      final produto = controller.produtos[index];
                      return Card(
                        elevation: 3,
                        child: InkWell(
                          onTap: () => _mostrarDetalhesProduto(produto),
                          child: Padding(
                            padding: EdgeInsets.all(isTablet ? 16 : 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Icon(
                                      Icons.shopping_bag,
                                      size: isTablet ? 70 : 60,
                                      color: Colors.blue.shade300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 10 : 8),
                                Text(
                                  produto.nome,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveHelper.getFontSize(context, 14),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: isTablet ? 6 : 4),
                                Text(
                                  controller.formatarPreco(produto.preco),
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveHelper.getFontSize(context, 16),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 6 : 4),
                                Text(
                                  'Estoque: ${produto.quantidadeEstoque}',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getFontSize(context, 12),
                                    color: produto.quantidadeEstoque > 0
                                        ? Colors.grey.shade600
                                        : Colors.red,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 10 : 8),
                                SizedBox(
                                  width: double.infinity,
                                  height: isTablet ? 40 : 36,
                                  child: ElevatedButton(
                                    onPressed: produto.quantidadeEstoque > 0
                                        ? () => _adicionarAoCarrinho(produto)
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: isTablet ? 10 : 8,
                                      ),
                                    ),
                                    child: Text(
                                      'Adicionar',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(context, 12),
                                      ),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}