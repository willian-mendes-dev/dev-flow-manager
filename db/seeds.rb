puts "Limpando produtos existentes..."
Product.delete_all

products = [
  { name: "Arroz Integral 1kg", description: "Arroz integral tipo 1", sku: "ALI-001", price: 9.90, stock_quantity: 45, category: "Alimentos" },
  { name: "Feijao Preto 1kg", description: "Feijao preto selecionado", sku: "ALI-002", price: 8.50, stock_quantity: 30, category: "Alimentos" },
  { name: "Macarrao Espaguete 500g", description: "Massa de semola", sku: "ALI-003", price: 5.20, stock_quantity: 60, category: "Alimentos" },
  { name: "Acucar Refinado 1kg", description: "Acucar refinado branco", sku: "ALI-004", price: 4.80, stock_quantity: 52, category: "Alimentos" },
  { name: "Detergente Neutro 500ml", description: "Detergente para loucas", sku: "LIM-001", price: 2.90, stock_quantity: 80, category: "Limpeza" },
  { name: "Agua Sanitaria 1L", description: "Desinfetante para uso domestico", sku: "LIM-002", price: 4.10, stock_quantity: 38, category: "Limpeza" },
  { name: "Sabao em Po 1kg", description: "Sabao em po concentrado", sku: "LIM-003", price: 12.90, stock_quantity: 24, category: "Limpeza" },
  { name: "Desinfetante Lavanda 2L", description: "Desinfetante perfumado", sku: "LIM-004", price: 7.60, stock_quantity: 27, category: "Limpeza" },
  { name: "Agua Mineral sem Gas 1,5L", description: "Garrafa de agua mineral", sku: "BEB-001", price: 3.20, stock_quantity: 110, category: "Bebidas" },
  { name: "Refrigerante Cola 2L", description: "Refrigerante sabor cola", sku: "BEB-002", price: 8.90, stock_quantity: 40, category: "Bebidas" },
  { name: "Suco de Laranja 1L", description: "Suco integral pasteurizado", sku: "BEB-003", price: 9.50, stock_quantity: 22, category: "Bebidas" },
  { name: "Cha Gelado Limao 1,5L", description: "Bebida nao alcoolica sabor limao", sku: "BEB-004", price: 6.70, stock_quantity: 18, category: "Bebidas" }
]

products.each do |product_data|
  Product.create!(product_data)
end

puts "#{Product.count} produtos de exemplo criados com sucesso."
