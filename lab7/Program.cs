using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using Npgsql;
using NpgsqlTypes;
using Newtonsoft.Json.Linq;
using Npgsql.EntityFrameworkCore.PostgreSQL;

[Table("author")]
public class Author
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
    [Column("name")]
    public string Name { get; set; }
    [Column("birth_date")]
    public DateTime BirthDate { get; set; }
    [Column("rating")]
    public double Rating { get; set; }
    [Column("bio")]
    public string Bio { get; set; }
}

[Table("publisher")]
public class Publisher
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
    [Column("name")]
    public string Name { get; set; }
    [Column("address")]
    public string Address { get; set; }
    [Column("phone")]
    public string Phone { get; set; }
    [Column("licence_number")]
    public int LicenceNumber { get; set; }
}

public class Translator
{
    [Key]
    public int Id { get; set; }
    public string Name { get; set; }
    public DateTime BirthDate { get; set; }
    public string Bio { get; set; }
    public string NativeLanguage { get; set; }
    public double Rating { get; set; }
}

[Table("book")]
public class Book
{
    public Book(int id, string title, DateTime publicationDate, long isbn, string genre, double rating, int authorId, int publisherId, int translatorId)
    {
        Id = id;
        Title = title;
        PublicationDate = publicationDate;
        Isbn = isbn;
        Genre = genre;
        Rating = rating;
        AuthorId = authorId;
        PublisherId = publisherId;
        TranslatorId = translatorId;
    }
    [Key]
    [Column("id")]
    public int Id { get; set; }
    [Column("title")]
    public string Title { get; set; }
    [Column("publication_date")]
    public DateTime PublicationDate { get; set; }
    [Column("isbn")]
    public long Isbn { get; set; }
    [Column("genre")]
    public string Genre { get; set; }
    [Column("rating")]
    public double Rating { get; set; }
    [Column("author_id")]
    public int AuthorId { get; set; }
    [Column("publisher_id")]
    public int PublisherId { get; set; }
    [Column("translator_id")]
    public int TranslatorId { get; set; }
}

public class MyDbContext : DbContext
{
    public DbSet<Author> Authors { get; set; }
    public DbSet<Publisher> Publishers { get; set; }
    public DbSet<Translator> Translators { get; set; }
    public DbSet<Book> Books { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseNpgsql("Host=127.0.0.1;Username=whither;Password=;Database=books;");
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Book>()
            .HasKey(b => b.Id);

        modelBuilder.Entity<Author>()
            .HasKey(a => a.Id);

        modelBuilder.Entity<Translator>()
            .HasKey(t => t.Id);

        modelBuilder.Entity<Publisher>()
            .HasKey(p => p.Id);
    }
}

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Task 1");
        List<Book> books = new List<Book>
        {
            new Book (1,"Book One", new DateTime(2020, 1, 15), 1234567890, "Fiction", 4.2,  1,  1,  1 ),
            new Book (2,"Book Two", new DateTime(2019, 5, 23), 9876543210, "Non-Fiction",  3.8,  2,  2,  2 ),
            new Book (3,"Book Three", new DateTime(2021, 11, 2), 4567891234, "Fiction",  4.5,  3,  3,  3 ),
            new Book (4,"Book Four", new DateTime(2018, 8, 10), 7895643210, "Science Fiction",  4.0,  4,  4,  4 ),
            new Book (5,"Book Five", new DateTime(2022, 3, 25), 1357924680, "Non-Fiction",  3.9,  5,  5,  5 )
        };

        var query1 = from book in books
                     where book.Rating > 4.0
                     select book.Title;

        Console.WriteLine("Books with rating above 4.0:");
        foreach (var title in query1)
        {
            Console.WriteLine(title);
        }

        var query2 = from book in books
                     orderby book.PublicationDate descending
                     select book;

        Console.WriteLine("\nBooks ordered by publication date descending:");
        foreach (var book in query2)
        {
            Console.WriteLine($"{book.Title} - {book.PublicationDate}");
        }

        var query3 = from book in books
                     group book by book.Genre into genreGroup
                     select new { Genre = genreGroup.Key, Count = genreGroup.Count() };

        Console.WriteLine("\nBooks grouped by genre:");
        foreach (var group in query3)
        {
            Console.WriteLine($"{group.Genre}: {group.Count} books");
        }

        var query4 = from book in books
                     let yearsSincePublication = DateTime.Now.Year - book.PublicationDate.Year
                     where yearsSincePublication < 5
                     select new { book.Title, yearsSincePublication };

        Console.WriteLine("\nBooks published in the last 5 years:");
        foreach (var item in query4)
        {
            Console.WriteLine($"{item.Title} - {item.yearsSincePublication} years since publication");
        }

        var query5 = from book in books
                     group book by book.AuthorId into authorGroup
                     orderby authorGroup.Key
                     select new { AuthorId = authorGroup.Key, BookCount = authorGroup.Count() };

        Console.WriteLine("\nBooks grouped by AuthorId:");
        foreach (var group in query5)
        {
            Console.WriteLine($"Author ID: {group.AuthorId}, Book Count: {group.BookCount}");
        }
        Console.WriteLine("Task 2");
        string connectionString = "Host=127.0.0.1;Username=whither;Password=;Database=books;";
        string updateQuery = "UPDATE book2 SET author_info = @author_info WHERE id = 2;";

        string query = "SELECT author_info FROM book2 WHERE id = 2;";
        var param = new NpgsqlParameter("@author_info", NpgsqlDbType.Jsonb);

        using (NpgsqlConnection conn = new NpgsqlConnection(connectionString))
        {
            conn.Open();
            using (NpgsqlCommand cmd = new NpgsqlCommand(query, conn))
            {
                using (NpgsqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string jsonString = reader.GetString(0);
                        var jo = JObject.Parse(jsonString);

                        Console.WriteLine(reader["author_info"]);

                        // Update
                        if ((string)jo["name"] == "имя2")
                        {
                            jo["rating"] = 5.0;
                        }

                        // Write/Add
                        jo["new_info"] = "Added new info";
                        string updatedJson = jo.ToString();
                        param.Value = updatedJson;
                    }
                }
            }
            using (NpgsqlCommand updateCmd = new NpgsqlCommand(updateQuery, conn))
            {
                updateCmd.Parameters.Add(param);
                updateCmd.ExecuteNonQuery();
            }

            Console.WriteLine("JSON data updated successfully.");
        }
        Console.WriteLine("Task 3");

        using (var db = new MyDbContext())
        {
                // Single-table query
            // var highRatedBooks = db.Books.Where(b => b.Rating > 4.0);
            // foreach (var book in highRatedBooks)
            // {
            //     Console.WriteLine(book.Title);
            // }

            // // Multi-table query
            // var booksWithAuthors = db.Books.Join(db.Authors, b => b.AuthorId, a => a.Id, (b, a) => new {BookTitle = b.Title, AuthorName = a.Name}).ToList();
            // foreach (var book in booksWithAuthors)
            // {
            //     Console.WriteLine($"{book.BookTitle}: {book.AuthorName}");
            // }
            // // Add a new book
            // db.Books.Add(new Book(1602, "Исскуство войны", new DateTime(2000, 01, 01).ToUniversalTime(), 2423931116773, "History", 5.0, 826, 264, 173));
            // db.SaveChanges();

            // // Update a book's rating
            // var bookToUpdate = db.Books.FirstOrDefault(b => b.Id == 2);
            // if (bookToUpdate != null)
            // {
            //     bookToUpdate.Rating = 4.5;
            //     db.SaveChanges();
            // }

            // // Delete a book
            // var bookToDelete = db.Books.FirstOrDefault(b => b.Id == 984);
            // if (bookToDelete != null)
            // {
            //     db.Books.Remove(bookToDelete);
            //     db.SaveChanges();
            // }

            // var result = db.Database.ExecuteSqlRaw("CALL books_by_genre(\'Fiction\')");

            int currentYear = DateTime.Now.Year - 6;

            var authorsWhoWorkedWithMoscowPublishersThisYear = 
                (from a in db.Authors
                where db.Books.Any(b => b.AuthorId == a.Id &&
                                        b.PublicationDate.Year == currentYear &&
                                        db.Publishers.Any(p => p.Id == b.PublisherId && p.Address.Contains("Москва")))
                select a).Distinct();
            var result = authorsWhoWorkedWithMoscowPublishersThisYear.ToList();
            foreach (var res in result)
            {
                Console.WriteLine(res.Id);
            }
        }
    }
}
// Добавить запрос, авторов, которые работали с моск издательствами в этом году.