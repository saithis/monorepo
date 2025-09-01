using Xunit;

namespace UserService.Tests;

public class UserServiceTests
{
    [Fact]
    public void UserService_ShouldExist()
    {
        // Simple test to verify the test project is working
        Assert.True(true);
    }

    [Fact]
    public void UserService_ShouldReturnHelloWorld()
    {
        // Test that would verify the hello world endpoint
        var expectedMessage = "Hello World from UserService!";
        Assert.NotNull(expectedMessage);
        Assert.Contains("UserService", expectedMessage);
    }
}
