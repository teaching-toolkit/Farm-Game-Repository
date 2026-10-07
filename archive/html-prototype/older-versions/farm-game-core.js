// farm-game-core.js
const STORAGE_KEY="farmQuizCoreV3";
let gameState=null;

// used for Training timeout
let currentTrainingTimeout=null;
let trainingQuestionActive=false;

function clone(o){return JSON.parse(JSON.stringify(o));}
function getResourceIcon(id){
  const m={
    wheat:"🌾",carrot:"🥕",tomato:"🍅",
    wheatSeed:"🌾",carrotSeed:"🥕",tomatoSeed:"🍅",
    egg:"🥚",milk:"🥛",wool:"🧶",honey:"🍯",
    bread:"🍞",
    coins:"💰",water:"💧",energy:"⚡"
  };
  return m[id]||"❓";
}
function loadGame(){
  try{
    const raw=localStorage.getItem(STORAGE_KEY);
    if(raw){
      const d=JSON.parse(raw);
      if(d&&typeof d==="object"){gameState=d;ensureMigration();return;}
    }
  }catch(e){}
  gameState=clone(STARTING_STATE);
}
function ensureMigration(){
  if(!gameState.resources)gameState.resources=clone(STARTING_STATE.resources);
  if(!gameState.farm)gameState.farm=clone(STARTING_STATE.farm);
  if(!gameState.buildings)gameState.buildings=clone(STARTING_STATE.buildings);
  if(!gameState.animals)gameState.animals={chickens:[],cows:[],sheep:[],bees:[]};
  if(!gameState.animals.cows)gameState.animals.cows=[];
  if(!gameState.animals.sheep)gameState.animals.sheep=[];
  if(!gameState.animals.bees)gameState.animals.bees=[];
  if(!gameState.unlockedCrops)gameState.unlockedCrops=clone(STARTING_STATE.unlockedCrops);
  if(!gameState.unlockedRecipes)gameState.unlockedRecipes=clone(STARTING_STATE.unlockedRecipes);
  if(!gameState.quiz)gameState.quiz={questionsAnswered:0};
}
function saveGame(){try{localStorage.setItem(STORAGE_KEY,JSON.stringify(gameState));}catch(e){}}
function isCropUnlocked(id){const c=CROPS[id];if(!c)return false;if(c.initiallyUnlocked)return true;return !!gameState.unlockedCrops[id];}
function getWellStats(){const lvl=(gameState.buildings?.well?.level)||1;const idx=Math.min(lvl-1,WELL_LEVELS.length-1);return WELL_LEVELS[idx];}
function clampEnergy(){gameState.resources.energy=Math.min(gameState.resources.energy,gameState.resources.energyMax);}

// Time Quiz: advance time, water, crop growth – NO energy
function advanceTimeFromQuiz(){
  gameState.quiz.questionsAnswered++;
  gameState.farm.plots.forEach(p=>{if(p.planted&&p.cropId)p.growth++;});
  const st=getWellStats();
  gameState.resources.water=Math.min(gameState.resources.water+st.production,st.capacity);
  gameState.resources.waterCapacity=st.capacity;
  renderAll();
  saveGame();
}

// Rendering helpers
function renderTopBar(){
  document.getElementById("coins-display").textContent=gameState.resources.coins;
  document.getElementById("water-display").textContent=`${gameState.resources.water}/${gameState.resources.waterCapacity}`;
  document.getElementById("energy-display").textContent=`${gameState.resources.energy}/${gameState.resources.energyMax}`;
}
function renderFieldPlot(i){
  const p=gameState.farm.plots[i];
  const el=document.querySelector(`.field-plot[data-plot="${i}"]`);
  if(!el)return;
  const content=el.querySelector(".plot-content");
  content.innerHTML="";
  if(!p.planted||!p.cropId)return;
  const c=CROPS[p.cropId];if(!c)return;
  const ready=p.growth>=c.growthTime;
  const r=Math.min(p.growth/c.growthTime,1);
  let stage=0;if(r>=0.75)stage=3;else if(r>=0.5)stage=2;else if(r>=0.25)stage=1;
  const span=document.createElement("span");
  span.className="crop-emoji growth-"+stage+(ready?" ready":"");
  span.textContent=c.emoji;
  content.appendChild(span);
}
function renderFields(){for(let i=0;i<gameState.farm.plots.length;i++)renderFieldPlot(i);}
function renderAll(){renderTopBar();renderFields();}

// Requirement progress bar
function renderRequirementLine(label,icon,current,required){
  if(required<=0)required=1;
  const ratio=Math.max(0,Math.min(current/required,1));
  let cls="req-mid";
  if(ratio>=1)cls="req-ok";
  else if(ratio<0.4)cls="req-low";
  const pct=(ratio*100).toFixed(0);
  return `<div class="req-line">
    <div class="req-label">${icon} ${label}: ${current}/${required}</div>
    <div class="req-bar"><div class="req-bar-fill ${cls}" style="width:${pct}%"></div></div>
  </div>`;
}

// Generic modal
function showModal(title,bodyHtml,onReady){
  const overlay=document.getElementById("ui-modal");
  const titleEl=document.getElementById("ui-modal-title");
  const bodyEl=document.getElementById("ui-modal-body");
  titleEl.textContent=title;
  bodyEl.innerHTML=bodyHtml;
  overlay.classList.remove("hidden");
  const close=()=>{
    overlay.classList.add("hidden");
  };
  document.getElementById("ui-modal-close").onclick=close;
  const extra=bodyEl.querySelector(".close-modal-btn");
  if(extra)extra.onclick=close;
  if(typeof onReady==="function")onReady(bodyEl,overlay);
}

// Planting
function showPlantingModal(idx){
  const p=gameState.farm.plots[idx];
  if(p.type!=="field"){alert("This patch is reserved for a special building later.");return;}
  let html="<div><p>Select a crop to plant:</p><div class='card-grid'>";
  CROP_ORDER.forEach(id=>{
    const c=CROPS[id];if(!c)return;
    if(!isCropUnlocked(id)){
      html+=`<div class="card locked"><div class="card-icon">${c.emoji}</div><div class="card-title">${c.name}</div><div class="card-sub">Locked</div></div>`;
      return;
    }
    const seeds=gameState.resources.inventory[c.seedItemId]||0;
    const hasSeeds=seeds>0;
    const hasWater=gameState.resources.water>=c.waterCost;
    const hasEnergy=gameState.resources.energy>=ENERGY_COST_PLANT;
    const canPlant=hasSeeds&&hasWater&&hasEnergy;
    html+=`<div class="card" data-crop="${id}">
      <div class="card-icon">${c.emoji}</div>
      <div class="card-title">${c.name} Seeds</div>
      <div class="card-sub">
        🌱 Seeds: ${seeds}<br>
        💧 ${c.waterCost} • ⚡ ${ENERGY_COST_PLANT} • ⏱️ ${c.growthTime} Q
      </div>
      ${renderRequirementLine("Water","💧",gameState.resources.water,c.waterCost)}
      ${renderRequirementLine("Energy","⚡",gameState.resources.energy,ENERGY_COST_PLANT)}
      <button class="card-btn plant-btn${canPlant?"":" disabled"}">
        ${canPlant?"Plant":"Need seeds/water/energy"}
      </button>
    </div>`;
  });
  html+=`</div><div class="helper-text">Seeds come from the Market. Time Quiz grows crops.</div><button class="close-modal-btn">Cancel</button></div>`;
  showModal("Plant",html,(body,overlay)=>{
    body.querySelectorAll(".plant-btn").forEach(btn=>{
      btn.onclick=e=>{
        if(btn.classList.contains("disabled"))return;
        const card=e.target.closest(".card");
        const cropId=card.getAttribute("data-crop");
        plantCrop(idx,cropId);
        overlay.classList.add("hidden");
      };
    });
  });
}
function plantCrop(idx,cropId){
  const c=CROPS[cropId];if(!c)return;
  const inv=gameState.resources.inventory;
  if(!isCropUnlocked(cropId)){alert("That crop is not unlocked yet.");return;}
  if((inv[c.seedItemId]||0)<1){alert("You need seeds. Visit the Market.");return;}
  if(gameState.resources.water<c.waterCost){alert("Not enough water.");return;}
  if(gameState.resources.energy<ENERGY_COST_PLANT){alert("Not enough energy.");return;}
  const p=gameState.farm.plots[idx];
  if(p.type!=="field"){alert("This patch is reserved for a special building later.");return;}
  gameState.resources.energy-=ENERGY_COST_PLANT;
  gameState.resources.water-=c.waterCost;
  inv[c.seedItemId]=(inv[c.seedItemId]||0)-1;
  p.planted=true;p.cropId=cropId;p.growth=0;
  renderAll();saveGame();
}
function clearPlot(i){const p=gameState.farm.plots[i];p.planted=false;p.cropId=null;p.growth=0;}
function harvestPlot(i){
  const p=gameState.farm.plots[i];if(!p.planted||!p.cropId)return;
  const c=CROPS[p.cropId];if(!c)return;
  if(p.growth<c.growthTime){alert(`${c.name} is still growing... (${p.growth}/${c.growthTime})`);return;}
  if(gameState.resources.energy<ENERGY_COST_HARVEST){alert("Not enough energy to harvest.");return;}
  const amt=1;const value=c.sellPrice*amt;
  const html=`<div style="text-align:center;">
    <div style="font-size:32px;">${c.emoji}</div>
    <p>You harvested <strong>${amt}</strong> ${c.name}.</p>
    <p style="font-size:13px;">Sell now or save for later?</p>
    <button id="harvest-sell" class="pill-btn pill-primary" style="width:100%;margin-top:6px;">💰 Sell (+${value} coins)</button>
    <button id="harvest-save" class="pill-btn pill-ghost" style="width:100%;margin-top:4px;">🧺 Save to pantry</button>
    <button class="close-modal-btn" style="margin-top:4px;">Cancel</button>
  </div>`;
  showModal("Harvest",html,(body,overlay)=>{
    body.querySelector("#harvest-sell").onclick=()=>{
      gameState.resources.energy-=ENERGY_COST_HARVEST;
      gameState.resources.coins+=value;
      clearPlot(i);renderAll();saveGame();overlay.classList.add("hidden");
    };
    body.querySelector("#harvest-save").onclick=()=>{
      gameState.resources.energy-=ENERGY_COST_HARVEST;
      const inv=gameState.resources.inventory;
      inv[p.cropId]=(inv[p.cropId]||0)+amt;
      clearPlot(i);renderAll();saveGame();overlay.classList.add("hidden");
    };
  });
}

// Pantry grouped by category
function showInventory(){
  const inv=gameState.resources.inventory;
  const raw=["wheat","carrot","tomato"];
  const animal=["egg","milk","wool","honey"];
  const crafted=["bread"];
  const renderCategory=(title,items,bg)=>{
    let inner="";
    items.forEach(k=>{
      const amt=inv[k]||0;
      if(!amt)return;
      const icon=getResourceIcon(k);
      let price=0;
      if(CROPS[k])price=CROPS[k].sellPrice;
      if(k==="egg")price=EGG_SELL_PRICE;
      if(k==="milk")price=MILK_SELL_PRICE;
      if(k==="wool")price=WOOL_SELL_PRICE;
      if(k==="honey")price=HONEY_SELL_PRICE;
      if(k==="bread")price=RECIPES.bread.sellPrice;
      inner+=`<div class="card" data-item="${k}" style="background:#fff;">
        <div class="card-icon">${icon}</div>
        <div class="inventory-amount">×${amt}</div>
        <div class="inventory-name">${k}</div>`;
      if(price>0)inner+=`<button class="card-btn inventory-sell-btn" data-price="${price}">Sell (+${price} each)</button>`;
      inner+=`</div>`;
    });
    if(!inner)inner='<div class="helper-text">None yet.</div>';
    return `<div class="inventory-category" style="background:${bg};border-radius:10px;padding:8px;margin-bottom:8px;">
      <strong>${title}</strong>
      <div class="card-grid">${inner}</div>
    </div>`;
  };
  let html="<div><p>Pantry 🧺</p>";
  html+=renderCategory("Raw crops",raw,"#f0e6d2");
  html+=renderCategory("Animal & bee products",animal,"#ffe4e1");
  html+=renderCategory("Crafted goods",crafted,"#e6f3ff");
  html+=`<div class="helper-text">Seeds are bought in the Market and not shown here.</div><button class="close-modal-btn">Close</button></div>`;
  showModal("Pantry",html,(body,overlay)=>{
    body.querySelectorAll(".inventory-sell-btn").forEach(btn=>{
      btn.onclick=()=>{
        const card=btn.closest(".card");
        const key=card.getAttribute("data-item");
        const price=Number(btn.getAttribute("data-price")||"0");
        const amt=gameState.resources.inventory[key]||0;
        if(!amt||!price)return;
        const total=amt*price;
        if(confirm(`Sell ${amt} ${key} for ${total} coins?`)){
          gameState.resources.coins+=total;
          gameState.resources.inventory[key]=0;
          renderAll();saveGame();showInventory();
        }
      };
    });
  });
}

// Market (seeds + tomato unlock) with bars
function showMarket(){
  const inv=gameState.resources.inventory;
  let html="<div><p>Marketplace – Seeds</p><div class='card-grid'>";
  CROP_ORDER.forEach(id=>{
    const c=CROPS[id];if(!c)return;
    const unlocked=isCropUnlocked(id);
    const seeds=inv[c.seedItemId]||0;
    if(unlocked){
      const canBuy=gameState.resources.coins>=c.seedCostCoins;
      html+=`<div class="card" data-crop="${id}">
        <div class="card-icon">${c.emoji}</div>
        <div class="card-title">${c.name} Seeds</div>
        <div class="card-sub">Owned: ${seeds}<br>Cost: ${c.seedCostCoins}💰 each</div>
        ${renderRequirementLine("Coins","💰",gameState.resources.coins,c.seedCostCoins)}
        <button class="card-btn buy-seed-btn${canBuy?"":" disabled"}">${canBuy?"Buy 1":"Need coins"}</button>
      </div>`;
    }else{
      const eggs=inv.egg||0;
      const need=c.unlockEggCost||0;
      const canUnlock=eggs>=need&&need>0;
      html+=`<div class="card locked" data-crop="${id}">
        <div class="card-icon">${c.emoji}</div>
        <div class="card-title">${c.name} Seeds</div>
        <div class="card-sub">Bring ${need} 🥚 once to unlock.</div>
        ${renderRequirementLine("Eggs","🥚",eggs,need)}`;
      if(canUnlock)html+=`<button class="card-btn unlock-crop-btn">Unlock (pay ${need} 🥚)</button>`;
      html+="</div>";
    }
  });
  html+=`</div><div class="helper-text">Basic seeds always purchasable with coins. Tomatoes unlock by paying eggs once.</div><button class="close-modal-btn">Close</button></div>`;
  showModal("Market",html,(body,overlay)=>{
    body.querySelectorAll(".buy-seed-btn").forEach(btn=>{
      btn.onclick=e=>{
        if(btn.classList.contains("disabled"))return;
        const card=e.target.closest(".card");
        const cropId=card.getAttribute("data-crop");
        const c=CROPS[cropId];if(!c)return;
        if(gameState.resources.coins<c.seedCostCoins)return;
        gameState.resources.coins-=c.seedCostCoins;
        gameState.resources.inventory[c.seedItemId]=(gameState.resources.inventory[c.seedItemId]||0)+1;
        renderAll();saveGame();showMarket();
      };
    });
    body.querySelectorAll(".unlock-crop-btn").forEach(btn=>{
      btn.onclick=e=>{
        const card=e.target.closest(".card");
        const cropId=card.getAttribute("data-crop");
        const c=CROPS[cropId];if(!c)return;
        const need=c.unlockEggCost||0;
        if((gameState.resources.inventory.egg||0)<need)return;
        if(!confirm(`Spend ${need} eggs to unlock ${c.name} seeds forever?`))return;
        gameState.resources.inventory.egg-=need;
        gameState.unlockedCrops[cropId]=true;
        renderAll();saveGame();showMarket();
      };
    });
  });
}

// Chicken Area
function showChickenArea(){
  const chickens=gameState.animals.chickens||[];
  const cap=3;
  let html=`<div><p class="chicken-info">Chicken Area – each chicken converts wheat + water + energy into eggs.</p>
  <div class="chicken-info">Chickens: ${chickens.length}/${cap}</div>`;
  if(chickens.length<cap){
    html+=`${renderRequirementLine("Coins","💰",gameState.resources.coins,20)}
    <button id="buy-chicken-btn" class="pill-btn pill-primary" style="width:100%;margin-bottom:8px;">Buy Chicken (20💰)</button>`;
  }
  html+=`<div style="margin-top:6px;margin-bottom:6px;font-size:13px;">Chickens:</div>`;
  const inv=gameState.resources.inventory;
  if(!chickens.length)html+=`<p style="font-size:13px;">No chickens yet.</p>`;
  else chickens.forEach((ch,i)=>{
    const last=ch.lastConversionQuestion??-1;
    const ready=gameState.quiz.questionsAnswered>last;
    html+=`<div class="chicken-row" data-index="${i}">
      <div>🐔 Chicken ${i+1}</div>
      <div style="font-size:11px;">3🌾 + 3💧 + 1⚡ → 1🥚</div>
      ${renderRequirementLine("Wheat","🌾",inv.wheat||0,3)}
      ${renderRequirementLine("Water","💧",gameState.resources.water,3)}
      ${renderRequirementLine("Energy","⚡",gameState.resources.energy,ENERGY_COST_CONVERT)}
      ${ready?`<button class="card-btn chicken-convert-btn" style="margin-top:4px;">Convert</button>`:`<div class="helper-text">Answer a Time Quiz first</div>`}
    </div>`;
  });
  html+=`<div class="helper-text">Eggs can be sold or saved for recipes and tomato unlocks.</div><button class="close-modal-btn">Close</button></div>`;
  showModal("Chicken Area",html,(body,overlay)=>{
    const buy=body.querySelector("#buy-chicken-btn");
    if(buy){
      buy.onclick=()=>{
        if(gameState.resources.coins<20){alert("Not enough coins.");return;}
        if((gameState.animals.chickens||[]).length>=cap){alert("Chicken area is full.");return;}
        gameState.resources.coins-=20;
        if(!gameState.animals.chickens)gameState.animals.chickens=[];
        gameState.animals.chickens.push({lastConversionQuestion:-1});
        renderAll();saveGame();showChickenArea();
      };
    }
    body.querySelectorAll(".chicken-convert-btn").forEach(btn=>{
      btn.onclick=e=>{
        const row=e.target.closest(".chicken-row");
        const idx=Number(row.getAttribute("data-index"));
        convertChicken(idx,overlay);
      };
    });
  });
}
function convertChicken(idx,overlayToClose){
  const chickens=gameState.animals.chickens||[];
  const ch=chickens[idx];if(!ch)return;
  const last=ch.lastConversionQuestion??-1;
  if(gameState.quiz.questionsAnswered<=last){alert("This chicken is tired. Answer a Time Quiz question first.");return;}
  const inv=gameState.resources.inventory;
  if((inv.wheat||0)<3){alert("Not enough wheat.");return;}
  if(gameState.resources.water<3){alert("Not enough water.");return;}
  if(gameState.resources.energy<ENERGY_COST_CONVERT){alert("Not enough energy.");return;}
  const value=EGG_SELL_PRICE;
  const html=`<div style="text-align:center;">
    <div style="font-size:32px;">🥚</div>
    <p>Your chicken produced <strong>1 egg</strong>.</p>
    <p style="font-size:13px;">Sell now or save for later?</p>
    <button id="egg-sell" class="pill-btn pill-primary" style="width:100%;margin-top:6px;">💰 Sell (+${value} coins)</button>
    <button id="egg-save" class="pill-btn pill-ghost" style="width:100%;margin-top:4px;">🧺 Save to pantry</button>
    <button class="close-modal-btn" style="margin-top:4px;">Cancel</button>
  </div>`;
  showModal("Egg",html,(body,overlay)=>{
    const finish=(save)=>{
      gameState.resources.energy-=ENERGY_COST_CONVERT;
      inv.wheat-=3;
      gameState.resources.water-=3;
      if(save)inv.egg=(inv.egg||0)+1;else gameState.resources.coins+=value;
      ch.lastConversionQuestion=gameState.quiz.questionsAnswered;
      renderAll();saveGame();
      overlay.classList.add("hidden");
      if(overlayToClose)overlayToClose.classList.add("hidden");
    };
    body.querySelector("#egg-sell").onclick=()=>finish(false);
    body.querySelector("#egg-save").onclick=()=>finish(true);
  });
}

// Cow Area – wheat + water + energy → milk
function showCowArea(){
  const cows=gameState.animals.cows||[];
  const cap=2;
  let html=`<div><p class="chicken-info">Cow Area – convert wheat + water + energy into milk.</p>
  <div class="chicken-info">Cows: ${cows.length}/${cap}</div>`;
  if(cows.length<cap){
    html+=`${renderRequirementLine("Coins","💰",gameState.resources.coins,40)}
    <button id="buy-cow-btn" class="pill-btn pill-primary" style="width:100%;margin-bottom:8px;">Buy Cow (40💰)</button>`;
  }
  html+=`<div style="margin-top:6px;margin-bottom:6px;font-size:13px;">Cows:</div>`;
  const inv=gameState.resources.inventory;
  if(!cows.length)html+=`<p style="font-size:13px;">No cows yet.</p>`;
  else cows.forEach((cow,i)=>{
    const last=cow.lastConversionQuestion??-1;
    const ready=gameState.quiz.questionsAnswered>last;
    html+=`<div class="chicken-row" data-index="${i}">
      <div>🐄 Cow ${i+1}</div>
      <div style="font-size:11px;">4🌾 + 4💧 + 2⚡ → 1🥛</div>
      ${renderRequirementLine("Wheat","🌾",inv.wheat||0,4)}
      ${renderRequirementLine("Water","💧",gameState.resources.water,4)}
      ${renderRequirementLine("Energy","⚡",gameState.resources.energy,2)}
      ${ready?`<button class="card-btn cow-convert-btn" style="margin-top:4px;">Convert</button>`:`<div class="helper-text">Answer a Time Quiz first</div>`}
    </div>`;
  });
  html+=`<div class="helper-text">Milk will later unlock butter, yogurt, and cheese recipes.</div><button class="close-modal-btn">Close</button></div>`;
  showModal("Cow Area",html,(body,overlay)=>{
    const buy=body.querySelector("#buy-cow-btn");
    if(buy){
      buy.onclick=()=>{
        if(gameState.resources.coins<40){alert("Not enough coins.");return;}
        if((gameState.animals.cows||[]).length>=cap){alert("Cow area is full.");return;}
        gameState.resources.coins-=40;
        if(!gameState.animals.cows)gameState.animals.cows=[];
        gameState.animals.cows.push({lastConversionQuestion:-1});
        renderAll();saveGame();showCowArea();
      };
    }
    body.querySelectorAll(".cow-convert-btn").forEach(btn=>{
      btn.onclick=e=>{
        const row=e.target.closest(".chicken-row");
        const idx=Number(row.getAttribute("data-index"));
        convertCow(idx,overlay);
      };
    });
  });
}
function convertCow(idx,overlayToClose){
  const cows=gameState.animals.cows||[];
  const cow=cows[idx];if(!cow)return;
  const last=cow.lastConversionQuestion??-1;
  if(gameState.quiz.questionsAnswered<=last){alert("This cow needs a rest. Answer a Time Quiz question first.");return;}
  const inv=gameState.resources.inventory;
  if((inv.wheat||0)<4){alert("Not enough wheat.");return;}
  if(gameState.resources.water<4){alert("Not enough water.");return;}
  if(gameState.resources.energy<2){alert("Not enough energy.");return;}
  const value=MILK_SELL_PRICE;
  const html=`<div style="text-align:center;">
    <div style="font-size:32px;">🥛</div>
    <p>Your cow produced <strong>1 milk</strong>.</p>
    <p style="font-size:13px;">Sell now or save for later?</p>
    <button id="milk-sell" class="pill-btn pill-primary" style="width:100%;margin-top:6px;">💰 Sell (+${value} coins)</button>
    <button id="milk-save" class="pill-btn pill-ghost" style="width:100%;margin-top:4px;">🧺 Save to pantry</button>
    <button class="close-modal-btn" style="margin-top:4px;">Cancel</button>
  </div>`;
  showModal("Milk",html,(body,overlay)=>{
    const finish=(save)=>{
      gameState.resources.energy-=2;
      inv.wheat-=4;
      gameState.resources.water-=4;
      if(save)inv.milk=(inv.milk||0)+1;else gameState.resources.coins+=value;
      cow.lastConversionQuestion=gameState.quiz.questionsAnswered;
      renderAll();saveGame();
      overlay.classList.add("hidden");
      if(overlayToClose)overlayToClose.classList.add("hidden");
    };
    body.querySelector("#milk-sell").onclick=()=>finish(false);
    body.querySelector("#milk-save").onclick=()=>finish(true);
  });
}

// Sheep Area – wheat + water + energy → wool
function showSheepArea(){
  const sheep=gameState.animals.sheep||[];
  const cap=3;
  let html=`<div><p class="chicken-info">Sheep Area – convert wheat + water + energy into wool.</p>
  <div class="chicken-info">Sheep: ${sheep.length}/${cap}</div>`;
  if(sheep.length<cap){
    html+=`${renderRequirementLine("Coins","💰",gameState.resources.coins,30)}
    <button id="buy-sheep-btn" class="pill-btn pill-primary" style="width:100%;margin-bottom:8px;">Buy Sheep (30💰)</button>`;
  }
  html+=`<div style="margin-top:6px;margin-bottom:6px;font-size:13px;">Sheep:</div>`;
  const inv=gameState.resources.inventory;
  if(!sheep.length)html+=`<p style="font-size:13px;">No sheep yet.</p>`;
  else sheep.forEach((s,i)=>{
    const last=s.lastConversionQuestion??-1;
    const ready=gameState.quiz.questionsAnswered>last;
    html+=`<div class="chicken-row" data-index="${i}">
      <div>🐑 Sheep ${i+1}</div>
      <div style="font-size:11px;">3🌾 + 3💧 + 1⚡ → 1🧶</div>
      ${renderRequirementLine("Wheat","🌾",inv.wheat||0,3)}
      ${renderRequirementLine("Water","💧",gameState.resources.water,3)}
      ${renderRequirementLine("Energy","⚡",gameState.resources.energy,1)}
      ${ready?`<button class="card-btn sheep-convert-btn" style="margin-top:4px;">Convert</button>`:`<div class="helper-text">Answer a Time Quiz first</div>`}
    </div>`;
  });
  html+=`<div class="helper-text">Wool will later feed into textile and scarecrow upgrades.</div><button class="close-modal-btn">Close</button></div>`;
  showModal("Sheep Area",html,(body,overlay)=>{
    const buy=body.querySelector("#buy-sheep-btn");
    if(buy){
      buy.onclick=()=>{
        if(gameState.resources.coins<30){alert("Not enough coins.");return;}
        if((gameState.animals.sheep||[]).length>=cap){alert("Sheep area is full.");return;}
        gameState.resources.coins-=30;
        if(!gameState.animals.sheep)gameState.animals.sheep=[];
        gameState.animals.sheep.push({lastConversionQuestion:-1});
        renderAll();saveGame();showSheepArea();
      };
    }
    body.querySelectorAll(".sheep-convert-btn").forEach(btn=>{
      btn.onclick=e=>{
        const row=e.target.closest(".chicken-row");
        const idx=Number(row.getAttribute("data-index"));
        convertSheep(idx,overlay);
      };
    });
  });
}
function convertSheep(idx,overlayToClose){
  const sheep=gameState.animals.sheep||[];
  const s=sheep[idx];if(!s)return;
  const last=s.lastConversionQuestion??-1;
  if(gameState.quiz.questionsAnswered<=last){alert("This sheep needs a rest. Answer a Time Quiz question first.");return;}
  const inv=gameState.resources.inventory;
  if((inv.wheat||0)<3){alert("Not enough wheat.");return;}
  if(gameState.resources.water<3){alert("Not enough water.");return;}
  if(gameState.resources.energy<1){alert("Not enough energy.");return;}
  const value=WOOL_SELL_PRICE;
  const html=`<div style="text-align:center;">
    <div style="font-size:32px;">🧶</div>
    <p>Your sheep produced <strong>1 wool</strong>.</p>
    <p style="font-size:13px;">Sell now or save for later?</p>
    <button id="wool-sell" class="pill-btn pill-primary" style="width:100%;margin-top:6px;">💰 Sell (+${value} coins)</button>
    <button id="wool-save" class="pill-btn pill-ghost" style="width:100%;margin-top:4px;">🧺 Save to pantry</button>
    <button class="close-modal-btn" style="margin-top:4px;">Cancel</button>
  </div>`;
  showModal("Wool",html,(body,overlay)=>{
    const finish=(save)=>{
      gameState.resources.energy-=1;
      inv.wheat-=3;
      gameState.resources.water-=3;
      if(save)inv.wool=(inv.wool||0)+1;else gameState.resources.coins+=value;
      s.lastConversionQuestion=gameState.quiz.questionsAnswered;
      renderAll();saveGame();
      overlay.classList.add("hidden");
      if(overlayToClose)overlayToClose.classList.add("hidden");
    };
    body.querySelector("#wool-sell").onclick=()=>finish(false);
    body.querySelector("#wool-save").onclick=()=>finish(true);
  });
}

// Bee Area – wheat + water + energy → honey (simplified)
function showBeeArea(){
  const bees=gameState.animals.bees||[];
  const cap=2;
  let html=`<div><p class="chicken-info">Bee Area – convert plants + water + energy into honey.</p>
  <div class="chicken-info">Bee colonies: ${bees.length}/${cap}</div>`;
  if(bees.length<cap){
    html+=`${renderRequirementLine("Coins","💰",gameState.resources.coins,25)}
    <button id="buy-bees-btn" class="pill-btn pill-primary" style="width:100%;margin-bottom:8px;">Buy Beehive (25💰)</button>`;
  }
  html+=`<div style="margin-top:6px;margin-bottom:6px;font-size:13px;">Beehives:</div>`;
  const inv=gameState.resources.inventory;
  if(!bees.length)html+=`<p style="font-size:13px;">No bees yet.</p>`;
  else bees.forEach((b,i)=>{
    const last=b.lastConversionQuestion??-1;
    const ready=gameState.quiz.questionsAnswered>last;
    html+=`<div class="chicken-row" data-index="${i}">
      <div>🐝 Hive ${i+1}</div>
      <div style="font-size:11px;">2🌾 + 2💧 + 1⚡ → 1🍯</div>
      ${renderRequirementLine("Wheat","🌾",inv.wheat||0,2)}
      ${renderRequirementLine("Water","💧",gameState.resources.water,2)}
      ${renderRequirementLine("Energy","⚡",gameState.resources.energy,1)}
      ${ready?`<button class="card-btn bee-convert-btn" style="margin-top:4px;">Convert</button>`:`<div class="helper-text">Answer a Time Quiz first</div>`}
    </div>`;
  });
  html+=`<div class="helper-text">Honey will later unlock premium desserts and trade unlocks.</div><button class="close-modal-btn">Close</button></div>`;
  showModal("Bee Area",html,(body,overlay)=>{
    const buy=body.querySelector("#buy-bees-btn");
    if(buy){
      buy.onclick=()=>{
        if(gameState.resources.coins<25){alert("Not enough coins.");return;}
        if((gameState.animals.bees||[]).length>=cap){alert("Bee area is full.");return;}
        gameState.resources.coins-=25;
        if(!gameState.animals.bees)gameState.animals.bees=[];
        gameState.animals.bees.push({lastConversionQuestion:-1});
        renderAll();saveGame();showBeeArea();
      };
    }
    body.querySelectorAll(".bee-convert-btn").forEach(btn=>{
      btn.onclick=e=>{
        const row=e.target.closest(".chicken-row");
        const idx=Number(row.getAttribute("data-index"));
        convertBee(idx,overlay);
      };
    });
  });
}
function convertBee(idx,overlayToClose){
  const bees=gameState.animals.bees||[];
  const b=bees[idx];if(!b)return;
  const last=b.lastConversionQuestion??-1;
  if(gameState.quiz.questionsAnswered<=last){alert("These bees need time. Answer a Time Quiz question first.");return;}
  const inv=gameState.resources.inventory;
  if((inv.wheat||0)<2){alert("Not enough wheat.");return;}
  if(gameState.resources.water<2){alert("Not enough water.");return;}
  if(gameState.resources.energy<1){alert("Not enough energy.");return;}
  const value=HONEY_SELL_PRICE;
  const html=`<div style="text-align:center;">
    <div style="font-size:32px;">🍯</div>
    <p>Your bees produced <strong>1 honey</strong>.</p>
    <p style="font-size:13px;">Sell now or save for later?</p>
    <button id="honey-sell" class="pill-btn pill-primary" style="width:100%;margin-top:6px;">💰 Sell (+${value} coins)</button>
    <button id="honey-save" class="pill-btn pill-ghost" style="width:100%;margin-top:4px;">🧺 Save to pantry</button>
    <button class="close-modal-btn" style="margin-top:4px;">Cancel</button>
  </div>`;
  showModal("Honey",html,(body,overlay)=>{
    const finish=(save)=>{
      gameState.resources.energy-=1;
      inv.wheat-=2;
      gameState.resources.water-=2;
      if(save)inv.honey=(inv.honey||0)+1;else gameState.resources.coins+=value;
      b.lastConversionQuestion=gameState.quiz.questionsAnswered;
      renderAll();saveGame();
      overlay.classList.add("hidden");
      if(overlayToClose)overlayToClose.classList.add("hidden");
    };
    body.querySelector("#honey-sell").onclick=()=>finish(false);
    body.querySelector("#honey-save").onclick=()=>finish(true);
  });
}

// Recipe Book (Bread only for now) with requirement bars
function showRecipeBook(){
  let html="<div><p>Recipe Book</p><div class='card-grid'>";
  Object.keys(RECIPES).forEach(id=>{
    if(!gameState.unlockedRecipes[id])return;
    const r=RECIPES[id];
    const hasIngredients=r.inputs.every(inp=>(gameState.resources.inventory[inp.itemId]||0)>=inp.amount);
    const hasEnergy=gameState.resources.energy>=r.energyCost;
    const can=hasIngredients&&hasEnergy;
    html+=`<div class="card" data-recipe="${id}">
      <div class="card-icon">${r.emoji}</div>
      <div class="card-title">${r.name}</div>
      <div class="card-sub">`;
    r.inputs.forEach(inp=>{
      const have=gameState.resources.inventory[inp.itemId]||0;
      html+=`${getResourceIcon(inp.itemId)} ${have}/${inp.amount} `;
    });
    html+=`<br>⚡ ${r.energyCost} • 💰 ${r.sellPrice}</div>`;
    r.inputs.forEach(inp=>{
      const have=gameState.resources.inventory[inp.itemId]||0;
      html+=renderRequirementLine(inp.itemId,"",have,inp.amount);
    });
    html+=renderRequirementLine("Energy","⚡",gameState.resources.energy,r.energyCost);
    html+=`<button class="card-btn recipe-craft-btn${can?"":" disabled"}">${can?"Cook":"Need ingredients/energy"}</button>
    </div>`;
  });
  html+=`</div><div class="helper-text">More recipes will appear here later.</div><button class="close-modal-btn">Close</button></div>`;
  showModal("Farmhouse Kitchen",html,(body,overlay)=>{
    body.querySelectorAll(".recipe-craft-btn").forEach(btn=>{
      btn.onclick=e=>{
        if(btn.classList.contains("disabled"))return;
        const card=e.target.closest(".card");
        const id=card.getAttribute("data-recipe");
        craftRecipe(id);
      };
    });
  });
}
function craftRecipe(id){
  const r=RECIPES[id];if(!r)return;
  if(!gameState.unlockedRecipes[id]){alert("That recipe is not unlocked yet.");return;}
  if(gameState.resources.energy<r.energyCost){alert("Not enough energy.");return;}
  const inv=gameState.resources.inventory;
  const ok=r.inputs.every(inp=>(inv[inp.itemId]||0)>=inp.amount);
  if(!ok){alert("Missing ingredients.");return;}
  r.inputs.forEach(inp=>{inv[inp.itemId]-=inp.amount;});
  gameState.resources.energy-=r.energyCost;
  const value=r.sellPrice;
  const html=`<div style="text-align:center;">
    <div style="font-size:32px;">${r.emoji}</div>
    <p>You cooked <strong>1 ${r.name}</strong>.</p>
    <p style="font-size:13px;">Sell now or save for later?</p>
    <button id="craft-sell" class="pill-btn pill-primary" style="width:100%;margin-top:6px;">💰 Sell (+${value} coins)</button>
    <button id="craft-save" class="pill-btn pill-ghost" style="width:100%;margin-top:4px;">🧺 Save to pantry</button>
    <button class="close-modal-btn" style="margin-top:4px;">Cancel</button>
  </div>`;
  showModal(r.name,html,(body,overlay)=>{
    body.querySelector("#craft-sell").onclick=()=>{
      gameState.resources.coins+=value;renderAll();saveGame();overlay.classList.add("hidden");
    };
    body.querySelector("#craft-save").onclick=()=>{
      inv[r.id]=(inv[r.id]||0)+1;renderAll();saveGame();overlay.classList.add("hidden");
    };
  });
}

// Well UI with bar
function showWellInfo(){
  const well=gameState.buildings.well||{level:1};
  const idx=Math.min(well.level-1,WELL_LEVELS.length-1);
  const cur=WELL_LEVELS[idx];
  const next=WELL_LEVELS[idx+1]||null;
  let html=`<div><p>Well – water per Time Quiz.</p>
  <p>Level: ${cur.level}</p>
  <p>💧 +${cur.production} water/question<br>📦 Capacity: ${cur.capacity}</p>`;
  if(next){
    const can=gameState.resources.coins>=next.upgradeCostCoins;
    html+=`<hr><p>Next level:</p>
    <p>💧 +${next.production} water/question<br>📦 Capacity: ${next.capacity}</p>
    <p>Cost: ${next.upgradeCostCoins}💰</p>
    ${renderRequirementLine("Coins","💰",gameState.resources.coins,next.upgradeCostCoins)}
    <button id="well-upgrade-btn" class="pill-btn pill-primary" style="width:100%;" ${can?"":"disabled"}>${can?"Upgrade Well":"Need coins"}</button>`;
  }else html+=`<p style="margin-top:6px;">Max level reached.</p>`;
  html+=`<button class="close-modal-btn" style="margin-top:6px;">Close</button></div>`;
  showModal("Well",html,(body,overlay)=>{
    const btn=body.querySelector("#well-upgrade-btn");
    if(btn&&!btn.disabled){
      btn.onclick=()=>{
        const nextIdx=idx+1;if(nextIdx>=WELL_LEVELS.length)return;
        const n=WELL_LEVELS[nextIdx];
        if(gameState.resources.coins<n.upgradeCostCoins)return;
        gameState.resources.coins-=n.upgradeCostCoins;
        gameState.buildings.well.level=n.level;
        gameState.resources.waterCapacity=n.capacity;
        renderAll();saveGame();overlay.classList.add("hidden");
      };
    }
  });
}

// Placeholder UIs for Workshop, Windmill, Barn, Extra
function showWorkshop(){
  const html=`<div>
    <p>The Workshop will later hold machines like the Flour Mill, Textile Machine, Press, and Forge.</p>
    <div class="helper-text">For now this is just a preview. No tools or machines are active yet.</div>
    <button class="close-modal-btn">Close</button>
  </div>`;
  showModal("Workshop",html);
}
function showWindmill(){
  const html=`<div>
    <p>The Windmill will become the main Flour Mill for turning grains into flour.</p>
    <div class="helper-text">Later, grinding wheat will move here from the Kitchen.</div>
    <button class="close-modal-btn">Close</button>
  </div>`;
  showModal("Windmill",html);
}
function showBarn(){
  const html=`<div>
    <p>The Barn links to storage upgrades, the Aging Station, and some animal-related upgrades.</p>
    <div class="helper-text">For this prototype, storage is handled by the Pantry UI.</div>
    <button class="close-modal-btn">Close</button>
  </div>`;
  showModal("Barn",html);
}
function showExtra(){
  const html=`<div>
    <p>This slot is reserved for a future building (like the Greenhouse or Avatar Shop).</p>
    <div class="helper-text">We can plug in new systems here without touching the main farm layout.</div>
    <button class="close-modal-btn">Close</button>
  </div>`;
  showModal("Future Slot",html);
}

// Training mini-quiz with 3-second timeout and Next/Close
function clearTrainingTimer(){
  if(currentTrainingTimeout){clearTimeout(currentTrainingTimeout);currentTrainingTimeout=null;}
}
function showTrainingQuestion(){
  clearTrainingTimer();
  trainingQuestionActive=true;
  const a=Math.floor(Math.random()*8)+2;
  const b=Math.floor(Math.random()*8)+1;
  const correct=a+b;
  const o1=correct+(Math.random()<0.5?-1:+1);
  const o2=correct+(Math.random()<0.5?-2:+2);
  const opts=[correct,o1,o2].sort(()=>Math.random()-0.5);
  const bodyHtml=`<div>
    <p>Training – quick energy quiz.</p>
    <p style="font-size:18px;text-align:center;margin:6px 0;">${a} + ${b} = ?</p>
    <div class="training-options">
      ${opts.map(v=>`<button class="training-btn" data-value="${v}">${v}</button>`).join("")}
    </div>
    <div class="helper-text">Answer in 3 seconds. Correct: +${ENERGY_FROM_TRAINING_SUCCESS}⚡ • Wrong/timeout: +${ENERGY_FROM_TRAINING_FAIL}⚡</div>
    <button class="close-modal-btn">Close</button>
  </div>`;
  showModal("Training",bodyHtml,(body,overlay)=>{
    const finish=(correctAnswer)=>{
      if(!trainingQuestionActive)return;
      trainingQuestionActive=false;
      clearTrainingTimer();
      if(correctAnswer){
        gameState.resources.energy=Math.min(gameState.resources.energy+ENERGY_FROM_TRAINING_SUCCESS,gameState.resources.energyMax);
      }else if(ENERGY_FROM_TRAINING_FAIL>0){
        gameState.resources.energy=Math.min(gameState.resources.energy+ENERGY_FROM_TRAINING_FAIL,gameState.resources.energyMax);
      }
      renderAll();saveGame();
      const resultHtml=`<div>
        <p style="text-align:center;font-size:16px;">${correctAnswer?"✅ Correct!":"⏰ Too late or incorrect."}</p>
        <p class="helper-text">Energy now: ${gameState.resources.energy}/${gameState.resources.energyMax}</p>
        <button id="training-next-btn" class="pill-btn pill-primary" style="width:100%;margin-top:6px;">Next question</button>
        <button class="close-modal-btn" style="margin-top:4px;">Close</button>
      </div>`;
      body.innerHTML=resultHtml;
      const nextBtn=body.querySelector("#training-next-btn");
      if(nextBtn){
        nextBtn.onclick=()=>{showTrainingQuestion();};
      }
    };
    body.querySelectorAll(".training-btn").forEach(btn=>{
      btn.onclick=()=>{
        if(!trainingQuestionActive)return;
        const v=Number(btn.getAttribute("data-value"));
        const isCorrect=v===correct;
        finish(isCorrect);
      };
    });
    currentTrainingTimeout=setTimeout(()=>{
      if(trainingQuestionActive)finish(false);
    },3000);
  });
}
function showTraining(){
  showTrainingQuestion();
}

// Time quiz iframe
function openQuizModal(){
  const m=document.getElementById("quiz-modal");
  const f=document.getElementById("quiz-iframe");
  f.src="farm-quiz-engine.html";
  m.classList.remove("hidden");
}
function closeQuizModal(){
  const m=document.getElementById("quiz-modal");
  const f=document.getElementById("quiz-iframe");
  m.classList.add("hidden");
  f.src="";
}
window.addEventListener("message",ev=>{
  const d=ev.data||{};
  if(d.type==="quizCorrect")advanceTimeFromQuiz();
  else if(d.type==="quizClose")closeQuizModal();
});

// Event wiring
function setupEventListeners(){
  document.getElementById("quiz-button").onclick=openQuizModal;
  document.getElementById("training-button").onclick=showTraining;
  document.getElementById("ui-modal-close").onclick=()=>{
    document.getElementById("ui-modal").classList.add("hidden");
    clearTrainingTimer();
    trainingQuestionActive=false;
  };
  document.querySelectorAll(".field-plot").forEach(el=>{
    const idx=Number(el.getAttribute("data-plot"));
    el.addEventListener("click",()=>{
      const p=gameState.farm.plots[idx];
      if(p.type==="special"){alert("This patch is reserved for a special building later.");return;}
      if(!p.planted||!p.cropId)showPlantingModal(idx);else harvestPlot(idx);
    });
  });
  document.querySelectorAll(".building-slot").forEach(el=>{
    const id=el.getAttribute("data-building");
    el.addEventListener("click",()=>{
      if(id==="market")showMarket();
      else if(id==="farmhouse")showRecipeBook();
      else if(id==="storage")showInventory();
      else if(id==="well")showWellInfo();
      else if(id==="workshop")showWorkshop();
      else if(id==="windmill")showWindmill();
      else if(id==="barn")showBarn();
      else if(id==="extra")showExtra();
    });
  });
  document.querySelectorAll(".animal-slot").forEach(el=>{
    const a=el.getAttribute("data-animal-slot");
    el.addEventListener("click",()=>{
      if(a==="chickens")showChickenArea();
      else if(a==="cows")showCowArea();
      else if(a==="sheep")showSheepArea();
      else if(a==="bees")showBeeArea();
    });
  });
}

// Init
function initGame(){
  loadGame();
  const st=getWellStats();
  gameState.resources.waterCapacity=st.capacity;
  clampEnergy();
  renderAll();
  setupEventListeners();
}
document.addEventListener("DOMContentLoaded",initGame);
