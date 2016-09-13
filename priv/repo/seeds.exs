

questions = [%Quizzbuzz.Question{
        body: "What is 1+1?",
        options: ["1","2","3","4"],
        answer: "2"
      },
      %Quizzbuzz.Question{
        body: "Are we awesome?",
        options: ["Yes","No","Maybe","Yellow"],
        answer: "Yes",
      },
      %Quizzbuzz.Question{
        body: "How much wood would a woodchuck chuck if a woodchuck could chuck wood?",
        options: ["some","a lot","a bit","none"],
        answer: "a lot",
      },
      %Quizzbuzz.Question{
        body: "What has four legs at dawn, two at midday and three at sunset?",
        options: ["an orange","a dog","a man","a cat"],
        answer: "a man",
      },
      %Quizzbuzz.Question{
        body: "Which of these is a mammal",
        options: ["an orange","a dolphin","a blobfish","a caterpiller"],
        answer: "a dolphin",
      },
      %Quizzbuzz.Question{
        body: "What type of language is Romanian",
        options: ["Romance","Slavic","Germanic","Mr. Bombastic"],
        answer: "Romance",
      },
      %Quizzbuzz.Question{
        body: "What is a ratus ratus",
        options: ["rat","pokemon","type of coffee","coding language"],
        answer: "rat",
      },
      %Quizzbuzz.Question{
        body: "Which pokemon is the first in the original 150",
        options: ["Bulbasaur","Pikachu","Charmander","Ditto"],
        answer: "Bulbasaur",
      },
      %Quizzbuzz.Question{
        body: "Never gonna...",
        options: ["give you up","let you down","hold you down","desert you"],
        answer: "give you up",
      },
      %Quizzbuzz.Question{
        body: "Where is the ponte dei sospiri",
        options: ["Venice","Rome","Reykjavik","Madrid"],
        answer: "Venice",
      },
      %Quizzbuzz.Question{
        body: "Who wrote Catch-22",
        options: ["Mozart","George Orwell","J.K Rowling","Joseph Heller"],
        answer: "Joseph Heller",
      },
      %Quizzbuzz.Question{
        body: "What year was the NHS formed",
        options: ["1947","1948","1949","1950"],
        answer: "1948"
      }]

Enum.map(questions, &(Quizzbuzz.Repo.insert!(&1)))

users = [%Quizzbuzz.User{
    email: "wawa@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 192
  },
  %Quizzbuzz.User{
    email: "solo@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 1222
  },
  %Quizzbuzz.User{
    email: "didi@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 373
  },
  %Quizzbuzz.User{
    email: "dada@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 123
  },
  %Quizzbuzz.User{
    email: "lolo@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 568
  },
  %Quizzbuzz.User{
    email: "mama@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 654
  },
  %Quizzbuzz.User{
    email: "momo@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 789
  },
  %Quizzbuzz.User{
    email: "kaka@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 194
  },
  %Quizzbuzz.User{
    email: "haha@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 194
  },
  %Quizzbuzz.User{
    email: "yaya@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 267
  },
  %Quizzbuzz.User{
    email: "lili@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 111
  },
  %Quizzbuzz.User{
    email: "fofo@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 1298
  },
  %Quizzbuzz.User{
    email: "zozo@email.com",
    password_hash: "rtyuiopjihgjhcfvnbmnjlhuiyut",
    high_score: 766
  }]

Enum.map(users, &(Quizzbuzz.Repo.insert!(&1)))
