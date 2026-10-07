// farm-game-config.js
const CROPS = {
  wheat: { id: "wheat", name: "Wheat", emoji: "🌾", growthTime: 2, waterCost: 2, sellPrice: 3, seedItemId: "wheatSeed", seedCostCoins: 1, initiallyUnlocked: true },
  carrot:{ id: "carrot",name:"Carrot",emoji:"🥕",growthTime:4,waterCost:2,sellPrice:8,seedItemId:"carrotSeed",seedCostCoins:2,initiallyUnlocked:true },
  tomato:{ id:"tomato",name:"Tomato",emoji:"🍅",growthTime:4,waterCost:3,sellPrice:10,seedItemId:"tomatoSeed",seedCostCoins:4,initiallyUnlocked:false,unlockEggCost:2 }
};
const CROP_ORDER=["wheat","carrot","tomato"];
const RECIPES={
  bread:{id:"bread",name:"Bread",emoji:"🍞",inputs:[{itemId:"wheat",amount:3}],sellPrice:15,energyCost:1}
};
const WELL_LEVELS=[
  {level:1,production:2,capacity:20,upgradeCostCoins:0},
  {level:2,production:4,capacity:30,upgradeCostCoins:20},
  {level:3,production:6,capacity:40,upgradeCostCoins:40}
];
// Time quiz now only advances time & water; energy comes only from Training
const ENERGY_FROM_TIME_QUIZ=0;
// Training quiz: success vs failure
const ENERGY_FROM_TRAINING_SUCCESS=5;
const ENERGY_FROM_TRAINING_FAIL=0;
const ENERGY_COST_PLANT=1;
const ENERGY_COST_HARVEST=1;
const ENERGY_COST_CONVERT=1;
const ENERGY_COST_CRAFT=1;
const EGG_SELL_PRICE=6;
const MILK_SELL_PRICE=12;
const WOOL_SELL_PRICE=14;
const HONEY_SELL_PRICE=10;
const STARTING_STATE={
  resources:{
    coins:200,
    water:8,
    waterCapacity:WELL_LEVELS[0].capacity,
    energy:10,
    energyMax:20,
    inventory:{
      wheatSeed:5,
      carrotSeed:0,
      tomatoSeed:0,
      wheat:0,
      carrot:0,
      tomato:0,
      egg:0,
      milk:0,
      wool:0,
      honey:0,
      bread:0
    }
  },
  farm:{
    plots:Array.from({length:12}).map((_,i)=>({
      planted:false,
      cropId:null,
      growth:0,
      type:i<9?"field":"special"
    }))
  },
  buildings:{well:{level:1}},
  animals:{chickens:[],cows:[],sheep:[],bees:[]},
  unlockedCrops:{wheat:true,carrot:true,tomato:false},
  unlockedRecipes:{bread:true},
  quiz:{questionsAnswered:0}
};
