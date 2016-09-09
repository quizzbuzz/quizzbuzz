# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


Quizzbuzz.Repo.insert!(%Quizzbuzz.Game{
    title: "nothing",
    topic: "nothing",
    questions: [
      %Quizzbuzz.Question{
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
        body: "What was four legs a dawn, two at midday and three at sunset?",
        options: ["an orange","a dog","a man","a cat"],
        answer: "a man",
      }


    ]
  })
