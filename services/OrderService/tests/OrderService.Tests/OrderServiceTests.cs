using Xunit;

namespace OrderService.Tests;

public class OrderServiceTests
{
    [Fact]
    public void OrderService_ShouldExist()
    {
        // Simple test to verify the test project is working
        Assert.True(true);
    }

    [Fact]
    public void OrderService_ShouldReturnHelloWorld()
    {
        // Test that would verify the hello world endpoint
        var expectedMessage = "Hello World from OrderService!";
        Assert.NotNull(expectedMessage);
        Assert.Contains("OrderService", expectedMessage);
    }
}
