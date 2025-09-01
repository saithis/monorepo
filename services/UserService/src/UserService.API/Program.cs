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
app.MapGet("/", () => "Hello World from UserService!")
    .WithName("GetHelloWorld")
    .WithOpenApi();

// Users endpoints
app.MapGet("/users", () => new[]
{
    new { Id = 1, Name = "John Doe", Email = "john@example.com" },
    new { Id = 2, Name = "Jane Smith", Email = "jane@example.com" }
})
.WithName("GetUsers")
.WithOpenApi();

app.MapGet("/users/{id}", (int id) => 
{
    if (id == 1)
        return Results.Ok(new { Id = 1, Name = "John Doe", Email = "john@example.com" });
    if (id == 2)
        return Results.Ok(new { Id = 2, Name = "Jane Smith", Email = "jane@example.com" });
    
    return Results.NotFound();
})
.WithName("GetUserById")
.WithOpenApi();

app.Run();
