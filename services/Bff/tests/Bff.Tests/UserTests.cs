using Bff.Core.Entities;
using FluentAssertions;
using System;
using Xunit;

namespace Bff.Tests;

public class UserTests
{
    [Fact]
    public void User_ShouldHaveValidProperties()
    {
        // Arrange
        var user = new User
        {
            Id = 1,
            Email = "test@example.com",
            FirstName = "John",
            LastName = "Doe",
            CreatedAt = DateTime.UtcNow,
            IsActive = true
        };

        // Assert
        user.Id.Should().Be(1);
        user.Email.Should().Be("test@example.com");
        user.FirstName.Should().Be("John");
        user.LastName.Should().Be("Doe");
        user.IsActive.Should().BeTrue();
    }
}
