// farm-quiz-questions.js — the Time Quiz question bank.
//
// Swap content in and out here; the game code never needs to change.
// - Add a pack: copy one { id, title, subject, questions: [...] } block and fill it in.
// - Turn packs on or off: list their ids in QUIZ_SETTINGS.activePacks.
// - Each question: q = the question, answers = 2–4 choices, correct = position of the right
//   answer (0 = first), right / wrong = optional feedback lines.
//   Answers are shuffled when shown, so the right one is not always in the same place.

window.QUIZ_SETTINGS = {
  activePacks: ["farm-basics", "continents"],
  // "retry"  = a wrong answer can be tried again until it's right (how the prototype works now)
  // "reveal" = a wrong answer shows the right one and moves on without advancing farm time
  wrongAnswer: "retry",
  avoidRepeatWithin: 3,   // don't ask the same question again within this many questions
  shuffleAnswers: true
};

window.QUIZ_PACKS = [
  {
    id: "farm-basics",
    title: "Farm basics",
    subject: "Science",
    questions: [
      { q: "Which uses more water to make?", answers: ["A glass of milk", "A glass of carrot juice"], correct: 0,
        right: "Yes! Animal products like milk usually use more water.", wrong: "Think about which one comes from an animal." },
      { q: "What helps plants grow on this farm?", answers: ["Water", "Coins"], correct: 0,
        right: "Right! Plants need water to grow.", wrong: "Coins buy things, but water makes plants grow." },
      { q: "If you save wheat instead of selling it, what can you do later?", answers: ["Use it in recipes", "Lose it forever"], correct: 0,
        right: "Correct! Saved wheat becomes porridge, flour or bread.", wrong: "Saved wheat can be very useful later." },
      { q: "Which is usually better for water use?", answers: ["Growing carrots", "Feeding animals to get eggs"], correct: 0,
        right: "Yes! Plants usually use less water than animal products.", wrong: "Animals need food and water, too!" }
    ]
  },
  {
    id: "continents",
    title: "Continents",
    subject: "Geography",
    questions: [
      { q: "On which continent is Switzerland?", answers: ["Europe", "Asia", "Africa"], correct: 0 },
      { q: "Which is the biggest continent?", answers: ["Asia", "Europe", "Australia"], correct: 0 },
      { q: "On which continent is Egypt?", answers: ["Africa", "Asia", "South America"], correct: 0 },
      { q: "Where do kangaroos live in the wild?", answers: ["Australia", "Africa", "Europe"], correct: 0 },
      { q: "Which continent is almost completely covered in ice?", answers: ["Antarctica", "Europe", "North America"], correct: 0 },
      { q: "On which continent is Brazil?", answers: ["South America", "Africa", "Asia"], correct: 0 },
      { q: "On which continent is Canada?", answers: ["North America", "Europe", "South America"], correct: 0 },
      { q: "How many continents are there?", answers: ["7", "5", "10"], correct: 0 },
      { q: "On which continent is the Sahara desert?", answers: ["Africa", "Australia", "Europe"], correct: 0 },
      { q: "On which continent is Mount Everest?", answers: ["Asia", "Europe", "South America"], correct: 0 },
      { q: "Which is the smallest continent?", answers: ["Australia", "Europe", "Antarctica"], correct: 0 },
      { q: "Which continent has the most countries?", answers: ["Africa", "Europe", "North America"], correct: 0 }
    ]
  }
];
