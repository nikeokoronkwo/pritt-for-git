<template>
  <div>
    <section>
      <h1 class="main-display">Code Review that Looks Cool</h1>
      <p class="text-2xl font-medium">Make Code Review and Git Analysis Easier with Pritt.</p>
      <div class="py-10 flex space-x-10 items-center justify-center">
        <button
          class="px-4 py-1 rounded-full border border-spacing-4 border-white hover:text-white hover:bg-yellow-500 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-offset-2"
        >
          <RouterLink to="/repositories">Your Repositories</RouterLink>
        </button>
        <button
          class="px-4 py-1 rounded-full border border-spacing-4 border-white hover:text-white hover:bg-yellow-500 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-offset-2"
        >
          Get Started
        </button>
      </div>
    </section>
  </div>
</template>

<style scoped>
section {
  position: relative;
  display: flex;
  margin: auto;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 90vh;
  max-height: 100vh;
  padding: 10vh 20vw;
}

@media screen and (min-width: 512px) {
  section {
    padding: 10vh;
  }
}

section div {
  align-items: center;
  justify-content: space-evenly;
}

.main-display {
  font-family: 'Nabla', system-ui;
  font-optical-sizing: auto;
  font-weight: 400;
  font-size: 3.5em;
  font-style: normal;
  font-variation-settings:
    'EDPT' 100,
    'EHLT' 12;
  padding: 40px;
}
</style>

<style>
@import url('https://fonts.googleapis.com/css2?family=Nabla&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Red+Hat+Display:ital,wght@0,300..900;1,300..900&display=swap');


</style>
