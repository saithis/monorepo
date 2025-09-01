var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// Hello World endpoint
app.MapGet("/", () => "Hello World from OrderService!")
    .WithName("GetHelloWorld")
    .WithOpenApi();

// Orders endpoints
app.MapGet("/orders", () => new[]
{
    new { Id = 1, Product = "Widget", Quantity = 10, Price = 25.99m },
    new { Id = 2, Product = "Gadget", Quantity = 5, Price = 15.50m }
})
.WithName("GetOrders")
.WithOpenApi();

app.MapGet("/orders/{id}", (int id) => 
{
    if (id == 1)
        return Results.Ok(new { Id = 1, Product = "Widget", Quantity = 10, Price = 25.99m });
    if (id == 2)
        return Results.Ok(new { Id = 2, Product = "Gadget", Quantity = 5, Price = 15.50m });
    
    return Results.NotFound();
})
.WithName("GetOrderById")
.WithOpenApi();

app.Run();
